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

public class ValaLint.Checks.BlockOpeningBraceSpaceBeforeCheck : Check {
    public BlockOpeningBraceSpaceBeforeCheck () {
        Object (
            title: _("block-opening-brace-space-before"),
            description: _("Checks for correct use of opening braces"),
            single_mistake_in_line: true
        );

        add_regex_check (
            ParseType.Default,
            """[\w)=]\n\s*{""",
            _("Unexpected line break before \"{\""),
            1
        );

        add_regex_check (
            ParseType.Default,
            """[\w)=]{""",
            _("Expected whitespace before \"{\""),
            1
        );

        // Check for a tab character or more than one whitespace character before the open parenthesis
        add_regex_check (
            ParseType.Default,
            """[\w)=](?:\t|\s{2,}){""",
            _("Expected single space before \"{\""),
            1
        );
    }
}
