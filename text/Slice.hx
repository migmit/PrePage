package text;

import prelude.Maybe;
import prelude.Pair;

using prelude.Maybe.MaybeExt;
using prelude.String.StringExt;
using tag.Tag.TagExt;
using text.Action.ActionExt;

class Slice<S> {
  public var text(default, null): String;
  public var style(default, null): TextStyle;
  public var action(default, null): Maybe<Action<S>>;
  public function new(text: String, style: TextStyle, action: Maybe<Action<S>>) {
    this.text = text;
    this.style = style;
    this.action = action;
  }
  public function length(): Int {
    return text.length;
  }
  public function split(index: Int): Pair<Slice<S>, Slice<S>> {
    return Pair(new Slice(text.substring(0, index).trimRight(), style, action), new Slice(text.substring(index).trimLeft(), style, action));
  }
  public function spaceSplit(lastIndex: Int): Maybe<Pair<Slice<S>, Slice<S>>> {
    var pos = text.lastIndexOf(" ", lastIndex);
    if (pos < 0) return Nothing;
    return Just(Pair(new Slice(text.substring(0, pos).trimRight(), style, action), new Slice(text.substring(pos+1).trimLeft(), style, action)));
  }
  public function trimLeft(): Slice<S> {
    return new Slice(text.trimLeft(), style, action);
  }
  public function trimRight(): Slice<S> {
    return new Slice(text.trimRight(), style, action);
  }
  public function map<T>(f: S -> T): Slice<T> {
    return new Slice(text, style, action.map(function(a) return a.map(f)));
  }
  public function render(): String{
    var styleTags = style.toTags();
    var reverseStyleTags = styleTags.copy();
    reverseStyleTags.reverse();
    var linkPrefix = switch(action) {
    case Just(Link(url)): "<a href=\"" + url + "\">";
    case Just(Signal(_)): "<a>";
    case Nothing: "";
    }
    var linkSuffix = switch(action) {
    case Just(_): "</a>";
    case Nothing: "";
    }
    return linkPrefix + styleTags.map(function(tag) return tag.opening()).join("") + text + reverseStyleTags.map(function(tag) return tag.closing()).join("") + linkSuffix;
  }
}
