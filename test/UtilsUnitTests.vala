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

class UtilsUnitTest : Object {

    public static int main (string[] args) {

        string example = """var position = 1.2; // [mm]
var velocity = 2.0; // [mm]
int counter = 0; /* Hello */
int second = 60;
/*
* Text
*/
string a = @"text";
string b = "c";
char c = 'c';
/* string a = @"asdf"; */""";

        assert (ValaLint.Utils.get_line_count ("lorem ipsum") == 0);
        assert (ValaLint.Utils.get_line_count (example) == 10);

        assert (ValaLint.Utils.get_char_index_in_line (example, 5) == 5);
        assert (ValaLint.Utils.get_char_index_in_line (example, 60) == 4);
        assert (ValaLint.Utils.get_char_index_in_line (example, 98) == 13);

        return 0;
    }
}
