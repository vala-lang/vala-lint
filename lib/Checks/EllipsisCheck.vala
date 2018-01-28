/*
 * Copyright (c) 2016 elementary LLC. (https://github.com/elementary/Vala-Lint)
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
    public override string get_title () {
        return _("ellipsis");
    }

    public override string get_description () {
        return _("Checks for ellipsis character instead of three periods");
    }

    public override void check (Gee.ArrayList<ParseResult?> parse_result, Gee.ArrayList<FormatMistake? > mistake_list) {
        foreach (ParseResult r in parse_result) {
            if (r.type == ParseType.String) {
                add_regex_mistake (this, """\.\.\.""", "Expected ellipsis instead of three periods", r, mistake_list);
            }
        }
    }
}
