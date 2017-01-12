theory AbstractExecution_ARS
imports
  Main
begin

text{* In this approach, we are interested in defining a non-deterministic reduction
  of the TESL-satisfiability (called TESL-SAT) problem into the Presburger-satisfiability.
  As such, we deeply define an ARS to enlarge a TESL specification \<phi>, while transfering
  local-indexed constraints into a Presburger-type context \<Gamma>. The reduction strategy is
  meant to apply a transitive-closure of the ARS until a normal form \<phi>' is reached and the
  \<Gamma> context is satisfiable.
*}

ML_file "TESLTypes.sml"
ML_file "SAT.sml"
ML_file "ARS.sml"

declare [[ML_print_depth=30]]

ML {*
(* In the following examples, we recall the following constraint predicates of type [TESLTypes.constr]:
  - [Timestamp (c, \<sigma>, \<tau>)]  also seen as [c \<Down>\<^sub>\<sigma> \<tau>]         means clock [c] at instant [\<sigma>] has tag time [\<tau>]
  - [Ticks (c, \<sigma>)]         also seen as [c \<Up>\<^sub>\<sigma>]           means clock [c] at instant [\<sigma>] is hamletly ticking
  - [NotTicks (c, \<sigma>)]      also seen as [c \<not>\<Up>\<^sub>\<sigma>]          means clock [c] at instant [\<sigma>] is hamletly NOT ticking
  - [Affine (\<tau>, \<alpha>, \<tau>', \<beta>)] al so seen as [\<tau> = \<alpha> \<times> \<tau>' + \<beta>]  means to satisfy tag relation \<tau> = \<alpha> \<times> \<tau>' + \<beta>
*)

(* --- Example 1 ---
   Z-clock H1 sporadic 1, 2
   U-clock H2
   H1 implies H2
*)
val cf0 : TESL_ARS_conf = ([], 0, [
Sporadic (Clk 1, Int 1),
Sporadic (Clk 1, Int 2),
Implies (Clk 1, Clk 2)], []);
(* val cf0_lim = exec cf0; *)

(* --- Example 2 ---
   Z-clock H1 sporadic 1
   Z-clock H2
   U-clock H3
   tag relation H1 = H2
   H1 time delayed by 9 on H2 implies H3
*)
val cf1 : TESL_ARS_conf = ([], 0, [
Sporadic (Clk 1, Int 1),
TagRelation (Clk 1, Int 1, Clk 2, Int 0), 
TimeDelayedBy (Clk 1, Int 9, Clk 2, Clk 3)], []);
(* val cf1_lim = exec cf1; *)

(* --- Example 3 ---
   Z-clock H1 sporadic 1
   H1 time delayed by 1 on H1 implies H1
*)
val cf2 : TESL_ARS_conf = ([], 0, [Sporadic (Clk 1, Int 1), TimeDelayedBy (Clk 1, Int 1, Clk 1, Clk 1)], []);
(* WARNING: The following example is supposed to loop and will. Uncomment just for fun! *)
(* val cf2_lim = exec cf2;  *)

(* --- Example 4 ---
   Z-clock H1 sporadic 1, 2, 3, 4, 5
   H1 filtered by 1, 2, (1, 2)* implies H2
*)
val cf3 : TESL_ARS_conf = ([], 0, [
  Sporadic (Clk 1, Int 1),
  Sporadic (Clk 1, Int 2),
  Sporadic (Clk 1, Int 3),
  Sporadic (Clk 1, Int 4),
  Sporadic (Clk 1, Int 5),
  FilteredBy (Clk 1, 1, 2, 1, 2, Clk 2)], []);
(* WARNING: Takes several seconds to simulate *)
(* val cf3_lim = exec cf3;  *)

(* --- Example 4 ---
   Z-clock H1 sporadic 1, 2, 3
   tag relation H1 = H2
   H1 delayed by 2 on H2 implies H3
*)
val cf4 : TESL_ARS_conf = ([], 0, [
  Sporadic (Clk 1, Int 1),
  Sporadic (Clk 2, Int 2),
  Sporadic (Clk 2, Int 3),
  TagRelation (Clk 1, Int 1, Clk 2, Int 0),
  DelayedBy (Clk 1, 2, Clk 2, Clk 3)], []);
(* WARNING: Takes several seconds to simulate *)
(* val cf4_lim = exec cf4; *)

val cf5 : TESL_ARS_conf = ([], 0, [
  Sporadic (Clk 1, Int 1),
  Sporadic (Clk 1, Int 2),
  Sporadic (Clk 1, Int 3),
  Sporadic (Clk 2, Int 2),
  Sporadic (Clk 3, Int 3),
  TagRelation (Clk 1, Int 1, Clk 2, Int 0),
  TagRelation (Clk 1, Int 1, Clk 3, Int 0),
  SustainedFrom (Clk 1, Clk 2, Clk 3, Clk 4)], []);
(* val cf5_lim = exec cf5; *)

val cf6 : TESL_ARS_conf = ([], 0, [
  Sporadic (Clk 1, Int 1),
  Sporadic (Clk 1, Int 3),
  Sporadic (Clk 2, Int 2),
  Sporadic (Clk 2, Int 3),
  TagRelation (Clk 1, Int 1, Clk 2, Int 0),
  Await ([Clk 1, Clk 2], [Clk 1, Clk 2], [Clk 1, Clk 2], Clk 3)], []);
(*  val cf6_lim = exec cf6; *)
*}

end