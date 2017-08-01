package page;

import prelude.Maybe;

interface Canvas<L, S> {
  public function length(): Int;
  public function addAfter(line: L, position: Maybe<Int>, handler: S -> Void): Bool;
  public function remove(line: Int): Bool;
}
