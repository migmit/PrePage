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
}

class Slice<S> {
  var text: String;
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
}

class Text<S> {
  var value: Array<Slice<S>>;
  public function new(value: Array<Slice<S>>) {
    this.value = value;
  }
  public function length(): Int {
    return value.foldLeft(0, function(n, s) return n + s.length());
  }
}

class Main {
  static public function main() {
    var a = Just("abc");
    var b = Nothing;
    var s = new Slice<String>("xyz   tuv f", new TextStyle(false, false, new TextColor(0,0,0)), Nothing);
    var t = new Text([s,s]);
    trace(a.getOrElse("Test"));
    trace(b.getOrElse("Test"));
    trace(a.map(function(s) return s.length).getOrElse(-1));
    trace(t);
    trace([0,1,2,3,4].find(function(n) return n % 3 == 0).getOrElse(-1));
    trace([0,1,2,3,4].findLast(function(n) return n % 3 == 0).getOrElse(-1));
    trace(s.spaceSplit(2));
    trace(s.spaceSplit(4));
    trace(s.spaceSplit(9));
    trace(s.split(8));
    trace(t.length());
  }
}