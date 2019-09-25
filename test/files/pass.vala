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

        return 0;
    }
}
