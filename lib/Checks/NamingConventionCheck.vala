/*
 * Copyright (c) 2019 elementary LLC. (https://github.com/elementary/vala-lint)
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

public class ValaLint.Checks.NamingConventionCheck : Check {
    public NamingConventionCheck () {
        Object (
            title: _("naming-convention"),
            description: _("Checks the naming convention")
        );

        state = Config.get_state (title);
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    private bool name_is_invalid (string name) {
        unichar c;
        for (int i = 0; name.get_next_char (ref i, out c);) {
            if (!(c.isalpha () || c.isdigit () || c == '_')) {
                return true;
            }
        }
        return false;
    }

    public void check_all_caps (Vala.Symbol symbol, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (state == Config.State.OFF || symbol.name == null) {
            return;
        }

        if (symbol.name != symbol.name.up () || name_is_invalid (symbol.name)) {
            var begin = symbol.source_reference.begin;
            var end = Utils.shift_location (begin, symbol.name.length);
            add_mistake ({ this, begin, end, _("Expected variable name in ALL_CAPS_CONVENTION") }, ref mistake_list);
        }
    }

    public void check_camel_case (Vala.Symbol symbol, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (state == Config.State.OFF || symbol.name == null) {
            return;
        }

        if (symbol.name[0].islower () || symbol.name.contains ("_") || name_is_invalid (symbol.name)) {
            var begin = symbol.source_reference.begin;
            var end = Utils.shift_location (begin, symbol.name.length);
            add_mistake ({ this, begin, end, _("Expected variable name in CamelCaseConvention") }, ref mistake_list);
        }
    }

    public void check_underscore (Vala.Symbol symbol, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (state == Config.State.OFF || symbol.name == null) {
            return;
        }

        if (symbol.name != symbol.name.down () || name_is_invalid (symbol.name)) {
            var begin = symbol.source_reference.begin;
            var end = Utils.shift_location (begin, symbol.name.length);
            add_mistake ({ this, begin, end, _("Expected variable name in underscore_convention") }, ref mistake_list);
        }
    }
}
