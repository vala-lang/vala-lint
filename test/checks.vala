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

 class CheckTest : GLib.Object {
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

    public static void error_mistake (string message, int number, string uri) {
        error (@"Mistake #$(number) in $(uri): $(message)");
    }

    public static void
    checks (string uri, Vala.ArrayList<ValaLint.FormatMistake?> mistakes, FileTestMistakeList mistake_list) {
        if (mistakes.size != mistake_list.list.size) {
            for (int i = 0; i < mistakes.size; i++) {
                var real = mistakes[i];
                print (@"Mistake #$(i) at ($(real.begin.line):$(real.begin.column)): '$(real.check.title)'\n");
            }

            error (@"$(uri) has $(mistakes.size), should have $(mistake_list.list.size) mistakes.");
        }

        for (int i = 0; i < mistakes.size; i++) {
            var real = mistakes[i];
            var should = mistake_list.list[i];

            if (real.check.title != should.title) {
                error_mistake (@"Title is '$(real.check.title)', should be '$(should.title)'.", i, uri);
            }
            if (real.begin.line != should.line) {
                error_mistake (@"Line is '$(real.begin.line)', should be '$(should.line)'.", i, uri);
            }
            if (should.column_begin != null && real.begin.column != should.column_begin) {
                error_mistake (@"Column is '$(real.begin.column)', should be '$(should.column_begin)'.", i, uri);
            }
            if (should.column_end != null && real.end.column != should.column_end) {
                error_mistake (@"End column is '$(real.end.column)', should be '$(should.column_end)'.", i, uri);
            }
            if (should.message != null && real.mistake != should.message) {
                error_mistake (@"Message is '$(real.mistake)', should be '$(should.message)'.", i, uri);
            }
        }
    }

    public static File get_test_file (string name) {
        return File.new_for_path (TestConfig.SRC_DIR + "/files/" + name);
    }
}
