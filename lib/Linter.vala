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

public class ValaLint.Linter : Object {
    public Gee.ArrayList<Check> enabled_checks { get; set; }

    public Linter () {
        enabled_checks = new Gee.ArrayList<Check> ();
        enabled_checks.add (new Checks.BlockOpeningBraceSpaceBeforeCheck ());
        enabled_checks.add (new Checks.EllipsisCheck ());
        enabled_checks.add (new Checks.TabCheck ());
        enabled_checks.add (new Checks.TrailingWhitespaceCheck ());
    }

    public Linter.with_checks (Gee.ArrayList<Check> checks) {
        enabled_checks = checks;
    }

    public Gee.ArrayList<FormatMistake?> run_checks_for_line (int line_index, string line) {
        var mistake_list = new Gee.ArrayList<FormatMistake?> ();

        foreach (Check check in enabled_checks) {
            check.check_line (mistake_list, line_index, line);
        }

        return mistake_list;
    }

    public Gee.ArrayList<FormatMistake?> run_checks_for_stream (DataInputStream stream) throws IOError {
        var mistake_list = new Gee.ArrayList<FormatMistake?> ();

        int line_index = 1;
        string line;

        while ((line = stream.read_line (null)) != null) {
            foreach (Check check in enabled_checks) {
                check.check_line (mistake_list, line_index, line);
            }

            line_index++;
        }

        return mistake_list;
    }

    public Gee.ArrayList<FormatMistake?> run_checks_for_file (File file) throws Error, IOError {
        return run_checks_for_stream (new DataInputStream (file.read ()));
    }
}
