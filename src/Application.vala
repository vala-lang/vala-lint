/*
 * Copyright (c) 2016-2018 elementary LLC. (https://github.com/elementary/vala-lint)
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
    private static string lint_directory;

    private Linter linter;
    private ApplicationCommandLine application_command_line;

    private const OptionEntry[] options = {
        { "version", 'v', 0, OptionArg.NONE, ref print_version, "Display version number", null },
        { "directory", 'd', 0, OptionArg.STRING, ref lint_directory, "Lint all Vala files in the given directory." },
        { null }
    };

    private Application () {
        Object (application_id: "io.elementary.vala-lint",
            flags: ApplicationFlags.HANDLES_COMMAND_LINE);
    }

    public override int command_line (ApplicationCommandLine command_line) {
        this.hold ();

        int res = handle_command_line (command_line);

        this.release ();
        return res;
    }

    private int handle_command_line (ApplicationCommandLine command_line) {
        string[] args = command_line.get_arguments ();
        string*[] _args = new string[args.length];

        for (int i = 0; i < args.length; i++) {
            _args[i] = args[i];
        }

        try {
            var option_context = new OptionContext ("- Vala-Lint");
            option_context.set_help_enabled (true);
            option_context.add_main_entries (options, null);

            unowned string[] tmp = _args;
            option_context.parse (ref tmp);
        } catch (OptionError e) {
            command_line.print (_("Error: %s") + "\n", e.message);
            command_line.print (_("Run '%s --help' to see a full list of available command line options.") + "\n", args[0]);

            return 0;
        }

        if (print_version) {
            command_line.print (_("Version: %s") + "\n", 0.1);

            return 0;
        }

        linter = new Linter ();
        this.application_command_line = command_line;

        try {
            if (lint_directory != null) {
                check_directory (File.new_for_path (lint_directory));
            } else {
                check_globs (command_line, args[1:args.length]);
            }
        } catch (Error e) {
            command_line.print (_("Error: %s") + "\n", e.message);
        }

        return 0;
    }

    void check_globs (ApplicationCommandLine command_line, string[] patterns) throws Error, IOError {
        foreach (string pattern in patterns) {
            var matcher = Posix.Glob ();

            if (matcher.glob (pattern) != 0) {
                command_line.print (_("Invalid pattern: %s") + "\n", pattern);

                return;
            }

            foreach (string path in matcher.pathv) {
                File file = File.new_for_path (path);
                FileType file_type = file.query_file_type (FileQueryInfoFlags.NONE);

                if (file_type != FileType.REGULAR) {
                    continue;
                }

                check_file (file);
            }
        }
    }

    void check_directory (File dir) throws Error, IOError {
        FileEnumerator enumerator = dir.enumerate_children (FileAttribute.STANDARD_NAME, 0, null);
        var info = enumerator.next_file (null);
        while (info != null) {
            string child_name = info.get_name ();
            File child_file = dir.resolve_relative_path (child_name);
            if (info.get_file_type () == FileType.DIRECTORY) {
                if (!info.get_is_hidden ()) {
                    check_directory (child_file);
                }
            } else if (info.get_file_type () == FileType.REGULAR) {
                /* Check only .vala files */
                if (child_name.length > 5 && child_name.has_suffix (".vala")) {
                    check_file (child_file);
                }
            }
            info = enumerator.next_file (null);
        }
    }

    void check_file (File file) throws Error, IOError {
        Gee.ArrayList<FormatMistake?> mistakes = linter.run_checks_for_file (file);

        if (!mistakes.is_empty) {
            application_command_line.print ("\x001b[1m\x001b[4m" + "%s" + "\x001b[0m\n", file.get_path ());

            foreach (FormatMistake mistake in mistakes) {
                application_command_line.print ("\x001b[0m%5i:%-3i \x001b[1m%-40s   \x001b[0m%s\n",
                    mistake.line_index,
                    mistake.char_index,
                    mistake.mistake,
                    mistake.check.get_title ());
            }
        }
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }
}
