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

    // For ParseDetailType
    string[] start_patterns = {
        """(\/\/)""",
        """(\/\*)""",
        """(\"\"\")""",
        """(@")""",
        """(")""",
        """(')"""
    };
    string[] close_patterns = {
        """(\n)""",
        """(\*\/)""",
        """((?<!\\)(\\\\)*\"\"\")""",
        """((?<!\\)(\\\\)*")""",
        """((?<!\\)(\\\\)*")""",
        """((?<!\\)(\\\\)*')"""
    };
    ParseType[] parse_types = {
        ParseType.COMMENT,
        ParseType.COMMENT,
        ParseType.STRING,
        ParseType.STRING,
        ParseType.STRING,
        ParseType.STRING,
        ParseType.DEFAULT
    };

    struct MatchTypeInfo {
        MatchInfo match_info;
        ParseDetailType type;
        int start_pos;
        int end_pos;
    }

    public Vala.ArrayList<ParseResult?> parse (string input) {
        var result = new Vala.ArrayList<ParseResult?> ();

        int search_pos = 0;
        int current_line = 0;

        MatchTypeInfo info = match_type(input, start_patterns, search_pos);
        while (info.match_info.matches ()) {
            if (info.start_pos > search_pos) {
                add_result (input, search_pos, info.start_pos, ParseDetailType.CODE, result, ref current_line);
            }
            search_pos = info.start_pos;

            MatchTypeInfo info_close = match_type (input, {close_patterns[info.type]}, info.end_pos);
            if (info_close.match_info.matches ()) {
                add_result (input, search_pos, info_close.end_pos, info.type, result, ref current_line);
            } else {
                add_result (input, search_pos, input.length, info.type, result, ref current_line);
                search_pos = input.length;
                break;
            }

            search_pos = info_close.end_pos;
            info = match_type (input, start_patterns, info_close.end_pos);
        }

        if (input.length > search_pos) {
            add_result (input, search_pos, input.length, ParseDetailType.CODE, result, ref current_line);
        }
        return result;
    }

    /**
     * Matches one of multiple regex patterns.
     *
     * @param input The input string.
     * @param patterns The array of regex patterns.
     * @param start_search_pos The start position for searching in the input string.
     * @param info The output, including which pattern was matched and the exact position.
     */
    MatchTypeInfo match_type (string input, string[] patterns, int start_search_pos) {
        string entire_pattern = string.joinv ("|", patterns); // Join regex patterns
        var info = MatchTypeInfo ();

        try {
            var regex = new Regex (entire_pattern);
            if (regex.match_full (input, -1, start_search_pos, 0, out info.match_info)) {
                info.match_info.fetch_pos (0, out info.start_pos, out info.end_pos);
                for (int i = 0; i < info.match_info.get_match_count (); i++) {
                    if (info.match_info.fetch (i + 1).length > 0) {
                        info.type = (ParseDetailType)i;
                        return info;
                    }
                }
            }
        } catch {
            error ("Regex error in parser: %s", entire_pattern);
        }
        return info;
    }

    /**
     * Adds a parse result entry.
     *
     * @param input The input string.
     * @param start_pos The start character position in the input string of the entry.
     * @param end_pos The end character position in the input string of the entry.
     * @param type The general type of the parsed entry.
     * @param result The final parsed result array.
     * @param result The current line of the entry in the input string.
     */
    void add_result (string input, int start_pos, int end_pos, ParseDetailType detail_type,
                     Vala.ArrayList<ParseResult?> result, ref int current_line) {
        string text = input[start_pos:end_pos];
        var loc = Vala.SourceLocation ((char *)text, current_line + 1, Utils.get_column_in_line (input, start_pos) + 1);
        result.add ({ text, parse_types[detail_type], detail_type, loc });
        current_line += Utils.get_line_count (text);
    }
}
