(* Formal theory of HPAPL 
 * 
 * Copyright (c) 2012 Aaron W. Hsu <arcfide@sacrideo.us>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE. *)

theory HPAPL 
imports Main
begin

text {*
This is the theory of HPAPL which defines arrays, the Mathematics of Arrays, and the semantics of 
an HPAPL program.  What I would like, ideally, is to have a clear exposition of the mathematics of 
arrays followed by a proper axiomatic semantics of HPAPL, a verified compiler, and a scheme for 
leveraging proofs about an HPAPL program for optimizations.
*}

text {*
We define the type of arrays.  In particular, I want to represent arrays in a simple 
manner to reason about first.  Perhaps at a later time I will focus on things that can be turned 
into code, but for the moment I would like to ease the proof process. Thus, I use the standard 
view of an array, extending it to any dimension. This means that an array is a subset of the 
type of @{typ "nat list \<rightharpoonup> 'a option"}. In particular, I want to restrict arrays based on the following 
conditions:

\startitemize[n]
\item The domain of any given array must consist of a set of lists of equal length.
\item An array must map any valid index in range of the shape of the array to a valid value.
\item An array must have a finite shape.
\stopitemize
*}

datatype 'a skelarray = SkelArray "nat list" "(nat list) \<rightharpoonup> 'a"

definition validsv :: "nat list \<Rightarrow> (nat list \<rightharpoonup> 'a) \<Rightarrow> bool"
where "validsv s v \<equiv> dom v = {x::(nat list). list_all2 op < x s}"

theorem validsvempty [simp]: "validsv [0] Map.empty"
by (auto simp: validsv_def list_all2_Cons2)

theorem validsvnil [simp]: "validsv [] v \<longleftrightarrow> dom v = {[]}"
by (auto simp: validsv_def)

definition validarr :: "'a skelarray \<Rightarrow> bool" 
where "validarr A \<equiv> case A of (SkelArray s v) \<Rightarrow> validsv s v"

theorem validarrempty [simp]: "validarr (SkelArray [0] Map.empty)"
by (simp add: validarr_def)

typedef (open) 'a array = "{a::('a skelarray). validarr a}"
proof
  show "SkelArray [0] Map.empty \<in> {a::('a skelarray). validarr a}" by (simp add: validarrempty)
qed

definition Array :: "nat list \<Rightarrow> ((nat list) \<rightharpoonup> 'a) \<Rightarrow> 'a array" 
where "Array s v \<equiv> 
  if validsv s v 
  then Abs_array (SkelArray s v) 
  else Abs_array (SkelArray [0] Map.empty)"

lemma rep_arrays_valid [simp]: "validarr (Rep_array A)" 
by (rule Abs_array_induct) (simp add: Abs_array_inverse Array_def)

definition shapelst :: "'a array \<Rightarrow> nat list"
where "shapelst a \<equiv> case Rep_array a of (SkelArray s v) \<Rightarrow> s"

lemma validsv_in_array: "validsv s v \<Longrightarrow> (SkelArray s v)\<in>{a::'a skelarray. validarr a}"
proof -
  fix s :: "nat list" and v :: "nat list \<rightharpoonup> 'a"
  assume "validsv s v"
  thus "(SkelArray s v)\<in>{x::'a skelarray. validarr x}" 
    by (auto simp: validsv_def validarr_def)
qed

theorem access_shapelst_array [simp]: "validsv s v \<Longrightarrow> shapelst (Array s v) = s"
proof -
  fix s :: "nat list" and v :: "nat list \<rightharpoonup> 'a"
  assume h: "validsv s v"
  hence mem: "(SkelArray s v)\<in>{x::'a skelarray. validarr x}"  by (simp only: validsv_in_array)
  from h have "shapelst (Array s v) = shapelst (Abs_array (SkelArray s v))" by (simp add: Array_def)
  also have "... = (case Rep_array (Abs_array (SkelArray s v)) of (SkelArray s v) \<Rightarrow> s)"
    by (simp add: shapelst_def)
  also from mem have "... = (case (SkelArray s v) of (SkelArray s v) \<Rightarrow> s)"
    by (simp add: Abs_array_inverse)
  finally show "shapelst (Array s v) = s" by simp
qed

definition arrvmap :: "'a array \<Rightarrow> (nat list \<rightharpoonup> 'a)"
where "arrvmap a \<equiv> case Rep_array a of (SkelArray s v) \<Rightarrow> v"

theorem access_arrvmap_array [simp]: "validsv s v \<Longrightarrow> arrvmap (Array s v) = v"
proof -
  fix s :: "nat list" and v :: "nat list \<rightharpoonup> 'a"
  assume h: "validsv s v"
  hence mem: "(SkelArray s v)\<in>{x::'a skelarray. validarr x}" by (simp only: validsv_in_array)
  from h have "arrvmap (Array s v) = arrvmap (Abs_array (SkelArray s v))" by (simp add: Array_def)
  also have "... = (case Rep_array (Abs_array (SkelArray s v)) of (SkelArray s v) \<Rightarrow> v)"
    by (simp add: arrvmap_def)
  also from mem have "... = (case (SkelArray s v) of (SkelArray s v) \<Rightarrow> v)"
    by (simp add: Abs_array_inverse)
  finally show "arrvmap (Array s v) = v" by simp
qed

theorem validsv_from_mem [simp]: "(SkelArray s v)\<in>{x::('a skelarray). validarr x} \<Longrightarrow> validsv s v"
by (auto simp: validsv_def validarr_def)

definition rank :: "'a array \<Rightarrow> nat" where "rank a \<equiv> length (shapelst a)"

theorem rank_length [simp]: "validsv s v \<longrightarrow> rank (Array s v) = length s"
by (simp add: rank_def)

definition list2arr :: "'a list \<Rightarrow> 'a array"
where "list2arr lst \<equiv> Array [length lst] [map (\<lambda>x. [x]) [0..<length lst] [\<mapsto>] lst]"

lemma validsvvec [simp]: "validsv [length lst] [map (\<lambda>x. [x]) [0..<length lst] [\<mapsto>] lst]"
by (auto simp: validsv_def list_all2_Cons2)

theorem list_array_shape [simp]: "shapelst (list2arr s) = [length s]"
by (auto simp: list2arr_def)

theorem list_array_rank [simp]: "rank (list2arr s) = 1"
by (simp add: list2arr_def)

theorem list_array_map [simp]:
  "arrvmap (list2arr lst) = (Map.empty([[x]. x \<leftarrow> [0..<length lst]] [\<mapsto>] lst))"
by (auto simp: list2arr_def)

(***********************
 * Real APL primitives *
 ************************)
definition Empty :: "'a array" where "Empty \<equiv> Array [0] Map.empty"

definition shape :: "'a array \<Rightarrow> nat array" 
where "shape a \<equiv> list2arr (shapelst a)"

(************************
 * Theorems about HPAPL *
 ************************)

(* Empty is a vector *)
theorem rank_Empty [simp]: "rank Empty = 1" 
by (auto simp: Empty_def)

(* The rank of the shape of any array is one *)
theorem rank_shape_one [simp]: "rank (shape x) = 1" 
by (auto simp: shape_def)

(* The shape of the shape of x is the same as a vector of the rank of x *)
theorem shape_shape_rank [simp]: "shape (shape x) = list2arr [rank x]"
by (auto simp: shape_def rank_def)

(* Three shapes makes one *)
theorem shape3_is_one [simp]: "shape (shape (shape x)) = list2arr [1]"
by (auto simp: shape_def)



end
