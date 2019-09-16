class FileTest : GLib.Object {

    public static int main(string[] args) { // vala-lint=space-before-paren
        test ();

        return 0;
    }

    public void test (string a,string b) { // vala-lint=no-space
        int number_of_semicolons = 2;; // vala-lint=double-semicolon

        var single_ellipsis = "..."; // vala-lint=ellipsis
        var double_ellipsis_single_mistake = "......"; // vala-lint=ellipsis
        var double_ellipsis_double_mistake = "... lorem ..."; // vala-lint=ellipsis

        var empty_string_template = @""; // vala-lint=unnecessary-string-template
        var content_string_template = @"Lorem ipsum"; // vala-lint=unnecessary-string-template
    }
} // vala-lint=trailing-newlines