package page.impl;

import prelude.Maybe;

using prelude.Maybe.MaybeExt;

class PageImpl<L, S, P> implements Page<L, S> {
  var canvas: Canvas<L, S, P>;
  var handler: S -> Void;
  var isPosition: Position<P>;
  public function new(canvas: Canvas<L, S, P>, handler: S -> Void, isPosition: Position<P>) {
    this.canvas = canvas;
    this.handler = handler;
    this.isPosition = isPosition;
  }
  public function addLine(line: L, after: Maybe<Cell<L>>): Maybe<Cell<L>> {
    return after.map(function(cell) return cell.addAfter(line)).getOrElse(addAfter(line, Nothing));
  }
  public function addAfter(line: L, after: Maybe<CellImpl<L, S, P>>): Maybe<Cell<L>> {
    return canvas.addAfter(line, after.map(function(cell) return cell.position), handler).map
      (function(newPos) return (new CellImpl(this, newPos, isPosition): Cell<L>));
  }
}