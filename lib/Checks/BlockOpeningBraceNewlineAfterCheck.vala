/*
 * Copyright (c) 2016 elementary LLC (https://github.com/elementary/Vala-Lint)
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 */

public class ValaLint.Checks.BlockOpeningBraceNewlineAfterCheck : Check {
    public override string get_title () {
        return _("block-opening-brace-newline-after");
    }

    public override string get_description () {
        return _("Checks for newlines after an opening brace for code blocks");
    }

    public override bool check_line (Gee.ArrayList<FormatMistake?> mistake_list, int line_index, string line) {

        if ("{" in line ) {
            string last_char = line.substring (line.length - 1, 1);
            if (last_char != "{" && last_char != "}") {
                string last_two_char = line.substring (line.length - 2, 2);
                if (last_two_char != "};") {
                    mistake_list.add ({ this, line_index + 1, line.length, _("Expected newline after '{' of a multi-line block")});
                    return true;
                }
            }
        }

        return false;
    }
}
