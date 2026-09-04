/*
 * Copyright (c) 2026 Colin Kiama
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

class UtilsTest : GLib.Object {
    void test_compute_fix_returns_null_when_check_has_no_fix () {
        var check = new ValaLint.Checks.NamingConventionCheck ();
        var begin = Vala.SourceLocation (null, 1, 1);
        var end = Vala.SourceLocation (null, 1, 2);

        var fix = ValaLint.Utils.compute_fix (check, begin, end, "int BadName = 1;\n");

        assert (fix == null);
    }

    void test_compute_fix_returns_null_when_fix_does_not_change_contents () {
        var check = new ValaLint.Checks.TrailingNewlinesCheck ();
        var begin = Vala.SourceLocation (null, 1, 1);
        var end = Vala.SourceLocation (null, 1, 1);

        var fix = ValaLint.Utils.compute_fix (check, begin, end, "class Foo {}");

        assert (fix == null);
    }

    void test_compute_fix_for_trailing_whitespace () {
        var check = new ValaLint.Checks.TrailingWhitespaceCheck ();
        var begin = Vala.SourceLocation (null, 1, 11);
        var end = Vala.SourceLocation (null, 1, 12);

        var fix = ValaLint.Utils.compute_fix (check, begin, end, "int x = 1;   \n");

        assert (fix != null);
        assert (fix.replacement == "");
        assert (fix.begin_line == 1);
        assert (fix.begin_column == 11);
        assert (fix.end_line == 1);
        assert (fix.end_column == 14);
    }

    void test_compute_fix_for_ellipsis () {
        var check = new ValaLint.Checks.EllipsisCheck ();
        var begin = Vala.SourceLocation (null, 1, 12);
        var end = Vala.SourceLocation (null, 1, 15);

        var fix = ValaLint.Utils.compute_fix (check, begin, end, "var s = \"abc...\";\n"); // vala-lint=ellipsis

        assert (fix != null);
        assert (fix.replacement == "…");
        assert (fix.begin_line == 1);
        assert (fix.begin_column == 12);
        assert (fix.end_line == 1);
        assert (fix.end_column == 15);
    }

    void test_compute_fix_uses_correct_line_for_multiline_contents () {
        var check = new ValaLint.Checks.TrailingWhitespaceCheck ();
        var begin = Vala.SourceLocation (null, 2, 7);
        var end = Vala.SourceLocation (null, 2, 10);

        var fix = ValaLint.Utils.compute_fix (check, begin, end, "int a;\nint b;   \nint c;\n");

        assert (fix != null);
        assert (fix.replacement == "");
        assert (fix.begin_line == 2);
        assert (fix.begin_column == 7);
        assert (fix.end_line == 2);
        assert (fix.end_column == 10);
    }

    public static int main (string[] args) {
        var test = new UtilsTest ();

        test.test_compute_fix_returns_null_when_check_has_no_fix ();
        test.test_compute_fix_returns_null_when_fix_does_not_change_contents ();
        test.test_compute_fix_for_trailing_whitespace ();
        test.test_compute_fix_for_ellipsis ();
        test.test_compute_fix_uses_correct_line_for_multiline_contents ();

        return 0;
    }
}
