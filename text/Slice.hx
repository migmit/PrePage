package text;

import prelude.Maybe;
import prelude.Pair;

using prelude.String.StringExt;

class Slice<S> {
  public var text(default, null): String;
  var style: TextStyle;
  var action: Maybe<Action<S>>;
  public function new(text: String, style: TextStyle, action: Maybe<Action<S>>) {
    this.text = text;
    this.style = style;
    this.action = action;
  }
  public function length(): Int {
    return text.length;
  }
  public function split(index: Int): Pair<Slice<S>, Slice<S>> {
    return new Pair(new Slice(text.substring(0, index).trimRight(), style, action), new Slice(text.substring(index).trimLeft(), style, action));
  }
  public function spaceSplit(lastIndex: Int): Maybe<Pair<Slice<S>, Slice<S>>> {
    var pos = text.lastIndexOf(" ", lastIndex);
    if (pos < 0) return Nothing;
    return Just(new Pair(new Slice(text.substring(0, pos).trimRight(), style, action), new Slice(text.substring(pos+1).trimLeft(), style, action)));
  }
  public function trimLeft(): Slice<S> {
    return new Slice(text.trimLeft(), style, action);
  }
  public function trimRight(): Slice<S> {
    return new Slice(text.trimRight(), style, action);
  }
}
