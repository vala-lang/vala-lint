class UnitTest : GLib.Object {

    public static int main(string[] args) {

        var ellipsis_check = new ValaLint.Checks.EllipsisCheck ();
        assert_pass(ellipsis_check, "lorem ipsum");
        assert_pass(ellipsis_check, "lorem ipsum...");
        assert_warning(ellipsis_check, "lorem ipsum\"...\"");

        var tab_check = new ValaLint.Checks.TabCheck ();
        assert_pass(tab_check, "lorem ipsum");
        assert_warning(tab_check, "lorem	ipsum");

        var trailing_whitespace_check = new ValaLint.Checks.TrailingWhitespaceCheck ();
        assert_pass(trailing_whitespace_check, "lorem ipsum");
        assert_warning(trailing_whitespace_check, "lorem ipsum ");

        return 0;
    }

    public static void assert_pass(ValaLint.Check check, string line) {
        var mistake_list = new Gee.ArrayList<ValaLint.FormatMistake?> ();
        assert(!check.check_line(mistake_list, 0, line));
    }

    public static void assert_warning(ValaLint.Check check, string line) {
        var mistake_list = new Gee.ArrayList<ValaLint.FormatMistake?> ();
        assert(check.check_line(mistake_list, 0, line));
    }
}
