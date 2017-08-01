package line;

import js.html.Element;

import page.Position;
import prelude.Maybe;

class ElementPos implements Position<Element> {
  function new() {}
  public function next(current: Element): Maybe<Element> {
    var result = current.nextElementSibling;
    if (result == null) return Nothing;
    return Just(result);
  }
  public function prev(current: Element): Maybe<Element> {
    var result = current.previousElementSibling;
    if (result == null) return Nothing;
    return Just(result);
  }
  public function isShown(current: Element): Bool {
    return current.ownerDocument != null;
  }
  public function remove(current: Element) {
    var parent = current.parentElement;
    if (parent != null) parent.removeChild(current);
  }
  static public var isPosition(default, null) = new ElementPos();
}