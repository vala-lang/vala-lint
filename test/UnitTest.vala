/*
 * Copyright (c) 2016 elementary LLC. (https://github.com/elementary/Vala-Lint)
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

        var ellipsis_check = new ValaLint.Checks.EllipsisCheck ();
        assert_pass (ellipsis_check, "lorem ipsum");
        assert_pass (ellipsis_check, "lorem ipsum...");
        assert_warning (ellipsis_check, "lorem ipsum\"...\"");

        var tab_check = new ValaLint.Checks.TabCheck ();
        assert_pass (tab_check, "lorem ipsum");
        assert_warning (tab_check, "lorem	ipsum");

        var trailing_whitespace_check = new ValaLint.Checks.TrailingWhitespaceCheck ();
        assert_pass (trailing_whitespace_check, "lorem ipsum");
        assert_warning (trailing_whitespace_check, "lorem ipsum ");

        return 0;
    }

    public static void assert_pass(ValaLint.Check check, string line) {
        var mistake_list = new Gee.ArrayList<ValaLint.FormatMistake?> ();
        assert (!check.check_line (mistake_list, 0, line));
    }

    public static void assert_warning(ValaLint.Check check, string line) {
        var mistake_list = new Gee.ArrayList<ValaLint.FormatMistake?> ();
        assert (check.check_line (mistake_list, 0, line));
    }
}
