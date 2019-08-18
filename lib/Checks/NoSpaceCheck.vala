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

public class ValaLint.Checks.NoSpaceCheck : Check {
    public NoSpaceCheck () {
        Object (
            title: _("no-space"),
            description: _("Checks for missing spaces")
        );
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_list (Vala.List<Vala.CodeNode?> list,
                            ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (list.size > 1) {
            for (int i = 0; i < list.size - 1; i++) {
                var expr = list[i];
                var end = expr.source_reference.end;

                if (expr is Vala.Parameter) {
                    var parameter = expr as Vala.Parameter;
                    if (parameter.initializer != null) {
                        end = parameter.initializer.source_reference.end;
                    }
                }

                char char_after = * (end.pos + 1);
                if (char_after != ' ' && char_after != '\n' && char_after != ')') {
                    var loc = end;
                    loc.column += 2;
                    add_mistake ({ this, loc, "Missing whitespace" }, ref mistake_list);
                }
            }
        }
    }

    public void check_binary_expression (Vala.BinaryExpression expr,
                                         ref Vala.ArrayList<FormatMistake?> mistake_list) {

        char char_before_operator = * (expr.left.source_reference.end.pos);
        if (char_before_operator != ' ' && char_before_operator != '\n' && char_before_operator != ')') {
            var loc = expr.left.source_reference.end;
            loc.column += 1;
            add_mistake ({ this, loc, "Missing whitespace" }, ref mistake_list);
        }

        char char_after_operator = * (expr.right.source_reference.begin.pos - 1);
        if (char_after_operator != ' ' && char_after_operator != '\n' && char_after_operator != '(') {
            var loc = expr.right.source_reference.begin;
            add_mistake ({ this, loc, "Missing whitespace" }, ref mistake_list);
        }
    }
}
