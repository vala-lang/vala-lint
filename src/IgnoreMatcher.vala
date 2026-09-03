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

namespace ValaLint {
    public class IgnoreMatcher : Object {
        private class Expansion {
            public Vala.ArrayList<string> positives = new Vala.ArrayList<string> ();
            public Vala.ArrayList<string> negations = new Vala.ArrayList<string> ();
        }

        private Vala.ArrayList<string> patterns = new Vala.ArrayList<string> ();
        private int flags;

        public IgnoreMatcher (int flags) {
            this.flags = flags;
        }

        public void add_pattern (string pattern) {
            if (pattern == "" || pattern.has_prefix ("#")) {
                return;
            }

            patterns.add (pattern);
        }

        public bool matches (string path) {
            foreach (var pattern in patterns) {
                if (pattern_matches (pattern, path)) {
                    return true;
                }
            }

            return false;
        }

        private bool pattern_matches (string pattern, string path) {
            var expansion = expand_extglob (pattern);

            bool matched = false;
            foreach (var candidate in expansion.positives) {
                if (Posix.fnmatch (candidate, path, flags) == 0) {
                    matched = true;
                    break;
                }
            }

            if (!matched) {
                return false;
            }

            foreach (var excluded in expansion.negations) {
                if (Posix.fnmatch (excluded, path, flags) == 0) {
                    return false;
                }
            }

            return true;
        }

        /*
         * Posix.fnmatch() has no concept of extglob operators (+(), *(), ?(), @(), !()),
         * so any pattern that uses them is expanded here into one or more plain glob
         * patterns before being handed to Posix.fnmatch(). +() and @() are approximated
         * as "exactly one of the alternatives" rather than true repetition, since
         * fnmatch() can't express unbounded repetition as a finite set of patterns - this
         * matches every practical use of these patterns in ignore lists.
         */
        private Expansion expand_extglob (string pattern) {
            int start;
            int end;
            char op;
            Vala.ArrayList<string> alternatives;

            var expansion = new Expansion ();

            if (!find_group (pattern, out start, out end, out op, out alternatives)) {
                expansion.positives.add (pattern);
                return expansion;
            }

            string prefix = pattern[0:start];
            string suffix = pattern[end + 1:pattern.length];

            if (op == '!') {
                var positive = expand_extglob (prefix + "*" + suffix);
                expansion.positives.add_all (positive.positives);
                expansion.negations.add_all (positive.negations);

                foreach (var alt in alternatives) {
                    var excluded = expand_extglob (prefix + alt + suffix);
                    expansion.negations.add_all (excluded.positives);
                }

                return expansion;
            }

            if (op == '?' || op == '*') {
                alternatives.insert (0, "");
            }

            foreach (var alt in alternatives) {
                var sub_expansion = expand_extglob (prefix + alt + suffix);
                expansion.positives.add_all (sub_expansion.positives);
                expansion.negations.add_all (sub_expansion.negations);
            }

            return expansion;
        }

        /* Finds the first top-level extglob group (e.g. "+(foo|bar)") in pattern. */
        private bool find_group (
            string pattern, out int start, out int end, out char op, out Vala.ArrayList<string> alternatives
        ) {
            start = -1;
            end = -1;
            op = '\0';
            alternatives = new Vala.ArrayList<string> ();

            for (int i = 0; i < pattern.length - 1; i++) {
                char c = pattern[i];
                if ((c == '+' || c == '*' || c == '?' || c == '@' || c == '!') && pattern[i + 1] == '(') {
                    start = i;
                    op = c;
                    break;
                }
            }

            if (start == -1) {
                return false;
            }

            int depth = 0;
            int alt_start = start + 2;

            for (int i = start + 1; i < pattern.length; i++) {
                char c = pattern[i];
                if (c == '(') {
                    depth++;
                } else if (c == ')') {
                    depth--;
                    if (depth == 0) {
                        end = i;
                        alternatives.add (pattern[alt_start:i]);
                        break;
                    }
                } else if (c == '|' && depth == 1) {
                    alternatives.add (pattern[alt_start:i]);
                    alt_start = i + 1;
                }
            }

            if (end == -1) {
                start = -1;
                return false;
            }

            return true;
        }
    }
}
