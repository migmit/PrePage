package page.impl;

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