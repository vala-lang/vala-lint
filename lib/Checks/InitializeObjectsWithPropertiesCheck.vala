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
                "(?P<init>[\\w,.]+ (?P<name>\\w+) = new [\\w,.]+ \\([^;]+);\n" +
                "(?:[ \t]*(?P=name).(?P<props>\\w+\\s?=\\s?[^;]+);[\n])*" +
                "(?:[ \t]*(?P=name).(\\w+\\s?=\\s?[^;]+);)");
        } catch (RegexError e) {
            stderr.printf (e.message);
        }
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {
        string content = "";
        foreach (ParseResult r in parse_result) {
            content += r.text;
        }

        if (parse_result.size > 0 && regex != null) {
            ParseResult r = parse_result[0];
            int index = 0;
            GLib.MatchInfo mi;
            try {
                while (regex.match_full (content, -1, index, 0, out mi)) {
                    int name_start_pos, start_pos, end_pos;
                    if ((mi.fetch_named_pos ("name", out name_start_pos, out end_pos)) &&
                        (mi.fetch_pos (0, out start_pos, out end_pos))) {
                        var begin = Utils.get_absolute_location (r.begin, content, name_start_pos);
                        var end = Utils.get_absolute_location (r.begin, content, end_pos);

                        var name = mi.fetch_named ("name");
                        var message = "\"%s\" should be initialized with properties".printf (name);

                        mistake_list.add ({ this, begin, end, message });

                        index = end_pos;
                    }
                }
            } catch (RegexError e) {
                stderr.printf (e.message);
            }
        }
    }
}
