package prelude;

enum Either<L, R> {
  Left(value: L);
  Right(value: R);
}

class EitherExt {
  static public function left<L, R>(e: Either<L, R>): Maybe<L> {
    switch(e) {
    case Left(value): return Just(value);
    case Right(_): return Nothing;
    }
  }
  static public function right<L, R>(e: Either<L, R>): Maybe<R> {
    switch(e) {
    case Left(_): return Nothing;
    case Right(value): return Just(value);
    }
  }
  static public function either<L, R, T>(e: Either<L, R>, onLeft: L -> T, onRight: R -> T): T {
    switch(e) {
    case Left(value): return onLeft(value);
    case Right(value): return onRight(value);
    }
  }
  static public function map<L, R, T>(e: Either<L, R>, f: R -> T): Either<L, T> {
    switch(e) {
    case Left(value): return Left(value);
    case Right(value): return Right(f(value));
    }
  }
  static public function flatMap<L, R, T>(e: Either<L, R>, f: R -> Either<L, T>): Either<L, T> {
    switch(e) {
    case Left(value): return Left(value);
    case Right(value): return f(value);
    }
  }
  static public function swap<L, R>(e: Either<L, R>): Either<R, L> {
    switch(e) {
    case Left(value): return Right(value);
    case Right(value): return Left(value);
    }
  }
  static public function assocLeft<L, M, R>(e: Either<L, Either<M, R>>): Either<Either<L, M>, R> {
    switch(e) {
    case Left(value): return Left(Left(value));
    case Right(Left(value)): return Left(Right(value));
    case Right(Right(value)): return Right(value);
    }
  }
  static public function assocRight<L, M, R>(e: Either<Either<L, M>, R>): Either<L, Either<M, R>> {
    switch(e) {
    case Left(Left(value)): return Left(value);
    case Left(Right(value)): return Right(Left(value));
    case Right(value): return Right(Right(value));
    }
  }
}