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

    private static void assert_pass (ValaLint.Check check, string input) {
        var linter = new ValaLint.Linter.with_check (check);
        assert (linter.run_checks (input).size == 0);
    }

    private static void assert_warning (ValaLint.Check check, string input, int char_pos = -1) {
        var linter = new ValaLint.Linter.with_check (check);
        var mistakes = linter.run_checks (input);
        assert (mistakes.size == 1);
        if (char_pos > -1) {
            assert (mistakes[0].char_index == char_pos);
        }
    }
}
