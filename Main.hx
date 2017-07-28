import prelude.Maybe;
import prelude.Pair;

import text.Action;
import text.Alignment;
import text.Slice;
import text.Text;
import text.TextColor;
import text.TextStyle;

using StringTools;

using prelude.Maybe.MaybeExt;
using prelude.Array.ArrayExt;
using prelude.String.StringExt;

class Main {
  static public function main() {
    var s = new Slice<String>("xyz   tuv f", new TextStyle(false, false, new TextColor(0,0,0)), Nothing);
    var t = new Text([s,s]);
    for (i in 1...23) {
      trace(i);
      t.splitWidth(i, Center).map(function(t) trace(">" + t.plain() + "<"));
    }
  }
}