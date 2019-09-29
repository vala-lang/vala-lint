namespace NamespaceName {
    class Test {
        int a;
    }
}

class TestNamespace.FileTest : GLib.Object {

    // Property for indentation
    public int test { get { return this._number; }; set; }
    public int number { get {
            return this._number;
        }
        set {
            this._number = value;
        }
    }

    public static int main (string[] args) {
        string no_ellipsis = ".. lorem ipsum."; // This is a very long comment over the line-length limit of 120 characters...
        string this_is_a_very_long_but_just_under_line_length_variable = "I am staying just under the line length l";
        string this_is_a_very_long_but_just_under_line_length_comment = /* comments are ignored */ "I am staying just under the line length l";

        string literal = "Lorem ipsum";
        var string_template = @"$literal et al.";

        // Some checks for indentation
        if (true) {
            var b = 3;
        } else {
            if (true) {
                var a = 2;

                switch (a) {
                case 2: {
                    a = 3;
                    break;
                }

                default:
                    break;
                }
            }
        }

        Bus.own_name (BusType.SESSION, "org.pantheon.greeter", BusNameOwnerFlags.NONE,
            (connection) => {
                if (instance == null) {
                    instance = new DBus ();
                }

                try {
                    connection.register_object ("/org/pantheon/greeter", instance);
                } catch (Error e) {
                    warning (e.message);
                }
            },
            () => {},
            () => warning ("Could not acquire name\n")
        );

        lock (notifications) {
            notifications = null;
        }

        new Thread<void*> (null, () => {
            lock (notifications) {
                try {
                    notifications = connection.get_proxy_sync<DBusNotifications> ("org.freedesktop.Notifications",
                        "/org/freedesktop/Notifications", DBusProxyFlags.NONE);
                } catch (Error e) {
                    notifications = null;
                }
            }
            return null;
        });
        var /* comment */ string_double_space = /* */ "lorem";

        return 0;
    }
}

public bool valid () {
    if (modifiers == Gdk.ModifierType.SHIFT_MASK) {
        if ((accel_key >= Gdk.Key.a && accel_key <= Gdk.Key.z)
         || (accel_key >= Gdk.Key.A && accel_key <= Gdk.Key.Z)
         || (accel_key >= Gdk.Key.@0 && accel_key <= Gdk.Key.@9)
         || (accel_key >= Gdk.Key.kana_fullstop && accel_key <= Gdk.Key.semivoicedsound)
         || (accel_key >= Gdk.Key.Arabic_comma && accel_key <= Gdk.Key.Arabic_sukun)
         || (accel_key >= Gdk.Key.Serbian_dje && accel_key <= Gdk.Key.Cyrillic_HARDSIGN)
         || (accel_key >= Gdk.Key.Greek_ALPHAaccent && accel_key <= Gdk.Key.Greek_omega)
         || (accel_key >= Gdk.Key.hebrew_doublelowline && accel_key <= Gdk.Key.hebrew_taf)
         || (accel_key >= Gdk.Key.Thai_kokai && accel_key <= Gdk.Key.Thai_lekkao)
         || (accel_key >= Gdk.Key.Hangul && accel_key <= Gdk.Key.Hangul_Special)
         || (accel_key >= Gdk.Key.Hangul_Kiyeog && accel_key <= Gdk.Key.Hangul_J_YeorinHieuh)
         || (accel_key == Gdk.Key.Home)
         || (accel_key == Gdk.Key.Left)
         || (accel_key == Gdk.Key.Up)
         || (accel_key == Gdk.Key.Right)
         || (accel_key == Gdk.Key.Down)
         || (accel_key == Gdk.Key.Page_Up)
         || (accel_key == Gdk.Key.Page_Down)
         || (accel_key == Gdk.Key.End)
         || (accel_key == Gdk.Key.Tab)
         || (accel_key == Gdk.Key.KP_Enter)
         || (accel_key == Gdk.Key.Return)) {
            return false;
        }
    }
}
