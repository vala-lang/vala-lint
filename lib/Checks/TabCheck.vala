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
 */

public class ValaLint.Checks.TabCheck : Check {
    public TabCheck () {
        Object (
            title: _("use-of-tabs"),
            description: _("Checks for tabs instead of spaces"),
            single_mistake_in_line: true
        );

        state = Config.get_state (title);
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {
        foreach (ParseResult r in parse_result) {
            if (r.type == ParseType.DEFAULT || r.type == ParseType.COMMENT) {
                add_regex_mistake ("""\t""", _("Expected spaces instead of tabs"), r, ref mistake_list);
            }
        }
    }
}
