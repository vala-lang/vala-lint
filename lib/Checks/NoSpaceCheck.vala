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
                var reference = expr.source_reference.end;

                if (expr is Vala.Parameter) {
                    var parameter = expr as Vala.Parameter;
                    if (parameter.initializer != null) {
                        reference = parameter.initializer.source_reference.end;
                    }
                }

                // Move char to comma seperator
                int offset = 0;
                while (reference.pos[offset] != ',') {
                    offset += 1;
                }
                offset += 1;

                if (reference.pos[offset] != ' ' && reference.pos[offset] != '\n') {
                    var begin = reference;
                    begin.pos += offset + 1;
                    begin.column += offset + 1;
                    var end = begin;
                    end.pos += 1;
                    end.column += 1;

                    add_mistake ({ this, begin, end, "Missing whitespace" }, ref mistake_list);
                }
            }
        }
    }

    public void check_binary_expression (Vala.BinaryExpression expr,
                                         ref Vala.ArrayList<FormatMistake?> mistake_list) {

        char* char_before = expr.left.source_reference.end.pos;
        if (char_before[0] != ' ' && char_before[0] != '\n' && char_before[0] != ')') {
            var begin = expr.left.source_reference.end;
            begin.pos += 1;
            begin.column += 1;
            var end = begin;
            end.pos += 1;
            end.column += 1;

            add_mistake ({ this, begin, end, "Missing whitespace" }, ref mistake_list);
        }

        char* char_after = expr.right.source_reference.begin.pos - 1;
        if (char_after[0] != ' ' && char_after[0] != '\n' && char_after[0] != '(') {
            var begin = expr.right.source_reference.begin;
            var end = begin;
            end.pos += 1;
            end.column += 1;

            add_mistake ({ this, begin, end, "Missing whitespace" }, ref mistake_list);
        }
    }
}
