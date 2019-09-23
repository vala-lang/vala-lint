/*
 * Copyright (c) 2019 elementary LLC. (https://github.com/elementary/vala-lint)
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


public struct ValaLint.DisableResult {
    public string check_title;
    public Vala.SourceLocation location; // Only using line location
}


public class ValaLint.Disabler : Object {
    const string DISABLE_KEY = "vala-lint=";
    const string SKIP_FILE_KEY = "skip-file";

    /**
     * Parses a list of checks to disable at specific lines.
     *
     * @param parse_result The parse result from ValaLint.Parser.
     */
    public Vala.ArrayList<DisableResult?> parse (Vala.ArrayList<ParseResult?> parse_result) {
        var result = new Vala.ArrayList<DisableResult?> ();

        foreach (ParseResult r in parse_result) {
            if (r.detail_type == ParseDetailType.INLINE_COMMENT) {
                int index = r.text.index_of (DISABLE_KEY);
                if (index > 0) {
                    index += DISABLE_KEY.length;

                    /* Find list of checks by splitting with "," */
                    var title_list = r.text.slice (index, r.text.length).split (",");

                    foreach (string title in title_list) {
                        result.add ({ title.strip (), r.begin });
                    }
                }
            }
        }

        return result;
    }

    /**
     * Filters a list of mistakes given checks to disable at specific lines.
     *
     * @param mistakes The overall mistake list from the Linter.
     * @param disable_results The list of results to disable.
     */
    public Vala.ArrayList<FormatMistake?> filter_mistakes (Vala.ArrayList<FormatMistake?> mistakes,
                                                           Vala.ArrayList<DisableResult?> disable_results) {
        // Skip mistakes of the entire file and return empty array if 'skip-file' tag exists
        if (!disable_results.is_empty && disable_results.first ().check_title == SKIP_FILE_KEY) {
            return new Vala.ArrayList<FormatMistake?> ();
        }

        return Utils.filter<FormatMistake?> (m => {
            foreach (DisableResult r in disable_results) {
                /* Find mistakes with same title and line index */
                if (m.check.title == r.check_title && m.begin.line == r.location.line) {
                    return false;
                }
            }

            return true;
        }, mistakes);
    }
}
