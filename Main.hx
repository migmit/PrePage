import line.Line;
import prelude.Either;
import prelude.Pair;
import prelude.Unit;
import tag.TextColor;
import text.Action;
import text.Slice;
import text.Text;
import text.TextStyle;
import widget.Arrow;
import widget.Widget;

using prelude.Maybe.MaybeExt;
using prelude.Pair.PairExt;
using tag.Tag.TagExt;

class Main {
  static public function main() {
    /*
    var s = new Slice<String>("xyz   tuv f", TextStyle.dflt, Nothing);
    var t = new Text([s,s]);
    for (i in 1...23) {
      trace(i);
      t.splitWidth(i, Center).map(function(t) trace(">" + t.plain() + "<"));
    }
    */
    /*
    var boldStyle = new TextStyle(true, false, Nothing);
    var italicStyle = new TextStyle(false, true, Nothing);
    var italicLighterStyle = new TextStyle(false, true, Just(new TextColor(1,1,1)));
    var boldItalicStyle = new TextStyle(true, true, Nothing);
    var boldSlice = new Slice<String>("abcdef ghi", boldStyle, Nothing);
    var italicSlice = new Slice<String>("pqr stuxyz", italicStyle, Just(Link("http://google.com")));
    var italicLighterSlice = new Slice<String>("ABCD EFGHI", italicLighterStyle, Nothing);
    var boldItalicSlice = new Slice<String>("PQRST UXYZ", boldItalicStyle, Nothing);
    var tt = new Text([boldSlice, italicSlice, italicLighterSlice, boldItalicSlice]);
    for (i in 5...25) {
      trace(i);
      tt.splitWidth(i, Center).map(function(l) trace(">" + l.render() + "<"));
    }
    */
    var a = Arrow.pure(function(n: Int) return n+1);
    var b = Arrow.impure(function(n: Int) return Just(2*n));
    var c = Arrow.omit();
    trace((a >> b).isDefined());
    trace((a >> c).isDefined());
    trace((b >> c).isDefined());
    trace((a >> b).call(5).getOrElse(-1));
    var testWidget1 =
      Widget.array
      ([Widget.line(PlainLine([new Slice("+", TextStyle.dflt, Just(Signal(Unit)))])),
	Widget.void().chameleon().filterMapIn
	(function(p: Pair<Unit, Int>) return Just(Right(Widget.line(PlainLine([new Slice(Std.string(p.snd() + 1), TextStyle.dflt, Nothing)]))))).state(0).filterMap
	(function(u) return Just(Right(Pair(Just(u), function(n) return n+1))),
	 function(p) return p.fst()
	 )
	]).mirror();
    $type(testWidget1);
  }
}