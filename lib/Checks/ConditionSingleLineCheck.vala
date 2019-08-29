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
        var statements = body.get_statements ();
        if (!statements.is_empty) {
            var first_statement = statements.first ();

            if (body.source_reference.begin.line > body.source_reference.end.line
                || (body.source_reference.begin.line == body.source_reference.end.line
                    && body.source_reference.begin.column > body.source_reference.end.column)) {
                // Block doesnt have braces                
                if (body.source_reference.end.line == first_statement.source_reference.begin.line) {
                    var begin = first_statement.source_reference.begin;
                    var end = begin;
                    end.pos += 1;
                    end.column += 1;

                    add_mistake ({ this, begin, end, "If statement should not be on a single line" }, ref mistake_list);
                }
            } else {
                // Block has braces
                if (body.source_reference.begin.line == first_statement.source_reference.begin.line) {
                    var begin = first_statement.source_reference.begin;
                    var end = begin;
                    end.pos += 1;
                    end.column += 1;

                    add_mistake ({ this, begin, end, "If statement should not be on a single line" }, ref mistake_list);
                }
            }
        }
    }
}
