/*
 * Copyright (c) 2018-2019 elementary LLC. (https://github.com/elementary/Vala-Lint)
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
     * @return The char column.
     */
    public static int get_column_in_line (string input, int pos) {
        return pos - input[0:pos].last_index_of_char ('\n') - 1;
    }

    /**
     * Method to calculate an absolute location given a reference location and an offset column.
     * 
     * @return The absolute location.
     */
    public static Vala.SourceLocation get_absolute_location (Vala.SourceLocation reference, string text, int offset) {
        // Clip the offset at text end
        offset = int.min (offset, text.length);

        int line_count = Utils.get_line_count (text[0:offset]);
        int line = reference.line + line_count;
        int column = Utils.get_column_in_line (text, offset);
        if (line_count == 0) {
            column += reference.column;
        }

        return Vala.SourceLocation (reference.pos + offset, line, column);
    }

    /**
     * Filter an ArrayList based on a given lambda.
     * 
     * @return The filtered array.
     */
    public delegate bool<G> FilterFunction<G> (G element);
    public static Vala.ArrayList<G> filter<G> (FilterFunction<G> func, Vala.ArrayList<G> source) {
        var result = new Vala.ArrayList<G> ();

        foreach (G elem in source) {
            if (func (elem)) {
                result.add (elem);
            }
        }

        return result;
    }

    /**
     * Method to return a new Vala.SourceLocation from a reference shifted by a given offset.
     * 
     * @return The new Vala.SourceLocation
     */
    public static Vala.SourceLocation shift_location (Vala.SourceLocation reference, int offset) {
        var result = reference;
        result.pos += offset;
        result.column += offset;
        return result;
    }
}
