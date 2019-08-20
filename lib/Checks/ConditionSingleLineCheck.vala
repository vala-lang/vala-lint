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

public class ValaLint.Checks.ConditionSingleLineCheck : Check {
    public ConditionSingleLineCheck () {
        Object (
            title: _("condition-single-line"),
            description: _("Checks that a condition does not share its line")
        );
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_statement (Vala.Expression condition, Vala.Block body,
                                 ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (body.source_reference.begin.line == condition.source_reference.end.line
            && body.source_reference.end.line == condition.source_reference.end.line) {
            var loc = body.source_reference.begin;
            add_mistake ({ this, loc, "If statement should not be on a single line" }, ref mistake_list);
        }
    }
}
