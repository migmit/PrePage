package text;

import prelude.Maybe;
import prelude.Pair;
import tag.Tag;
import tag.TextColor;

using prelude.Array.ArrayExt;
using prelude.Maybe.MaybeExt;
using tag.Tag.TagExt;

class TextStyle {
  var bold: Bool;
  var italic: Bool;
  var color: Maybe<TextColor>;
  public function new(bold: Bool, italic: Bool, color: Maybe<TextColor>) {
    this.bold = bold;
    this.italic = italic;
    this.color = color;
  }
  function hasColor(c: TextColor): Bool {
    switch(color) {
    case Just(clr): return clr.equals(c);
    case Nothing: return false;
    }
  }
  public function toTags(): Array<Tag> {
    var result = [];
    if (bold) result.push(Bold);
    if (italic) result.push(Italic);
    switch(color) {
    case Just(c): result.push(Color(c));
    case Nothing:
    }
    return result;
  }
  static public var dflt = new TextStyle(false, false, Nothing);
}
