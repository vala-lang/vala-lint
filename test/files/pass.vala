class FileTest : GLib.Object {

    public static int main (string[] args) {
        bool true_bool = true;

        // ConditionSingleLineCheck
        if (true_bool == false) {
            true_bool = false;
        }

        if (
            true_bool == false
        ) {
            true_bool = false;
        }

        if (true_bool == false)
            true_bool = false;

        return 0;
    }
}
