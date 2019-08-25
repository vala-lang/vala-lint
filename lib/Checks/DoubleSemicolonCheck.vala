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

public class ValaLint.Checks.DoubleSemicolonCheck : Check {
    public DoubleSemicolonCheck () {
        Object (
            title: _("double-semicolon"),
            description: _("Checks for unnecessary semicolons")
        );
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_statement (Vala.CodeNode stmt,
                            ref Vala.ArrayList<FormatMistake?> mistake_list) {

        var end = stmt.source_reference.end;
        var offset = end.pos[-1] == ';' ? -1 : 0; // End location can be off by one

        if (end.pos[offset] == ';' && end.pos[offset + 1] == ';') {
            var loc = end;
            loc.pos += offset + 2;
            loc.column += offset + 2;

            add_mistake ({ this, loc, "Unnecessary semicolon" }, ref mistake_list);
        }
    }
}
