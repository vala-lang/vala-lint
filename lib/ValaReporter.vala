/*
 * Copyright (c) 2018 elementary LLC. (https://github.com/elementary/vala-lint)
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

class ValaLint.Reporter : Vala.Report {
    Gee.ArrayList<FormatMistake?> mistake_list;

    /* If we want, the Vala Reporter class could add its own warnings to our mistake_list */
    public Reporter (Gee.ArrayList<FormatMistake?> mistake_list) {
        this.mistake_list = mistake_list;
    }

    public override void note (Vala.SourceReference? reference, string message) { }

    public override void depr (Vala.SourceReference? reference, string message) { }

    public override void warn (Vala.SourceReference? reference, string message) { }

    public override void err (Vala.SourceReference? reference, string message) { }
}
