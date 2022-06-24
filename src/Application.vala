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

        /* 1. Get list of files */
        var file_data_list = new Vala.ArrayList<FileData?> ();
        try {
            string[] file_name_list = tmp[1:tmp.length];
            if (lint_directory != null) {
                //  command_line.print (_("The directory flag is depreceated, just omit the flag for future versions.") + "\n");
                file_name_list += lint_directory;
            }

            file_data_list = get_files (command_line, file_name_list);
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
        bool has_errors = print_mistakes (file_data_list);

        if (exit_with_zero) {
            return 0;
        }

        return (int) has_errors;
    }

    Vala.ArrayList<FileData?> get_files (ApplicationCommandLine command_line, string[] patterns) throws Error, IOError {
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
            File child_file = dir.resolve_relative_path (child_name);
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
            info = enumerator.next_file (null);
        }
        return files;
    }

    bool print_mistakes (Vala.ArrayList<FileData?> file_data_list) {
        int num_errors = 0;
        int num_warnings = 0;

        foreach (FileData file_data in file_data_list) {
            if (!file_data.mistakes.is_empty) {
                application_command_line.print ("\x001b[1m\x001b[4m" + "%s" + "\x001b[0m\n", file_data.name);

                foreach (FormatMistake mistake in file_data.mistakes) {
                    switch (mistake.check.state) {
                        case ERROR:
                            num_errors++;
                            break;

                        case WARN:
                            num_warnings++;
                            break;

                        default:
                            break;
                    }

                    string color_state = "%-5s";
                    string mistakes_end = "";
                    if (print_mistakes_end) {
                        mistakes_end = "-%5i.%-3i".printf (mistake.end.line, mistake.end.column);
                    }

                    color_state = apply_color_for_state (color_state, mistake.check.state);

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

        int total_mistakes = num_errors + num_warnings;
        if (total_mistakes == 0) {
            application_command_line.print (_("No mistakes found") + "\n");
            return false;
        }

        string summary = ("\n" + _("%d %s (%d %s, %d %s)") + "\n").printf (
            total_mistakes,
            total_mistakes == 1 ? _("mistake") : _("mistakes"),
            num_errors,
            num_errors == 1 ? _("error") : _("errors"),
            num_warnings,
            num_warnings == 1 ? _("warning") : _("warnings")
        );
        if (num_errors > 0) {
            application_command_line.print (apply_color_for_state (summary, Config.State.ERROR));
        } else {
            application_command_line.print (apply_color_for_state (summary, Config.State.WARN));
        }
        return num_errors > 0;
    }

    string apply_color_for_state (string str, Config.State state) {
        switch (state) {
            case ERROR:
                return "\033[1;31m" + str + "\033[0m"; // red

            case WARN:
                return "\033[1;33m" + str + "\033[0m"; // yellow

            default:
                return str;
        }
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }
}
