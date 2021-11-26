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

class AutoFixTest : GLib.Object {
    File inital_auto_fix_files_dir = File.new_for_path (TestConfig.SRC_DIR + "/auto-fix/initial");

    File expected_auto_fix_test_files_dir = File.new_for_path (
            TestConfig.SRC_DIR + "/auto-fix/expected"
    );

    public struct AutoFixFileData {
        File file;
        Vala.ArrayList<ValaLint.FormatMistake?> mistakes;
    }

    public bool copy_recursive (GLib.File src, GLib.File dest,
        GLib.FileCopyFlags flags = GLib.FileCopyFlags.NONE, GLib.Cancellable? cancellable = null) throws GLib.Error {
      GLib.FileType src_type = src.query_file_type (GLib.FileQueryInfoFlags.NONE, cancellable);
      if ( src_type == GLib.FileType.DIRECTORY ) {
        if (!dest.query_exists ()) {
            dest.make_directory (cancellable);
        }

        src.copy_attributes (dest, flags, cancellable);

        string src_path = src.get_path ();
        string dest_path = dest.get_path ();
        GLib.FileEnumerator enumerator = src.enumerate_children (GLib.FileAttribute.STANDARD_NAME,
            GLib.FileQueryInfoFlags.NONE, cancellable);

        for ( GLib.FileInfo? info = enumerator.next_file (cancellable);
            info != null ; info = enumerator.next_file (cancellable) ) {
          copy_recursive (
            GLib.File.new_for_path (GLib.Path.build_filename (src_path, info.get_name ())),
            GLib.File.new_for_path (GLib.Path.build_filename (dest_path, info.get_name ())),
            flags,
            cancellable);
        }
      } else if ( src_type == GLib.FileType.REGULAR) {
        src.copy (dest, flags, cancellable);
      }

      return true;
    }

    public Vala.ArrayList<File> get_test_files_from_dir (File dir) throws Error, IOError {
        var files = new Vala.ArrayList<File> ();
        FileEnumerator enumerator = dir.enumerate_children (FileAttribute.STANDARD_NAME, 0, null);

        var info = enumerator.next_file (null);

        while (info != null) {
            string child_name = info.get_name ();
            File child_file = dir.resolve_relative_path (child_name);
            files.add (child_file);
            info = enumerator.next_file (null);
        }

        return files;
    }

    public Vala.ArrayList<AutoFixFileData?> create_file_data_list (Vala.ArrayList<File> files) {
        var file_data_list = new Vala.ArrayList<AutoFixFileData?> ();

        foreach (File file in files) {
             file_data_list.add ({ file, file.get_path (), new Vala.ArrayList<ValaLint.FormatMistake?> () });
        }

        return file_data_list;
    }

    public Vala.ArrayList<AutoFixFileData?> prepare_files_for_test () {
        File output_dir = File.new_for_path (TestConfig.SRC_DIR + "/auto-fix/output");
        assert (output_dir.query_exists ());
        assert (inital_auto_fix_files_dir.query_exists ());

        try {
            copy_recursive (inital_auto_fix_files_dir, output_dir, FileCopyFlags.OVERWRITE);
        } catch (Error e) {
            error ("Error!: %s", e.message);
        }

        assert (expected_auto_fix_test_files_dir.query_exists ());

        Vala.ArrayList<File> test_files;

        try {
            test_files = get_test_files_from_dir (output_dir);
        } catch (Error e) {
            error ("Error: %s", e.message);
        }

        return create_file_data_list (test_files);
    }

    public void check_if_file_content_is_expected (File fixed_file) {
        string file_name = fixed_file.get_basename ();
        File expected_file = File.new_for_path (expected_auto_fix_test_files_dir.get_path () + @"/$file_name");
        string expected_file_contents;
        string fixed_file_contents;

        try {
            FileUtils.get_contents (expected_file.get_path (), out expected_file_contents);
            FileUtils.get_contents (fixed_file.get_path (), out fixed_file_contents);
        } catch (Error e) {
            error ("Error: %s", e.message);
        }

        if (expected_file_contents != fixed_file_contents) {
            error ("Output not expected in: %s", fixed_file.get_path ());
        }
    }

    public bool run () {
        Vala.ArrayList<AutoFixFileData?> file_data_list = prepare_files_for_test ();

        // 1. Lint file
        var linter = new ValaLint.Linter ();
        linter.disable_mistakes = false;
        var fixer = new ValaLint.Fixer ();

        foreach (AutoFixFileData data in file_data_list) {
            try {
            var mistakes = linter.run_checks_for_file (data.file);
            // 2. Apply fixes to file
            fixer.apply_fixes_for_file (data.file, ref mistakes);
            data.mistakes.add_all (mistakes);

            // 3. Compare contents of file to the expect file contents.
            check_if_file_content_is_expected (data.file);
            } catch (Error e) {
                critical (_("Error: %s while linting file %s") + "\n", e.message, data.file.get_path ());
            }
        }

        return true;
    }

    public static int main (string[] args) {
        ValaLint.Config.load_file (null);

        AutoFixTest test = new AutoFixTest ();
        return test.run () ? 0 : 1;
    }
}
