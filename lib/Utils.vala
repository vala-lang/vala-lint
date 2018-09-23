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

public class ValaLint.Utils : Object {
    /**
     * Method to get the line count of a string.
     *
     * @return The number of lines in the input string.
     */
    public static int get_line_count (string input) {
        return int.max (input.split ("\n").length - 1, 0);
    }

    /**
     * Method to get the char position in the current line of the input string.
     *
     * @return The char index.
     */
    public static int get_char_index_in_line (string input, int pos) {
        return pos - input[0:pos].last_index_of_char ('\n') - 1;
    }
}
