package page.impl;

import prelude.Maybe;

typedef Position = {
 position: Int,
 next: Maybe<Position>,
 prev: Maybe<Position>
}