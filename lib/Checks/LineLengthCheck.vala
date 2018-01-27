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
 */

public class ValaLint.Checks.LineLengthCheck : Check {
    static int MAXIMUM_CHARACTERS = 120;

    public override string get_title () {
        return _("line-length");
    }

    public override string get_description () {
        return _("Checks for a maxmimum line legnth");
    }

    public override void check (Gee.ArrayList<ParseResult? > parse_result, Gee.ArrayList<FormatMistake? > mistake_list) {
        string input = "";
        foreach (ParseResult r in parse_result) {
            input += r.text;
        }

        int line_counter = 1;
        foreach (string line in input.split("\n")) {
            if (line.length > MAXIMUM_CHARACTERS) {
                mistake_list.add ({ this, line_counter, MAXIMUM_CHARACTERS, @"Line exceeds limit of $MAXIMUM_CHARACTERS characters" });
            }
            line_counter += 1;
        }
    }
}
