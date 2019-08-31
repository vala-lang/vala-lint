class FileTest : GLib.Object {

    public static int main(string[] args) { // vala-lint=space-before-paren
        bool true_bool = true;

        if (true_bool == false) true_bool = false; // vala-lint=condition-single-line
        if (true_bool == false) { true_bool = false; } // vala-lint=condition-single-line

        return 0;
    }

    public void test (string a,string b) { // vala-lint=no-space
        var a = 2;; // vala-lint=double-semicolon

    }
} // vala-lint=trailing-newlines