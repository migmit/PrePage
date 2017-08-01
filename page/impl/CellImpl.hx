package page.impl;

import prelude.Maybe;

class CellImpl<L> extends Cell<L> {
  public var page(default, null): PageImpl<L>;
  public var position(default, null): Position;
  public function new(page: PageImpl<L>, position: Position) {
    this.page = page;
    this.position = position;
    super(next, prev, isShown, remove, addAfter);
  }
  public function next(): Maybe<Cell<L>> {
    return page.next(this);
  }
  public function prev(): Maybe<Cell<L>> {
    return page.prev(this);
  }
  public function isShown(): Bool {
    return page.isShown(this);
  }
  public function remove() {
    page.remove(this);
  }
  public function addAfter(line: L): Maybe<Cell<L>> {
    return page.addAfter(line, Just(this));
  }
}