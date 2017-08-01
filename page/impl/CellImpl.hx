package page.impl;

import prelude.Maybe;

using prelude.Maybe.MaybeExt;

class CellImpl<L, S, P> implements Cell<L> {
  public var page(default, null): PageImpl<L, S, P>;
  public var position(default, null): P;
  public var isPosition(default, null): Position<P>;
  public function new(page: PageImpl<L, S, P>, position: P, isPosition: Position<P>) {
    this.page = page;
    this.position = position;
    this.isPosition = isPosition;
  }
  public function next(): Maybe<Cell<L>> {
    return isPosition.next(position).map(function(pos) return (new CellImpl(page, pos, isPosition): Cell<L>));
  }
  public function prev(): Maybe<Cell<L>> {
    return isPosition.prev(position).map(function(pos) return (new CellImpl(page, pos, isPosition): Cell<L>));
  }
  public function isShown(): Bool {
    return isPosition.isShown(position);
  }
  public function remove() {
    return isPosition.remove(position);
  }
  public function addAfter(line: L): Maybe<Cell<L>> {
    return page.addAfter(line, Just(this));
  }
}