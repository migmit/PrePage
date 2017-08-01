package text;

import prelude.Maybe;
import prelude.Pair;

using StringTools;

using prelude.Array.ArrayExt;
using prelude.Maybe.MaybeExt;

class Text<S> {
  public var value(default, null): Array<Slice<S>>;
  public function new(value: Array<Slice<S>>) {
    this.value = value;
  }
  public function length(): Int {
    return value.foldLeft(0, function(n, s) return n + s.length());
  }
  public function plain(): String {
    return value.foldLeft("", function(r, s) return r + s.text);
  }
  function findSliceByWidth(w: Int): Maybe<Pair<Int,Int>> {
    var p = 0;
    for (i in 0...value.length) {
      var newP = p + value[i].length();
      if (newP > w) return Just(Pair(i, w-p));
      p = newP;
    }
    return Nothing;
  }
  function trimLeft(): Text<S> {
    for (i in 0...value.length) {
      var slice = value[i].trimLeft();
      if (slice.length() > 0) {
	var tail = value.slice(i+1);
	tail.insert(0, slice);
	return new Text(tail);
      }
    }
    return new Text([]);
  }
  function trimRight(): Text<S> {
    for (i in -value.length...0) {
      var slice = value[-i-1].trimRight();
      if (slice.length() > 0) {
	var head = value.slice(0, -i-1);
	head.push(slice);
	return new Text(head);
      }
    }
    return new Text([]);
  }
  function pad(w: Int, alignment: Alignment): Text<S> {
    var l = length();
    if (l < w) {
      var result = value.copy();
      switch(alignment) {
      case Left: result.push(new Slice("".rpad(" ", w-l), TextStyle.dflt, Nothing));
      case Center:
	var lp = Std.int((w-l)/2);
	var rp = w - l - lp;
	result.insert(0, new Slice("".rpad(" ", lp), TextStyle.dflt, Nothing));
	result.push(new Slice("".rpad(" ", rp), TextStyle.dflt, Nothing));
      case Right: result.insert(0, new Slice("".rpad(" ", w-l), TextStyle.dflt, Nothing));
      }
      return new Text(result);
    } else {
      return this;
    }
  }
  function splitWidthFirst(w: Int): Pair<Text<S>, Maybe<Text<S>>> {
    return findSliceByWidth(w).map(function(sliceIndexAndPos) return switch(sliceIndexAndPos) {case Pair(sliceIndex, pos):
	  var p = pos;
	  var slice = value[sliceIndex];
	  for (i in -sliceIndex...1) {
	    switch(slice.spaceSplit(p)) {
	    case Just(Pair(splitHead, splitTail)):
	      var head = value.slice(0, -i);
	      head.push(splitHead);
	      var tail = value.slice(-i+1);
	      tail.insert(0, splitTail);
	      return Pair(new Text(head).trimRight(), Just(new Text(tail).trimLeft()));
	    case Nothing:
	      if (i < 0) {
		slice = value[-i-1];
		p = slice.length();
	      }
	    }
	  }
	  slice = value[sliceIndex];
	  switch(slice.split(pos)) {
	  case Pair(splitHead, splitTail):
	    var head = value.slice(0, sliceIndex);
	    head.push(splitHead);
	    var tail = value.slice(sliceIndex+1);
	    tail.insert(0, splitTail);
	    return Pair(new Text(head).trimRight(), Just(new Text(tail).trimLeft()));
	  }
      }).getOrElse(Pair(this, Nothing));
  }
  public function splitWidth(w: Int, alignment: Alignment): Array<Text<S>> {
    var result = [];
    var currentText = this;
    while(true) {
      switch(currentText.splitWidthFirst(w)) {
      case Pair(firstLine, restLines):
	result.push(firstLine);
	switch(restLines) {
	case Just(rest): currentText = rest;
	case Nothing: return result.map(function(text) return text.pad(w, alignment));
	}
      }
    }
  }
  public function map<T>(f: S -> T): Text<T> {
    return new Text(value.map(function(slice) return slice.map(f)));
  }
  public function render(): String {
    return value.map(function(s) return s.render()).join("");
  }
}
