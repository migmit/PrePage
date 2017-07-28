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
  function findCommon(open: Array<Tag>): Int {
    for (i in 0...open.length) {
      switch(open[i]) {
      case Bold if (!bold): return i;
      case Italic if (!italic): return i;
      case Color(c) if (!hasColor(c)): return i;
      case _:
      }
    }
    return open.length;
  }
  public function render(open: Array<Tag>): Pair<String, Array<Tag>> {
    var firstWrong = findCommon(open);
    var toClose = open.slice(firstWrong);
    toClose.reverse();
    var closingTags = toClose.map(function(tag) return tag.closing()).join("");
    var stillOpen = open.slice(0, firstWrong);
    var newOpen = [];
    if (bold && stillOpen.indexOf(Bold) < 0) newOpen.push(Bold);
    if (italic && stillOpen.indexOf(Italic) < 0) newOpen.push(Italic);
    var oldColor = stillOpen.find(function(tag) {switch(tag) {case Color(_): return true; case _: return false;}});
    switch(color) {
    case Just(c) if (!oldColor.isDefined()): newOpen.push(Color(c));
    case _:
    }
    var openingTags = newOpen.map(function(tag) return tag.opening()).join("");
    return new Pair(closingTags + openingTags, stillOpen.concat(newOpen));
  }
  static public var dflt = new TextStyle(false, false, Nothing);
}
