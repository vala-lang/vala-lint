/*
 * Copyright (c) 2016-2019 elementary LLC. (https://github.com/elementary/vala-lint)
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

class UnitTest : GLib.Object {

    public static int main (string[] args) {

        var block_parenthesis_check = new ValaLint.Checks.BlockOpeningBraceSpaceBeforeCheck ();
        assert_pass (block_parenthesis_check, "test () {");
        assert_warning (block_parenthesis_check, "test (){");
        assert_warning (block_parenthesis_check, "test ()\n{");
        assert_warning (block_parenthesis_check, "test ()   {");

        var double_spaces_check = new ValaLint.Checks.DoubleSpacesCheck ();
        assert_pass (double_spaces_check, "/*    *//*");
        assert_pass (double_spaces_check, "   lorem ipsum");
        assert_pass (double_spaces_check, "int test = 2;    // asdf");
        assert_pass (double_spaces_check, "int test = 2;    /* asdf  */");
        assert_warning (double_spaces_check, "int test  = 2;", 9);
        assert_warning (double_spaces_check, "int test = {  };", 13);

        var ellipsis_check = new ValaLint.Checks.EllipsisCheck ();
        Assertion<Vala.StringLiteral>.pass (ellipsis_check.check_string_literal, new Vala.StringLiteral ("lorem ipsum"));
        Assertion<Vala.StringLiteral>.warning (ellipsis_check.check_string_literal, new Vala.StringLiteral ("lorem [...] ipsum"), 1, 7);
        Assertion<Vala.StringLiteral>.warning (ellipsis_check.check_string_literal, new Vala.StringLiteral ("lorem [...] ipsum..."), 2);

        var line_length_check = new ValaLint.Checks.LineLengthCheck ();
        assert_pass (line_length_check, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore aliqua."); // vala-lint=line-length
        // This is 70 characters but 140 bytes, it should still pass.
        assert_pass (line_length_check, "éééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééééé");
        assert_warning (line_length_check, "/* Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore aliqua consectetur */ aliqua.", 120); // vala-lint=line-length
        assert_warning (line_length_check, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", 120); // vala-lint=line-length

        var naming_all_caps_check = new ValaLint.Checks.NamingAllCapsCheck ();
        assert_pass (naming_all_caps_check, "LOREM");
        assert_pass (naming_all_caps_check, "LOREM_IPSUM");
        assert_warning (naming_all_caps_check, "lOREM");
        assert_warning (naming_all_caps_check, "LOREm");
        assert_warning (naming_all_caps_check, "LOREM-IPSUM");

        var naming_camel_case_check = new ValaLint.Checks.NamingCamelCaseCheck ();
        assert_pass (naming_camel_case_check, "Lorem");
        assert_pass (naming_camel_case_check, "LoremIpsum");
        assert_pass (naming_camel_case_check, "HTTPConnection");
        assert_warning (naming_camel_case_check, "lorem");
        assert_warning (naming_camel_case_check, "loremIpsum");
        assert_warning (naming_camel_case_check, "lorem_ipsum");
        assert_warning (naming_camel_case_check, "lorem-ipsum");

        var naming_underscore_check = new ValaLint.Checks.NamingUnderscoreCheck ();
        assert_pass (naming_underscore_check, "lorem");
        assert_pass (naming_underscore_check, "lorem_ipsum");
        assert_warning (naming_underscore_check, "Lorem");
        assert_warning (naming_underscore_check, "Lorem_Ipsum");
        assert_warning (naming_underscore_check, "lorem_IPsum");

        var note_check = new ValaLint.Checks.NoteCheck ();
        assert_pass (note_check, "lorem");
        assert_pass (note_check, "lorem todo");
        assert_warning (note_check, "lorem // TODO: nothing to do", 10);
        assert_pass (note_check, "lorem // NOTE: nothing to do");
        assert_warning (note_check, "lorem // FIXME: nothing to do", 10);

        var space_before_paren_check = new ValaLint.Checks.SpaceBeforeParenCheck ();
        assert_pass (space_before_paren_check, "void test ()");
        assert_pass (space_before_paren_check, "var test = 2 * (3 + 1);");
        assert_pass (space_before_paren_check, "a = !(true && false);");
        assert_pass (space_before_paren_check, "actions &= ~(Gdk.DragAction.COPY | Gdk.DragAction.LINK)");
        assert_warning (space_before_paren_check, "void test()", 10);
        assert_warning (space_before_paren_check, "void = 2*(2+2)", 10);

        var tab_check = new ValaLint.Checks.TabCheck ();
        assert_pass (tab_check, "lorem ipsum");
        assert_warning (tab_check, "lorem	ipsum");

        var trailing_newlines_check = new ValaLint.Checks.TrailingNewlinesCheck ();
        assert_pass (trailing_newlines_check, "lorem ipsum\n");
        assert_warning (trailing_newlines_check, "lorem ipsum", 11);
        assert_warning (trailing_newlines_check, "lorem ipsum ", 12);
        assert_warning (trailing_newlines_check, "lorem ipsum\n\n");

        var trailing_whitespace_check = new ValaLint.Checks.TrailingWhitespaceCheck ();
        assert_pass (trailing_whitespace_check, "lorem ipsum");
        assert_warning (trailing_whitespace_check, "lorem ipsum ");

        return 0;
    }

    private static void assert_pass (ValaLint.Check check, string input) {
        var parser = new ValaLint.Parser ();
        var parsed_result = parser.parse (input);
        var mistakes = new Vala.ArrayList<ValaLint.FormatMistake?> ();
        check.check (parsed_result, ref mistakes);
        if (mistakes.size != 0) {
            error ("%s: %s at char %d", input, mistakes[0].mistake, mistakes[0].begin.column);
        }
    }

    private static void assert_warning (ValaLint.Check check, string input, int column = -1) {
        var parser = new ValaLint.Parser ();
        var parsed_result = parser.parse (input);
        var mistakes = new Vala.ArrayList<ValaLint.FormatMistake?> ();
        check.check (parsed_result, ref mistakes);
        assert (mistakes.size > 0);
        if (column > -1) {
            assert (mistakes[0].begin.column == column);
        }
    }
}



public class Assertion<G> {
    public delegate void CheckFunction<G> (G input, ref Vala.ArrayList<ValaLint.FormatMistake?> mistakes);

    public static void pass (CheckFunction<G> check_function, G input) {
        var mistakes = new Vala.ArrayList<ValaLint.FormatMistake?> ();

        check_function (input, ref mistakes);
        if (mistakes.size != 0) {
            error ("%s at char %d", mistakes[0].mistake, mistakes[0].begin.column);
        }
    }

    public static void warning (CheckFunction<G> check_function, G input, int number_mistakes = -1, int column = -1) {
        var mistakes = new Vala.ArrayList<ValaLint.FormatMistake?> ();

        check_function (input, ref mistakes);
        if (number_mistakes > 0) {
            assert (mistakes.size == number_mistakes);
        } else {
            assert (mistakes.size > 0);
        }
        
        if (column > -1) {
            assert (mistakes[0].begin.column == column);
        }
    }
}
