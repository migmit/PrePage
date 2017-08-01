package page.impl;

import prelude.Maybe;

using prelude.Maybe.MaybeExt;

class PageImpl<L> extends Page<L> {
  var canvas: Canvas<L>;
  var firstPosition: Maybe<Position>;
  public function new(canvas: Canvas<L>) {
    this.canvas = canvas;
    this.firstPosition = Nothing;
    super(addLine);
  }
  public function addLine(line: L, after: Maybe<Cell<L>>): Maybe<Cell<L>> {
    return after.map(function(cell) return cell._addAfter(line)).getOrElse(addAfter(line, Nothing));
  }
  public function addAfter(line: L, after: Maybe<CellImpl<L>>): Maybe<Cell<L>> {
    var index = after.map(function(cell) return cell.position.position + 1).getOrElse(0);
    if (canvas._add(line, index)) {
      var next = after.map(function(cell) return cell.position.next).getOrElse(firstPosition);
      var pos: Position = {
      position: index,
      next: next,
      prev: after.map(function(cell) return cell.position)
      };
      next.map(function(n) n.prev = Just(pos));
      pos.prev.map(function(p) p.next = Just(pos));
      if (!pos.prev.isDefined()) firstPosition = Just(pos);
      while(true) {
	switch(next) {
	case Just(n):
	  n.position++;
	  next = n.next;
	case Nothing: break;
	}
      }
      return Just((new CellImpl(this, pos): Cell<L>));
    } else {
      return Nothing;
    }
  }
  public function next(cell: CellImpl<L>): Maybe<Cell<L>> {
    if (cell.page != this) return Nothing;
    var curr = cell.position;
    if (curr.position < 0) return Nothing;
    return curr.next.map(function(n) return (new CellImpl(this, n): Cell<L>));
  }
  public function prev(cell: CellImpl<L>): Maybe<Cell<L>> {
    if (cell.page != this) return Nothing;
    var curr = cell.position;
    if (curr.position < 0) return Nothing;
    return curr.prev.map(function(p) return (new CellImpl(this, p): Cell<L>));
  }
  public function isShown(cell: CellImpl<L>): Bool {
    return cell.position.position >= 0;
  }
  public function remove(cell: CellImpl<L>) {
    var pos = cell.position.position;
    if (pos >= 0 && pos < canvas._length()) {
      canvas._remove(pos);
      cell.position.position = -1;
      var next = cell.position.next;
      var prev = cell.position.prev;
      next.map(function(n) n.prev = prev);
      prev.map(function(p) p.next = next);
      while(true) {
	switch(next) {
	case Just(n):
	  n.position--;
	  next = n.next;
	case Nothing: break;
	}
      }
    }
  }
}