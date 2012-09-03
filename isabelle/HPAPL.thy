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

class scalar =
  fixes fill :: 'a

instantiation int and nat :: scalar
begin
  definition fill_int :: int where "fill_int \<equiv> 0"
  definition fill_nat :: nat where "fill_nat \<equiv> 0"
  instance by default
end

datatype 'a::scalar array = Array "nat list" "'a::scalar list"

definition Empty :: "'a::scalar array" where "Empty \<equiv> Array [0] []"

definition shapelst :: "'a::scalar array \<Rightarrow> nat list"
where "shapelst a \<equiv> case a of Array s v \<Rightarrow> s"

definition listprod :: "nat list \<Rightarrow> nat"
where "listprod x = foldr times x 1"

fun sv2vl :: "nat \<Rightarrow> 'a::scalar list \<Rightarrow> 'a::scalar list \<Rightarrow> 'a::scalar list" where
    "sv2vl 0 orig lst = []"
  | "sv2vl cnt [] lst = (replicate cnt fill)"
  | "sv2vl (Suc cnt) (oel # ors) [] = (oel # (sv2vl cnt (oel # ors) ors))"
  | "sv2vl (Suc cnt) orig (elm # rst) = (elm # (sv2vl cnt orig rst))"

definition valuelst :: "'a::scalar array \<Rightarrow> 'a::scalar list" 
where "valuelst a \<equiv> case a of Array s v \<Rightarrow> sv2vl (listprod s) v v"

definition Scalar :: "'a::scalar \<Rightarrow> 'a array" 
where "Scalar s \<equiv> Array [] [s]"

definition Vector :: "'a::scalar list => 'a::scalar array" 
where "Vector lst \<equiv> Array [length lst] lst"

definition natrank :: "'a::scalar array \<Rightarrow> nat"
where "natrank a \<equiv> length (shapelst a)"

lemma natrank_Empty [simp]: "natrank Empty = 1"
by (simp add: Empty_def natrank_def shapelst_def)

lemma natrank_Scalar [simp]: "natrank (Scalar x) = 0"
by (simp add: natrank_def Scalar_def shapelst_def)

definition vec2lst :: "'a::scalar array \<Rightarrow> 'a::scalar list"
where "vec2lst vec \<equiv> case vec of Array s v \<Rightarrow> v"

theorem vector_shape [simp]: "shapelst (Vector s) = [length s]"
by (simp add: Vector_def shapelst_def)

theorem vector_rank [simp]: "natrank (Vector s) = 1"
by (simp add: Vector_def natrank_def shapelst_def)

theorem vector_inverse [simp]: "vec2lst (Vector lst) = lst"
by (simp add: Vector_def vec2lst_def)

theorem vector_empty: "Vector [] = Empty"
by (simp add: Vector_def Empty_def)

theorem vec2lst_empty [simp]: "vec2lst Empty = []"
by (simp add: Empty_def vec2lst_def)

definition shape :: "'a::scalar array \<Rightarrow> nat array" 
where "shape a \<equiv> Vector (shapelst a)"

theorem shape_Empty [simp]: "shape Empty = Vector [0]"
by (simp add: shape_def Empty_def shapelst_def)

theorem rank_shape_one [simp]: "natrank (shape a) = 1" 
by (auto simp: shape_def)

theorem shape2_rank [simp]: "shape (shape a) = Vector [natrank a]"
by (auto simp: shape_def natrank_def)

theorem shape3_is_one [simp]: "shape (shape (shape a)) = Vector [1]"
by (auto simp: shape_def)

theorem shape_scalar [simp]: "shape (Scalar x) = Empty"
by (simp add: shape_def Empty_def Vector_def Scalar_def shapelst_def)

fun comp_idx :: "nat \<Rightarrow> nat list \<Rightarrow> nat list \<Rightarrow> nat" where
    "comp_idx n [] i = n"
  | "comp_idx n s [] = n"
  | "comp_idx n (se # sr) (ie # ir) = comp_idx (ie + se * n) sr ir"

definition index_unraveled :: "nat list \<Rightarrow> nat list \<Rightarrow> nat" 
where "index_unraveled s i \<equiv> comp_idx 0 s i"

definition index :: "nat array \<Rightarrow> 'a::scalar array \<Rightarrow> 'a" where
"index i a \<equiv> (valuelst a) ! index_unraveled (shapelst a) (valuelst i)"

theorem index_scalar [simp]: "index Empty (Scalar x) = x"
by (simp add: Empty_def Scalar_def index_def valuelst_def shapelst_def
              listprod_def index_unraveled_def)

end
