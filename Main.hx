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

class Main {
  static public function main() {
    var a = Just("abc");
    var b = Nothing;
    trace(a.getOrElse("Test"));
    trace(b.getOrElse("Test"));
    trace(a.map(function(s) return s.length).getOrElse(-1));
  }
}