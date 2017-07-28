package text;

class TextStyle {
  var bold: Bool;
  var italic: Bool;
  var color: TextColor;
  public function new(bold: Bool, italic: Bool, color: TextColor) {
    this.bold = bold;
    this.italic = italic;
    this.color = color;
  }
  static public var dflt = new TextStyle(false, false, TextColor.dflt);
}
