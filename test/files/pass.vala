class FileTest : GLib.Object {

    public static int main (string[] args) {
        string no_ellipsis = ".. lorem ipsum."; // This is a very long comment over the line-length limit of 120 characters...
        string this_is_a_very_long_but_just_under_line_length_variable = "I am staying just under the line length l";
        string this_is_a_very_long_but_just_under_line_length_comment = /* comments are ignored */ "I am staying just under the line length l";

        string literal = "Lorem ipsum";
        var string_template = @"$literal et al.";

        return 0;
    }
}
