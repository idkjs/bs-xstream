module StreamString = Xstream_stream.Make_stream({
  type ok = string
  type error = Js.Exn.t
})
module StreamInt = Xstream_stream.Make_stream({
  type ok = int
  type error = Js.Exn.t
})

let thirdPartyStream = StreamInt.ofVal(1)
thirdPartyStream |> Js.log
