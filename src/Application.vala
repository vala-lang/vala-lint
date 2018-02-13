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

    private const OptionEntry[] options = {
        { "version", 'v', 0, OptionArg.NONE, ref print_version, "Display version number", null },
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

        try {
            do_checks (command_line, args[1:args.length]);
        } catch (Error e) {
            command_line.print (_("Error: %s") + "\n", e.message);
        }

        return 0;
    }

    private void do_checks (ApplicationCommandLine command_line, string[] patterns) throws Error, IOError {
        var linter = new Linter ();

        foreach (string pattern in patterns) {
            var matcher = Posix.Glob ();

            if (matcher.glob (pattern) != 0) {
                command_line.print (_("Invalid pattern: %s") + "\n", pattern);

                return;
            }

            foreach (string path in matcher.pathv) {
                Gee.ArrayList<FormatMistake?> mistakes = linter.run_checks_for_filename (path);

                if (!mistakes.is_empty) {
                    command_line.print ("\x001b[1m\x001b[4m" + "%s" + "\x001b[0m\n", path);

                    foreach (FormatMistake mistake in mistakes) {
                        command_line.print ("\x001b[0m%5i:%-3i \x001b[1m%-40s   \x001b[0m%s\n",
                            mistake.line_index,
                            mistake.char_index,
                            mistake.mistake,
                            mistake.check.get_title ());
                    }
                }
            }
        }
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }
}
