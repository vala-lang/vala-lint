/*
 * Copyright (c) 2026 Colin Kiama
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

/**
 * Describes how to fix a single mistake: the text to insert and the range
 * of the original file contents it replaces.
 */
public struct ValaLint.CodeFix {
    public string replacement;
    public int begin_line;
    public int begin_column;
    public int end_line;
    public int end_column;
}
