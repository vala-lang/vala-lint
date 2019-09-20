// vala-lint=skip-file

class FileTest : GLib.Object {

    public static int main(string[] args) {
        test (); // TODO
        test (); // TODO: Lorem ipsum

        return 0;
    }

    public void test (string a,string b) {
        int number_of_semicolons = 2;;

        var single_ellipsis = "...";
        var double_ellipsis_single_mistake = "......";
        var double_ellipsis_double_mistake = "... lorem ...";

        var empty_string_template = @"";
        var content_string_template = @"Lorem ipsum";
    }
}