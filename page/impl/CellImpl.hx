package page.impl;

import prelude.Maybe;

class CellImpl<L, S> implements Cell<L> {
  public var page(default, null): PageImpl<L, S>;
  public var position(default, null): PositionImpl;
  public function new(page: PageImpl<L, S>, position: PositionImpl) {
    this.page = page;
    this.position = position;
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