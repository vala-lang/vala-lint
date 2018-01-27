/*
 * Copyright (c) 2018 elementary LLC. (https://github.com/elementary/Vala-Lint)
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
        enabled_checks.add (new Checks.DoubleSpacesCheck ());
        enabled_checks.add (new Checks.EllipsisCheck ());
        enabled_checks.add (new Checks.LineLengthCheck ());
        enabled_checks.add (new Checks.SpaceBeforeBracketCheck ());
        enabled_checks.add (new Checks.TabCheck ());
        enabled_checks.add (new Checks.TrailingWhitespaceCheck ());
    }

    public Linter.with_check (Check check) {
        enabled_checks = new Gee.ArrayList<Check> ();
        enabled_checks.add (check);
    }

    public Linter.with_checks (Gee.ArrayList<Check> checks) {
        enabled_checks = checks;
    }

    public Gee.ArrayList<FormatMistake?> run_checks (string input) {
        var parser = new ValaLint.Parser();
        Gee.ArrayList<ParseResult?> parse_result = parser.parse(input);

        var mistake_list = new Gee.ArrayList<FormatMistake?> ();

        foreach (Check check in enabled_checks) {
            check.check (parse_result, mistake_list);
        }

        mistake_list.sort((a, b) => {
            if (a.line_index == b.line_index) {
                return a.char_index - b.char_index;
            }
            return a.line_index - b.line_index;
        });

        return mistake_list;
    }

    public Gee.ArrayList<FormatMistake?> run_checks_for_filename (string filename) throws Error, IOError {
        var channel = new IOChannel.file (filename, "r");
        string text;
        size_t length;
        channel.read_to_end (out text, out length);
        return run_checks (text);
    }
}
