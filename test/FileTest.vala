/*
 * Copyright (c) 2016-2018 elementary LLC. (https://github.com/elementary/vala-lint)
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

class FileTest : GLib.Object {

    public static int main (string[] args) {
        var linter = new ValaLint.Linter ();
        linter.disable_mistakes = false;
        Vala.ArrayList<ValaLint.FormatMistake?> mistakes;

        try {
            mistakes = linter.run_checks_for_file (File.new_for_path ("../test/files/pass.vala"));
            assert (mistakes.size == 0);
        } catch (Error e) {
            critical ("Error: %s while linting pass file\n", e.message);
        }

        try {
            mistakes = linter.run_checks_for_file (File.new_for_path ("../test/files/warnings.vala"));
            assert (mistakes.size == 3);
            assert (mistakes[0].check.title == "space-before-paren");
            assert (mistakes[1].check.title == "no-space");
            assert (mistakes[2].check.title == "double-semicolon");
            //  assert (mistakes[2].check.title == "trailing-newlines");
        } catch (Error e) {
            critical ("Error: %s while linting warnings file\n", e.message);
        }

        return 0;
    }
}
