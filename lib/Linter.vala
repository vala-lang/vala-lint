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
 *
 * Authored by: Marcus Wichelmann <marcus.wichelmann@hotmail.de>
 */

public class ValaLint.Linter : Object {

    /* Checks which work on the result of our own ValaLint.Parser. */
    public Gee.ArrayList<Check> global_checks { get; set; }

    /* Checks which work on the abstract syntax tree of the offical Vala.Parser */
    ValaLint.Visitor visitor;

    public Linter () {
        global_checks = new Gee.ArrayList<Check> ();
        global_checks.add (new Checks.BlockOpeningBraceSpaceBeforeCheck ());
        global_checks.add (new Checks.DoubleSpacesCheck ());
        global_checks.add (new Checks.EllipsisCheck ());
        global_checks.add (new Checks.LineLengthCheck ());
        global_checks.add (new Checks.SpaceBeforeParenCheck ());
        global_checks.add (new Checks.TabCheck ());
        global_checks.add (new Checks.TrailingWhitespaceCheck ());

        visitor = new ValaLint.Visitor ();
        visitor.naming_all_caps_check = new Checks.NamingAllCapsCheck ();
        visitor.naming_camel_case_check = new Checks.NamingCamelCaseCheck ();
        visitor.naming_underscore_check = new Checks.NamingUnderscoreCheck ();
        visitor.checks = new Gee.ArrayList<Check> ();
        visitor.checks.add (visitor.naming_all_caps_check);
        visitor.checks.add (visitor.naming_camel_case_check);
        visitor.checks.add (visitor.naming_underscore_check);
    }

    public Linter.with_check (Check check) {
        global_checks = new Gee.ArrayList<Check> ();
        global_checks.add (check);
    }

    public Linter.with_checks (Gee.ArrayList<Check> checks) {
        global_checks = checks;
    }

    public Gee.ArrayList<FormatMistake?> run_checks_for_file (File file) throws Error, IOError {
        var mistake_list = new Gee.ArrayList<FormatMistake?> ();

        var context = new Vala.CodeContext ();
        Vala.CodeContext.push (context);

        var filename = file.get_path ();
        var reporter = new Reporter (mistake_list);
        context.report = reporter;
        context.add_source_filename (filename, false, true);

        /* This parser builds the abstract syntax tree (AST) */
        var parser_ast = new Vala.Parser ();
        parser_ast.parse (context);

        visitor.set_mistake_list (mistake_list);
        foreach (var vala_source_file in context.get_source_files ()) {
            vala_source_file.accept (visitor);
        }

        string content;
        FileUtils.get_contents (filename, out content); // Get file content

        /* Our parser checks only strings, comments and other code */
        var parser_code = new ValaLint.Parser ();
        Gee.ArrayList<ParseResult?> parse_result = parser_code.parse (content);

        foreach (Check check in global_checks) {
            check.check (parse_result, ref mistake_list);
        }

        mistake_list.sort ((a, b) => {
            if (a.line_index == b.line_index) {
                return a.char_index - b.char_index;
            }
            return a.line_index - b.line_index;
        });

        return mistake_list;
    }
}
