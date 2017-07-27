using Main.MaybeExt;

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
}

class Text<S> {
  var value: Array<Slice<S>>;
  public function new(value: Array<Slice<S>>) {
    this.value = value;
  }
}

class Main {
  static public function main() {
    var a = Just("abc");
    var b = Nothing;
    var s = new Slice<String>("xyz", new TextStyle(false, false, new TextColor(0,0,0)), Nothing);
    var t = new Text([s]);
    trace(a.getOrElse("Test"));
    trace(b.getOrElse("Test"));
    trace(a.map(function(s) return s.length).getOrElse(-1));
    trace(t);
  }
}