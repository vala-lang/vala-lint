/* vlint-linter.vala
 *
 * Copyright 2019 Daniel Espinosa <esodan@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

 public class Vlint.Linter : GLib.Object {
     private GLib.ListStore _mistakes;
     public GLib.ListModel mistakes { get { return _mistakes; } }

     construct {
         _mistakes = new GLib.ListStore (typeof (Vlint.Mistake));
     }

     public void
     check_file (GLib.File file) throws GLib.Error
     {
        _mistakes = new GLib.ListStore (typeof (Vlint.Mistake));
        var l = new ValaLint.Linter ();
        l.disable_mistakes = false;
        var m = l.run_checks_for_file (file);
        foreach (ValaLint.FormatMistake fm in m) {
                Vlint.Mistake mt = new Vlint.Mistake ();
                mt.message = fm.mistake;
                Vlint.Position start = new Vlint.Position.from_values (fm.begin.line - 1, fm.begin.column - 1);
                Vlint.Position end = new Vlint.Position.from_values (fm.end.line - 1, fm.end.column - 1);
                mt.start = start;
                mt.end = end;
                mt.uri = file.get_uri ();
                _mistakes.append (mt);
        }
     }

     public void
     check_text (string content, string uri) throws GLib.Error
     {
        _mistakes = new GLib.ListStore (typeof (Vlint.Mistake));
        var l = new ValaLint.Linter ();
        l.disable_mistakes = false;
        var m = l.run_checks_for_content (content, uri);
        foreach (ValaLint.FormatMistake fm in m) {
                Vlint.Mistake mt = new Vlint.Mistake ();
                mt.message = fm.mistake;
                Vlint.Position start = new Vlint.Position.from_values (fm.begin.line - 1, fm.begin.column - 1);
                Vlint.Position end = new Vlint.Position.from_values (fm.end.line - 1, fm.end.column - 1);
                mt.start = start;
                mt.end = end;
                mt.uri = uri;
                _mistakes.append (mt);
        }
     }

 }

 public class Vlint.Mistake : GLib.Object {
     public Vlint.Position start { get; set; }
     public Vlint.Position end { get; set; }
     public string uri { get; set; }
     public string message { get; set; }

     public Mistake.from_values (string uri,
                                int start_line,
                                int start_char,
                                int end_line,
                                int end_char)
    {
        start = new Vlint.Position.from_values (start_line, start_char);
        end = new Vlint.Position.from_values (end_line, end_char);
        this.uri = uri;
    }
 }

 public class Vlint.Position : GLib.Object {
     public int line { get; set; }
     public int character { get; set; }

     public Position.from_values (int line, int charater) {
         this.line = line;
         this.character = character;
     }
 }