/*
 * Copyright (c) 2016-2019 elementary LLC. (https://github.com/elementary/vala-lint)
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

    /**
     * Property whether the check is enabled in the current linter config.
     */
    public Config.State state { get; set; }

    /**
     * Checks a given parse result for formatting mistakes.
     *
     * @param parse_result The parsed string.
     * @param mistake_list The list new mistakes should be added to.
     */
    public abstract void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list);

    /**
     * Adds a mistake based on a regex pattern.
     *
     * @param pattern The regex pattern.
     * @param mistake The mistake description.
     * @param parse_result The current parse result element.
     * @param mistakes The mistakes list.
     * @param column_offset The offset between the mistake char position and the regex pattern start.
     */
    protected void add_regex_mistake (string pattern,
                                      string mistake,
                                      ParseResult parse_result,
                                      ref Vala.ArrayList<FormatMistake?> mistakes,
                                      int length = 1,
                                      int column_offset = 0,
                                      bool return_after_mistake = false) {

        MatchInfo match_info;
        try {
            var regex = new Regex (pattern);
            regex.match (parse_result.text, 0, out match_info);
            while (match_info.matches ()) {
                int pos_start, pos_end;
                match_info.fetch_pos (0, out pos_start, out pos_end);

                int pos_mistake = pos_start + column_offset;
                var begin = Utils.get_absolute_location (parse_result.begin, parse_result.text, pos_mistake);
                var end = Utils.get_absolute_location (parse_result.begin, parse_result.text, pos_mistake + length);

                /* If single_mistake_in_line is true, add only one mistake of the same check per line */
                if (!single_mistake_in_line ||
                    (mistakes.is_empty || mistakes.last ().check != this ||
                    mistakes.last ().begin.line < begin.line)) {

                    add_mistake ({ this, begin, end, mistake }, ref mistakes);
                }

                if (return_after_mistake) {
                    break;
                }
                match_info.next ();
            }
        } catch {
            critical ("%s is not a valid Regex", pattern);
        }
    }

    /**
     * Adds a mistake to the mistake list and checks for duplicates.
     *
     * @param mistake The mistake.
     * @param mistakes The mistakes list.
     */
    protected void add_mistake (FormatMistake mistake, ref Vala.ArrayList<FormatMistake?> mistakes) {
        if (!mistakes.contains (mistake)) {
            mistakes.add (mistake);
        }
    }

    // TODO: docstring
    public virtual bool apply_fix (Vala.SourceLocation begin, Vala.SourceLocation end, ref string contents) {
        return false;
    }
}
