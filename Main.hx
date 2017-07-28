using StringTools;

using Main.MaybeExt;
using Main.ArrayExt;
using Main.StringExt;

enum Maybe<T> {
  Just(value: T);
  Nothing;
}

class MaybeExt {
  static public function getOrElse<T>(m: Maybe<T>, other: T): T {
    switch(m) {
    case Just(v): return v;
    case Nothing: return other;
    }
  }
  static public function map<T,U>(m: Maybe<T>, f: T -> U): Maybe<U> {
    switch(m) {
    case Just(v): return Just(f(v));
    case Nothing: return Nothing;
    }
  }
  static public function flatMap<T,U>(m: Maybe<T>, f: T -> Maybe<U>): Maybe<U> {
    return m.map(f).getOrElse(Nothing);
  }
}

class Pair<T,U> {
  public var fst(default, null): T;
  public var snd(default, null): U;
  public function new(fst: T, snd: U) {
    this.fst = fst;
    this.snd = snd;
  }
}

class ArrayExt {
  static public function find<T>(a: Array<T>, p: T -> Bool): Maybe<T> {
    for (i in 0...a.length) {
      var t = a[i];
      if (p(t)) return Just(t);
    }
    return Nothing;
  }
  static public function findLast<T>(a: Array<T>, p: T -> Bool): Maybe<T> {
    var l = a.length;
    for (i in 0...l) {
      var t = a[l-i-1];
      if (p(t)) return Just(t);
    }
    return Nothing;
  }
  static public function foldLeft<T, U>(a: Array<T>, z: U, op: U -> T -> U): U {
    var r = z;
    for (i in 0...a.length) {
      r = op(r, a[i]);
    }
    return r;
  }
}

class StringExt {
  public static function trimRight(s: String) {
    var l = s.length;
    for (i in 0...l) {
      var p = l-i-1;
      if (s.charAt(p) != " ") return s.substring(0,p+1);
    }
    return "";
  }
  public static function trimLeft(s: String) {
    for (i in 0...s.length) {
      if (s.charAt(i) != " ") return s.substring(i);
    }
    return "";
  }
}

enum Alignment {
  Left;
  Center;
  Right;
}

enum Action<S> {
  Link(url: String);
  Signal(data: S);
}

class TextColor {
  var red: Int;
  var green: Int;
  var blue: Int;
  public function new(red: Int, green: Int, blue: Int) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }
  static public var dflt = new TextColor(0,0,0);
}

class TextStyle {
  var bold: Bool;
  var italic: Bool;
  var color: TextColor;
  public function new(bold: Bool, italic: Bool, color: TextColor) {
    this.bold = bold;
    this.italic = italic;
    this.color = color;
  }
  static public var dflt = new TextStyle(false, false, TextColor.dflt);
}

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

class Text<S> {
  var value: Array<Slice<S>>;
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
      if (newP > w) return Just(new Pair(i, w-p));
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
    return findSliceByWidth(w).map(function(sliceIndexAndPos) {
	var sliceIndex = sliceIndexAndPos.fst;
	var pos = sliceIndexAndPos.snd;
	var p = pos;
	var slice = value[sliceIndex];
	for (i in -sliceIndex...1) {
	  switch(slice.spaceSplit(p)) {
	  case Just(splitResult):
	    var head = value.slice(0, -i);
	    head.push(splitResult.fst);
	    var tail = value.slice(-i+1);
	    tail.insert(0, splitResult.snd);
	    return new Pair(new Text(head).trimRight(), Just(new Text(tail).trimLeft()));
	  case Nothing:
	    if (i < 0) {
	      slice = value[-i-1];
	      p = slice.length();
	    }
	  }
	}
	slice = value[sliceIndex];
	var splitResult = slice.split(pos);
	var head = value.slice(0, sliceIndex);
	head.push(splitResult.fst);
	var tail = value.slice(sliceIndex+1);
	tail.insert(0, splitResult.snd);
	return new Pair(new Text(head).trimRight(), Just(new Text(tail).trimLeft()));
      }).getOrElse(new Pair(this, Nothing));
  }
  public function splitWidth(w: Int, alignment: Alignment): Array<Text<S>> {
    var result = [];
    var currentText = this;
    while(true) {
      var swf = currentText.splitWidthFirst(w);
      result.push(swf.fst);
      switch(swf.snd) {
      case Just(rest): currentText = rest;
      case Nothing: return result.map(function(text) return text.pad(w, alignment));
      }
    }
  }
}

class Main {
  static public function main() {
    var s = new Slice<String>("xyz   tuv f", new TextStyle(false, false, new TextColor(0,0,0)), Nothing);
    var t = new Text([s,s]);
    for (i in 1...23) {
      trace(i);
      t.splitWidth(i, Center).map(function(t) trace(">" + t.plain() + "<"));
    }
  }
}