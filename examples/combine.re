/* We can combine any number of streams */
/* Polymorphism is fully supported using function overloads */

open Demo;
open Xstream.Stream.Operators;

let int_output = StreamInt.fromArray([|1, 2, 3|]);
let str_output = StreamString.fromArray([|"A number"|]);

let mix =
  StreamString.combine2(str_output, int_output)
  ->map2(((text, n)) => [|text, n|]);
// let listener:Xstream.Stream.stream = {next:Js.Console.log, error:Js.Console.error, complete:() =>
//       Js.Console.log("complete")
//     };
Demo.StreamInt.(
  addListener(
    mix,
    {
      next: Js.Console.log,
      error: Js.Console.error,
      complete: () => Js.Console.log("complete"),
    },
  )
);