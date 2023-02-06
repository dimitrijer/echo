open! Core
open Async

type t

module Line_handler : sig
  type t = [ `Ok of string | `Eof ] -> [ `Ok of string | `Disconnect ]
end

(** [create ~port f] starts echo server on provided [port] and uses line handler
    [f] to handle incoming data on client socket. *)
val create : port:int -> Line_handler.t -> t Deferred.t

(** [close_finished t] becomes determined once server socket is closed. *)
val close_finished : t -> unit Deferred.t
