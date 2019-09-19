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

    public NoteCheck () {
        Object (
            title: _("note"),
            description: _("Checks for notes (TODO, FIXME, etc.)"),
            single_mistake_in_line: true
        );

        state = Config.get_state (title);
        keywords = Config.get_string_list (title, "keywords");
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
                        int index_end = (index_newline > -1) ? int.min (r.text.length, index_newline) : r.text.length;
                        string message = r.text.slice (index + keyword.length + 1, index_end).strip ();

                        var begin = Utils.get_absolute_location (r.begin, r.text, index);
                        var end = Utils.get_absolute_location (r.begin, r.text, index_end);
                        mistake_list.add ({ this, begin, end, @"$keyword: $message" });
                    }
                }
            }
        }
    }
}
