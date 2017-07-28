package text;

class TextColor {
  var red: Int;
  var green: Int;
  var blue: Int;
  public function new(red: Int, green: Int, blue: Int) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }
  static public var dflt = new TextColor(0,0,0);
}
