package prelude;

class StringExt {
  public static function trimRight(s: String) {
    var l = s.length;
    for (i in 0...l) {
      var p = l-i-1;
      if (s.charAt(p) != " ") return s.substring(0,p+1);
    }
    return "";
  }
  public static function trimLeft(s: String) {
    for (i in 0...s.length) {
      if (s.charAt(i) != " ") return s.substring(i);
    }
    return "";
  }
}