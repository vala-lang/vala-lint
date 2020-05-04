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
        string? message;
    }

    public struct FileTestMistakeList {
        Vala.ArrayList<FileTestMistake?> list;
        int line;

        public FileTestMistakeList () {
            list = new Vala.ArrayList<FileTestMistake?> ();
            line = 0;
        }

        public void add (string title, int line_diff, string? message = null) {
            list.add ({ title, line += line_diff, message });
        }
    }

    public static void check_file_for_mistake (File file, FileTestMistakeList mistake_list) {
        var linter = new ValaLint.Linter ();
        linter.disable_mistakes = false;

        try {
            Vala.ArrayList<ValaLint.FormatMistake?> mistakes = linter.run_checks_for_file (file);

            if (mistakes.size != mistake_list.list.size) {
                for (int i = 0; i < mistakes.size; i++) {
                    var is_mistake = mistakes[i];
                    print ("Mistake %d: Title '%s', line '%d', pos '%d'\n", i, is_mistake.check.title, is_mistake.begin.line, is_mistake.begin.column);
                }

                error ("%s has %d but should have %d mistakes. Found mistakes are listed above.", file.get_path (), mistakes.size, mistake_list.list.size);
            }

            for (int i = 0; i < mistakes.size; i++) {
                var is_mistake = mistakes[i];
                var should_mistake = mistake_list.list[i];

                if (is_mistake.check.title != should_mistake.title) {
                    error ("Mistake %d of file %s: Title is '%s' but should be '%s'", i, file.get_path (), is_mistake.check.title, should_mistake.title);
                }
                if (is_mistake.begin.line != should_mistake.line) {
                    error ("Mistake %d of file %s: Line '%d' but should be '%d'", i, file.get_path (), is_mistake.begin.line, should_mistake.line);
                }

                if (should_mistake.message != null && is_mistake.mistake != should_mistake.message) {
                    error ("Mistake %d of file %s: Message is '%s' but should be '%s'", i, file.get_path (), is_mistake.mistake, should_mistake.message);
                }
            }
        } catch (Error e) {
            critical ("Error: %s while linting pass file %s\n", e.message, file.get_path ());
        }
    }

    public static File get_test_file (string name) {
        return File.new_for_path ("../test/files/" + name);
    }

    public static int main (string[] args) {
        var block_opening_warnings = FileTestMistakeList ();
        block_opening_warnings.add ("block-opening-brace-space-before", 7);
        check_file_for_mistake (get_test_file ("block-opening-brace-space-before-check.vala"), block_opening_warnings);

        var double_spaces_warnings = FileTestMistakeList ();
        double_spaces_warnings.add ("double-spaces", 8);
        double_spaces_warnings.add ("double-spaces", 1);
        check_file_for_mistake (get_test_file ("double-spaces-check.vala"), double_spaces_warnings);

        var ellipsis_warnings = FileTestMistakeList ();
        ellipsis_warnings.add ("ellipsis", 5);
        ellipsis_warnings.add ("ellipsis", 1);
        ellipsis_warnings.add ("ellipsis", 0);
        check_file_for_mistake (get_test_file ("ellipsis-check.vala"), ellipsis_warnings);

        var empty_list = FileTestMistakeList ();
        check_file_for_mistake (get_test_file ("general-pass.vala"), empty_list);

        var general_warnings = FileTestMistakeList ();
        general_warnings.add ("naming-convention", 4);
        general_warnings.add ("space-before-paren", 2);
        general_warnings.add ("note", 1, "TODO");
        general_warnings.add ("note", 1, "TODO: Lorem ipsum");
        general_warnings.add ("double-spaces", 2);
        general_warnings.add ("double-spaces", 1);
        general_warnings.add ("double-spaces", 0);
        general_warnings.add ("double-spaces", 0);
        general_warnings.add ("double-spaces", 1);
        general_warnings.add ("trailing-whitespace", 1);
        general_warnings.add ("no-space", 3);
        general_warnings.add ("double-semicolon", 1);
        general_warnings.add ("naming-convention", 1);
        general_warnings.add ("ellipsis", 2);
        general_warnings.add ("ellipsis", 1);
        general_warnings.add ("ellipsis", 1);
        general_warnings.add ("ellipsis", 0);
        general_warnings.add ("unnecessary-string-template", 2);
        general_warnings.add ("unnecessary-string-template", 1);
        general_warnings.add ("line-length", 2);
        general_warnings.add ("line-length", 1);
        general_warnings.add ("trailing-newlines", 2);
        check_file_for_mistake (get_test_file ("general-warnings.vala"), general_warnings);

        var line_length_warnings = FileTestMistakeList ();
        line_length_warnings.add ("line-length", 8);
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
        note_warnings.add ("note", 7);
        note_warnings.add ("note", 1);
        check_file_for_mistake (get_test_file ("note-check.vala"), note_warnings);

        var space_before_paren_warnings = FileTestMistakeList ();
        space_before_paren_warnings.add ("space-before-paren", 4);
        space_before_paren_warnings.add ("no-space", 5);
        space_before_paren_warnings.add ("space-before-paren", 0);
        space_before_paren_warnings.add ("no-space", 0);
        space_before_paren_warnings.add ("no-space", 0);
        check_file_for_mistake (get_test_file ("space-before-paren-check.vala"), space_before_paren_warnings);

        var tab_warnings = FileTestMistakeList ();
        tab_warnings.add ("use-of-tabs", 5);
        check_file_for_mistake (get_test_file ("tab-check.vala"), tab_warnings);

        check_file_for_mistake (get_test_file ("trailing-newlines-check-1.vala"), empty_list);

        var trailing_newlines_2_warnings = FileTestMistakeList ();
        trailing_newlines_2_warnings.add ("trailing-newlines", 5);
        check_file_for_mistake (get_test_file ("trailing-newlines-check-2.vala"), trailing_newlines_2_warnings);

        var trailing_newlines_3_warnings = FileTestMistakeList ();
        trailing_newlines_3_warnings.add ("trailing-newlines", 5);
        trailing_newlines_3_warnings.add ("trailing-whitespace", 0);
        check_file_for_mistake (get_test_file ("trailing-newlines-check-3.vala"), trailing_newlines_3_warnings);

        var trailing_newlines_4_warnings = FileTestMistakeList ();
        trailing_newlines_4_warnings.add ("trailing-newlines", 5);
        check_file_for_mistake (get_test_file ("trailing-newlines-check-4.vala"), trailing_newlines_4_warnings);

        var trailing_whitespace_warnings = FileTestMistakeList ();
        trailing_whitespace_warnings.add ("trailing-whitespace", 4);
        check_file_for_mistake (get_test_file ("trailing-whitespace-check.vala"), trailing_whitespace_warnings);

        return 0;
    }
}
