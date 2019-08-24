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

public class ValaLint.Checks.EllipsisCheck : Check {
    public EllipsisCheck (Config config = new Config ()) {
        Object (
            title: _("ellipsis"),
            description: _("Checks for ellipsis character instead of three periods")
        );

        try {
            enabled = config.get_boolean ("Checks", title);
        } catch (KeyFileError e) {
            critical ("Error while loading check %s: %s", title, e.message);
        }
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {
        foreach (ParseResult r in parse_result) {
            if (r.type == ParseType.STRING) {
                add_regex_mistake ("""\.\.\.""", _("Expected ellipsis instead of three periods"), r, ref mistake_list);
            }
        }
    }
}
