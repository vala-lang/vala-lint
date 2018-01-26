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

    public static int get_lines (string input) {
        return input.split ("\n").length - 1;
    }

    public static int get_char_number (string input, int pos) {
        return pos - input[0:pos].last_index_of_char ('\n') - 1;
    }

    public static void add_regex_mistake (Check check, string pattern, string mistake, ParseResult parse_result, Gee.ArrayList<FormatMistake? > mistake_list) {

        MatchInfo match_info;
        try {
            var regex = new Regex (pattern);

            regex.match (parse_result.text, 0, out match_info);
            while (match_info.matches () ) {
                int pos_start, pos_end;
                match_info.fetch_pos (0, out pos_start, out pos_end);

                int line_pos = ValaLint.Utils.get_lines(parse_result.text[0:pos_start]);
                int char_pos = ValaLint.Utils.get_char_number(parse_result.text, pos_start);

                mistake_list.add ({ check, parse_result.line_pos + line_pos, parse_result.char_pos + char_pos, mistake});
                match_info.next ();
            }
        } catch {
            error ("%s is not a valid Regex", pattern);
        }
    }
}
