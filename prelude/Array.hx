package prelude;

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