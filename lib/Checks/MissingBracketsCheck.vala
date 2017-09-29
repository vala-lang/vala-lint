/*
 * Copyright (c) 2016 elementary LLC. (https://github.com/elementary/Vala-Lint)
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authored by: Sören Busse
 */

public class ValaLint.Checks.MissingBracketsCheck : Check {
    private Regex regex_no_brackets;
    private Regex regex_same_line;
    private Regex regex_same_line_no_brackets;

    public MissingBracketsCheck () {
        try {
            regex_no_brackets = new Regex ("^(if|while|for|foreach) *\\(.*\\) *$");
            regex_same_line = new Regex ("(if|while|for|foreach) *\\(.*\\) *[{]+ *[a-zA-Z0-9_()]+");
            regex_same_line_no_brackets = new Regex ("(if|while|for|foreach) *\\(.*\\) *[^{] *[a-zA-Z0-9_()]+");
        } catch (Error e) {
            /* Should never happen */
            error ("There was a parsing error during doing some regex");
        }
    }

    public override string get_title () {
        return _("missing-brackets-check");
    }

    public override string get_description () {
        return _("Checks for missing brackets in conditions");
    }

    public override bool check_line (Gee.ArrayList<FormatMistake? > mistake_list, int line_index, string line) {
        MatchInfo matchInfo;

        /*
         *   Does the condition have brackets
         *   Example if(true)
         *              dosomething();
         */
        regex_no_brackets.match (line, 0, out matchInfo);

        if (matchInfo.matches ()) {
            mistake_list.add ({ this, line_index, line.length, _("Expected brackets") });
        }

        /*
         *   Does the condition is in the same line and has no brackets
         *   Example: if(true) doSomething();
         */
        regex_same_line_no_brackets.match (line, 0, out matchInfo);

        if (matchInfo.matches ()) {
            mistake_list.add ({ this, line_index, 0, _("Expected brackets") });
        }

        /*
         *   Is there a method call in the same line as the condition
         *   Example: if(true) { do_something(); }
         */
        regex_same_line.match (line, 0, out matchInfo);

        if (matchInfo.matches ()) {
            mistake_list.add ({ this, line_index, 0, _("Unexpected method call") });
        }

        return false;
    }
}