package widget;
import line.Line;
import prelude.Either;
import prelude.Maybe;
import prelude.Pair;

using line.Line.LineExt;
using prelude.Array.ArrayExt;
using prelude.Either.EitherExt;
using prelude.Maybe.MaybeExt;
using prelude.Pair.PairExt;

abstract Widget<I, O>(Array<WidgetNode<I, O>>) from Array<WidgetNode<I, O>> to Array<WidgetNode<I, O>> {
  static public function void<I, O>(): Widget<I, O> {
    return [];
  }
  static public function array<I, O>(widgets: Array<Widget<I, O>>): Widget<I, O> {
    return widgets.flatten();
  }
  @:op(A >> B)
  public function append<II, OO>(other: Widget<II, OO>): Widget<Either<I, II>, Either<O, OO>> {
    return array
      ([
	filterMap(function(e: Either<I, II>) return e.left(), function(i) return Just(Left(i))),
	other.filterMap(function(e: Either<I, II>) return e.right(), function(ii) return Just(Right(ii)))
	]);
  }
  static public function line<I, O>(l: Line<O>): Widget<I, O> {
    return [(new LineWidget(l.map(MaybeExt.just)): WidgetNode<I, O>)];
  }
  static public function async<I, O>(call: I -> (O -> Void) -> Void) {
    return [(new AsyncWidget(call): WidgetNode<I, O>)];
  }
  public function filterMap<II, OO>(input: II -> Maybe<I>, output: O -> Maybe<OO>): Widget<II, OO> {
    return filterMapIn(input).filterMapOut(output);
  }
  public function chameleon(): Widget<Either<I, Widget<I, O>>, O> {
    return [(new Chameleon(this, MaybeExt.just): WidgetNode<Either<I, Widget<I, O>>, O>)];
  }
  static public function state<I, S, O>
  (widget: Widget<Pair<I, S>, O>,
   initial: S
   ): Widget<Either<I, Pair<Maybe<I>, S -> S>>, Pair<O, S>> {
    var result: State<Either<I, Pair<Maybe<I>, S -> S>>, I, S, O, Pair<O, S>> = new State
      (initial,
       widget,
       function(s: S, e: Either<I, Pair<Maybe<I>, S -> S>>)
       return e.either(MaybeExt.just, function(p) return p.fst()),
       function(s, e) return e.right().map(function(p) return p.snd()(s)),
       function(s, o) return Just(Pair(o, s))
       );
    return [(result: WidgetNode<Either<I, Pair<Maybe<I>, S -> S>>, Pair<O, S>>)];
  }
  static public function mirror<L>(widget: Widget<L, L>): Widget<L, L> {
    return [(new Mirror(widget, MaybeExt.just, MaybeExt.just): WidgetNode<L, L>)];
  }
  public function filterMapIn<II>(f: II -> Maybe<I>): Widget<II, O> {
    return this.map(function(n) return n.filterMapIn(f));
  }
  public function filterMapOut<OO>(f: O -> Maybe<OO>): Widget<I, OO> {
    return this.map(function(n) return n.filterMapOut(f));
  }
}

class WidgetExt {
  static public function state<I, S, O>
  (widget: Widget<Pair<I, S>, O>,
   initial: S
   ): Widget<Either<I, Pair<Maybe<I>, S -> S>>, Pair<O, S>> {
    return Widget.state(widget, initial);
  }
  static public function mirror<L>(widget: Widget<L, L>): Widget<L, L> {
    return Widget.mirror(widget);
  }
}

private interface WidgetNode<I, O> {
  public function filterMapIn<II>(f: II -> Maybe<I>): WidgetNode<II, O>;
  public function filterMapOut<OO>(f: O -> Maybe<OO>): WidgetNode<I, OO>;
}

private class LineWidget<I, O> implements WidgetNode<I, O> {
  var line: Line<Maybe<O>>;
  public function new(line: Line<Maybe<O>>) {
    this.line = line;
  }
  public function filterMapIn<II>(f: II -> Maybe<I>): WidgetNode<II, O> {
    return new LineWidget(line);
  }
  public function filterMapOut<OO>(f: O -> Maybe<OO>): WidgetNode<I, OO> {
    return new LineWidget(line.map(function(o) return o.flatMap(f)));
  }
}

private class AsyncWidget<I, O> implements WidgetNode<I, O> {
  var call: I -> (O -> Void) -> Void;
  public function new(call: I -> (O -> Void) -> Void) {
    this.call = call;
  }
  public function filterMapIn<II>(f: II -> Maybe<I>): WidgetNode<II, O> {
    return new AsyncWidget(function(ii, ov) f(ii).map(function(i) return call(i, ov)));
  }
  public function filterMapOut<OO>(f: O -> Maybe<OO>): WidgetNode<I, OO> {
    return new AsyncWidget(function(i, oov) call(i, function(o) f(o).map(oov)));
  }
}

private class Chameleon<I, II, O> implements WidgetNode<I, O> {
  var children: Array<WidgetNode<II, O>>;
  var input: I -> Maybe<Either<II, Widget<II, O>>>;
  public function new(widget: Widget<II, O>, input: I -> Maybe<Either<II, Widget<II, O>>>) {
    this.children = widget;
    this.input = input;
  }
  public function filterMapIn<III>(f: III -> Maybe<I>): WidgetNode<III, O> {
    return new Chameleon(children, function(iii) return f(iii).flatMap(input));
  }
  public function filterMapOut<OO>(f: O -> Maybe<OO>): WidgetNode<I, OO> {
    return new Chameleon
      (
       children.map(function(n) return n.filterMapOut(f)),
       function(i) return input(i).map(function(e) return e.map(function(w) return w.filterMapOut(f)))
       );
  }
}

private class State<I, II, S, OO, O> implements WidgetNode<I, O> {
  var initial: S;
  var children: Array<WidgetNode<Pair<II, S>, OO>>;
  var input: S -> I -> Maybe<II>;
  var put: S -> I -> Maybe<S>;
  var output: S -> OO -> Maybe<O>;
  public function new
  (initial: S,
   widget: Widget<Pair<II, S>, OO>,
   input: S -> I -> Maybe<II>,
   put: S -> I -> Maybe<S>,
   output: S -> OO -> Maybe<O>) {
    this.initial = initial;
    this.children = widget;
    this.input = input;
    this.put = put;
    this.output = output;
  }
  public function filterMapIn<III>(f: III -> Maybe<I>): WidgetNode<III, O> {
    return new State(initial, children, function(s, iii) return f(iii).flatMap(input.bind(s, _)), function(s, iii) return f(iii).flatMap(put.bind(s, _)), output);
  }
  public function filterMapOut<OOO>(f: O -> Maybe<OOO>): WidgetNode<I, OOO> {
    return new State(initial, children, input, put, function(s, oo) return output(s, oo).flatMap(f));
  }
}

private class Mirror<I, L, O> implements WidgetNode<I, O> {
  var children: Array<WidgetNode<L, L>>;
  var input: I -> Maybe<L>;
  var output: L -> Maybe<O>;
  public function new(widget: Widget<L, L>, input: I -> Maybe<L>, output: L -> Maybe<O>) {
    this.children = widget;
    this.input = input;
    this.output = output;
  }
  public function filterMapIn<II>(f: II -> Maybe<I>): WidgetNode<II, O> {
    return new Mirror(children, function(ii) return f(ii).flatMap(input), output);
  }
  public function filterMapOut<OO>(f: O -> Maybe<OO>): WidgetNode<I, OO> {
    return new Mirror(children, input, function(l) return output(l).flatMap(f));
  }
}