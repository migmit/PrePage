package text;

enum Action<S> {
  Link(url: String);
  Signal(data: S);
}

class ActionExt {
  static public function map<S, T>(action: Action<S>, f: S -> T): Action<T> {
    switch(action) {
    case Link(url): return Link(url);
    case Signal(s): return Signal(f(s));
    }
  }
}