package page;

class Canvas<L> {
  public var _length(default, null): Void -> Int;
  public var _add(default, null): L -> Int -> Bool;
  public var _remove(default, null): Int -> Bool;
  public function new(length: Void -> Int, add: L -> Int -> Bool, remove: Int -> Bool) {
    this._length = length;
    this._add = add;
    this._remove = remove;
  }
}
