/*
 * Copyright (c) 2026 Colin Kiama
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 */

class IgnoreMatcherTest : GLib.Object {
    ValaLint.IgnoreMatcher new_matcher (string[] patterns) {
        var matcher = new ValaLint.IgnoreMatcher (Posix.FNM_PERIOD | Posix.FNM_PATHNAME);
        foreach (var pattern in patterns) {
            matcher.add_pattern (pattern);
        }

        return matcher;
    }

    void test_literal_match () {
        var matcher = new_matcher ({ "build" });

        assert (matcher.matches ("build"));
        assert (!matcher.matches ("build2"));

        // FNM_PATHNAME means a bare directory name must not match a nested path.
        assert (!matcher.matches ("build/foo.c"));
    }

    void test_wildcard_does_not_cross_path_separator () {
        var matcher = new_matcher ({ "*.vala" });

        assert (matcher.matches ("Foo.vala"));
        assert (!matcher.matches ("src/Foo.vala"));
    }

    void test_question_mark_matches_single_char () {
        var matcher = new_matcher ({ "?.vala" });

        assert (matcher.matches ("a.vala"));
        assert (!matcher.matches ("ab.vala"));
    }

    void test_period_flag_excludes_leading_dot_files () {
        var matcher = new_matcher ({ "*.vala" });

        assert (!matcher.matches (".hidden.vala"));

        var matcher_without_period = new ValaLint.IgnoreMatcher (Posix.FNM_PATHNAME);
        matcher_without_period.add_pattern ("*.vala");

        assert (matcher_without_period.matches (".hidden.vala"));
    }

    void test_extglob_one_or_more_group () {
        var matcher = new_matcher ({ "+(foo|bar).vala" });

        assert (matcher.matches ("foo.vala"));
        assert (matcher.matches ("bar.vala"));
        assert (!matcher.matches ("baz.vala"));
    }

    void test_extglob_optional_group () {
        var matcher = new_matcher ({ "ignore?(d).vala" });

        assert (matcher.matches ("ignore.vala"));
        assert (matcher.matches ("ignored.vala"));
        assert (!matcher.matches ("ignores.vala"));
    }

    void test_extglob_exactly_one_group () {
        var matcher = new_matcher ({ "@(foo|bar).vala" });

        assert (matcher.matches ("foo.vala"));
        assert (matcher.matches ("bar.vala"));
        assert (!matcher.matches ("foobar.vala"));
    }

    void test_bracket_expression () {
        var matcher = new_matcher ({ "[abc].vala" });

        assert (matcher.matches ("a.vala"));
        assert (matcher.matches ("b.vala"));
        assert (!matcher.matches ("d.vala"));
    }

    void test_negated_bracket_expression () {
        var matcher = new_matcher ({ "[!abc].vala" });

        assert (!matcher.matches ("a.vala"));
        assert (!matcher.matches ("b.vala"));
        assert (matcher.matches ("d.vala"));
    }

    void test_blank_and_comment_patterns_are_ignored () {
        var matcher = new_matcher ({ "", "#build" });

        assert (!matcher.matches (""));
        assert (!matcher.matches ("#build"));
        assert (!matcher.matches ("build"));
    }

    void test_multiple_patterns_are_matched_with_or () {
        var matcher = new_matcher ({ "build", "po", "~*.vala" });

        assert (matcher.matches ("build"));
        assert (matcher.matches ("po"));
        assert (matcher.matches ("~backup.vala"));
        assert (!matcher.matches ("src/Foo.vala"));
    }

    public static int main (string[] args) {
        var test = new IgnoreMatcherTest ();

        test.test_literal_match ();
        test.test_wildcard_does_not_cross_path_separator ();
        test.test_question_mark_matches_single_char ();
        test.test_period_flag_excludes_leading_dot_files ();
        test.test_extglob_one_or_more_group ();
        test.test_extglob_optional_group ();
        test.test_extglob_exactly_one_group ();
        test.test_bracket_expression ();
        test.test_negated_bracket_expression ();
        test.test_blank_and_comment_patterns_are_ignored ();
        test.test_multiple_patterns_are_matched_with_or ();

        return 0;
    }
}
