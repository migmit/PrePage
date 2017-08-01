package page;

import prelude.Maybe;

interface Canvas<L, S, P> {
  public function getPosition(n: Int): Maybe<P>;
  public function addAfter(line: L, position: Maybe<P>, handler: S -> Void): Maybe<P>;
}
