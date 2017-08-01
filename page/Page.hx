package page;

import prelude.Maybe;

class Page<L, S> {
  var _addLine: L -> Maybe<Cell<L>> -> Maybe<Cell<L>>;
  public function new(addLine: L -> Maybe<Cell<L>> -> Maybe<Cell<L>>) {
    this._addLine = addLine;
  }
  static public function attach<L, S>(canvas: Canvas<L, S>, handler: S -> Void): Page<L, S> {
    return new page.impl.PageImpl(canvas, handler);
  }
}