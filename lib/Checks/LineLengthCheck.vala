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

    public LineLengthCheck (Config config = new Config ()) {
        Object (
            title: _("line-length"),
            description: _("Checks for a maxmimum line legnth")
        );

        try {
            enabled = config.get_boolean ("Checks", title);
            maximum_characters = config.get_integer (title, "max-line-length");
        } catch (KeyFileError e) {
            critical ("Error while loading check %s: %s", title, e.message);
        }
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {
        string input = "";
        foreach (ParseResult r in parse_result) {
            input += r.text;
        }

        int line_counter = 1;
        foreach (string line in input.split ("\n")) {
            if (line.char_count () > maximum_characters) {
                int line_length = line.char_count ();
                string formatted_message = MESSAGE.printf (maximum_characters, line_length);

                var begin = Vala.SourceLocation ((char *)line + maximum_characters, line_counter, maximum_characters);
                var end = Vala.SourceLocation ((char *)line + line_length, line_counter, line_length);
                add_mistake ({ this, begin, end, formatted_message }, ref mistake_list);
            }
            line_counter += 1;
        }
    }
}
