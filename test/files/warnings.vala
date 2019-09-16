class FileTest : GLib.Object {

    public static int main(string[] args) { // vala-lint=space-before-paren

        return 0;
    }

    public void test (string a,string b) { // vala-lint=no-space
        var a = 2;; // vala-lint=double-semicolon

        var single_ellipsis = "..."; // vala-lint=ellipsis
        var double_ellipsis_single_mistake = "......"; // vala-lint=ellipsis
        var double_ellipsis_double_mistake = "... lorem ..."; // vala-lint=ellipsis
    }
} // vala-lint=trailing-newlines