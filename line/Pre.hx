package line;

import js.html.Element;
import js.html.Node;

import page.Canvas;
import page.Page;
import prelude.Maybe;
import text.Text;
import text.TextStyle;

using StringTools;

using prelude.Maybe.MaybeExt;

class Pre<S> implements Canvas<Line<S>, S, Element> {
  var pre: Element;
  public function new(pre: Element) {
    this.pre = pre;
  }
  public function getPosition(n: Int): Maybe<Element> {
    var children = pre.children;
    if (n < 0 || n >= children.length) return Nothing;
    return Just(children[n]);
  }
  public function addAfter(line: Line<S>, position: Maybe<Element>, handler: S -> Void): Maybe<Element> {
    var span = pre.ownerDocument.createSpanElement();
    switch(line) {
    case PlainLine(value): addText(span, value, handler);
    case ComplexLine(left, content, contentWidth, right):
      addText(span, left, handler);
      addContent(span, content, contentWidth);
      addText(span, right, handler);
    }
    switch(position) {
    case Just(line):
      var nextLine = line.nextSibling;
      if (nextLine == null) pre.appendChild(span) else pre.insertBefore(span, nextLine);
    case Nothing: pre.insertBefore(span, pre.children[0]);
    }
    return Just((span: Element));
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
  static public function attach<S>(pre: Element, handler: S -> Void): Page<Line<S>, S> {
    return page.Page.AttachPage.attach(new Pre(pre), handler, ElementPos.isPosition);
  }
}