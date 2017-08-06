package prelude;

using prelude.Array.ArrayExt;

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
  static public function flatMap<T, U>(a: Array<T>, f: T -> Array<U>): Array<U> {
    return a.foldLeft([], function(acc: Array<U>, elt: T) return acc.concat(f(elt)));
  }
  static public function flatten<T>(a: Array<Array<T>>): Array<T> {
    return a.foldLeft([], function(acc: Array<T>, elt: Array<T>) return acc.concat(elt));
  }
  static public function pushI<T>(a: Array<T>, t: T): Array<T> {
    var copy = a.copy();
    copy.push(t);
    return copy;
  }
}