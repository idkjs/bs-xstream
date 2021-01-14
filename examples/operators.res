/* Third party libraries may expose stream factory functions */
/* For most of these cases the Operators modules should cover most uses */

open Xstream.Stream.Operators

/* Example with a third party stream of integers */

/* we import the stream from the demo module, where integers are going to be emitted */
let str_counter = Demo.thirdPartyStream
/* we then transform the ok output into a string */
let _ = map(str_counter, n => j`Received $n`)

/* or we can do the same using fast pipe */
let str_counter_concise = Demo.thirdPartyStream->map(n => j`Received $n`)

/* Third party libraries (e.g.: cycle.js run function) may already set up listeners */
/* But for this example, we attach a listener to check our transformation worked ok */
{
  open Demo.StreamInt
  addListener(
    str_counter_concise,
    {
      next: Js.Console.log,
      error: Js.Console.error,
      complete: () => Js.Console.log("complete"),
    },
  )
}
