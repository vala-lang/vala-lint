/*
 * Copyright (c) 2018-2019 elementary LLC. (https://github.com/elementary/vala-lint)
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

public class ValaLint.Checks.LineLengthCheck : Check {
    const string MESSAGE = "Line exceeds limit of %d characters (currently %d characters)";

    public int maximum_characters { get; set; }
    public bool ignore_comments { get; set; }

    public LineLengthCheck () {
        Object (
            title: _("line-length"),
            description: _("Checks for a maxmimum line legnth")
        );

        state = Config.get_state (title);
        maximum_characters = Config.get_integer (title, "max-line-length");
        ignore_comments = Config.get_boolean (title, "ignore-comments");
    }

    public void check_line (string line, int line_count, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        int line_length = line.char_count ();
        if (line_length > maximum_characters) {
            string formatted_message = MESSAGE.printf (maximum_characters, line_length);

            var pos = (char *)line;
            var begin = Vala.SourceLocation (pos + maximum_characters, line_count, maximum_characters);
            var end = Vala.SourceLocation (pos + line_length, line_count, line_length);
            add_mistake ({ this, begin, end, formatted_message }, ref mistake_list);
        }
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {
        string line = "";
        foreach (ParseResult r in parse_result) {
            var text_split = r.text.split ("\n");
            for (int i = 0; i < text_split.length - 1; i++) {
                if (r.type != ParseType.COMMENT || !ignore_comments) {
                    line += text_split[i];
                }

                check_line (line, r.begin.line + i, ref mistake_list);

                line = "";
            }

            if (r.type != ParseType.COMMENT || !ignore_comments) {
                line += text_split[text_split.length - 1];
            }
        }

        var r = parse_result.last ();
        check_line (line, r.begin.line, ref mistake_list);
    }
}
