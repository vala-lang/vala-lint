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

class ParserUnitTest : GLib.Object {

    public static int main (string[] args) {

        var parser = new ValaLint.Parser ();
        var result = parser.parse ("""var position = 1.2; // [mm]
var velocity = 2.0; // [mm]
int counter = 0; /* Hello */
int second = 60;
/*
* Text
*/
string a = @"text";
string b = "c";
char c = 'c';
/* string a = @"asdf"; */""");
        assert (result.size == 16);
        assert (result[0].type == ParseType.Default);
        assert (result[0].text == "var position = 1.2; ");
        assert (result[0].line_pos == 1);
        assert (result[0].char_pos == 1);
        assert (result[1].type == ParseType.Comment);
        assert (result[1].line_pos == 1);
        assert (result[1].char_pos == 21);
        assert (result[2].type == ParseType.Default);
        assert (result[2].text == "var velocity = 2.0; ");
        assert (result[2].line_pos == 2);
        assert (result[2].char_pos == 1);
        assert (result[13].type == ParseType.String);
        assert (result[15].type == ParseType.Comment);
        assert (result[15].line_pos == 11);
        assert (result[15].char_pos == 1);

        result = parser.parse ("var boolean = true; // why?
string a = \"test\";

// More definitions
struct {
    int that = 2;
}");
        assert (result.size == 7);
        assert (result[0].text == "var boolean = true; ");
        assert (result[2].text == "string a = ");
        assert (result[3].type == ParseType.String);
        assert (result[3].text == "\"test\"");
        assert (result[3].line_pos == 2);
        assert (result[3].char_pos == 12);
        assert (result[4].line_pos == 2);
        assert (result[4].char_pos == 18);

        return 0;
    }
}
