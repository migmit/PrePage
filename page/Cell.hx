package page;

import prelude.Maybe;

class Cell<L> {
  public var _next(default, null): Void -> Maybe<Cell<L>>;
  public var _prev(default, null): Void -> Maybe<Cell<L>>;
  public var _isShown(default, null): Void -> Bool;
  public var _remove(default, null): Void -> Void;
  public var _addAfter(default, null): L -> Maybe<Cell<L>>;
  public function new
  (next: Void -> Maybe<Cell<L>>,
   prev: Void -> Maybe<Cell<L>>,
   isShown: Void -> Bool,
   remove: Void -> Void,
   addAfter: L -> Maybe<Cell<L>>
   ) {
    this._next = next;
    this._prev = prev;
    this._isShown = isShown;
    this._remove = remove;
    this._addAfter = addAfter;
  }
}