(*
   Untranslated CST allowing mixing with an AST.
*)

(*
   A concrete syntax subtree that was not fully translated yet.
   We get this representation automatically from ocaml-tree-sitter.
   This type is normally translated one-to-one from the Raw_tree.t
   type provided by the ocaml-tree-sitter runtime library.
*)
type 'any t =
  (* keyword, identifier, punctuation, int literal, ... = string wrap *)
  | Token of (string * Tok.t_always_equal)
  (* sequence of variable length [repeat] *)
  | List of 'any t list
  (* sequence of fixed length (wrt type) [seq] *)
  | Tuple of 'any t list
  (* tagged value = variant [choice] *)
  | Case of string * 'any t
  (* optional value [optional] *)
  | Option of 'any t option
  (* return to the normal generic AST *)
  | Any of 'any
[@@deriving show { with_path = false }, eq, hash]

(*
   Return the first and the last token of the tree, if any.

   Note that it might be more efficient if the raw tree stored this
   location at each node but this would require changing the OCaml
   types generated by ocaml-tree-sitter (CST.ml files).
*)
val loc : _ t -> (Tok.t * Tok.t) option

(* Same as loc but return fake tokens in case the tree is empty *)
val unsafe_loc : _ t -> Tok.t * Tok.t

(* Extract all the Any nodes, in left-to-right order.
   (without descending recursively into these nodes)
*)
val anys : 'any t -> 'any list

(* Translate the custom nodes into another type. *)
val map : map_any:('a -> 'b) -> 'a t -> 'b t

(* Iterate over the tree. *)
val visit :
  v_raw_tree:('any t -> unit) ->
  v_token:(string * Tok.t -> unit) ->
  v_any:('any -> unit) ->
  'any t ->
  unit
