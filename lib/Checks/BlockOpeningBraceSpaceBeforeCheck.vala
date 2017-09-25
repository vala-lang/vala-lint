/*
 * Copyright (c) 2016 elementary LLC. (https://github.com/elementary/Vala-Lint)
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

public class ValaLint.Checks.BlockOpeningBraceSpaceBeforeCheck : Check {
    public override string get_title () {
        return _("block-opening-brace-space-before");
    }

    public override string get_description () {
        return _("Checks for correct use of opening braces");
    }

    public override bool check_line (Gee.ArrayList<FormatMistake?> mistake_list, int line_index, string line) {
        if (line.strip () == "{") {
            mistake_list.add ({ this, line_index, line.index_of ("{"), _("Unexpected line break before \"{\"") });

            return true;
        }

        char[] chars = line.to_utf8 ();
        bool mistake_found = false;
        for (int i = 0; i < chars.length; i++) {
            if (i >= 1 && chars[i] == '{' && chars[i - 1] != ' ' && chars[i - 1] != '(') {
                mistake_list.add ({ this, line_index, i, _("Expected single space before \"{\"") });

                mistake_found = true;
            }
        }

        return mistake_found;
    }
}
