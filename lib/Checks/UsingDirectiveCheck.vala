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

public class ValaLint.Checks.UsingDirectiveCheck : Check {
    const string MESSAGE = _("Use explicit namespace instead");

    public UsingDirectiveCheck () {
        Object (
            title: "using-directive",
            description: _("Checks for undesirable using directives")
        );

        state = Config.get_state (title);
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_using_directive (Vala.UsingDirective ns, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (state == Config.State.OFF) {
            return;
        }

        var pos = ns.source_reference;
        add_mistake ({ this, pos.begin, pos.end, MESSAGE }, ref mistake_list);
    }
}
