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

public class ValaLint.Config {
    static KeyFile? config;

    public enum State {
        ERROR,
        WARN,
        OFF;

        public string to_string () {
            switch (this) {
                case ERROR:
                    return "error";

                case WARN:
                    return "warn";

                default:
                    return "off";
            }
        }
    }

    public static KeyFile get_default_config () {
        var default_config = new KeyFile ();

        default_config.set_list_separator (',');

        default_config.set_string ("Checks", "block-opening-brace-space-before", State.ERROR.to_string ());
        default_config.set_string ("Checks", "double-semicolon", State.ERROR.to_string ());
        default_config.set_string ("Checks", "double-spaces", State.ERROR.to_string ());
        default_config.set_string ("Checks", "ellipsis", State.ERROR.to_string ());
        default_config.set_string ("Checks", "line-length", State.WARN.to_string ());
        default_config.set_string ("Checks", "naming-convention", State.ERROR.to_string ());
        default_config.set_string ("Checks", "no-space", State.ERROR.to_string ());
        default_config.set_string ("Checks", "note", State.WARN.to_string ());
        default_config.set_string ("Checks", "space-before-paren", State.ERROR.to_string ());
        default_config.set_string ("Checks", "use-of-tabs", State.ERROR.to_string ());
        default_config.set_string ("Checks", "trailing-newlines", State.ERROR.to_string ());
        default_config.set_string ("Checks", "trailing-whitespace", State.ERROR.to_string ());
        default_config.set_string ("Checks", "unnecessary-string-template", State.ERROR.to_string ());

        default_config.set_boolean ("Disabler", "disable-by-inline-comments", true);

        default_config.set_double ("line-length", "max-line-length", 120);
        default_config.set_boolean ("line-length", "ignore-comments", true);

        default_config.set_string_list ("naming-convention", "exceptions", {"UUID"});

        default_config.set_string_list ("note", "keywords", {"TODO", "FIXME"});

        return default_config;
    }

    public static void load_file (string? path) {
        config = get_default_config ();

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
                    config.set_value (group, key, keyfile.get_value (group, key));
                }
            }
        } catch (KeyFileError e) {
            critical ("Error while loading config file %s: %s\n", path, e.message);
        }
    }

    public static State get_state (string check) {
        if (config == null) {
            config = get_default_config ();
        }

        try {
            switch (config.get_string ("Checks", check)) {
                case "error":
                    return ERROR;
                case "warn":
                    return WARN;
                case "off":
                    return OFF;
                default:
                    print ("""Error in config:
    Unknown state "%s" for check "%s" (should be either "error", "warn", or "off"), using "error" for now.

""", config.get_string ("Checks", check), check);
                    return ERROR;
            }
        } catch (KeyFileError e) {
            critical ("Error while loading config %s-%s: %s", "Checks", check, e.message);
            return ERROR;
        }
    }

    public static bool get_boolean (string group, string key) {
        if (config == null) {
            config = get_default_config ();
        }

        try {
            return config.get_boolean (group, key);
        } catch (KeyFileError e) {
            critical ("Error while loading config %s-%s: %s", group, key, e.message);
            return false;
        }
    }

    public static int get_integer (string group, string key) {
        if (config == null) {
            config = get_default_config ();
        }

        try {
            return config.get_integer (group, key);
        } catch (KeyFileError e) {
            critical ("Error while loading config %s-%s: %s", group, key, e.message);
            return 0;
        }
    }

    public static string get_string (string group, string key) {
        if (config == null) {
            config = get_default_config ();
        }

        try {
            return config.get_string (group, key);
        } catch (KeyFileError e) {
            critical ("Error while loading config %s-%s: %s", group, key, e.message);
            return "";
        }
    }

    public static string[] get_string_list (string group, string key) {
        if (config == null) {
            config = get_default_config ();
        }

        try {
            return config.get_string_list (group, key);
        } catch (KeyFileError e) {
            critical ("Error while loading config %s-%s: %s", group, key, e.message);
            return {};
        }
    }
}
