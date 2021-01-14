type stream<'a, 'b>
module type StreamTypes = {
  type ok
  type error
}

/* Very similar to stream operators */
/* Except not included: imitate, startWith, remember */
module Operators = {
  @bs.send external map: (stream<'a, 'b>, 'a => 'c) => stream<'c, 'b> = "map"
  @bs.send
  external mapToValue: (stream<'a, 'b>, 'c) => stream<'c, 'b> = "mapTo"
  @bs.send
  external filter: (stream<'a, 'b>, 'a => bool) => stream<'a, 'b> = "filter"
  @bs.send external take: (stream<'a, 'b>, int) => stream<'a, 'b> = "take"
  @bs.send external drop: (stream<'a, 'b>, int) => stream<'a, 'b> = "drop"
  @bs.send external last: (stream<'a, 'b>, unit) => stream<'a, 'b> = "last"
  @bs.send
  external endWhen: (stream<'a, 'b>, stream<'c, 'd>) => stream<'a, 'b> =
    "endWhen"
  @bs.send
  external replaceError: (
    stream<'a, 'b>,
    'b => stream<'c, 'd>,
  ) => stream<'c, 'd> = "replaceError"
  @bs.send
  external flatten: (stream<stream<'a, 'b>, 'c>, unit) => stream<'a, 'b> =
    "flatten"
  @bs.send
  external compose: (
    stream<'a, 'b>,
    @bs.this (stream<'a, 'b> => stream<'c, 'd>),
  ) => stream<'c, 'd> = "compose"

  @bs.send
  external fold: (stream<'a, 'b>, ('c, 'a) => 'c, 'c) => stream<'c, 'b> = "fold"

  /* Map combined streams */
  @bs.send
  external map2: (
    (stream<'a, 'b>, stream<'e, 'f>),
    (('a, 'c)) => 'concat,
  ) => stream<'concat, 'b> = "map"
  @bs.send
  external map3: (
    (stream<'a, 'b>, stream<'c, 'd>, stream<'e, 'f>),
    (('a, 'c, 'e)) => 'concat,
  ) => stream<'concat, 'b> = "map"
  @bs.send
  external map4: (
    (stream<'a, 'b>, stream<'c, 'd>, stream<'e, 'f>, stream<'g, 'h>),
    (('a, 'c, 'e, 'g)) => 'concat,
  ) => stream<'concat, 'b> = "map"
  @bs.send
  external map5: (
    (
      stream<'a, 'b>,
      stream<'c, 'd>,
      stream<'e, 'f>,
      stream<'g, 'h>,
      stream<'i, 'j>,
    ),
    (('a, 'c, 'e, 'g, 'i)) => 'concat,
  ) => stream<'concat, 'b> = "map"
  @bs.send
  external map6: (
    (
      stream<'a, 'b>,
      stream<'c, 'd>,
      stream<'e, 'f>,
      stream<'g, 'h>,
      stream<'i, 'j>,
      stream<'k, 'l>,
    ),
    (('a, 'c, 'e, 'g, 'i, 'k)) => 'concat,
  ) => stream<'concat, 'b> = "map"
  @bs.send
  external map7: (
    (
      stream<'a, 'b>,
      stream<'c, 'd>,
      stream<'e, 'f>,
      stream<'g, 'h>,
      stream<'i, 'j>,
      stream<'k, 'l>,
      stream<'m, 'n>,
    ),
    (('a, 'c, 'e, 'g, 'i, 'k, 'm)) => 'concat,
  ) => stream<'concat, 'b> = "map"
  @bs.send
  external map8: (
    (
      stream<'a, 'b>,
      stream<'c, 'd>,
      stream<'e, 'f>,
      stream<'g, 'h>,
      stream<'i, 'j>,
      stream<'k, 'l>,
      stream<'m, 'n>,
      stream<'o, 'p>,
    ),
    (('a, 'c, 'e, 'g, 'i, 'k, 'm, 'o)) => 'concat,
  ) => stream<'concat, 'b> = "map"
  @bs.send
  external map9: (
    (
      stream<'a, 'b>,
      stream<'c, 'd>,
      stream<'e, 'f>,
      stream<'g, 'h>,
      stream<'i, 'j>,
      stream<'k, 'l>,
      stream<'m, 'n>,
      stream<'o, 'p>,
      stream<'q, 'r>,
    ),
    (('a, 'c, 'e, 'g, 'i, 'k, 'm, 'o, 'q)) => 'concat,
  ) => stream<'concat, 'b> = "map"
  @bs.send
  external map10: (
    (
      stream<'a, 'b>,
      stream<'c, 'd>,
      stream<'e, 'f>,
      stream<'g, 'h>,
      stream<'i, 'j>,
      stream<'k, 'l>,
      stream<'m, 'n>,
      stream<'o, 'p>,
      stream<'q, 'r>,
      stream<'s, 't>,
    ),
    (('a, 'c, 'e, 'g, 'i, 'k, 'm, 'o, 'q, 's)) => 'concat,
  ) => stream<'concat, 'b> = "map"

  /* Debug */
  @bs.send
  external debug: (stream<'a, 'b>, ~spy: 'a => _=?, unit) => stream<'a, 'b> =
    "debug"
  @bs.send
  external debugWithSpyName: (stream<'a, 'b>, string) => stream<'a, 'b> =
    "debugWithSpyName"

  /* Extra */
  @bs.module("xstream/extra/dropRepeats")
  external dropRepeats: (
    ~comparator: ('a, 'a) => bool=?,
    unit,
  ) => @bs.this (stream<'a, 'b> => stream<'c, 'd>) = "default"
}

/* Create a MemoryStream module */
/* Factories and remembering methods not included */
module Make_memory_stream = (Type: StreamTypes) => {
  type ok = Type.ok
  type error = Type.error
  type t = stream<ok, error>

  include Operators

  type internal_listener = {
    _n: Type.ok => unit,
    _e: Type.error => unit,
    _c: unit => unit,
  }

  type listener = {
    next: Type.ok => unit,
    error: Type.error => unit,
    complete: unit => unit,
  }

  type producer = {
    start: listener => unit,
    stop: unit => unit,
  }

  type observable<'a> = {.."subscribe": Type.ok => unit} as 'a

  /* Limitation for merge, as all streams must be of same type */
  /* Use combine for a more polymorphic concatenation */
  @bs.module("xstream") @bs.scope("Stream") @bs.splice
  external merge: array<stream<'a, 'b>> => stream<'a, 'b> = "merge"

  /* combine */
  @bs.module("xstream") @bs.scope("Stream")
  external combine0: unit => t = "combine"
  @bs.module("xstream") @bs.scope("Stream")
  external combine1: t => t = "combine"
  @bs.module("xstream") @bs.scope("Stream")
  external combine2: (t, stream<'a, 'b>) => (t, stream<'a, 'b>) = "combine"
  @bs.module("xstream") @bs.scope("Stream")
  external combine3: (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
  ) => (t, stream<'a, 'b>, stream<'e, 'f>) = "combine"
  external combine4: (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
  ) => (t, stream<'a, 'b>, stream<'e, 'f>, stream<'e, 'f>) = "combine"
  external combine5: (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
  ) => (t, stream<'a, 'b>, stream<'e, 'f>, stream<'e, 'f>, stream<'g, 'h>) =
    "combine"
  external combine6: (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
  ) => (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
  ) = "combine"
  external combine7: (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
    stream<'k, 'l>,
  ) => (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
    stream<'k, 'l>,
  ) = "combine"
  external combine8: (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
    stream<'k, 'l>,
    stream<'m, 'n>,
  ) => (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
    stream<'k, 'l>,
    stream<'m, 'n>,
  ) = "combine"
  external combine9: (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
    stream<'k, 'l>,
    stream<'m, 'n>,
    stream<'o, 'p>,
  ) => (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
    stream<'k, 'l>,
    stream<'m, 'n>,
    stream<'o, 'p>,
  ) = "combine"
  external combine10: (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
    stream<'k, 'l>,
    stream<'m, 'n>,
    stream<'o, 'p>,
    stream<'q, 'r>,
  ) => (
    t,
    stream<'a, 'b>,
    stream<'e, 'f>,
    stream<'e, 'f>,
    stream<'g, 'h>,
    stream<'i, 'j>,
    stream<'k, 'l>,
    stream<'m, 'n>,
    stream<'o, 'p>,
    stream<'q, 'r>,
  ) = "combine"

  /* subscriptions and listeners */
  type subscription = {unsubscribe: unit => unit}

  @bs.send
  external addListener: (stream<'a, 'b>, listener) => unit = "addListener"
  @bs.send
  external removeListener: (stream<'a, 'b>, listener) => unit = "removeListener"
  @bs.send
  external subscribe: (stream<'a, 'b>, listener) => subscription = "subscribe"

  /* shame */
  @bs.send
  external shamefullySendNext: (stream<'a, 'b>, 'a) => unit =
    "shamefullySendNext"
  @bs.send
  external shamefullySendError: (stream<'a, 'b>, 'b) => unit =
    "shamefullySendError"
  @bs.send
  external shamefullySendComplete: (stream<'a, 'b>, unit) => unit =
    "shamefullySendComplete"
  @bs.send
  external setDebugListener: (stream<'a, 'b>, option<listener>) => unit =
    "setDebugListener"
}
