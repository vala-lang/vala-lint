/*
 * Copyright (c) 2018 elementary LLC. (https://github.com/elementary/Vala-Lint)
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

public enum ParseType {
    DEFAULT,
    COMMENT,
    STRING
}

public enum ParseDetailType { // start pattern, close pattern
    INLINE_COMMENT, // //, \n
    MULTILINE_COMMENT, // /*, */
    VERBATIM_STRING, // """, """
    INTERPOLATED_STRING, // @", "
    NORMAL_STRING, // ", "
    SINGLE_CHAR, // ', '
    CODE
}

public struct ParseResult {
    public string text;
    public ParseType type;
    public Vala.SourceLocation loc;
}
