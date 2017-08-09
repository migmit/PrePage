package widget;
import prelude.Maybe;
import prelude.Pair;

using prelude.Maybe.MaybeExt;

abstract Arrow<I, O>(Maybe<I -> Maybe<O>>) from (Maybe<I -> Maybe<O>>) {
  inline function content(): Maybe<I -> Maybe<O>> {
    return this;
  }
  @:op(A >> B)
  inline public function andThen<OO>(other: Arrow<O, OO>): Arrow<I, OO> {
    return this.flatMap
      (function(io) return other.content().map
       (function(ooo) return function(i) return io(i).flatMap(ooo))
       );
  }
  inline static public function omit<I, O>(): Arrow<I, O> {
    return Nothing;
  }
  inline static public function pure<I, O>(f: I -> O): Arrow<I, O> {
    return Just(function(i) return Just(f(i)));
  }
  inline static public function impure<I, O>(f: I -> Maybe<O>): Arrow<I, O> {
    return Just(f);
  }
  inline static public function id<I>(): Arrow<I, I> {
    return pure(function(i) return i);
  }
  inline public function left<S>(): Arrow<Pair<I, S>, Pair<O, S>> {
    return this.map
      (function(io) return function(is) switch(is) {
      case Pair(i, s): return io(i).map(function(o) return Pair(o, s));
      });
  }
  inline public function right<S>(): Arrow<Pair<S, I>, Pair<S, O>> {
    return this.map
      (function(io) return function(si) switch(si) {
      case Pair(s, i): return io(i).map(function(o) return Pair(s, o));
      });
  }
  inline public function call(i: I): Maybe<O> {
    return this.flatMap(function(io) return io(i));
  }
  inline public function isDefined(): Bool {
    return this.isDefined();
  }
}