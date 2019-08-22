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

public class ValaLint.Config : KeyFile {
    public Config () {
        set_list_separator (',');

        set_boolean ("Checks", "block-opening-brace-space-before", true);
        set_boolean ("Checks", "double-spaces", true);
        set_boolean ("Checks", "ellipsis", true);
        set_boolean ("Checks", "line-length", true);
        set_boolean ("Checks", "naming-convention", true);
        set_boolean ("Checks", "no-space", true);
        set_boolean ("Checks", "note", true);
        set_boolean ("Checks", "space-before-paren", true);
        set_boolean ("Checks", "use-of-tabs", true);
        set_boolean ("Checks", "trailing-newlines", true);
        set_boolean ("Checks", "trailing-whitespace", true);

        set_boolean ("Disabler", "disable-by-inline-comments", true);

        set_double ("line-length", "max-line-length", 120);

        set_string_list ("note", "keywords", {"TODO", "FIXME"});
    }

    public Config.load_file (string? path) {
        // Load default config
        this ();

        if (path == null) {
            return;
        }

        var keyfile = new KeyFile ();
        try {
            keyfile.load_from_file (path, 0);
        } catch (GLib.Error e) {
            critical ("Cannot load config file %s: %s\n", path, e.message);
        }

        // Merge loaded file into default config
        try {
            foreach (string group in keyfile.get_groups ()) {
                foreach (string key in keyfile.get_keys (group)) {
                    set_value (group, key, keyfile.get_value (group, key));
                }
            }
        } catch (KeyFileError e) {
            critical ("Error while loading config file %s: %s\n", path, e.message);
        }
    }
}
