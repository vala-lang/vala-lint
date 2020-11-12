/*
 * Copyright (c) 2020 elementary Inc. (https://github.com/elementary/vala-lint)
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
 * Authored by: Marius Meisenzahl <mariusmeisenzahl@gmail.com>
 */

public class ValaLint.Checks.InitializeObjectsWithPropertiesCheck : Check {
    private Regex? regex;

    public InitializeObjectsWithPropertiesCheck () {
        Object (
            title: "initialize-objects-with-properties",
            description: _("Checks if objects are initialized with properties")
        );

        state = Config.get_state (title);

        try {
            regex = new Regex (
                "(?P<space>[ \t]*)(?P<init>[\\w,.]+ (?P<name>\\w+) = new [\\w,.]+ \\([^;]+);\n" +
                "(?:[ \t]*(?P=name).(?P<props>\\w+\\s?=\\s?[^;]+);\n)+");
        } catch (RegexError e) {
            stderr.printf (e.message);
        }
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {
        foreach (ParseResult r in parse_result) {
            if (regex != null) {
                int index = 0;
                GLib.MatchInfo mi;
                try {
                    while (regex.match_full (r.text, -1, index, 0, out mi)) {
                        int start_pos, end_pos;
                        if (mi.fetch_pos (0, out start_pos, out end_pos)) {
                            var begin = Utils.get_absolute_location (r.begin, r.text, start_pos);
                            var end = Utils.get_absolute_location (r.begin, r.text, end_pos);
    
                            var name = mi.fetch_named ("name");
                            var message = "\"%s\" should be initialized with properties".printf (name);
    
                            mistake_list.add ({ this, begin, end, message });
    
                            index = end_pos + 1;
                        }
                    }
                }  catch (RegexError e) {
                    stderr.printf (e.message);
                }
            }
        }
    }
}
