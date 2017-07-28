package tag;

enum Tag {
  Bold;
  Italic;
  Color(c: TextColor);
}

class TagExt {
  static public function opening(tag: Tag): String {
    switch(tag) {
    case Bold: return "<b>";
    case Italic: return "<i>";
    case Color(c): return "<font color=\"#" + c.toHex() + "\">";
    }
  }
  static public function closing(tag: Tag): String {
    switch(tag) {
    case Bold: return "</b>";
    case Italic: return "</i>";
    case Color(_): return "</font>";
    }
  }
}