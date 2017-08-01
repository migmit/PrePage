package page;

import prelude.Maybe;

interface Position<P> {
  public function next(current: P): Maybe<P>;
  public function prev(current: P): Maybe<P>;
  public function isShown(current: P): Bool;
  public function remove(current: P): Void;
}