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

using Vala;

class ValaLint.Visitor : CodeVisitor {
    public Gee.ArrayList<FormatMistake?> mistake_list;

    public Gee.ArrayList<Check> checks { get; set; }

    public Checks.NamingAllCapsCheck naming_all_caps_check;
    public Checks.NamingCamelCaseCheck naming_camel_case_check;
    public Checks.NamingUnderscoreCheck naming_underscore_check;

    public void set_mistake_list (Gee.ArrayList<FormatMistake?> mistake_list) {
        this.mistake_list = mistake_list;
    }

    public override void visit_source_file (SourceFile sf) {
        sf.accept_children (this);
    }

    public override void visit_namespace (Namespace ns) {
        naming_camel_case_check.check (string_parsed (ns.name, ns.source_reference), ref mistake_list);
        ns.accept_children (this);
    }

    public override void visit_class (Class cl) {
        naming_camel_case_check.check (string_parsed (cl.name, cl.source_reference), ref mistake_list);
        cl.accept_children (this);
    }

    public override void visit_struct (Struct st) {
        naming_camel_case_check.check (string_parsed (st.name, st.source_reference), ref mistake_list);
        st.accept_children (this);
    }

    public override void visit_interface (Interface iface) {
        naming_camel_case_check.check (string_parsed (iface.name, iface.source_reference), ref mistake_list);
        iface.accept_children (this);
    }

    public override void visit_enum (Enum en) {
        naming_camel_case_check.check (string_parsed (en.name, en.source_reference), ref mistake_list);
        en.accept_children (this);
    }

    public override void visit_enum_value (Vala.EnumValue ev) {
        naming_all_caps_check.check (string_parsed (ev.name, ev.source_reference), ref mistake_list);
        ev.accept_children (this);
    }

    public override void visit_error_domain (ErrorDomain edomain) {
        edomain.accept_children (this);
    }

    public override void visit_error_code (ErrorCode ecode) {
        ecode.accept_children (this);
    }

    public override void visit_delegate (Delegate d) {
        d.accept_children (this);
    }

    public override void visit_constant (Constant c) {
        naming_all_caps_check.check (string_parsed (c.name, c.source_reference), ref mistake_list);
        c.accept_children (this);
    }

    public override void visit_field (Field f) {
        naming_underscore_check.check (string_parsed (f.name, f.source_reference), ref mistake_list);
        f.accept_children (this);
    }

    public override void visit_method (Method m) {
        naming_underscore_check.check (string_parsed (m.name, m.source_reference), ref mistake_list);
        m.accept_children (this);
    }

    public override void visit_creation_method (CreationMethod m) {
        m.accept_children (this);
    }

    public override void visit_formal_parameter (Vala.Parameter p) {
        naming_underscore_check.check (string_parsed (p.name, p.source_reference), ref mistake_list);
        p.accept_children (this);
    }

    public override void visit_property (Property prop) {
        prop.accept_children (this);
    }

    public override void visit_property_accessor (PropertyAccessor acc) {
        acc.accept_children (this);
    }

    public override void visit_signal (Vala.Signal sig) {
        sig.accept_children (this);
    }

    public override void visit_constructor (Constructor c) {
        c.accept_children (this);
    }

    public override void visit_destructor (Destructor d) {
        d.accept_children (this);
    }

    public override void visit_type_parameter (TypeParameter p) {
        p.accept_children (this);
    }

    public override void visit_using_directive (UsingDirective ns) {
        ns.accept_children (this);
    }

    public override void visit_data_type (DataType type) {
        type.accept_children (this);
    }

    public override void visit_block (Block b) {
        b.accept_children (this);
    }

    public override void visit_empty_statement (EmptyStatement stmt) {
    }

    public override void visit_declaration_statement (DeclarationStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_local_variable (LocalVariable local) {
        local.accept_children (this);
    }

    public override void visit_initializer_list (InitializerList list) {
        list.accept_children (this);
    }

    public override void visit_expression_statement (ExpressionStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_if_statement (IfStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_switch_statement (SwitchStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_switch_section (SwitchSection section) {
        section.accept_children (this);
    }

    public override void visit_switch_label (SwitchLabel label) {
        label.accept_children (this);
    }

    public override void visit_loop (Loop stmt) {
        stmt.accept_children (this);
    }

    public override void visit_while_statement (WhileStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_do_statement (DoStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_for_statement (ForStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_foreach_statement (ForeachStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_break_statement (BreakStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_continue_statement (ContinueStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_return_statement (ReturnStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_yield_statement (YieldStatement y) {
        y.accept_children (this);
    }

    public override void visit_throw_statement (ThrowStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_try_statement (TryStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_catch_clause (CatchClause clause) {
        clause.accept_children (this);
    }

    public override void visit_lock_statement (LockStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_unlock_statement (UnlockStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_delete_statement (DeleteStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_expression (Expression expr) {
        expr.accept_children (this);
    }

    public override void visit_array_creation_expression (ArrayCreationExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_boolean_literal (BooleanLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_character_literal (CharacterLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_integer_literal (IntegerLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_real_literal (RealLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_regex_literal (RegexLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_string_literal (StringLiteral lit) {
        // TODO Move ellipsis check here
        // ellipsis_check.check (string_parsed (lit.value, lit.source_reference, ParseType.STRING), ref mistake_list);
        lit.accept_children (this);
    }

    public override void visit_template (Template tmpl) {
        tmpl.accept_children (this);
    }

    public override void visit_tuple (Tuple tuple) {
        tuple.accept_children (this);
    }

    public override void visit_null_literal (NullLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_member_access (MemberAccess expr) {
        expr.accept_children (this);
    }

    public override void visit_method_call (MethodCall expr) {
        expr.accept_children (this);
    }

    public override void visit_element_access (ElementAccess expr) {
        expr.accept_children (this);
    }

    public override void visit_slice_expression (SliceExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_base_access (BaseAccess expr) {
        expr.accept_children (this);
    }

    public override void visit_postfix_expression (PostfixExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_object_creation_expression (ObjectCreationExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_sizeof_expression (SizeofExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_typeof_expression (TypeofExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_unary_expression (UnaryExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_cast_expression (CastExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_named_argument (NamedArgument expr) {
        expr.accept_children (this);
    }

    public override void visit_pointer_indirection (PointerIndirection expr) {
        expr.accept_children (this);
    }

    public override void visit_addressof_expression (AddressofExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_reference_transfer_expression (ReferenceTransferExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_binary_expression (BinaryExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_type_check (TypeCheck expr) {
        expr.accept_children (this);
    }

    public override void visit_conditional_expression (ConditionalExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_lambda_expression (LambdaExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_assignment (Assignment a) {
        a.accept_children (this);
    }

    public override void visit_end_full_expression (Expression expr) {
        expr.accept_children (this);
    }

    private static Gee.ArrayList<ParseResult?> string_parsed (string text, SourceReference source_ref, ParseType type = ParseType.Default) {
        var parsed = new Gee.ArrayList<ParseResult?> ();
        ParseResult result = { text, type, source_ref.begin.line, source_ref.begin.column };
        parsed.add (result);
        return parsed;
    }
}
