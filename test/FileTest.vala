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

class FileTest : GLib.Object {
    public struct FileTestMistake {
        string title;
        int line;
        int? column_begin;
        int? column_end;
        string? message;
    }

    public struct FileTestMistakeList {
        Vala.ArrayList<FileTestMistake?> list;
        int line;

        public FileTestMistakeList () {
            list = new Vala.ArrayList<FileTestMistake?> ();
            line = 0;
        }

        public void add (string title,
                         int line_diff,
                         int? column_begin = null,
                         int? column_end = null,
                         string? message = null) {

            list.add ({ title, line += line_diff, column_begin, column_end, message });
        }
    }

    public static void error_mistake (string message, int number, File file) {
        error (@"Mistake #$(number) in $(file.get_path ()): $(message)");
    }

    public static void check_file_for_mistake (File file, FileTestMistakeList mistake_list) {
        var linter = new ValaLint.Linter ();
        linter.disable_mistakes = false;

        try {
            Vala.ArrayList<ValaLint.FormatMistake?> mistakes = linter.run_checks_for_file (file);

            if (mistakes.size != mistake_list.list.size) {
                for (int i = 0; i < mistakes.size; i++) {
                    var real = mistakes[i];
                    print (@"Mistake #$(i) at ($(real.begin.line):$(real.begin.column)): '$(real.check.title)'\n");
                }

                error (@"$(file.get_path ()) has $(mistakes.size), should have $(mistake_list.list.size) mistakes.");
            }

            for (int i = 0; i < mistakes.size; i++) {
                var real = mistakes[i];
                var should = mistake_list.list[i];

                if (real.check.title != should.title) {
                    error_mistake (@"Title is '$(real.check.title)', should be '$(should.title)'.", i, file);
                }
                if (real.begin.line != should.line) {
                    error_mistake (@"Line is '$(real.begin.line)', should be '$(should.line)'.", i, file);
                }
                if (should.column_begin != null && real.begin.column != should.column_begin) {
                    error_mistake (@"Column is '$(real.begin.column)', should be '$(should.column_begin)'.", i, file);
                }
                if (should.column_end != null && real.end.column != should.column_end) {
                    error_mistake (@"End column is '$(real.end.column)', should be '$(should.column_end)'.", i, file);
                }
                if (should.message != null && real.mistake != should.message) {
                    error_mistake (@"Message is '$(real.mistake)', should be '$(should.message)'.", i, file);
                }
            }
        } catch (Error e) {
            critical ("Error: %s while linting pass file %s.\n", e.message, file.get_path ());
        }
    }

    public static File get_test_file (string name) {
        return File.new_for_path ("../test/files/" + name);
    }

    public static int main (string[] args) {
        var block_opening_warnings = FileTestMistakeList ();
        block_opening_warnings.add ("block-opening-brace-space-before", 7, 13, 0);
        check_file_for_mistake (get_test_file ("block-opening-brace-space-before-check.vala"), block_opening_warnings);

        var double_spaces_warnings = FileTestMistakeList ();
        double_spaces_warnings.add ("double-spaces", 8, 10, 12);
        double_spaces_warnings.add ("double-spaces", 1, 14, 16);
        check_file_for_mistake (get_test_file ("double-spaces-check.vala"), double_spaces_warnings);

        var ellipsis_warnings = FileTestMistakeList ();
        ellipsis_warnings.add ("ellipsis", 5, 24, 27);
        ellipsis_warnings.add ("ellipsis", 1, 24, 27);
        ellipsis_warnings.add ("ellipsis", 0, 34, 37);
        check_file_for_mistake (get_test_file ("ellipsis-check.vala"), ellipsis_warnings);

        var empty_list = FileTestMistakeList ();
        check_file_for_mistake (get_test_file ("general-pass.vala"), empty_list);

        var general_warnings = FileTestMistakeList ();
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
        check_file_for_mistake (get_test_file ("general-warnings.vala"), general_warnings);

        var initialize_objects_with_properties_warnings = FileTestMistakeList ();
        initialize_objects_with_properties_warnings.add ("initialize-objects-with-properties", 4, 0, 0);
        check_file_for_mistake (get_test_file ("initialize-objects-with-properties.vala"), initialize_objects_with_properties_warnings);

        var line_length_warnings = FileTestMistakeList ();
        line_length_warnings.add ("line-length", 8, 120, 141);
        check_file_for_mistake (get_test_file ("line-length-check.vala"), line_length_warnings);

        var naming_convention_warnings = FileTestMistakeList ();
        naming_convention_warnings.add ("naming-convention", 7);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 6);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 7);
        naming_convention_warnings.add ("naming-convention", 1);
        naming_convention_warnings.add ("naming-convention", 1);
        check_file_for_mistake (get_test_file ("naming-convention-check.vala"), naming_convention_warnings);

        var note_warnings = FileTestMistakeList ();
        note_warnings.add ("note", 7, 19, 38);
        note_warnings.add ("note", 1, 19, 39);
        check_file_for_mistake (get_test_file ("note-check.vala"), note_warnings);

        var space_before_paren_warnings = FileTestMistakeList ();
        space_before_paren_warnings.add ("space-before-paren", 4, 9, 10);
        space_before_paren_warnings.add ("no-space", 5, 14, 15);
        space_before_paren_warnings.add ("space-before-paren", 0, 14, 15);
        space_before_paren_warnings.add ("no-space", 0, 17, 18);
        space_before_paren_warnings.add ("no-space", 0, 18, 19);
        check_file_for_mistake (get_test_file ("space-before-paren-check.vala"), space_before_paren_warnings);

        var tab_warnings = FileTestMistakeList ();
        tab_warnings.add ("use-of-tabs", 5, 20, 21);
        check_file_for_mistake (get_test_file ("tab-check.vala"), tab_warnings);

        check_file_for_mistake (get_test_file ("trailing-newlines-check-1.vala"), empty_list);

        var trailing_newlines_2_warnings = FileTestMistakeList ();
        trailing_newlines_2_warnings.add ("trailing-newlines", 5, 0, 1);
        check_file_for_mistake (get_test_file ("trailing-newlines-check-2.vala"), trailing_newlines_2_warnings);

        var trailing_newlines_3_warnings = FileTestMistakeList ();
        trailing_newlines_3_warnings.add ("trailing-newlines", 5, 1, 2);
        trailing_newlines_3_warnings.add ("trailing-whitespace", 0, 1, 2);
        check_file_for_mistake (get_test_file ("trailing-newlines-check-3.vala"), trailing_newlines_3_warnings);

        var trailing_newlines_4_warnings = FileTestMistakeList ();
        trailing_newlines_4_warnings.add ("trailing-newlines", 5, 1, 0);
        check_file_for_mistake (get_test_file ("trailing-newlines-check-4.vala"), trailing_newlines_4_warnings);

        var trailing_whitespace_warnings = FileTestMistakeList ();
        trailing_whitespace_warnings.add ("trailing-whitespace", 4, 14, 15);
        check_file_for_mistake (get_test_file ("trailing-whitespace-check.vala"), trailing_whitespace_warnings);

        return 0;
    }
}
