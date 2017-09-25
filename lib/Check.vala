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
 *
 * Authored by: Marcus Wichelmann <marcus.wichelmann@hotmail.de>
 */

public abstract class ValaLint.Check {
    /**
     * Method to get a short but descriptive title of the check.
     *
     * @return The title of the check.
     */
    public abstract string get_title ();


    /**
     * Method to get a short description of what this class checks for.
     *
     * @return The description of the check.
     */
    public abstract string get_description ();

    /**
     * Checks a given line for formatting mistakes.
     *
     * @param mistake_list The list new mistakes should be added to.
     * @param line_index The index of the given line.
     * @param line The line that should be checked.
     *
     * @return Indicates if new mistakes were added to the list.
     */
    public abstract bool check_line (Gee.ArrayList<FormatMistake?> mistake_list, int line_index, string line);
}
