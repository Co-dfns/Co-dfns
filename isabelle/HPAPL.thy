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

datatype scalar = AplInt int | AplNat nat
datatype scalar_list = NatList "nat list" | IntList "int list"
datatype array = Array "nat list" "scalar_list"

definition Empty :: array where "Empty \<equiv> Array [0] (NatList [])"

definition shapelst :: "array \<Rightarrow> nat list"
where "shapelst a \<equiv> case a of Array s v \<Rightarrow> s"

definition listprod :: "nat list \<Rightarrow> nat"
where "listprod x = foldr times x 1"

fun sv2vlnat :: "nat \<Rightarrow> nat list \<Rightarrow> nat list \<Rightarrow> nat list"
where
    "sv2vlnat 0 orig lst = []"
  | "sv2vlnat cnt [] lst = (replicate cnt (0::nat))"
  | "sv2vlnat (Suc cnt) (oel # ors) [] = (oel # (sv2vlnat cnt (oel # ors) ors))"
  | "sv2vlnat (Suc cnt) orig (elm # rst) = (elm # (sv2vlnat cnt orig rst))"

fun sv2vlint :: "nat \<Rightarrow> int list \<Rightarrow> int list \<Rightarrow> int list"
where
    "sv2vlint 0 orig lst = []"
  | "sv2vlint cnt [] lst = (replicate cnt (0::int))"
  | "sv2vlint (Suc cnt) (oel # ors) [] = (oel # (sv2vlint cnt (oel # ors) ors))"
  | "sv2vlint (Suc cnt) orig (elm # rst) = (elm # (sv2vlint cnt orig rst))"

definition sv2vl :: "nat \<Rightarrow> scalar_list \<Rightarrow> scalar_list"
where
  "sv2vl n lst \<equiv>
     case lst of
       (NatList l) \<Rightarrow> NatList (sv2vlnat n l l) |
       (IntList l) \<Rightarrow> IntList (sv2vlint n l l)"

definition valuelst :: "array \<Rightarrow> scalar_list" 
where "valuelst a \<equiv> case a of Array s v \<Rightarrow> sv2vl (listprod s) v"

definition Scalar :: "scalar \<Rightarrow> array" where
  "Scalar s \<equiv>
     case s of
       AplNat x \<Rightarrow> Array [] (NatList [x]) |
       AplInt x \<Rightarrow> Array [] (IntList [x])"

definition Vector :: "scalar_list => array" where 
  "Vector lst \<equiv> 
     case lst of
       NatList l \<Rightarrow> Array [length l] lst |
       IntList l \<Rightarrow> Array [length l] lst"

definition natrank :: "array \<Rightarrow> nat"
where "natrank a \<equiv> length (shapelst a)"

lemma natrank_Empty [simp]: "natrank Empty = 1"
by (simp add: Empty_def natrank_def shapelst_def)

lemma natrank_Scalar [simp]: "natrank (Scalar x) = 0"
by (simp add: natrank_def Scalar_def shapelst_def) (split scalar.split, simp)

definition vec2lst :: "array \<Rightarrow> scalar_list"
where "vec2lst vec \<equiv> case vec of Array s v \<Rightarrow> v"

theorem vector_shape [simp]: "shapelst (Vector (NatList s)) = [length s]"
by (simp add: Vector_def shapelst_def)

theorem vector_shape2 [simp]: "shapelst (Vector (IntList s)) = [length s]"
by (simp add: Vector_def shapelst_def)

theorem vector_rank [simp]: "natrank (Vector s) = 1"
by (simp add: Vector_def natrank_def shapelst_def) 
   (split scalar_list.split, simp)

theorem vector_inverse [simp]: "vec2lst (Vector lst) = lst"
by (simp add: Vector_def vec2lst_def, split scalar_list.split, simp)

theorem vector_empty: "Vector (NatList []) = Empty"
by (simp add: Vector_def Empty_def)

theorem vec2lst_empty [simp]: "vec2lst Empty = (NatList [])"
by (simp add: Empty_def vec2lst_def)

definition shape :: "array \<Rightarrow> array" 
where "shape a \<equiv> Vector (NatList (shapelst a))"

theorem shape_Empty [simp]: "shape Empty = Vector (NatList [0])"
by (simp add: shape_def Empty_def shapelst_def)

theorem rank_shape_one [simp]: "natrank (shape a) = 1" 
by (auto simp: shape_def)

theorem shape2_rank [simp]: "shape (shape a) = Vector (NatList [natrank a])"
by (auto simp: shape_def natrank_def)

theorem shape3_is_one [simp]: "shape (shape (shape a)) = Vector (NatList [1])"
by (auto simp: shape_def)

theorem shape_scalar [simp]: "shape (Scalar x) = Empty"
by (simp add: shape_def Empty_def Vector_def Scalar_def shapelst_def)
   (split scalar.split, simp)

definition slget :: "scalar_list \<Rightarrow> nat \<Rightarrow> scalar" where
  "slget l i \<equiv>
     case l of
         NatList v \<Rightarrow> AplNat (v ! i)
       | IntList v \<Rightarrow> AplInt (v ! i)"

definition index_unraveled :: "nat list \<Rightarrow> nat list \<Rightarrow> nat"
where "index_unraveled s i \<equiv> 0"

definition indexer :: "nat list \<Rightarrow> nat list \<Rightarrow> scalar_list \<rightharpoonup> scalar" where
  "indexer i s d \<equiv> 
     if (list_all2 op < i s)
     then Some (slget d (index_unraveled s i))
     else None"

definition indexerint :: "int list \<Rightarrow> nat list \<Rightarrow> scalar_list \<rightharpoonup> scalar" where
  "indexerint i s d \<equiv> 
     if (list_all2 op > i (replicate (length i) 0))
     then indexer (map nat i) s d
     else None"

definition index :: "array \<Rightarrow> array \<rightharpoonup> scalar" where 
  "index i a \<equiv> 
     case (i, a) of
         (Array [n] (NatList v), (Array s d)) \<Rightarrow> indexer v s d
       | (Array [n] (IntList v), (Array s d)) \<Rightarrow> indexerint v s d
       | other \<Rightarrow> None"

theorem index_scalar [simp]: "index Empty (Scalar x) = Some x"
by sorry

definition releach :: "(scalar \<Rightarrow> scalar \<Rightarrow> bool) \<Rightarrow> array \<Rightarrow> array \<Rightarrow> bool"
where "releach f a b \<equiv> 
  (shapelst a = (shapelst b) \<and> (list_all2 f (valuelst a) (valuelst b)))
   \<or> (natrank a = 0 
      \<and> (list_all2 f 
          (sv2vl (listprod (shapelst b)) (valuelst a)) 
          (valuelst b)))
   \<or> (natrank b = 0 
      \<and> (list_all2 f 
          (valuelst a) 
          (sv2vl (listprod (shapelst a)) (valuelst b))))"

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
