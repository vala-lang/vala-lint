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
            description: _("Checks that a statement does not share its line")
        );
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_statement (Vala.Block body, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        var statements = body.get_statements ();
        if (statements.is_empty) {
            return;
        }

        var body_ref = body.source_reference;
        var first_ref = statements.first ().source_reference;

        /* First find out if the body has braces around it */
        bool body_without_braces = body_ref.begin.line > body_ref.end.line
            || (body_ref.begin.line == body_ref.end.line && body_ref.begin.column > body_ref.end.column);

        /* If it does, it can only have one line */
        var comparison_pos = body_without_braces ? body_ref.end : body_ref.begin;

        if (comparison_pos.line == first_ref.begin.line) {
            var begin = first_ref.begin;
            var end = begin;
            end.pos += 1;
            end.column += 1;

            add_mistake ({ this, begin, end, "Expected line break after statement" }, ref mistake_list);
        }
    }
}
