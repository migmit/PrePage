import tag.TextColor;
import text.Slice;
import text.Text;
import text.TextStyle;

using tag.Tag.TagExt;

class Main {
  static public function main() {
    var s = new Slice<String>("xyz   tuv f", TextStyle.dflt, Nothing);
    var t = new Text([s,s]);
    for (i in 1...23) {
      trace(i);
      t.splitWidth(i, Center).map(function(t) trace(">" + t.plain() + "<"));
    }
    var s1 = new TextStyle(true, false, Nothing);
    var s2 = new TextStyle(false, true, Nothing);
    var s3 = new TextStyle(false, true, Just(new TextColor(1,1,1)));
    var s4 = new TextStyle(true, true, Nothing);
    var p1 = s1.render([]);
    trace(p1.fst);
    var p2 = s2.render(p1.snd);
    trace(p2.fst);
    var p3 = s3.render(p2.snd);
    trace(p3.fst);
    var p4 = s4.render(p3.snd);
    trace(p4.fst);
    var p5 = s2.render(p4.snd);
    trace(p5.fst);
    var tags = p5.snd;
    tags.reverse();
    trace(tags.map(function(tag) return tag.closing()).join(""));
  }
}