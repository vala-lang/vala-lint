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

public class ValaLint.Parser : Object {

    private struct MatchTypeInfo {
        MatchInfo match_info;
        int type;
        int pos_start;
        int pos_end;
    }

    /*
     * 0: Inline comment //
     * 1: Multiline comment /*, \*\/
     * 2: Verbatim string """, """
     * 3: Interpolated string @", "
     * 4: Normal string ", "
     * 5: Single char ', '
     */
    private string regexes_start = "(\\/\\/)|(\\/\\*)|(\"\"\")|(@\")|(\")|(\\')";


    public Gee.ArrayList<ParseResult?> parse (string input) {
        var result = new Gee.ArrayList<ParseResult?> ();

        int search_pos = 0;
        int current_line = 0;

        MatchTypeInfo info;
        match_type (input, regexes_start, search_pos, out info);

        while (info.match_info.matches()) {
            if (info.pos_start > search_pos) {
                add_result (input, search_pos, info.pos_start, ParseType.Default, result, ref current_line);
            }
            search_pos = info.pos_start;

            MatchTypeInfo info_close;
            match_type (input, get_close_regex(info.type), info.pos_end, out info_close);

            if (info_close.match_info.matches()) {
                add_result (input, search_pos, info_close.pos_end, get_parse_type(info.type), result, ref current_line);
            } else {
                add_result (input, search_pos, input.length, get_parse_type(info.type), result, ref current_line);
                search_pos = input.length;
                break;
            }

            search_pos = info_close.pos_end;
            match_type (input, regexes_start, info_close.pos_end, out info);
        }

        if (search_pos < input.length) {
            add_result (input, search_pos, input.length, ParseType.Default, result, ref current_line);
        }
        return result;
    }

    private void match_type (string input, string regexes, int start_search_pos, out MatchTypeInfo info) {
        try {
            var regex = new Regex (regexes);
            if (regex.match_full (input, -1, start_search_pos, 0, out info.match_info)) {
                info.match_info.fetch_pos (0, out info.pos_start, out info.pos_end);
                for (int i = 0; i < info.match_info.get_match_count (); i++) {
                    if (info.match_info.fetch (i + 1).length > 0) {
                        info.type = i;
                        return;
                    }
                }
            }
        } catch {
            error ("Regex error in parser: %s", regexes);
        }
    }

    private void add_result (string input, int pos_start, int pos_end, ParseType type, Gee.ArrayList<ParseResult?> result, ref int current_line) {
        var text = input[pos_start:pos_end];
        result.add (ParseResult () {
            text = text,
            type = type,
            line_pos = current_line + 1,
            char_pos = ValaLint.Utils.get_char_number(input, pos_start) + 1
        });
        current_line += ValaLint.Utils.get_lines(text);
    }

    private ParseType get_parse_type(int type_number) {
        switch (type_number) {
            case 0:
            case 1: {
                return ParseType.Comment;
            }
            case 2:
            case 3:
            case 4:
            case 5: {
                return ParseType.String;
            }
        }
        return ParseType.Default;
    }

    private string get_close_regex(int type_number) {
        switch (type_number) {
            case 0: { // Inline comment
                return "(\n)";
            }
            case 1: { // Multiline comment
                return "(\\*\\/)";
            }
            case 2: { // Verbatim string
                return "((?<!\\\\)(\\\\\\\\)*\"\"\")";
            }
            case 3:
            case 4: { // Interpolated and normal string
                return "((?<!\\\\)(\\\\\\\\)*\")";
            }
            case 5: { // Single char
                return "((?<!\\\\)(\\\\\\\\)*\\')";
            }
        }
        return "";
    }
}
