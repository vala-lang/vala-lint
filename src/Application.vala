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
    private static bool print_version = false;
    private static bool print_mistakes_end = false;
    private static bool exit_with_zero = false;
    private static bool generate_config_file = false;

    private static string? lint_directory = null;
    private static File? lint_directory_file = null;
    private static string? config_file = null;


    private ApplicationCommandLine application_command_line;

    private const OptionEntry[] OPTIONS = {
        { "version", 'v', 0, OptionArg.NONE, ref print_version,
            "Display version number" },
        { "directory", 'd', 0, OptionArg.STRING, ref lint_directory,
            "Lint all Vala files in the given directory." },
        { "print-end", 'e', 0, OptionArg.NONE, ref print_mistakes_end,
            "Show end of mistakes" },
        { "config", 'c', 0, OptionArg.STRING, ref config_file,
            "Specify a configuration file." },
        { "exit-zero", 'z', 0, OptionArg.NONE, ref exit_with_zero,
            "Always return a 0 (non-error) status code, even if lint errors are found." },
        { "generate-config", 'g', 0, OptionArg.NONE, ref generate_config_file,
            "Generate a sample configuration file with default values." },
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
            args = { args[0], "-d", "." };
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
            command_line.print (_("Version: %s") + "\n", 0.1);
            return 0;
        }

        if (generate_config_file) {
            var default_config = ValaLint.Config.get_default_config ();
            command_line.print (default_config.to_data ());
            return 0;
        }

        this.application_command_line = command_line;

        /* 1. Get list of files */
        var files = new Vala.ArrayList<File> ();
        try {
            if (lint_directory != null) {
                lint_directory_file = File.new_for_path (lint_directory);
                files = get_files_from_directory (lint_directory_file);
            } else {
                files = get_files_from_globs (command_line, tmp);
            }
        } catch (Error e) {
            critical ("Error: %s\n", e.message);
        }

        /* 2. Load config */
        ValaLint.Config.load_file (config_file);

        /* 3. Check files */
        var linter = new Linter ();
        var file_data_list = new Vala.ArrayList<FileData?> ();
        foreach (File file in files) {
            try {
                Vala.ArrayList<FormatMistake?> mistakes = linter.run_checks_for_file (file);
                file_data_list.add ({ file, mistakes });
            } catch (Error e) {
                critical ("Error: %s while linting file %s\n", e.message, file.get_path ());
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

    Vala.ArrayList<File> get_files_from_globs (ApplicationCommandLine command_line,
                                               string[] patterns) throws Error, IOError {
        var files = new Vala.ArrayList<File> ();
        foreach (string pattern in patterns) {
            var matcher = Posix.Glob ();

            if (matcher.glob (pattern) != 0) {
                command_line.print (_("No files found for pattern: %s") + "\n", pattern);
                return files;
            }

            foreach (string path in matcher.pathv) {
                File file = File.new_for_path (path);
                FileType file_type = file.query_file_type (FileQueryInfoFlags.NONE);

                if (file_type != FileType.REGULAR) {
                    continue;
                }

                files.add (file);
            }
        }
        return files;
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
                if (child_name.length > 5 && child_name.has_suffix (".vala")) {
                    files.add (child_file);
                }
            }
            info = enumerator.next_file (null);
        }
        return files;
    }

    void print_mistakes (Vala.ArrayList<FileData?> file_data_list) {
        foreach (FileData file_data in file_data_list) {
            if (!file_data.mistakes.is_empty) {
                string path = "";
                if (lint_directory_file != null) {
                    path = lint_directory_file.get_relative_path (file_data.file);
                } else {
                    path = file_data.file.get_path ();
                }

                application_command_line.print ("\x001b[1m\x001b[4m" + "%s" + "\x001b[0m\n", path);
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
