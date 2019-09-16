class FileTest : GLib.Object {

    public static int main(string[] args) { // vala-lint=space-before-paren
        test (); // TODO vala-lint=note

        return 0;
    }

    public void test (string a,string b) { // vala-lint=no-space
        var empty_string_template = @""; // vala-lint=unnecessary-string-template
        var content_string_template = @"Lorem ipsum"; // vala-lint=unnecessary-string-template
        int number_of_semicolons = 2;; // vala-lint=double-semicolon
    }
} // vala-lint=trailing-newlines