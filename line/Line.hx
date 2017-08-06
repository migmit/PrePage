package line;

import js.html.Element;

import text.Text;

enum Line<S> {
  PlainLine(value: Text<S>);
  ComplexLine(left: Text<S>, content: Element, contentWidth: Int, right: Text<S>);
}

class LineExt {
  static public function map<S, T>(line: Line<S>, f: S -> T): Line<T> {
    switch(line) {
    case PlainLine(value): return PlainLine(value.map(f));
    case ComplexLine(left, content, contentWidth, right): return ComplexLine(left.map(f), content, contentWidth, right.map(f));
    }
  }
}