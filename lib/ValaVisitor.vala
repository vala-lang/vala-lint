/*
 * Copyright (c) 2018-2019 elementary LLC. (https://github.com/elementary/vala-lint)
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

class ValaLint.Visitor : Vala.CodeVisitor {
    public Vala.ArrayList<FormatMistake?> mistake_list;

    public Vala.ArrayList<Check> checks { get; set; }

    public Checks.NamingAllCapsCheck naming_all_caps_check;
    public Checks.NamingCamelCaseCheck naming_camel_case_check;
    public Checks.NamingUnderscoreCheck naming_underscore_check;

    public void set_mistake_list (Vala.ArrayList<FormatMistake?> mistake_list) {
        this.mistake_list = mistake_list;
    }

    public override void visit_source_file (Vala.SourceFile sf) {
        sf.accept_children (this);
    }

    public override void visit_namespace (Vala.Namespace ns) {
        naming_camel_case_check.check (string_parsed (ns.name, ns.source_reference), ref mistake_list);

        /* Dont visit namespaces, as double visiting can occur. */
        // ns.accept_children (this);
    }

    public override void visit_class (Vala.Class cl) {
        naming_camel_case_check.check (string_parsed (cl.name, cl.source_reference), ref mistake_list);
        cl.accept_children (this);
    }

    public override void visit_struct (Vala.Struct st) {
        naming_camel_case_check.check (string_parsed (st.name, st.source_reference), ref mistake_list);
        st.accept_children (this);
    }

    public override void visit_interface (Vala.Interface iface) {
        naming_camel_case_check.check (string_parsed (iface.name, iface.source_reference), ref mistake_list);
        iface.accept_children (this);
    }

    public override void visit_enum (Vala.Enum en) {
        naming_camel_case_check.check (string_parsed (en.name, en.source_reference), ref mistake_list);
        en.accept_children (this);
    }

    public override void visit_enum_value (Vala.EnumValue ev) {
        naming_all_caps_check.check (string_parsed (ev.name, ev.source_reference), ref mistake_list);
        ev.accept_children (this);
    }

    public override void visit_error_domain (Vala.ErrorDomain edomain) {
        edomain.accept_children (this);
    }

    public override void visit_error_code (Vala.ErrorCode ecode) {
        ecode.accept_children (this);
    }

    public override void visit_delegate (Vala.Delegate d) {
        d.accept_children (this);
    }

    public override void visit_constant (Vala.Constant c) {
        naming_all_caps_check.check (string_parsed (c.name, c.source_reference), ref mistake_list);
        c.accept_children (this);
    }

    public override void visit_field (Vala.Field f) {
        naming_underscore_check.check (string_parsed (f.name, f.source_reference), ref mistake_list);
        f.accept_children (this);
    }

    public override void visit_method (Vala.Method m) {
        naming_underscore_check.check (string_parsed (m.name, m.source_reference), ref mistake_list);
        m.accept_children (this);
    }

    public override void visit_creation_method (Vala.CreationMethod m) {
        m.accept_children (this);
    }

    public override void visit_formal_parameter (Vala.Parameter p) {
        naming_underscore_check.check (string_parsed (p.name, p.source_reference), ref mistake_list);
        p.accept_children (this);
    }

    public override void visit_property (Vala.Property prop) {
        prop.accept_children (this);
    }

    public override void visit_property_accessor (Vala.PropertyAccessor acc) {
        acc.accept_children (this);
    }

    public override void visit_signal (Vala.Signal sig) {
        sig.accept_children (this);
    }

    public override void visit_constructor (Vala.Constructor c) {
        c.accept_children (this);
    }

    public override void visit_destructor (Vala.Destructor d) {
        d.accept_children (this);
    }

    public override void visit_type_parameter (Vala.TypeParameter p) {
        p.accept_children (this);
    }

    public override void visit_using_directive (Vala.UsingDirective ns) {
        ns.accept_children (this);
    }

    public override void visit_data_type (Vala.DataType type) {
        type.accept_children (this);
    }

    public override void visit_block (Vala.Block b) {
        b.accept_children (this);
    }

    public override void visit_empty_statement (Vala.EmptyStatement stmt) {
    }

    public override void visit_declaration_statement (Vala.DeclarationStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_local_variable (Vala.LocalVariable local) {
        local.accept_children (this);
    }

    public override void visit_initializer_list (Vala.InitializerList list) {
        list.accept_children (this);
    }

    public override void visit_expression_statement (Vala.ExpressionStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_if_statement (Vala.IfStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_switch_statement (Vala.SwitchStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_switch_section (Vala.SwitchSection section) {
        section.accept_children (this);
    }

    public override void visit_switch_label (Vala.SwitchLabel label) {
        label.accept_children (this);
    }

    public override void visit_loop (Vala.Loop stmt) {
        stmt.accept_children (this);
    }

    public override void visit_while_statement (Vala.WhileStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_do_statement (Vala.DoStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_for_statement (Vala.ForStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_foreach_statement (Vala.ForeachStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_break_statement (Vala.BreakStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_continue_statement (Vala.ContinueStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_return_statement (Vala.ReturnStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_yield_statement (Vala.YieldStatement y) {
        y.accept_children (this);
    }

    public override void visit_throw_statement (Vala.ThrowStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_try_statement (Vala.TryStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_catch_clause (Vala.CatchClause clause) {
        clause.accept_children (this);
    }

    public override void visit_lock_statement (Vala.LockStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_unlock_statement (Vala.UnlockStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_delete_statement (Vala.DeleteStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_expression (Vala.Expression expr) {
        expr.accept_children (this);
    }

    public override void visit_array_creation_expression (Vala.ArrayCreationExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_boolean_literal (Vala.BooleanLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_character_literal (Vala.CharacterLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_integer_literal (Vala.IntegerLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_real_literal (Vala.RealLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_regex_literal (Vala.RegexLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_string_literal (Vala.StringLiteral lit) {
        // ellipsis_check.check (string_parsed (lit.value, lit.source_reference, ParseType.STRING), ref mistake_list);
        lit.accept_children (this);
    }

    public override void visit_template (Vala.Template tmpl) {
        tmpl.accept_children (this);
    }

    public override void visit_tuple (Vala.Tuple tuple) {
        tuple.accept_children (this);
    }

    public override void visit_null_literal (Vala.NullLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_member_access (Vala.MemberAccess expr) {
        expr.accept_children (this);
    }

    public override void visit_method_call (Vala.MethodCall expr) {
        expr.accept_children (this);
    }

    public override void visit_element_access (Vala.ElementAccess expr) {
        expr.accept_children (this);
    }

    public override void visit_slice_expression (Vala.SliceExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_base_access (Vala.BaseAccess expr) {
        expr.accept_children (this);
    }

    public override void visit_postfix_expression (Vala.PostfixExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_object_creation_expression (Vala.ObjectCreationExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_sizeof_expression (Vala.SizeofExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_typeof_expression (Vala.TypeofExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_unary_expression (Vala.UnaryExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_cast_expression (Vala.CastExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_named_argument (Vala.NamedArgument expr) {
        expr.accept_children (this);
    }

    public override void visit_pointer_indirection (Vala.PointerIndirection expr) {
        expr.accept_children (this);
    }

    public override void visit_addressof_expression (Vala.AddressofExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_reference_transfer_expression (Vala.ReferenceTransferExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_binary_expression (Vala.BinaryExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_type_check (Vala.TypeCheck expr) {
        expr.accept_children (this);
    }

    public override void visit_conditional_expression (Vala.ConditionalExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_lambda_expression (Vala.LambdaExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_assignment (Vala.Assignment a) {
        a.accept_children (this);
    }

    public override void visit_end_full_expression (Vala.Expression expr) {
        expr.accept_children (this);
    }

    private static Vala.ArrayList<ParseResult?> string_parsed (string text, Vala.SourceReference source_ref,
                                                               ParseType type = ParseType.DEFAULT,
                                                               ParseDetailType detail_type = ParseDetailType.CODE) {
        var parsed = new Vala.ArrayList<ParseResult?> ();
        ParseResult result = { text, type, detail_type, source_ref.begin.line, source_ref.begin.column };
        parsed.add (result);
        return parsed;
    }
}
