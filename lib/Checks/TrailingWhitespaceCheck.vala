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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authored by: Marcus Wichelmann <marcus.wichelmann@hotmail.de>
 */

public class ValaLint.Checks.TrailingWhitespaceCheck : Check {
    public override string get_title () {
        return _("Trailing-Whitespaces");
    }

    public override string get_description () {
        return _("Checks for whitespaces at the end of lines");
    }

    public override bool check_line (Gee.ArrayList<FormatMistake?> mistake_list, int line_index, string line) {
        string clean_line = line.chomp ();

        if (clean_line != line) {
            string mistake = _("There are %i trailing whitespaces at the end of the line.").printf (line.length - clean_line.length);

            mistake_list.add ({ this, line_index, clean_line.length, mistake });

            return true;
        }

        return false;
    }
}
