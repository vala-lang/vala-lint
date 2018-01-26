/*
 * Copyright (c) 2018 elementary LLC. (https://github.com/elementary/Vala-Lint)
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

        var block_opening_brace_space_before_check = new ValaLint.Checks.BlockOpeningBraceSpaceBeforeCheck ();
        assert_pass (block_opening_brace_space_before_check, "class { }");
        assert_pass (block_opening_brace_space_before_check, "string a = @\"asdf{}\";");
        assert_warning (block_opening_brace_space_before_check, "struct{ a }");
        assert_warning (block_opening_brace_space_before_check, "struct){ a }");
        assert_warning (block_opening_brace_space_before_check, "var test ={ a }");
        assert_warning (block_opening_brace_space_before_check, "struct\n{ a }");
        assert_warning (block_opening_brace_space_before_check, "struct)\n{ a }");
        assert_warning (block_opening_brace_space_before_check, "struct\n\t{ a }");

        var ellipsis_check = new ValaLint.Checks.EllipsisCheck ();
        assert_pass (ellipsis_check, "lorem ipsum");
        assert_pass (ellipsis_check, "lorem ipsum...");
        assert_pass (ellipsis_check, "lorem ipsum // ...");
        assert_warning (ellipsis_check, "lorem ipsum\"...\"");

        var double_spaces_check = new ValaLint.Checks.DoubleSpacesCheck ();
        assert_pass (double_spaces_check, "/*    */");
        assert_pass (double_spaces_check, "   lorem ipsum");
        assert_warning (double_spaces_check, "int test  = 2;");
        assert_warning (double_spaces_check, "int test = {  };");

        var line_length_check = new ValaLint.Checks.LineLengthCheck ();
        assert_pass (line_length_check, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore aliqua.");
        assert_warning (line_length_check, "/* Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore aliqua consectetur */ aliqua.");
        assert_warning (line_length_check, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.");

        var tab_check = new ValaLint.Checks.TabCheck ();
        assert_pass (tab_check, "lorem ipsum");
        assert_pass (tab_check, "string a = \"lorem	ipsum\"");
        assert_warning (tab_check, "lorem\tipsum");
        assert_warning (tab_check, "lorem	ipsum");

        var trailing_whitespace_check = new ValaLint.Checks.TrailingWhitespaceCheck ();
        assert_pass (trailing_whitespace_check, "lorem ipsum");
        assert_pass (trailing_whitespace_check, "lorem ipsum // trailing comment: ");
        assert_warning (trailing_whitespace_check, "lorem ipsum ");

        return 0;
    }

    public static void assert_pass (ValaLint.Check check, string input) {
        var linter = new ValaLint.Linter.with_check(check);
        assert (linter.run_checks(input).size == 0);
    }

    public static void assert_warning (ValaLint.Check check, string input) {
        var linter = new ValaLint.Linter.with_check(check);
        assert (linter.run_checks(input).size > 0);
    }
}
