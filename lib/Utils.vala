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
        return input.split ("\n").length - 1;
    }

    /**
     * Method to get the char position in the current line of the input string.
     *
     * @return The char index.
     */
    public static int get_char_index_in_line (string input, int pos) {
        return pos - input[0:pos].last_index_of_char ('\n') - 1;
    }

    public static void add_regex_mistake (Check check, string pattern, string mistake, ParseResult parse_result, Gee.ArrayList<FormatMistake? > mistakes, int char_offset = 0) {

        MatchInfo match_info;
        try {
            var regex = new Regex (pattern);
            regex.match (parse_result.text, 0, out match_info);
            while (match_info.matches () ) {
                int pos_start, pos_end;
                match_info.fetch_pos (0, out pos_start, out pos_end);

                int line_count = get_line_count (parse_result.text[0:pos_start]);
                int line_pos = parse_result.line_pos + line_count;
                int char_pos = char_offset + get_char_index_in_line (parse_result.text, pos_start);
                if (line_count == 0) {
                    char_pos += parse_result.char_pos;
                }

                mistakes.add ({ check, line_pos, char_pos, mistake});
                match_info.next ();
            }
        } catch {
            error ("%s is not a valid Regex", pattern);
        }
    }
}
