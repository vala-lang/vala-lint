/*
 * Copyright (c) 2018 elementary LLC. (https://github.com/elementary/vala-lint)
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
    }

    public override void check (Gee.ArrayList<ParseResult?> parse_result, ref Gee.ArrayList<FormatMistake?> mistake_list) {
        foreach (ParseResult r in parse_result) {
            if (r.type == ParseType.Default) {
                add_regex_mistake ("""\S  """, "Unexpected double spaces", r, ref mistake_list, 1);

                // Check for problems at the beginning of strings
                if (r.char_pos > 1) {
                    add_regex_mistake ("""^  """, "Unexpected double spaces", r, ref mistake_list);
                }
            }
        }
    }
}
