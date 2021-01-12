/*
 * Copyright (c) 2016-2021 elementary LLC. (https://github.com/vala-lang/vala-lint)
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
 * Authored by: Darshak Parikh <darshak@protonmail.com>
 */

public class ValaLint.Fixer : Object {
    public void apply_fixes_for_file (File file, ref Vala.ArrayList<FormatMistake?> mistakes) throws Error, IOError {
        var filename = file.get_path ();
        string contents;
        FileUtils.get_contents (filename, out contents);

        foreach (FormatMistake? mistake in mistakes) {
            mistake.check.apply_fix (mistake.begin, mistake.end, ref contents);
            stdout.printf (@"Fix: $contents\n");
            // TODO: write contents to file
            // TODO: remove mistake from list
        }
    }
}
