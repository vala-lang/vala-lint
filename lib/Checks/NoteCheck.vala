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

public class ValaLint.Checks.NoteCheck : Check {
    public string[] keywords { get; set; }

    public NoteCheck (Config config = new Config ()) {
        Object (
            title: _("note"),
            description: _("Checks for notes (TODO, FIXME, etc.)"),
            single_mistake_in_line: true
        );

        try {
            enabled = config.get_boolean ("Checks", title);
            keywords = config.get_string_list (title, "keywords");
        } catch (KeyFileError e) {
            critical ("Error while loading check %s: %s", title, e.message);
        }
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {
        foreach (ParseResult r in parse_result) {
            if (r.type == ParseType.COMMENT) {
                foreach (string keyword in keywords) {
                    int index = r.text.index_of (keyword);
                    if (index > 0) {
                        /* Get message of note */
                        int index_newline = r.text.index_of ("\n", index);
                        int index_end = int.min (r.text.length, index_newline);
                        string message = r.text.slice (index + keyword.length + 1, index_end).strip ();

                        /* Get correct position of note */
                        int line_count = Utils.get_line_count (r.text[0:index]);
                        int line = r.begin.line + line_count;
                        int column = Utils.get_column_in_line (r.text, index);
                        if (line_count == 0) {
                            column += r.begin.column;
                        }

                        var loc = Vala.SourceLocation ((char *)r.begin.pos + index, line, column);
                        mistake_list.add ({ this, loc, @"$keyword: $message" });
                    }
                }
            }
        }
    }
}
