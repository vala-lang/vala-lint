/*
 * Copyright (c) 2019 elementary LLC. (https://github.com/elementary/vala-lint)
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

public class ValaLint.Checks.UnnecessaryStringTemplateCheck : Check {
    const string MESSAGE = _("String template can be simplified using a literal");

    public UnnecessaryStringTemplateCheck () {
        Object (
            title: _("unnecessary-string-template"),
            description:_("Checks for templates that could be replaced by a string literal"),
            level: "err"
        );
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_template (Vala.Template tmpl, ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (tmpl.get_expressions ().size <= 1) {
            add_mistake ({ this, tmpl.source_reference.begin, tmpl.source_reference.end, MESSAGE }, ref mistake_list);
        }
    }
}
