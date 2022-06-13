/*
 * Copyright (c) 2016-2019 elementary LLC. (https://github.com/elementary/vala-lint)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 *
 * Authored by: Marcus Wichelmann <marcus.wichelmann@hotmail.de>
 */

public class ValaLint.Application : GLib.Application {
    private const string VERSION = "0.1";

    private static string? lint_directory = null;
    private static bool print_version = false;
    private static bool print_mistakes_end = false;
    private static bool exit_with_zero = false;
    private static bool generate_config_file = false;
    private static bool auto_fix = false;
    private static string? config_file = null;
    private static string? ignorefile_path = null;
    private static string? ignore_pattern = null;
    private static string ignore_pattern_list = "";
    private static int fnmatch_flags = Posix.FNM_EXTMATCH | Posix.FNM_PERIOD | Posix.FNM_PATHNAME;
    private static File root_dir;

    private ApplicationCommandLine application_command_line;

    private const OptionEntry[] OPTIONS = {
        { "version", 'v', 0, OptionArg.NONE, ref print_version,
            "Display version number." },
        { "directory", 'd', OptionFlags.HIDDEN, OptionArg.STRING, ref lint_directory, // Hidden flag
            "Lint all Vala files in the given directory. (DEPRECEATED)" },
        { "print-end", 'e', 0, OptionArg.NONE, ref print_mistakes_end,
            "Show end of mistakes." },
        { "config", 'c', 0, OptionArg.STRING, ref config_file,
            "Specify a configuration file." },
        { "ignore", 'x', 0, OptionArg.STRING, ref ignore_pattern,
            "Specify a glob pattern to ignore." },
        { "ignore-file", 'X', 0, OptionArg.STRING, ref ignorefile_path,
            "Specify a file containing glob patterns to ignore, one pattern per line" },
        { "exit-zero", 'z', 0, OptionArg.NONE, ref exit_with_zero,
            "Always return a 0 (non-error) status code, even if lint errors are found." },
        { "generate-config", 'g', 0, OptionArg.NONE, ref generate_config_file,
            "Generate a sample configuration file with default values." },
        { "fix", 'f', 0, OptionArg.NONE, ref auto_fix,
            "Fix any auto-fixable mistakes." },
        { null }
    };

    private Application () {
        Object (
            application_id: "io.elementary.vala-lint",
            flags: ApplicationFlags.HANDLES_COMMAND_LINE
        );
    }

    public override int command_line (ApplicationCommandLine command_line) {
        this.hold ();

        int res = handle_command_line (command_line);

        this.release ();
        return res;
    }

    private int handle_command_line (ApplicationCommandLine command_line) {
        string[] args = command_line.get_arguments ();

        if (args.length == 1) {
            args = { args[0], "." };
        }

        unowned string[] tmp = args;

        try {
            var option_context = new OptionContext ("- Vala-Lint");
            option_context.set_help_enabled (true);
            option_context.add_main_entries (OPTIONS, null);

            option_context.parse (ref tmp);
        } catch (OptionError e) {
            command_line.print (_("Error: %s") + "\n", e.message);
            command_line.print (_("Run '%s --help' to see a full list of available options.") + "\n", args[0]);
            return 1;
        }

        if (print_version) {
            command_line.print (_("Version: %s") + "\n", VERSION);
            return 0;
        }

        if (generate_config_file) {
            var default_config = ValaLint.Config.get_default_config ();
            command_line.print (default_config.to_data ());
            return 0;
        }

        this.application_command_line = command_line;

        /* Get ignore patterns. Ignore patterns are glob patterns relative to the scanned directory */
        string[] ignore_patterns = {};
        if (ignore_pattern != null) {
            ignore_patterns += ignore_pattern;
        } else {
            if (ignorefile_path == null) {
                ignorefile_path = ".gitignore"; //TODO Allow config file to specify default ignore file
            }

            if (ignorefile_path.has_prefix ("~/")) {
                ignorefile_path = Environment.get_home_dir () + ignorefile_path[1:ignorefile_path.length];
            }

            string contents;
            size_t size;
            try {
                FileUtils.get_contents (ignorefile_path, out contents, out size);
            } catch (Error e) {
                warning ("Error loading ignore file contents: %s", e.message);
            }

            if (size > 10000UL) {
                ///TRANSLATORS %s is a placeholder for a file path
                command_line.print (_("%s is too large and will not be used.") + "\n", ignorefile_path);
            } else {
                var ignore_split = contents.split ("\n", -1);
                foreach (string ignore in ignore_split) {
                    if (ignore != "" && ignore.length <= 255) {
                        ignore_patterns += ignore;
                    } else if (ignore.length > 255) {
                        command_line.print (_("The pattern %s is too long and will not be used.") + "\n", ignore);
                    }
                }
            }
        }

        /* Get list of files */
        var file_data_list = new Vala.ArrayList<FileData?> ();
        try {
            string[] file_name_list = tmp[1:tmp.length];
            if (lint_directory != null) {
                file_name_list += lint_directory;
            }

            file_data_list = get_files (command_line, file_name_list, ignore_patterns);
        } catch (Error e) {
            critical (_("Error: %s") + "\n", e.message);
        }

        /* 2. Load config */
        ValaLint.Config.load_file (config_file);

        /* 3. Check files */
        var linter = new Linter ();
        var fixer = new Fixer ();
        foreach (FileData data in file_data_list) {
            try {
                var mistakes = linter.run_checks_for_file (data.file);
                if (auto_fix) {
                    fixer.apply_fixes_for_file (data.file, ref mistakes);
                }
                data.mistakes.add_all (mistakes);
            } catch (Error e) {
                critical (_("Error: %s while linting file %s") + "\n", e.message, data.file.get_path ());
            }
        }

        /* 4. Print mistakes */
        print_mistakes (file_data_list);

        if (exit_with_zero) {
            return 0;
        }

        foreach (FileData file_data in file_data_list) {
            foreach (FormatMistake? mistake in file_data.mistakes) {
                if (mistake.check.state == Config.State.ERROR) {
                    return 1;
                }
            }
        }

        return 0;
    }

    Vala.ArrayList<FileData?> get_files (
        ApplicationCommandLine command_line, string[] patterns, string[] ignore_patterns ) throws Error, IOError {

        foreach (string pattern in ignore_patterns) {
            ignore_pattern_list += ("|" + pattern);
        }

        debug ("Ignore pattern list: %s", ignore_pattern_list);
        if (ignore_pattern_list.length > 0) {
            ignore_pattern_list = "+(" + ignore_pattern_list[1: ignore_pattern_list.length] + ")";
        }

        var result = new Vala.ArrayList<FileData?> ();
        foreach (string pattern in patterns) {
            var matcher = Posix.Glob ();

            if (matcher.glob (pattern) != 0) {
                command_line.print (_("No files found for pattern: %s") + "\n", pattern);
                continue;
            }

            foreach (string path in matcher.pathv) {
                File file = File.new_for_path (path);
                FileType file_type = file.query_file_type (FileQueryInfoFlags.NONE);

                switch (file_type) {
                    case FileType.REGULAR:
                        result.add ({ file, path, new Vala.ArrayList<FormatMistake?> () });
                        break;

                    case FileType.DIRECTORY:
                        root_dir = file;
                        foreach (File f in get_files_from_directory (file)) {
                            string name = path + file.get_relative_path (f);
                            result.add ({ f, name, new Vala.ArrayList<FormatMistake?> () });
                        }
                        break;

                    default:
                        break;
                }
            }
        }
        return result;
    }

    Vala.ArrayList<File> get_files_from_directory (File dir) throws Error, IOError {
        var files = new Vala.ArrayList<File> ();
        FileEnumerator enumerator = dir.enumerate_children (FileAttribute.STANDARD_NAME, 0, null);
        var info = enumerator.next_file (null);
        while (info != null) {
            string child_name = info.get_name ();
            var child_file = dir.resolve_relative_path (child_name);
            var rel_path = root_dir.get_relative_path (child_file);
            if (Posix.fnmatch (ignore_pattern_list, rel_path, fnmatch_flags) != 0) {
                if (info.get_file_type () == FileType.DIRECTORY) {
                    if (!info.get_is_hidden ()) {
                        var sub_files = get_files_from_directory (child_file);
                        files.add_all (sub_files);
                    }
                } else if (info.get_file_type () == FileType.REGULAR) {
                    /* Check only .vala files */
                    if (child_name.has_suffix (".vala")) {
                        files.add (child_file);
                    }
                }
            } else {
                debug ("%s ignored", rel_path);
            }

            info = enumerator.next_file (null);
        }
        return files;
    }

    void print_mistakes (Vala.ArrayList<FileData?> file_data_list) {
        foreach (FileData file_data in file_data_list) {
            if (!file_data.mistakes.is_empty) {
                application_command_line.print ("\x001b[1m\x001b[4m" + "%s" + "\x001b[0m\n", file_data.name);

                foreach (FormatMistake mistake in file_data.mistakes) {
                    string color_state = "%-5s";
                    string mistakes_end = "";
                    if (print_mistakes_end) {
                        mistakes_end = "-%5i.%-3i".printf (mistake.end.line, mistake.end.column);
                    }

                    switch (mistake.check.state) {
                        case ERROR:
                            color_state = "\033[1;31m" + color_state + "\033[0m"; // red
                            break;

                        case WARN:
                            color_state = "\033[1;33m" + color_state + "\033[0m";  // yellow
                            break;

                        default:
                            break;
                    }

                    application_command_line.print (
                        "\x001b[0m%5i.%-3i %s  " + color_state + "   %-45s   \033[2m%s\033[0m\n",
                        mistake.begin.line,
                        mistake.begin.column,
                        mistakes_end,
                        mistake.check.state.to_string (),
                        mistake.mistake,
                        mistake.check.title
                    );
                }
            }
        }
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }
}
