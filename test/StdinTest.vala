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

class StdinTest : GLib.Object {
    struct RunResult {
        string standard_output;
        string standard_error;
        int exit_status;
    }

    RunResult run_vala_lint (string[] extra_args, string stdin_content) {
        string[] argv = { TestConfig.VALA_LINT_BIN };
        foreach (string arg in extra_args) {
            argv += arg;
        }

        try {
            var launcher = new GLib.SubprocessLauncher (
                GLib.SubprocessFlags.STDIN_PIPE |
                GLib.SubprocessFlags.STDOUT_PIPE |
                GLib.SubprocessFlags.STDERR_PIPE
            );

            var process = launcher.spawnv (argv);

            string standard_output, standard_error;
            process.communicate_utf8 (stdin_content, null, out standard_output, out standard_error);

            return RunResult () {
                standard_output = standard_output,
                standard_error = standard_error,
                exit_status = process.get_exit_status ()
            };
        } catch (Error e) {
            error ("Failed to run vala-lint: %s", e.message);
        }
    }

    Json.Object parse_first_mistake (string json_text) {
        var parser = new Json.Parser ();
        try {
            parser.load_from_data (json_text);
        } catch (Error e) {
            error ("Failed to parse JSON output: %s\nOutput was: %s", e.message, json_text);
        }

        var mistakes = parser.get_root ().get_object ().get_array_member ("mistakes");
        assert (mistakes.get_length () > 0);

        return mistakes.get_element (0).get_object ();
    }

    void test_json_output_reports_filename_and_fix () {
        var result = run_vala_lint (
            { "--stdin", "--stdin-filename", "Foo.vala", "-j" },
            "public class Foo : Object {\n    public void bar () {\n        var x = 1;   \n    }\n}\n"
        );

        assert (result.exit_status != 0);

        var mistake = parse_first_mistake (result.standard_output);
        assert (mistake.get_string_member ("filename") == "Foo.vala");
        assert (mistake.get_string_member ("ruleId") == "trailing-whitespace");

        var fix = mistake.get_object_member ("fix");
        assert (fix != null);
        assert (fix.get_string_member ("replacement") == "");
    }

    void test_default_stdin_filename_is_used_when_not_specified () {
        var result = run_vala_lint (
            { "--stdin", "-j" },
            "public class Foo : Object {\n    public void bar () {\n        var x = 1;   \n    }\n}\n"
        );

        var mistake = parse_first_mistake (result.standard_output);
        assert (mistake.get_string_member ("filename") == "stdin");
    }

    void test_fix_with_stdin_prints_fixed_source_to_stdout () {
        var result = run_vala_lint (
            { "--stdin", "--fix" },
            "public class Foo : Object {\n    public void bar () {\n        var x = 1;   \n    }\n}\n"
        );

        assert (result.exit_status == 0);
        assert (result.standard_error == "");
        assert (result.standard_output ==
            "public class Foo : Object {\n    public void bar () {\n        var x = 1;\n    }\n}\n");
    }

    void test_stdin_with_no_mistakes_exits_zero () {
        var result = run_vala_lint ({ "--stdin", "-j" }, "public class Foo : Object {\n}\n");

        assert (result.exit_status == 0);
        assert (result.standard_error == "");

        var parser = new Json.Parser ();
        try {
            parser.load_from_data (result.standard_output);
        } catch (Error e) {
            error ("Failed to parse JSON output: %s\nOutput was: %s", e.message, result.standard_output);
        }

        var mistakes = parser.get_root ().get_object ().get_array_member ("mistakes");
        assert (mistakes.get_length () == 0);
    }

    public static int main (string[] args) {
        var test = new StdinTest ();

        test.test_json_output_reports_filename_and_fix ();
        test.test_default_stdin_filename_is_used_when_not_specified ();
        test.test_fix_with_stdin_prints_fixed_source_to_stdout ();
        test.test_stdin_with_no_mistakes_exits_zero ();

        return 0;
    }
}
