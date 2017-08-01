package page;

class Canvas<L, S> {
  public var _length(default, null): Void -> Int;
  public var _add(default, null): L -> Int -> (S -> Void) -> Bool;
  public var _remove(default, null): Int -> Bool;
  public function new(length: Void -> Int, add: L -> Int -> (S -> Void) -> Bool, remove: Int -> Bool) {
    this._length = length;
    this._add = add;
    this._remove = remove;
  }
}
