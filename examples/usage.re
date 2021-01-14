open Demo.StreamInt;

/* Functional usge */
let producer = fromArray([|1|]);
let transformed = map(producer, x => x + 5);
let transformedMemo = remember(transformed);

/* chained methods */
let piped = producer->map(x => x + 5)->filter(x => x > 5)->remember();

piped->Js.log
