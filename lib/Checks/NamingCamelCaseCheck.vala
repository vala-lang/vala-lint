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

public class ValaLint.Checks.NamingCamelCaseCheck : Check {
    public NamingCamelCaseCheck () {
        Object (
            title: _("naming-convention"),
            description: _("Checks for the camel case naming convention")
        );
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        foreach (ParseResult r in parse_result) {
            add_regex_mistake ("""(^[a-z]|_)""", _("Expected variable name in CamelCaseConvention"), r, ref mistake_list, 0, true);
        }
    }
}
