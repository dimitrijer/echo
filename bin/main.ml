open Core
open Async

let command =
  let%map_open.Command port =
    flag "-port" (required int) ~doc:"port on which to listen"
  in
  fun () ->
    Echo.Server.create ~port (fun input ->
      match input with
      | `Ok "bye!" | `Eof -> `Disconnect
      | `Ok line -> `Ok (String.uppercase line))
    >>= Echo.Server.close_finished
;;

let () =
  Command.async ~summary:"A simple echo server that shouts back at you." command
  |> Command_unix.run
;;
