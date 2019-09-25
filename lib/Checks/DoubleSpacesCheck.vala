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

                var text_split = r.text.split ("\n");
                for (int j = 0; j < text_split.length; j++) {
                    unowned string line_string = text_split[j];

                    if (line_string.length == 0) {
                        continue;
                    }

                    int trim_start = 0;
                    int trim_end = line_string.length;
                    if (j > 0 || r.begin.column == 1) {
                        while (line_string[trim_start].isspace () && trim_start < trim_end) {
                            trim_start += 1;
                        }
                    }
                    if (j < text_split.length - 1 || next_is_comment) {
                        while (line_string[trim_end - 1].isspace () && trim_end > trim_start) {
                            trim_end -= 1;
                        }
                    }

                    int index = line_string[0:trim_end].index_of ("  ", trim_start);
                    while (index > -1) {
                        int line = r.begin.line + j;
                        int column = (j == 0) ? r.begin.column + index : index;

                        var begin = Vala.SourceLocation ((char *)line_string + index, line, column);
                        var end = Utils.shift_location (begin, 2);
                        add_mistake ({ this, begin, end, "Expected single space" }, ref mistake_list);

                        while (line_string[index].isspace () && index < trim_end) {
                            index += 1;
                        }

                        index = line_string[0:trim_end].index_of ("  ", index + 1);
                    }
                }

            }
        }
    }
}
