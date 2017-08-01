package page;

import prelude.Maybe;

interface Cell<L> {
  public function next(): Maybe<Cell<L>>;
  public function prev(): Maybe<Cell<L>>;
  public function isShown(): Bool;
  public function remove(): Void;
  public function addAfter(line: L): Maybe<Cell<L>>;
}