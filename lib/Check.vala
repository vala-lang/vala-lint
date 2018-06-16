/*
 * Copyright (c) 2016-2018 elementary LLC. (https://github.com/elementary/vala-lint)
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
 *
 * Authored by: Marcus Wichelmann <marcus.wichelmann@hotmail.de>
 */

public abstract class ValaLint.Check : Object {

    /**
     * A structure used to hold the regex patterns used to parse for errors
     * within a check.
     */
    public struct RegexCheck {
        public ParseType match_types;
        public Regex pattern;
        public string mistake_text;
        public int offset;
    }

    /**
     * Property whether the check should allow multiple mistakes in a single line.
     */
    public bool single_mistake_in_line { get; construct; default = false; }

    /**
     * Short but descriptive title of the check.
     */
    public string title { get; construct; }

    /**
     * A short description of what this class checks for.
     */
    public string description { get; construct; }

    private Gee.ArrayList<RegexCheck?> mistake_checkers = new Gee.ArrayList<RegexCheck?> ();

    /**
     * Checks a given parse result for formatting mistakes.
     *
     * @param parse_result The parsed string.
     * @param mistake_list The list new mistakes should be added to.
     */
    public virtual void check (Gee.ArrayList<ParseResult?> parse_results, ref Gee.ArrayList<FormatMistake?> mistakes) {
        foreach (var check in mistake_checkers) {
            MatchInfo match_info;
            foreach (var parse_result in parse_results) {
                if (!(parse_result.type in check.match_types)) {
                    continue;
                }

                try {
                    check.pattern.match (parse_result.text, 0, out match_info);
                    while (match_info.matches ()) {
                        int pos_start;
                        match_info.fetch_pos (0, out pos_start, null);

                        int pos_mistake = pos_start + check.offset;
                        int line_count = Utils.get_line_count (parse_result.text[0:pos_mistake]);
                        int line_pos = parse_result.line_pos + line_count;
                        int char_pos = Utils.get_char_index_in_line (parse_result.text, pos_mistake);
                        if (line_count == 0) {
                            char_pos += parse_result.char_pos;
                        }

                        /* If single_mistake_in_line is true, add only one mistake of the same check per line */
                        if (!single_mistake_in_line ||
                            (mistakes.is_empty || mistakes.last ().check != this || mistakes.last ().line_index < line_pos)) {
                            mistakes.add ({ this, line_pos, char_pos, check.mistake_text });
                        }


                        match_info.next ();
                    }
                } catch (Error e) {
                    critical ("Error while running regex against file: %s", e.message);
                }
            }
        }
    }

    /**
     * Adds a type of mistake to match against based on a regex pattern.
     *
     * @param types Flags containing the parts of the file to check.
     * @param pattern The regex pattern to try and match.
     * @param mistake The warning text to display to the user
     * @param char_offset The offset between the mistake char position and the regex pattern start.
     */
    protected void add_regex_check (ParseType types, string pattern, string mistake, int char_offset = 0) {
        Regex regex;
        try {
            regex = new Regex (pattern);
        } catch (Error e) {
            critical ("Error constructing regex \"%s\" for check: %s", pattern, e.message);
            return;
        }

        var check = RegexCheck () {
            match_types = types,
            pattern = regex,
            mistake_text = mistake,
            offset = char_offset
        };

        mistake_checkers.add (check);
    }
}
