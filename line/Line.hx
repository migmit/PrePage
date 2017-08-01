package line;

import js.html.Element;

import text.Text;

enum Line<S> {
  PlainLine(value: Text<S>);
  ComplexLine(left: Text<S>, content: Element, contentWidth: Int, right: Text<S>);
}