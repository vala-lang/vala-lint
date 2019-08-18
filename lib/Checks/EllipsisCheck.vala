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
 */

public class ValaLint.Checks.EllipsisCheck : Check {
    public EllipsisCheck () {
        Object (
            title: _("ellipsis"),
            description: _("Checks for ellipsis character instead of three periods")
        );
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_string_literal (Vala.StringLiteral lit, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        var a = lit.value.index_of ("..."); // vala-lint=ellipsis
        if (a > -1) {
            var location = Utils.get_absolute_location (lit.source_reference.begin, lit.value, a);
            add_mistake ({ this, location, _("Expected ellipsis instead of three periods") }, ref mistake_list);
        }
    }
}
