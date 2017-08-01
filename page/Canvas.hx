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

class ArrayCanvas<L> extends Canvas<L> {
  var value: Array<L>;
  public function length(): Int {
    return value.length;
  }
  public function add(l: L, i: Int): Bool {
    if (i > value.length) return false;
    value.insert(i, l);
    return true;
  }
  public function remove(i: Int): Bool {
    if (i >= value.length) return false;
    value.splice(i, 1);
    return true;
  }
  public function new(value: Array<L>) {
    this.value = value.copy();
    super(length, add, remove);
  }
}