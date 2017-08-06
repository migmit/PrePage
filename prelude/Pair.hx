package prelude;

enum Pair<T,U> {
  Pair(fst: T, snd: U);
}

class PairExt {
  static public function fst<T, U>(pair: Pair<T, U>): T {
    switch(pair) {case Pair(fst, _): return fst;}
  }
  static public function snd<T, U>(pair: Pair<T, U>): U {
    switch(pair) {case Pair(_, snd): return snd;}
  }
}