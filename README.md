# bs-xstream

Bucklescript/ReasonML bindings for [xstream](https://github.com/staltz/xstream).
Forked from [j3a-solutions/bs-xstream](https://gitlab.com/j3a-solutions/bs-xstream)

## Installation

```sh
npm install --save @idkjs/bs-xstream
```

Then add `@idkjs/bs-xstream` to `bs-dependencies` in your `bsconfig.json`:

```js
{
  ...
  "bs-dependencies": ["@idkjs/bs-xstream"]
}
```

## Differences with JS version

No runtime code is included in this package. Only bindings are provided.

Having said that, there are a few differences that come from using ocaml's type system:

- If your stream emits integers, Typescript version picks up on that, but methods like `throw` and `replaceError` do not offer safe types. This is because in the JS/TS version, streams are generically typed for ok messages (aka: right branch, result ok type, etc.). In this version, both ok and error messages are typed. This leads to a much stronger typed usage of streams.
- Instead of generics, this package uses ocaml functors. If you're starting your streams from scratch, create your module first using `Stream.Make_stream` and `Memory.Make_memory_stream`. By creating a module you're not creating a constructor in JS sense. These are type factories. For an in-depth explanation of how functors work read [this](http://reasonmlhub.com/exploring-reasonml/ch_functors.html). See the [demo module](examples/demo.re) to see a couple of simple examples.
- As a more basic alternative to the functor approach, if you are consuming external streams, it may be enough to use the `Operators` modules in either `Stream` or `Memory`.
- In bs, array elements must all be of the same type. This poses a limitation fot the `merge` method. However, full polymorphism of streams can be achieved with `combine`.
- Stream and memory streams are treated as two completely different types.

For anything else, check the documentation of [xstream](https://github.com/staltz/xstream).

## Why are there two different modules for Stream and Memory streams?

In the Javascript implementation, Memory streams extend the main Stream class. Even though OCAML supports inheritance, the relationship between plain and memory streams is a complex one to type (and even the Typescript version has some gotchas!).

I find that OCAML functors allow for modular streams which are both easier to reason about and strongly typed. This option does come with some drawbacks (e.g. repetition of methods) but I prefer it to inheritance patterns for definition of JS externals and interop. If there's a better way please open an issue with some examples and let's discuss them!

For now, in order to pipe data through streams which may be one or the other type, there are some operators which cast from Stream into Memory (see, for example `map` and `flatten` variations).

## Usage

The JS implementation of Xstream heavily relies on fluent interfaces for streams (i.e.: chaining of methods). These bindings try to be as close to the JS version as possible by using `[@bs.send]`. Feel free to choose between a fluent or a more functional approach. As per the examples given in `examples` folder:

### Functional style

```ocaml
open Xstream.Stream;

let producer = fromArray([|1|]);
let transformed = map(producer, x => x + 5);
let transformedMemo = remember(transformed);
```

### Fluent style with pipes

```ocaml
open Xstream.Stream;

let producer = fromArray([1]);
let piped = producer
  -> map(x => x + 5)
  -> filter(x => x > 5)
  -> remember();
```

# Build

```
npm run build
```

# Build + Watch

```
npm run start
```

# Editor

If you use `vscode`, Press `Windows + Shift + B` it will build automatically

# Examples

```bash
bs-xstream on  main [!?] is 📦 v0.7.3 via ⬢ v14.4.0
 [I] ➜ node lib/js/examples/operators.bs.js
Received 1
complete

bs-xstream on  main [!?] is 📦 v0.7.3 via ⬢ v14.4.0
 [I] ➜ node lib/js/examples/demo.bs.js
Stream {
  _prod: FromArray { type: 'fromArray', a: [ 1 ] },
  _ils: [],
  _stopID: {},
  _dl: {},
  _d: false,
  _target: null,
  _err: {}
}

bs-xstream on  main [!?] is 📦 v0.7.3 via ⬢ v14.4.0
 [I] ➜ node lib/js/examples/combine.bs.js
[ 'A number', 1 ]
[ 'A number', 2 ]
[ 'A number', 3 ]
complete
```
