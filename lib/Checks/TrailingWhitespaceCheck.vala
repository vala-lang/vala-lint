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

public class ValaLint.Checks.TrailingWhitespaceCheck : Check {
    public TrailingWhitespaceCheck () {
        Object (
            title: _("trailing-whitespace"),
            description:_("Checks for whitespaces at the end of lines")
        );
    }

    public override void check (Gee.ArrayList<ParseResult? > parse_result, ref Gee.ArrayList<FormatMistake? > mistake_list) {
        foreach (ParseResult r in parse_result) {
            if (r.type == ParseType.DEFAULT) {
                add_regex_mistake ("""\h\n""", _("Unexpected whitespace at end of line"), r, ref mistake_list);
            }
        }

        // Check for whitespace at last line
        ParseResult r_last = parse_result.last ();
        if (r_last.type == ParseType.DEFAULT) {
            add_regex_mistake ("""\h$""", _("Unexpected whitespace at end of last line"), r_last, ref mistake_list);
        }
    }
}
