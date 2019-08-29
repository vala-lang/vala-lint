class FileTest : GLib.Object {

    public static int main(string[] args) { // vala-lint=space-before-paren

        return 0;
    }

    public void test (string a,string b) { // vala-lint=no-space
        var a = @""; // vala-lint=unnecessary-string-template

    }
} // vala-lint=trailing-newlines