/*
 * Copyright (c) 2016-2019 elementary LLC. (https://github.com/elementary/vala-lint)
 * Copyright (c) 2022 Daniel Espinosa <esodan@gmail.com>
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

class ContentTest : GLib.Object {
    public static void check_contents_for_mistake (File file, CheckTest.FileTestMistakeList mistake_list) {
        var linter = new ValaLint.Linter ();
        linter.disable_mistakes = false;

        try {
            var istream = new GLib.DataInputStream (file.read ());
            string text = istream.read_upto ("\0", -1, null);
            if (text == null) {
                text = "";
            }

            Vala.ArrayList<ValaLint.FormatMistake?> mistakes = linter.run_checks_for_content (text, file.get_uri ());
            CheckTest.checks (file.get_uri (), mistakes, mistake_list);
        } catch (Error e) {
            critical ("Error: %s while linting pass file %s.\n", e.message, file.get_path ());
        }
    }
    public static int main (string[] args) {
        var block_opening_warnings = CheckTest.FileTestMistakeList ();
        block_opening_warnings.add ("block-opening-brace-space-before", 7, 13, 0);
        check_contents_for_mistake (CheckTest.get_test_file ("block-opening-brace-space-before-check.vala"),
                                        block_opening_warnings);

        var double_spaces_warnings = CheckTest.FileTestMistakeList ();
        double_spaces_warnings.add ("double-spaces", 8, 10, 12);
        double_spaces_warnings.add ("double-spaces", 1, 14, 16);
        check_contents_for_mistake (CheckTest.get_test_file ("double-spaces-check.vala"), double_spaces_warnings);

        var ellipsis_warnings = CheckTest.FileTestMistakeList ();
        ellipsis_warnings.add ("ellipsis", 5, 24, 27);
        ellipsis_warnings.add ("ellipsis", 1, 24, 27);
        ellipsis_warnings.add ("ellipsis", 0, 34, 37);
        check_contents_for_mistake (CheckTest.get_test_file ("ellipsis-check.vala"), ellipsis_warnings);

        var empty_list = CheckTest.FileTestMistakeList ();
        check_contents_for_mistake (CheckTest.get_test_file ("general-pass.vala"), empty_list);

        var general_warnings = CheckTest.FileTestMistakeList ();
        general_warnings.add ("naming-convention", 4);
        general_warnings.add ("space-before-paren", 2, 26, 27);
        general_warnings.add ("note", 1, 21, 25, "TODO");
        general_warnings.add ("note", 1, 21, 38, "TODO: Lorem ipsum");
        general_warnings.add ("double-spaces", 2, 25, 27);
        general_warnings.add ("double-spaces", 1, 15, 17);
        general_warnings.add ("double-spaces", 0, 36, 38);
        general_warnings.add ("double-spaces", 0, 39, 41);
        general_warnings.add ("double-spaces", 1, 13, 15);
        general_warnings.add ("trailing-whitespace", 1, 18, 19);
        general_warnings.add ("no-space", 3, 32, 33);
        general_warnings.add ("double-semicolon", 1, 38, 39);
        general_warnings.add ("naming-convention", 1);
        general_warnings.add ("ellipsis", 2, 32, 35);
        general_warnings.add ("ellipsis", 1, 47, 53);
        general_warnings.add ("ellipsis", 1, 47, 50);
        general_warnings.add ("ellipsis", 0, 57, 60);
        general_warnings.add ("unnecessary-string-template", 2, 37, 39);
        general_warnings.add ("unnecessary-string-template", 1, 39, 52);
        general_warnings.add ("line-length", 2, 120, 130);
        general_warnings.add ("line-length", 1, 120, 131);
        general_warnings.add ("trailing-newlines", 2);
        check_contents_for_mistake (CheckTest.get_test_file ("general-warnings.vala"), general_warnings);

        var line_length_warnings = CheckTest.FileTestMistakeList ();
        line_length_warnings.add ("line-length", 8, 120, 141);
        check_contents_for_mistake (CheckTest.get_test_file ("line-length-check.vala"), line_length_warnings);

        var naming_convention_warnings = CheckTest.FileTestMistakeList ();
        naming_convention_warnings.add ("naming-convention", 7);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 6);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 7);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 1);
        check_contents_for_mistake (CheckTest.get_test_file ("naming-convention-check.vala"),
                                        naming_convention_warnings);

        var note_warnings = CheckTest.FileTestMistakeList ();
        note_warnings.add ("note", 7, 19, 38);
        note_warnings.add ("note", 1, 19, 39);
        check_contents_for_mistake (CheckTest.get_test_file ("note-check.vala"), note_warnings);

        var space_before_paren_warnings = CheckTest.FileTestMistakeList ();
        space_before_paren_warnings.add ("space-before-paren", 4, 9, 10);
        space_before_paren_warnings.add ("no-space", 5, 14, 15);
        space_before_paren_warnings.add ("space-before-paren", 0, 14, 15);
        space_before_paren_warnings.add ("no-space", 0, 17, 18);
        space_before_paren_warnings.add ("no-space", 0, 18, 19);
        check_contents_for_mistake (CheckTest.get_test_file ("space-before-paren-check.vala"),
                                        space_before_paren_warnings);

        var tab_warnings = CheckTest.FileTestMistakeList ();
        tab_warnings.add ("use-of-tabs", 5, 20, 21);
        check_contents_for_mistake (CheckTest.get_test_file ("tab-check.vala"), tab_warnings);

        check_contents_for_mistake (CheckTest.get_test_file ("trailing-newlines-check-1.vala"), empty_list);

        var trailing_newlines_2_warnings = CheckTest.FileTestMistakeList ();
        trailing_newlines_2_warnings.add ("trailing-newlines", 5, 0, 1);
        check_contents_for_mistake (CheckTest.get_test_file ("trailing-newlines-check-2.vala"),
                                        trailing_newlines_2_warnings);

        var trailing_newlines_3_warnings = CheckTest.FileTestMistakeList ();
        trailing_newlines_3_warnings.add ("trailing-newlines", 5, 1, 2);
        trailing_newlines_3_warnings.add ("trailing-whitespace", 0, 1, 2);
        check_contents_for_mistake (CheckTest.get_test_file ("trailing-newlines-check-3.vala"),
                                        trailing_newlines_3_warnings);

        var trailing_newlines_4_warnings = CheckTest.FileTestMistakeList ();
        trailing_newlines_4_warnings.add ("trailing-newlines", 5, 1, 0);
        check_contents_for_mistake (CheckTest.get_test_file ("trailing-newlines-check-4.vala"),
                                        trailing_newlines_4_warnings);

        var trailing_whitespace_warnings = CheckTest.FileTestMistakeList ();
        trailing_whitespace_warnings.add ("trailing-whitespace", 4, 14, 15);
        check_contents_for_mistake (CheckTest.get_test_file ("trailing-whitespace-check.vala"),
                                        trailing_whitespace_warnings);

        check_contents_for_mistake (CheckTest.get_test_file ("empty-file.vala"), empty_list);

        return 0;
    }
}
