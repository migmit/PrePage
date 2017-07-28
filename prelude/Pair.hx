package prelude;

class Pair<T,U> {
  public var fst(default, null): T;
  public var snd(default, null): U;
  public function new(fst: T, snd: U) {
    this.fst = fst;
    this.snd = snd;
  }
}
