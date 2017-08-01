package page.impl;

import prelude.Maybe;

using prelude.Maybe.MaybeExt;

class ArrayCanvas<L, S> implements Canvas<L, S> {
  var value: Array<L>;
  public function length(): Int {
    return value.length;
  }
  public function addAfter(l: L, i: Maybe<Int>, h: S -> Void): Bool {
    var index = i.map(function(n) return n+1).getOrElse(0);
    if (index > value.length) return false;
    value.insert(index, l);
    return true;
  }
  public function remove(i: Int): Bool {
    if (i >= value.length) return false;
    value.splice(i, 1);
    return true;
  }
  public function new(value: Array<L>) {
    this.value = value.copy();
  }
}