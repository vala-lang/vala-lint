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
    public NoSpaceCheck (Config config = new Config ()) throws KeyFileError  {
        Object (
            title: _("no-space"),
            description: _("Checks for missing spaces")
        );

        enabled = config.get_boolean ("Checks", title);
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

                // Move char to comma seperator
                int offset = 0;
                while (end.pos[offset] != ',') {
                    offset += 1;
                }
                offset += 1;

                if (end.pos[offset] != ' ' && end.pos[offset] != '\n') {
                    var loc = end;
                    loc.pos += offset + 1;
                    loc.column += offset + 1;
                    add_mistake ({ this, loc, "Missing whitespace" }, ref mistake_list);
                }
            }
        }
    }

    public void check_binary_expression (Vala.BinaryExpression expr,
                                         ref Vala.ArrayList<FormatMistake?> mistake_list) {

        char* char_before = expr.left.source_reference.end.pos;
        if (char_before[0] != ' ' && char_before[0] != '\n' && char_before[0] != ')') {
            var loc = expr.left.source_reference.end;
            loc.column += 1;
            add_mistake ({ this, loc, "Missing whitespace" }, ref mistake_list);
        }

        char* char_after = expr.right.source_reference.begin.pos - 1;
        if (char_after[0] != ' ' && char_after[0] != '\n' && char_after[0] != '(') {
            var loc = expr.right.source_reference.begin;
            add_mistake ({ this, loc, "Missing whitespace" }, ref mistake_list);
        }
    }
}
