/*
 * Copyright (c) 2019 elementary LLC. (https://github.com/elementary/vala-lint)
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

public class ValaLint.Checks.TrailingNewlinesCheck : Check {
    public TrailingNewlinesCheck (Config config = new Config ()) {
        Object (
            title: _("trailing-newlines"),
            description:_("Checks for a single newline at the end of files")
        );

        try {
            enabled = config.get_boolean ("Checks", title);
        } catch (KeyFileError e) {
            critical ("Error while loading check %s: %s", title, e.message);
        }
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {
        ParseResult r_last = parse_result.last ();
        if (r_last.type == ParseType.DEFAULT) {
            add_regex_mistake ("""[^\n]\z""", _("Missing newline at the end of file"), r_last, ref mistake_list);
            add_regex_mistake ("""\n{2,}\z""", _("Multiple newlines at the end of file"), r_last, ref mistake_list);
        }
    }
}
