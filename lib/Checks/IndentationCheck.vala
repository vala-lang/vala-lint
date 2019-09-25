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
    const string MESSAGE = _("Indentation is %d but should %d");
    public int indent_size = 4;

    public IndentationCheck () {
        Object (
            title: _("indentation"),
            description: _("Checks for correct indentation")
        );

        state = Config.get_state (title);
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public bool is_node_in_namespace (Vala.CodeNode n, Vala.Namespace ns) {
        if (n is Vala.Class) {
            return ns.get_classes ().contains ((Vala.Class)n);
        } else if (n is Vala.Interface) {
            return ns.get_interfaces ().contains ((Vala.Interface)n);
        } else if (n is Vala.Struct) {
            return ns.get_structs ().contains ((Vala.Struct)n);
        } else if (n is Vala.Enum) {
            return ns.get_enums ().contains ((Vala.Enum)n);
        } else if (n is Vala.ErrorDomain) {
            return ns.get_error_domains ().contains ((Vala.ErrorDomain)n);
        } else if (n is Vala.Delegate) {
            return ns.get_delegates ().contains ((Vala.Delegate)n);
        } else if (n is Vala.Constant) {
            return ns.get_constants ().contains ((Vala.Constant)n);
        } else if (n is Vala.Field) {
            return ns.get_fields ().contains ((Vala.Field)n);
        } else if (n is Vala.Method) {
            return ns.get_methods ().contains ((Vala.Method)n);
        } else if (n is Vala.Namespace) {
            return ns.get_namespaces ().contains ((Vala.Namespace)n);
        }

        return false;
    }

    public bool is_explicit_namespace (Vala.Namespace ns) {
        foreach (var n in ns.get_classes ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        foreach (var n in ns.get_interfaces ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        foreach (var n in ns.get_structs ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        foreach (var n in ns.get_enums ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        foreach (var n in ns.get_error_domains ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        foreach (var n in ns.get_delegates ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        foreach (var n in ns.get_constants ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        foreach (var n in ns.get_fields ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        foreach (var n in ns.get_methods ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        foreach (var n in ns.get_namespaces ()) {
            if (n.source_reference.begin.line == ns.source_reference.begin.line) {
                return false;
            }
        }

        return true;
    }

    public bool is_else_if_statement (Vala.IfStatement s) {
        var b = s.parent_node;
        if (b != null && b.parent_node is Vala.IfStatement) {
            Vala.IfStatement if_statement = (Vala.IfStatement)b.parent_node;
            if (if_statement.false_statement == b && b.source_reference.begin.line == s.source_reference.begin.line) {
                return true;
            }
        }

        return false;
    }

    public void check_block (Vala.Block b, int level, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (state == Config.State.OFF) {
            return;
        }

        foreach (var s in b.get_statements ()) {
            int offset = 0;

            if (s is Vala.IfStatement && is_else_if_statement ((Vala.IfStatement)s)) {
                offset -= 1;
            }

            var n = b.parent_node;
            while (n != null) {
                if (n is Vala.LockStatement) {
                    offset += 1;
                }

                n = n.parent_node;
            }

            if (s.parent_node == null || s.parent_node.source_reference.begin.line != s.source_reference.begin.line) {
                check_line (s.source_reference, level + offset, ref mistake_list);
            }
        }
    }

    public void check_symbol (Vala.Symbol s, int level, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (state == Config.State.OFF) {
            return;
        }

        if (s.parent_node == null || s.parent_node.source_reference.begin.line != s.source_reference.begin.line) {
            check_line (s.source_reference, level, ref mistake_list);
        }
    }

    private void check_line (Vala.SourceReference loc, int level, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        Vala.SourceLocation line = loc.begin;
        char* file_begin = loc.file.get_mapped_contents ();

        while (line.pos > file_begin && line.pos[0] != '\n') {
            line.pos -= 1;
            line.column -= 1;
        }

        var first_char = line;
        int indent = 0;
        while (first_char.pos[0] == ' ' || first_char.pos[0] == '\n' || first_char.pos[0] == '\t') {
            if (first_char.pos[0] == ' ') {
                indent += 1;
            }

            first_char.pos += 1;
            first_char.column += 1;
        }

        int indent_should = level * indent_size;
        if (indent != indent_should) {
            add_mistake ({ this, first_char, line, MESSAGE.printf (indent, indent_should) }, ref mistake_list);
        }
    }
}
