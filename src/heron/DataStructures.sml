(**
   Module Basics

   Author : Hai Nguyen Van
            LRI, Université Paris-Sud/CNRS
   
   The copyright to this code is held by Laboratoire de Recherche en
   Informatique, Université Paris-Sud/CNRS. All rights reserved. This
   file is distributed under the MIT License.
*)

(* WARNING *)
(* COMMENT THE FOLLOWING LINE IF YOU WISH TO USE Isabelle/jEdit IDE *)
fun writeln s = print (s ^ "\n")
fun string_of_int n = Int.toString n

fun minus_instead_of_tild (str: string): string =
  String.implode (List.map (fn chr => if chr = #"~" then #"-" else chr) (String.explode str))
fun string_of_int_minus n =
  minus_instead_of_tild (Int.toString n)

(* **************************************************************** *)

(* Some colors *)
val BOLD_COLOR      = "\u001B[1m"
val UNDERLINE_COLOR = "\u001B[4m"
val RED_COLOR       = "\u001B[31m"
val GREEN_COLOR     = "\u001B[32m"
val YELLOW_COLOR    = "\u001B[33m"
val BLUE_COLOR      = "\u001B[34m"
val MAGENTA_COLOR   = "\u001B[35m"
val CYAN_COLOR      = "\u001B[36m"
val RESET_COLOR     = "\u001B[0m"

fun clear_line () =
  print "\r                                                                               "

(* Ranges integers [1 : n] *)
fun range n  = let fun aux n' l = if n' = 0 then l else aux (n' - 1) (n' :: l) in aux n [] end;
fun range0 n = let fun aux n' l = if n' < 0 then l else aux (n' - 1) (n' :: l) in aux n [] end;

(* Dummy constants *)
val MAXINT = valOf (Int.maxInt)
val MININT = valOf (Int.minInt)

(* Update operators for referenced lists *)
infix 1 <>> <>>>
fun rl <>> x    = rl := (!rl) @ [x]
fun rl <>>> rl' = rl := (!rl) @ rl'

(* Returns the sublist of [l1] without occurences of elements of [l2] *)
infix 1 @-
fun l1 @- l2 = List.filter (fn e1 => List.all (fn e2 => e1 <> e2) l2) l1

(* Intersection *)
infix 1 @/\
fun l1 @/\ l2 = List.filter (fn x1 => List.exists (fn x2 => x1 = x2) l2) l1

(* Union *)
infix 1 @\/
fun l1 @\/ l2 = List.foldl (fn (x2, res) => if List.exists (fn x => x = x2) res
						  then res
						  else x2 :: res) l1 l2

fun is_empty l = case l of [] => true | _ => false
fun contains x l = List.exists (fn x' => x = x') l

(* Returns a list of unique elements *)
fun uniq l =
  let
    fun aux (x :: l') acc =
          if List.exists (fn x' => x' = x) acc
          then aux l' acc
          else aux l' (x :: acc)
      | aux [] acc             = acc
  in List.rev (aux l [])
  end

fun fst (a, b) = a
fun snd (a, b) = b

exception Assert_failure
fun assert b =
  if b then b else raise Assert_failure

(* Returns the minimum of a list [l] of elements totally ordered by [leq] *)
fun min_list (leq: 'a * 'a -> bool) (l: 'a list) : 'a option = case l of
    []      => NONE
  | [x]     => SOME x
  | x :: l' => SOME (List.foldl (fn (e, current_min) => if leq (e, current_min)
								then e
								else current_min) x l')

(* Returns the maximum of a list [l] of elements totally ordered by [leq] *)
fun max_list (leq: 'a * 'a -> bool) (l: 'a list) : 'a option = case l of
    []      => NONE
  | [x]     => SOME x
  | x :: l' => SOME (List.foldl (fn (e, current_max) => if leq (e, current_max)
								then current_max
								else e) x l')

(* Given a seed [s], returns a random integer in [i, j] int interval *)
fun random_int_range (i: int, j: int) (s: word): int = 
  if j < i
  then raise Assert_failure
  else
    if j = i then i
    else
      let 
	 val m : Int32.int = 2147483647  (* 2^31 - 1 *)
	 val R = (Int32.fromInt j) - (Int32.fromInt i)
	 val cvt = Word.toIntX o Word.fromLargeInt o Int32.toLarge
      in
	 if R = m
	 then Word.toIntX s
	 else i + cvt (((Int32.fromLarge o Word.toLargeInt) s) mod (R+1))
      end
handle Overflow => random_int_range (i, j) (valOf (MLton.Random.useed ()));

exception NotFoundAssoc
fun assoc l x = case (List.find (fn (k, v) => k = x) l) of
  SOME (_, V) => V
| NONE => raise NotFoundAssoc

exception Empty

fun max (a, b) = if a > b then a else b

fun largest [] = raise Empty 
 | largest [x] = x
 | largest (x::xs) = max(x, largest xs)
 
structure ListMore =
struct
  (* Set-wise equality *)
  fun equals l1 l2 =
      List.all (fn x => List.exists (fn x' => x = x') l2) l1
      andalso List.all (fn x => List.exists (fn x' => x = x') l1) l2
   
  (* Splits a list into 2 lists (linear time) *)
  fun split_half l =
    let fun aux l (left, right) = case l of
     []		    => (left, right)
   | [x]		    => (x :: left, right)
   | x1 :: x2 :: l' => aux l' (x1 :: left, x2 :: right)
    in aux l ([], [])
    end
   
  (* Splits a list into 2 lists (linear time) *)
  fun split_in_8 l =
    let fun aux l (l1, l2, l3, l4, l5, l6, l7, l8) = case l of
     []		                                        => (l1, l2, l3, l4, l5, l6, l7, l8)
   | x1 :: x2 :: x3 :: x4 :: x5 :: x6 :: x7 :: x8 :: l' => aux l' (x1 :: l1, x2 :: l2, x3 :: l3, x4 :: l4, x5 :: l5, x6 :: l6, x7 :: l7, x8 :: l8)
   | x1 :: x2 :: x3 :: x4 :: x5 :: x6 :: x7 :: l'       => aux l' (x1 :: l1, x2 :: l2, x3 :: l3, x4 :: l4, x5 :: l5, x6 :: l6, x7 :: l7, l8)
   | x1 :: x2 :: x3 :: x4 :: x5 :: x6 :: l'             => aux l' (x1 :: l1, x2 :: l2, x3 :: l3, x4 :: l4, x5 :: l5, x6 :: l6, l7, l8)
   | x1 :: x2 :: x3 :: x4 :: x5 :: l'                   => aux l' (x1 :: l1, x2 :: l2, x3 :: l3, x4 :: l4, x5 :: l5, l6, l7, l8)
   | x1 :: x2 :: x3 :: x4 :: l'                         => aux l' (x1 :: l1, x2 :: l2, x3 :: l3, x4 :: l4, l5, l6, l7, l8)
   | x1 :: x2 :: x3 :: l'                               => aux l' (x1 :: l1, x2 :: l2, x3 :: l3, l4, l5, l6, l7, l8)
   | x1 :: x2 :: l'                                     => aux l' (x1 :: l1, x2 :: l2, l3, l4, l5, l6, l7, l8)
   | x1 :: l'                                           => aux l' (x1 :: l1, l2, l3, l4, l5, l6, l7, l8)
    in aux l ([], [], [], [], [], [], [], [])
    end
   
  fun seteq l1 l2 =
      List.all (fn x1 => List.exists (fn x2 => x1 = x2) l2) l1
      andalso List.all (fn x2 => List.exists (fn x1 => x1 = x2) l1) l2
end

infix 1 @==
fun l1 @== l2 = ListMore.equals l1 l2

(* Computes the least fixpoint of a functional [ff] starting at [x] *)
(*
fun lfp (ff: ''a -> ''a) (x: ''a) : ''a =
  let val x' = ff x in
  (if x = x' then x else lfp (ff) x') end
*)
fun lfp (ff: ''a -> ''a) (x: ''a) : ''a =
    let val x_ = ref x
	 val x' = ref (ff x)
    in (while ((!x_) <> (!x')) do
	      (x_ := (!x') ;
	       x' := ff (!x'))) ;
	!x_
    end

fun lfp_set ff x =
    let val x_ = ref x
	 val x' = ref (ff x)
    in (while not ((!x_) @== (!x')) do
	      (x_ := (!x') ;
	       x' := ff (!x'))) ;
	!x_
    end

(**
  Strings
*)
structure StringMore =
struct

(* Same as OCaml's String.concat *)
fun concat (sep: string) (l: string list) =
  let fun aux l res = case l of
     []      => res
   | x :: l' =>
     if res = ""
     then aux l' x
     else aux l' (res ^ sep ^ x)
  in aux l ""
  end

end
