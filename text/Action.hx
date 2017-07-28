package text;

enum Action<S> {
  Link(url: String);
  Signal(data: S);
}
