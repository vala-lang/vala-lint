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

public class ValaLint.Checks.IndentationCheck : Check {
    public int indentation_distance = 4;

    public IndentationCheck () {
        Object (
            title: _("indentation"),
            description: _("Checks for correct indentation")
        );
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_block (Vala.Block b,
                            ref Vala.ArrayList<FormatMistake?> mistake_list) {

        int indentation_counter = 1;
        Vala.CodeNode node = b;
        while (node != null) {
            if (node.parent_node is Vala.Block && node.source_reference.begin.line != node.parent_node.source_reference.begin.line) {
                if (!(node is Vala.IfStatement)) {
                    //  print ("asdfasdf\n");
                    
                }
                indentation_counter += 1;
            } else if (node is Vala.Method) {
                indentation_counter += 1;
            }
            node = node.parent_node;
        }

        foreach (var s in b.get_statements ()) {           
            var begin_line = s.source_reference.begin;
            while (begin_line.pos[0] != '\n') {
                begin_line.pos -= 1;
                begin_line.column -= 1;
            }
            
            var first_character = begin_line;
            int indentation = 0;
            while (first_character.pos[0] == ' ' || first_character.pos[0] == '\n' || first_character.pos[0] == '\t') {
                if (first_character.pos[0] == ' ') {
                    indentation += 1;
                }

                first_character.pos += 1;
                first_character.column += 1;
            }

            if (indentation != indentation_counter * indentation_distance) {
                add_mistake ({ this, first_character, begin_line, "Indentation" }, ref mistake_list);
            }
        }
    }
}
