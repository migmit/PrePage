package page.impl;

import prelude.Maybe;

typedef PositionImpl = {
 position: Int,
 next: Maybe<PositionImpl>,
 prev: Maybe<PositionImpl>
}