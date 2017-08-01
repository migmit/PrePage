package page;

import prelude.Maybe;

class Page<L> {
  var _addLine: L -> Maybe<Cell<L>> -> Maybe<Cell<L>>;
  public function new(addLine: L -> Maybe<Cell<L>> -> Maybe<Cell<L>>) {
    this._addLine = addLine;
  }
  public function attach<L>(canvas: Canvas<L>): Page<L> {
    return new page.impl.PageImpl(canvas);
  }
}