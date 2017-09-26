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

public class ValaLint.Utils {
    public static bool is_char_inside_string (string line, int char_index) {
        /*
            Example for easier understanding:

            "a'b'c\"d'e'f\"g"h'i'

              " => is_in_string = true, is_in_char = false, escape_on = false
            a ' => is_in_string = true, is_in_char = false, escape_on = false
            b ' => is_in_string = true, is_in_char = false, escape_on = false
            c \ => is_in_string = true, is_in_char = false, escape_on = true
              " => is_in_string = true, is_in_char = false, escape_on = false
            d ' => is_in_string = true, is_in_char = false, escape_on = false
            e ' => is_in_string = true, is_in_char = false, escape_on = false
            f \ => is_in_string = true, is_in_char = false, escape_on = true
              " => is_in_string = true, is_in_char = false, escape_on = false
            g " => is_in_string = false, is_in_char = false, escape_on = false
            h ' => is_in_string = false, is_in_char = true, escape_on = false
            i ' => is_in_string = false, is_in_char = false, escape_on = false
        */

        bool is_in_string = false;
        bool is_in_char = false;
        bool escape_on = false;

        char[] chars = line.to_utf8 ();

        for (int i = 0; i < char_index; i++) {
            if (chars[i] == '"' && !escape_on && !is_in_char) {
                is_in_string = !is_in_string;
            } else if (chars[i] == '\'' && !escape_on && !is_in_string) {
                is_in_char = !is_in_char;
            } else if (chars[i] == '\\') {
                escape_on = !escape_on;
                continue;
            }

            if (escape_on) {
                escape_on = false;
            }
        }

        return is_in_string || is_in_char;
    }
}
