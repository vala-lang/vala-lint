/*
 * Copyright (c) 2016-2019 elementary LLC. (https://github.com/elementary/vala-lint)
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
 * Authored by: pantor
 */


public struct ValaLint.DisableResult {
    public string check_title;
    public int line_pos;
}

public class ValaLint.Disabler : Object {
    const string DISABLE_KEY = "vala-lint";

    public Vala.ArrayList<DisableResult?> parse (Vala.ArrayList<ParseResult?> parse_result) {
        var result = new Vala.ArrayList<DisableResult?> ();

        foreach (ParseResult r in parse_result) {
            if (r.detail_type == ParseDetailType.INLINE_COMMENT) {
                int index = r.text.index_of (@"$DISABLE_KEY=");
                if (index > 0) {
                    index += DISABLE_KEY.length + 1;

                    /* Find list of checks by splitting with "," */
                    var title_list = r.text.slice (index, r.text.length).split (",");

                    foreach (string title in title_list) {
                        result.add ({ title.strip (), r.line_pos });
                    }
                }
            }
        }

        return result;
    }

    public Vala.ArrayList<FormatMistake?> filter_mistakes (Vala.ArrayList<FormatMistake?> mistakes,
                                                           Vala.ArrayList<DisableResult?> disable_results) {
        var result = new Vala.ArrayList<FormatMistake?> ();

        foreach (FormatMistake m in mistakes) {
            bool found_no_disabler = true;
            foreach (DisableResult r in disable_results) {
                /* Find mistakes with same title and line index */
                if (m.check.title == r.check_title && m.line_index == r.line_pos) {
                    found_no_disabler = false;
                    break;
                }
            }

            if (found_no_disabler) {
                result.add (m);
            }
        }

        return result;
    }
}
