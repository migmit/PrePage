package line;

import js.html.Element;
import js.html.Node;

import page.Canvas;
import prelude.Maybe;
import text.Text;
import text.TextStyle;

using StringTools;

using prelude.Maybe.MaybeExt;

class Pre<S> implements Canvas<Line<S>, S> {
  var pre: Element;
  public function new(pre: Element) {
    this.pre = pre;
  }
  public function length(): Int {
    return pre.children.length;
  }
  public function addAfter(line: Line<S>, position: Maybe<Int>, handler: S -> Void): Bool {
    var pos = position.map(function(p) return p+1).getOrElse(0);
    var l = length();
    if (pos < 0 || pos > l) return false;
    var span = pre.ownerDocument.createSpanElement();
    switch(line) {
    case PlainLine(value): addText(span, value, handler);
    case ComplexLine(left, content, contentWidth, right):
      addText(span, left, handler);
      addContent(span, content, contentWidth);
      addText(span, right, handler);
    }
    if (pos == l) pre.appendChild(span) else pre.insertBefore(span, pre.children[pos]);
    return true;
  }
  public function remove(position: Int): Bool {
    if (position < 0 || position >= length()) return false;
    pre.removeChild(pre.children[position]);
    return true;
  }
  function addSimpleText(to: Element, text: String, style: TextStyle) {
    var doc = to.ownerDocument;
    var toAdd: Node = doc.createTextNode(text);
    if (style.italic) {
      var i = doc.createElement("I");
      i.appendChild(toAdd);
      toAdd = i;
    }
    if (style.bold) {
      var b = doc.createElement("B");
      b.appendChild(toAdd);
      toAdd = b;
    }
    switch(style.color) {
    case Just(c):
      var f = doc.createFontElement();
      f.color = "#" + c.toHex();
      f.appendChild(toAdd);
      toAdd = f;
    case Nothing:
    }
    to.appendChild(toAdd);
  }
  function addText(span: Element, text: Text<S>, handler: S -> Void) {
    for (slice in text.value) {
      switch(slice.action) {
      case Nothing: addSimpleText(span, slice.text, slice.style);
      case Just(Link(url)):
	var a = span.ownerDocument.createAnchorElement();
	a.href = url;
	addSimpleText(a, slice.text, slice.style);
	span.appendChild(a);
      case Just(Signal(s)):
	var sp = span.ownerDocument.createSpanElement();
	sp.onclick = function() handler(s);
	addSimpleText(sp, slice.text, slice.style);
	span.appendChild(sp);
      }
    }
  }
  function addContent(span: Element, content: Element, contentWidth: Int) {
    content.style.position = "absolute";
    span.appendChild(content);
    span.appendChild(span.ownerDocument.createTextNode("".rpad(" ", contentWidth)));
  }
}