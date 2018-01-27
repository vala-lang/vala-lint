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

class FileTest : GLib.Object {

    public static int main (string[] args) {

        var linter = new ValaLint.Linter ();

        var mistakes = linter.run_checks_for_filename ("../test/files/IconRenderer.vala");
        assert (mistakes.size == 4);
        assert_includes_mistake (mistakes, "trailing-whitespace", 128, 46);
        assert_includes_mistake (mistakes, "line-length", 176, 120);
        assert_includes_mistake (mistakes, "double-spaces", 231);
        assert_includes_mistake (mistakes, "line-length", 293);

        mistakes = linter.run_checks_for_filename ("../test/files/PantheonTerminalWindow.vala");
        assert (mistakes.size == 6);
        assert_includes_mistake (mistakes, "line-length", 235, 120);
        assert_includes_mistake (mistakes, "double-spaces", 479);
        assert_includes_mistake (mistakes, "double-spaces", 647);
        assert_includes_mistake (mistakes, "double-spaces", 1075);
        assert_includes_mistake (mistakes, "block-opening-brace-space-before", 1114);
        assert_includes_mistake (mistakes, "line-length", 1120, 120);

        mistakes = linter.run_checks_for_filename ("../test/files/TextRenderer.vala");
        assert (mistakes.size == 5);
        assert_includes_mistake (mistakes, "line-length", 83, 120);
        assert_includes_mistake (mistakes, "double-spaces", 168);
        assert_includes_mistake (mistakes, "double-spaces", 169);
        assert_includes_mistake (mistakes, "double-spaces", 170);
        assert_includes_mistake (mistakes, "block-opening-brace-space-before", 309);

        return 0;
    }

    private static void assert_includes_mistake (Gee.ArrayList<ValaLint.FormatMistake?> mistakes, string title, int line_pos, int char_pos = -1) {
        foreach (var m in mistakes) {
            if (m.check.get_title () == title && m.line_index == line_pos) {
                if (char_pos == -1 || (char_pos > -1 && m.char_index == char_pos)) {
                    return;
                }
            }
        }
        assert (false);
    }
}
