package tag;

class TextColor {
  var red: Int;
  var green: Int;
  var blue: Int;
  public function new(red: Int, green: Int, blue: Int) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }
  public function toHex(): String {
    return makeHex(red) + makeHex(green) + makeHex(blue);
  }
  public function equals(other: TextColor) {
    return red == other.red && green == other.green && blue == other.blue;
  }
  static function makeHex(color: Int): String {
    var firstDigit = hexDigits.charAt(Std.int(color/16));
    var secondDigit = hexDigits.charAt(color % 16);
    return firstDigit + secondDigit;
  }
  static var hexDigits = "0123456789ABCDEF";
  static public var dflt = new TextColor(0,0,0);
}
