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
     * Method to get the position within an input string. Similar to index_of, but for non-null terminated strings using char pointers.
     *
     * @return The position of first index, otherwise null.
     */
    public static char* get_pos_of (string needle, char* begin, char* end) {
        char* pos = begin;
        while (pos <= end - needle.length) {
            bool equal = true;
            for (int i = 0; i < needle.length; i++) {
                if (pos[i] != needle[i]) {
                    equal = false;
                    break;
                }
            }

            if (equal) {
                return pos;
            }

            pos += 1;
        }

        return null;
    }

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
     * Method to get the char position in the current line of the input string using char pointers.
     *
     * @return The char column.
     */
    public static int get_column_of (char* begin, char* pos) {
        int i = 0;
        while ((pos - i)[-1] != '\n' && pos - i > begin) {
            i += 1;
        }
        return i + 1;
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
    public delegate bool FilterFunction<G> (G element);
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

    /**
     * Computes the fix for a mistake, if the check provides one, by running the check's
     * fix logic against a copy of the file contents and diffing the result against the
     * original contents.
     *
     * @param check The check the mistake was reported by.
     * @param begin The source location where the mistake begins.
     * @param end The source location where the mistake ends.
     * @param original_contents The unmodified contents of the file containing the mistake.
     *
     * @return The computed fix, or null if the check does not provide one for this mistake.
     */
    public static CodeFix? compute_fix (Check check, Vala.SourceLocation begin, Vala.SourceLocation end,
                                        string original_contents) {

        string fixed_contents = original_contents;
        bool applied = check.apply_fix (begin, end, ref fixed_contents);
        if (!applied || fixed_contents == original_contents) {
            return null;
        }

        int max_common = int.min (original_contents.length, fixed_contents.length);

        int prefix_len = 0;
        while (prefix_len < max_common && original_contents[prefix_len] == fixed_contents[prefix_len]) {
            prefix_len++;
        }

        int max_suffix = max_common - prefix_len;
        int suffix_len = 0;
        while (
            suffix_len < max_suffix &&
            original_contents[original_contents.length - 1 - suffix_len] ==
            fixed_contents[fixed_contents.length - 1 - suffix_len]
        ) {
            suffix_len++;
        }

        string replacement = fixed_contents[prefix_len : fixed_contents.length - suffix_len];

        int fix_begin_line, fix_begin_column, fix_end_line, fix_end_column;
        get_line_column_at_offset (original_contents, prefix_len, out fix_begin_line, out fix_begin_column);
        get_line_column_at_offset (
            original_contents, original_contents.length - suffix_len, out fix_end_line, out fix_end_column
        );

        return CodeFix () {
            replacement = replacement,
            begin_line = fix_begin_line,
            begin_column = fix_begin_column,
            end_line = fix_end_line,
            end_column = fix_end_column
        };
    }

    /**
     * Method to convert an absolute byte offset within a string to a 1-indexed line and column.
     */
    static void get_line_column_at_offset (string text, int offset, out int line, out int column) {
        line = 1;
        int line_start = 0;
        for (int i = 0; i < offset; i++) {
            if (text[i] == '\n') {
                line++;
                line_start = i + 1;
            }
        }

        column = offset - line_start + 1;
    }
}
