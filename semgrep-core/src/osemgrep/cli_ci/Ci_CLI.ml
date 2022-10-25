(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)
(*
   'semgrep ci' subcommand

   Translated from ci.py
*)

(*****************************************************************************)
(* Types and constants *)
(*****************************************************************************)

type conf = Scan_CLI.conf

(*****************************************************************************)
(* Entry point *)
(*****************************************************************************)

let parse_argv (argv : string array) : (conf, Exit_code.t) result =
  Scan_CLI.parse_argv argv
