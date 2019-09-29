// vala-lint=skip-file

class FileTest : GLib.Object {
    const int underscore_constant = 3;
        int wrong_indentation;

    public static int main(string[] args) {
        test (); // TODO
        test (); // TODO: Lorem ipsum

        int double_space  = 2;
        string  double_space_string  =  _("");
        test  ();
        return 0;  
    }

    public void test (string a,string b) {
        int number_of_semicolons = 2;;
        int NUMBER_ALL_CAPS = 3;

        var single_ellipsis = "...";
        var double_ellipsis_single_mistake = "......";
        var double_ellipsis_double_mistake = "... lorem ...";

        var empty_string_template = @"";
        var content_string_template = @"Lorem ipsum";

        string this_is_a_very_long_variable_name_to_get_over_the_120_character_line_length_limit = "lorem ipsum dolor amet test"; // despite the comment
        string this_is_a_very_long_variable_name_to_get_over_the_120_character_line_with_comment /* with comment */ = "lorem ipsum dolor amet test"; // and comment here

        if (empty_string_template == "") {
                wrong_indentation = 3;
        }
    }
}