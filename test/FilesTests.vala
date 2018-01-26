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

class UnitTest : GLib.Object {

    public static int main (string[] args) {

        var linter = new ValaLint.Linter ();
        try {
            var mistakes = linter.run_checks_for_filename ("../test/files/IconRenderer.vala");

            assert (mistakes.size == 4);
            assert (mistakes[0].line_index == 128);
            assert (mistakes[0].check.get_title() == "trailing-whitespace");
        } catch {
            error ("Could not read file.");
        }


        return 0;
    }
}
