/*
 * Copyright (c) 2018-2019 elementary LLC. (https://github.com/elementary/vala-lint)
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

public class ValaLint.Checks.DoubleSpacesCheck : Check {
    public DoubleSpacesCheck () {
        Object (
            title: _("double-spaces"),
            description: _("Checks for double spaces")
        );

        state = Config.get_state (title);
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {
        for (int i = 0; i < parse_result.size; i++) {
            ParseResult r = parse_result[i];
            if (r.type == ParseType.DEFAULT) {
                bool next_is_comment = (i + 1 < parse_result.size && parse_result[i + 1].type == ParseType.COMMENT);

                /* Iterate through lines of parsed result */
                var text_split = r.text.split ("\n");
                for (int j = 0; j < text_split.length; j++) {
                    unowned string line_string = text_split[j];

                    if (line_string.length == 0) {
                        continue;
                    }

                    char* pos_start = (char *)line_string;
                    char* pos_end = pos_start + line_string.length;
                    if (j > 0 || r.begin.column == 1) {
                        while (pos_start[0].isspace () && pos_start < pos_end) {
                            pos_start += 1;
                        }
                    }
                    if (j < text_split.length - 1 || next_is_comment) {
                        while (pos_end[-1].isspace () && pos_end > pos_start) {
                            pos_end -= 1;
                        }
                    }

                    char* index = Utils.get_pos_of ("  ", pos_start, pos_end);
                    while (index != null) {
                        int column = Utils.get_column_of ((char *)line_string, index);
                        if (j == 0) {
                            column += r.begin.column - 1;
                        }
                        var begin = Vala.SourceLocation (index, r.begin.line + j, column);
                        var end = Utils.shift_location (begin, 2);
                        add_mistake ({ this, begin, end, "Expected single space" }, ref mistake_list);

                        while (index[0].isspace () && index < pos_end) {
                            index += 1;
                        }

                        index = Utils.get_pos_of ("  ", index + 1, pos_end);
                    }
                }

            }
        }
    }
}
