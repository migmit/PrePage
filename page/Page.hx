package page;

import prelude.Maybe;

interface Page<L, S> {
  public function addLine(line: L, after: Maybe<Cell<L>>): Maybe<Cell<L>>;
}

class AttachPage{
  static public function attach<L, S, P>(canvas: Canvas<L, S, P>, handler: S -> Void, isPosition: Position<P>): Page<L, S> {
    return new page.impl.PageImpl(canvas, handler, isPosition);
  }
}
