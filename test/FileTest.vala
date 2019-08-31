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

    public struct FileTestMistake {
        string title;
        int line;
    }

    public static void check_file_for_mistake (File file, Vala.ArrayList<FileTestMistake?> mistake_list) {
        var linter = new ValaLint.Linter ();
        linter.disable_mistakes = false;

        try {
            Vala.ArrayList<ValaLint.FormatMistake?> mistakes = linter.run_checks_for_file (file);

            if (mistakes.size != mistake_list.size) {
                error ("Error: File %s has %d but should have %d mistakes.", file.get_path (), mistakes.size, mistake_list.size);
            }

            for (int i = 0; i < mistakes.size; i++) {
                assert (mistakes[i].check.title == mistake_list[i].title);
                assert (mistakes[i].begin.line == mistake_list[i].line);
            }
        } catch (Error e) {
            critical ("Error: %s while linting pass file %s\n", e.message, file.get_path ());
        }
    }

    public static int main (string[] args) {
        var m_pass = new Vala.ArrayList<FileTestMistake?>();
        check_file_for_mistake (File.new_for_path ("../test/files/pass.vala"), m_pass);

        var m_warnings = new Vala.ArrayList<FileTestMistake?>();
        m_warnings.add ({ "space-before-paren", 3 });
        m_warnings.add ({ "no-space", 9 });
        m_warnings.add ({ "unnecessary-string-template", 10 });
        m_warnings.add ({ "double-semicolon", 11 });
        check_file_for_mistake (File.new_for_path ("../test/files/warnings.vala"), m_warnings);

        return 0;
    }
}
