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
        private Vala.ArrayList<GLib.Regex> regexes = new Vala.ArrayList<GLib.Regex> ();
        private int flags;

        public IgnoreMatcher (int flags) {
            this.flags = flags;
        }

        public void add_pattern (string pattern) {
            if (pattern == "" || pattern.has_prefix ("#")) {
                return;
            }

            try {
                var regex_pattern = glob_to_regex (pattern);
                regexes.add (new GLib.Regex (regex_pattern, RegexCompileFlags.OPTIMIZE));
            } catch (Error e) {
                warning ("Invalid ignore pattern '%s': %s", pattern, e.message);
            }
        }

        public bool matches (string path) {
            foreach (var regex in regexes) {
                if (regex.match (path)) {
                    return true;
                }
            }
            return false;
        }

        private string glob_to_regex (string glob) {
            bool pathname = (flags & Posix.FNM_PATHNAME) != 0;
            bool period = (flags & Posix.FNM_PERIOD) != 0;

            var res = new StringBuilder ("^");
            var stack = new Vala.ArrayList<string> ();
            bool in_brackets = false;

            for (int i = 0; i < glob.length; i++) {
                char c = glob[i];
                char next = (i + 1 < glob.length) ? glob [i + 1] : '\0';

                if (in_brackets) {
                    if (c == ']') {
                        in_brackets = false;
                        res.append ("]");
                    } else if (c == '\\') {
                        res.append ("\\\\");
                    } else {
                        res.append_c (c);
                    }
                    continue;
                }

                switch (c) {
                    case '*':
                        if (next == '(') {
                            res.append ("(?:");
                            stack.add (")*");
                            i++;
                        } else {
                            if (pathname) {
                                if (period) res.append ("(?![./])");
                                res.append ("[^/]*");
                            } else {
                                if (period) res.append ("(?!\\.)");
                                res.append (".*");
                            }
                        }
                        break;
                    case '?':
                        if (next == '(') {
                            res.append ("(?:");
                            stack.add (")?");
                            i++;
                        } else {
                            if (pathname) res.append ("[^/]");
                            else res.append (".");
                        }
                        break;
                    case '+':
                        if (next == '(') {
                            res.append ("(?:");
                            stack.add (")+");
                            i++;
                        } else {
                            res.append ("\\+");
                        }
                        break;
                    case '@':
                        if (next == '(') {
                            res.append ("(?:");
                            stack.add (")");
                            i++;
                        } else {
                            res.append ("@");
                        }
                        break;
                    case '!':
                        if (next == '(') {
                            res.append ("(?!");
                            stack.add (").*");
                            i++;
                        } else {
                            res.append ("!");
                        }
                        break;
                    case '(': res.append ("\\("); break;
                    case ')':
                        if (!stack.is_empty) res.append (stack.remove_at (stack.size - 1));
                        else res.append ("\\)");
                        break;
                    case '|': res.append ("|"); break;
                    case '[': in_brackets = true; res.append ("["); break;
                    case '.': case '\\': case '$': case '^': case '{': case '}':
                        res.append ("\\"); res.append_c (c); break;
                    case '/':
                        res.append_c (c);
                        break;
                    default: res.append_c (c); break;
                }
            }

            res.append ("$");
            return res.str;
        }
    }
}
