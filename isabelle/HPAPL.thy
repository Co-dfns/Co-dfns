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

definition validsv :: "nat list \<Rightarrow> (nat list \<rightharpoonup> 'a) \<Rightarrow> bool"
where "validsv s v \<equiv> dom v = {x::(nat list). list_all2 op < x s}"

typedef (open) 'a array = 
  "{e::(nat list \<times> (nat list \<rightharpoonup> 'a)). validsv (fst e) (snd e)}"
proof
  show "([0], Map.empty) \<in> {e. validsv (fst e) (snd e)}"
    by (simp add: validsv_def list_all2_Cons2)
qed

definition Empty :: "'a array" where "Empty \<equiv> Abs_array ([0], Map.empty)"

lemma Empty_validsv [simp]: "validsv [0] Map.empty"
by (simp add: validsv_def list_all2_Cons2)

definition Array :: "nat list \<Rightarrow> (nat list \<rightharpoonup> 'a) \<Rightarrow> 'a array"
where "Array s v \<equiv> if validsv s v then Abs_array (s, v) else Empty"

find_theorems "Rep_array (Abs_array _)"

lemma Array_validsv [simp]: "case Rep_array (Array s v) of (s, v) \<Rightarrow> validsv s v"
by (simp add: Array_def Abs_array_inverse Empty_def)

definition shapelst :: "'a array \<Rightarrow> nat list"
where "shapelst a \<equiv> case Rep_array a of (s, v) \<Rightarrow> s"

lemma Array_shapelst [simp]: "validsv s v \<Longrightarrow> shapelst (Array s v) = s"
by (simp add: shapelst_def Array_def Abs_array_inverse)

definition arrvmap :: "'a array \<Rightarrow> nat list \<rightharpoonup> 'a"
where "arrvmap a \<equiv> case Rep_array a of (s, v) \<Rightarrow> v"

lemma Array_arrvmap [simp]: "validsv s v \<Longrightarrow> arrvmap (Array s v) = v"
by (simp add: arrvmap_def Array_def Abs_array_inverse)

definition Scalar :: "'a \<Rightarrow> 'a array" 
where "Scalar x \<equiv> Array [] [[] \<mapsto> x]"

lemma Scalar_validsv [simp]: "validsv [] [[] \<mapsto> x]"
by (simp add: validsv_def list_all2_Cons2)

definition Vector :: "'a list \<Rightarrow> 'a array"
where "Vector lst \<equiv> 
Array [length lst] [map (\<lambda>x. [x]) [0..<length lst] [\<mapsto>] lst]"

lemma Vector_validsv [simp]: 
  "validsv [length lst] [map (\<lambda>x. [x]) [0..<length lst] [\<mapsto>] lst]"
by (auto simp: validsv_def list_all2_Cons2)

definition rank :: "'a array \<Rightarrow> nat" where "rank a \<equiv> length (shapelst a)"

theorem rank_length [simp]: "validsv s v \<Longrightarrow> rank (Array s v) = length s"
by (simp add: rank_def)

lemma rank_Empty [simp]: "rank Empty = 1"
by (simp add: Empty_def rank_def shapelst_def Abs_array_inverse)

lemma rank_Scalar [simp]: "rank (Scalar x) = 0"
by (auto simp: Scalar_def)

definition vec2lst :: "'a array \<Rightarrow> 'a list"
where "vec2lst vec \<equiv> 
[(the ((arrvmap vec) e)). e \<leftarrow> [[i]. i \<leftarrow> [0..<hd (shapelst vec)]]]"

theorem vector_shape [simp]: "shapelst (Vector s) = [length s]"
by (auto simp: Vector_def)

theorem vector_rank [simp]: "rank (Vector s) = 1"
by (simp add: Vector_def)

theorem vector_map [simp]:
  "arrvmap (Vector lst) = (Map.empty([[x]. x \<leftarrow> [0..<length lst]] [\<mapsto>] lst))"
by (auto simp: Vector_def)

theorem vector_inverse [simp]: "vec2lst (Vector lst) = lst"
by sorry

theorem vector_empty: "Vector [] = Empty"
by (simp add: Vector_def Empty_def Array_def)

theorem vec2lst_empty [simp]: "vec2lst Empty = []"
proof -
  have "vec2lst Empty = vec2lst (Vector [])" by (simp only: vector_empty)
  also have "... = []" by simp 
  finally show ?thesis.
qed

definition shape :: "'a array \<Rightarrow> nat array" 
where "shape a \<equiv> Vector (shapelst a)"

theorem shape_Empty [simp]: "shape Empty = Vector [0]"
by (simp add: shape_def Empty_def shapelst_def Abs_array_inverse)

theorem rank_shape_one [simp]: "rank (shape a) = 1" 
by (auto simp: shape_def)

theorem shape2_rank [simp]: "shape (shape a) = Vector [rank a]"
by (auto simp: shape_def rank_def)

theorem shape3_is_one [simp]: "shape (shape (shape a)) = Vector [1]"
by (auto simp: shape_def)

theorem shape_scalar [simp]: "shape (Scalar x) = Empty"
by (simp add: shape_def Scalar_def vector_empty)

definition index :: "nat array \<Rightarrow> 'a array \<Rightarrow> 'a"
where "index i a \<equiv> the ((arrvmap a) (vec2lst i))"

theorem index_scalar [simp]: "index Empty (Scalar x) = x"
by (simp add: index_def Scalar_def)

definition valididx :: "nat array \<Rightarrow> 'a array \<Rightarrow> bool"
where "valididx i a \<equiv> list_all2 op < (vec2lst i) (shapelst a)"

definition releach :: "('a \<Rightarrow> 'b \<Rightarrow> bool) \<Rightarrow> 'a array \<Rightarrow> 'b array \<Rightarrow> bool"
where "releach f a b \<equiv> 
  (shape a = (shape b) \<and> (\<forall>i. valididx i a \<longrightarrow> (f (index i a) (index i b))))
   \<or> (rank a = 0 \<and> (\<forall>i. valididx i b \<longrightarrow> f (index Empty a) (index i b))) 
   \<or> (rank b = 0 \<and> (\<forall>i. valididx i a \<longrightarrow> f (index i a) (index Empty b)))"

definition monmap :: "('a \<Rightarrow> 'b) \<Rightarrow> (nat list \<rightharpoonup> 'a) \<Rightarrow> (nat list \<rightharpoonup> 'b)"
where "monmap fn v i \<equiv> Option.map fn (v i)"

lemma monmap_dom [simp]: "dom (monmap fn v) = dom v"
by (auto simp: monmap_def dom_option_map)

definition monseach :: "('a \<Rightarrow> 'b) \<Rightarrow> 'a array \<Rightarrow> 'b array"
where "monseach fn a \<equiv> Array (shapelst a) (monmap fn (arrvmap a))"

theorem monseach_shape [simp]: "shapelst (monseach fn a) = shapelst a"
by sorry

theorem monseach_rank [simp]: "rank (monseach fn a) = rank a"
by sorry

end
