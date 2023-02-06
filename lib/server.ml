open! Core
open Async

type t = (Socket.Address.Inet.t, int) Tcp.Server.t

module Line_handler = struct
  type t = [ `Ok of string | `Eof ] -> [ `Ok of string | `Disconnect ]
end

let handler ~reader ~writer f =
  let rec loop () =
    let%bind input = Reader.read_line reader in
    match f input with
    | `Ok output ->
      Writer.write_line writer output;
      loop ()
    | `Disconnect -> return ()
  in
  loop ()
;;

let create ~port f =
  Tcp.Server.create
    ~on_handler_error:`Raise
    (Tcp.Where_to_listen.of_port port)
    (fun _ reader writer -> handler f ~reader ~writer)
;;

let close_finished = Tcp.Server.close_finished
