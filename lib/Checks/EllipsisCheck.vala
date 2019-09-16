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

public class ValaLint.Checks.EllipsisCheck : Check {
    const string ELLIPSIS = "..."; // vala-lint=ellipsis

    public EllipsisCheck () {
        Object (
            title: _("ellipsis"),
            description: _("Checks for ellipsis character instead of three periods")
        );

        state = Config.get_state (title);
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_string_literal (Vala.StringLiteral lit, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        var index = lit.value.index_of (ELLIPSIS);
        while (index > -1) {
            var begin = Utils.get_absolute_location (lit.source_reference.begin, lit.value, index);

            // Find length and end of periods
            var length = 0;
            while (lit.value[index + length] == '.') {
                length += 1;
            }

            var end = Utils.shift_location (begin, length);

            add_mistake ({ this, begin, end, _("Expected ellipsis instead of periods") }, ref mistake_list);

            index = lit.value.index_of (ELLIPSIS, index + length);
        }
    }
}
