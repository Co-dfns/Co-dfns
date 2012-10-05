header {* A Formal Theory of APL *}

(*
Copyright (c) 2012 Aaron W. Hsu <arcfide@sacrideo.us>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE. *)

theory HPAPL 
imports Main
begin

text {* 
The first step to a formalization for HPAPL and parallel programs is an 
appropriate theory of arrays that sufficiently encompasses the serial,
implicitly parallel language of Dfns, which will be used to drive 
both the language of specification and the core language for parallel 
programming in HPAPL. In truth, the constructs described here may 
actually be compiled to parallel constructs, but differ from the 
HPAPL extensions in that they are not described as having an explicit 
concurrency in their use. Indeed, some of the constructs are implicitly 
ordered, a feature that we rely in sometimes.

The language that we formalize in the HPAPL theory is the side-effect 
free language of APL expressions, beginning with the mathematics of arrays.
The development in this document follows the treatment of the same subjects 
in roughly the same order and manner as the original dissertation defining 
the mathematics of arrays.
*}

subsection {* Defining arrays in Isabelle *}

text {* 
To make life easier in Isabelle, the HPAPL theory deviates from 
the axiomatic basis of the mathematics of array slightly be starting with 
an operation definition of arrays and the primitives over arrays, before 
moving to proof theorems about these definitions that are equivalent in 
usefulness and meaning to the theorems of the mathematics of arrays.
This allows a slightly more flexible approach, since both the axioms of 
the mathematics and the operation definitions may be used when proving 
richer theorems in the document.

To begin with the concept of a scalar must be defined. All arrays are 
composed of Scalar elements, and the @{term "class scalar"} defines 
the important properties of scalars. Namely, all scalars must be associated 
with a ``fill'' element, which is used when extending arrays of that 
scalar type. For integers and natural numbers, this fill element is 
zero. For characters it is the space character.
*}

class scalar = fixes fill :: 'a

instantiation int and nat :: scalar
begin
  definition fill_int :: int where "fill_int \<equiv> 0"
  definition fill_nat :: nat where "fill_nat \<equiv> 0"
  instance by default
end

text {*
Arrays themselves have two important parts. Firstly, they have a shape, 
which describes their form, their dimensionality, and the sizes of 
the various dimensions of an array. Secondly, they have elements which 
correspond to indices in the range of the shape of the array. Arrays, 
then are composed of a shape which is a @{typ "nat list"} and a 
set of values, which is a @{typ "'a::scalar list"}. A scalar array is 
an array whose dimensionality is the zero, that is, the empty list.
A vector is a 1-dimensional array, and a matrix a 2-dimensional array.
Arrays greater than 2 dimensions are considered noble arrays.
*}

datatype 'a::scalar array = Array "nat list" "'a::scalar list"

text {*
The following to procedures map the common interfaces of creating 
scalars and vectors to the notion of an array. They are also useful in 
that they map to the two forms of constructors that would be used when 
parsing the syntax of APL, as the APL syntax provides only a means of 
entering vectors and scalars directly. 
*}

definition Scalar :: "'a::scalar \<Rightarrow> 'a array" 
where "Scalar s \<equiv> Array [] [s]"

definition Vector :: "'a::scalar list \<Rightarrow> 'a::scalar array" 
where "Vector lst \<equiv> Array [length lst] lst"

subsection {* The shapes of arrays *}

text {*
The @{term shapelst} is a simple field accessor for the @{typ "'a array"} 
type. 
*}

definition shapelst :: "'a::scalar array \<Rightarrow> nat list"
where "shapelst a \<equiv> case a of Array s v \<Rightarrow> s"

text {* The following trivial lemma helps to simplify proofs involving the 
shape field of an array. *}

lemma shapelst_array [simp]: "shapelst (Array s v) = s"
by (simp add: shapelst_def)

text {*
An array's dimensionality is also called its rank, and the following 
function is used to compute the natural number corresponding 
to the rank of an array. This is used to implement the APL notion of 
rank below, in terms of the @{term shape} function.
*}

definition natrank :: "'a::scalar array \<Rightarrow> nat"
where "natrank a \<equiv> length (shapelst a)"

text {*
The following theorems describe
the relationship between the functions @{term "Scalar"} and @{term "Vector"}
and the ranks of their results.
*}

lemma natrank_Scalar [simp]: "natrank (Scalar x) = 0"
by (simp add: natrank_def Scalar_def shapelst_def)

lemma natrank_Vector [simp]: "natrank (Vector s) = 1"
by (simp add: Vector_def natrank_def shapelst_def)

text {*
The @{term natrank} function is not a normal APL function, and is generally 
used only for the definition of the primary APL functions that describe the 
structure of an array. Foremost of these primary functions is the shape 
function, which describes the shape of an array. Namely, the shape of 
an array is the vector whose length is the rank of the array and whose 
values correspond to the size of the dimensions of the array.
*}

definition shape :: "'a::scalar array \<Rightarrow> nat array" 
where "shape a \<equiv> Vector (shapelst a)"

text {* The empty vector, or empty array shows up so often that it has 
its own binding *}

definition Empty :: "'a::scalar array" where "Empty \<equiv> Vector []"

text {*
The following lemmas describe the shapes of vectors and scalars.
*}

lemma shape_Empty [simp]: "shape Empty = Vector [0]"
by (simp add: shape_def Empty_def Vector_def)

lemma shape_Scalar [simp]: "shape (Scalar s) = Vector []"
by (simp add: shape_def Scalar_def Vector_def)

lemma shape_Vector [simp]: "shape (Vector v) = Vector [length v]"
by (simp add: shape_def Vector_def)

lemma shape_Array [simp]: "shape (Array s v) = Vector s"
by (auto simp: shape_def)

text {*
The rank of an array can be described using two applications of the shape 
function, as demonstrated below. Furthermore, we can provide statements 
about the rank of the empty array and scalars, as well as the constancy 
of three applications of shape.
*}

lemma shape_rank [simp]: "shape (shape a) = Vector [natrank a]"
by (simp add: shape_def Vector_def natrank_def)

lemma shape_rank_Empty [simp]: "shape (shape Empty) = Vector [1]"
by simp

lemma shape_rank_Vector [simp]: "shape (shape (Vector a)) = Vector [1]"
by simp

lemma shape_rank_Scalar [simp]: "shape (shape (Scalar a)) = Vector [0]"
by simp

lemma shape3_const [simp]: "shape (shape (shape a)) = Vector [1]"
by simp

text {*
The following lemmas are not part of the original specification of 
the mathematics of arrays, but they are useful enough in the current 
presentation to make them worth having. The @{term shape_vec} lemma 
conflicts with the @{term shape_derived} lemma, so only the 
@{term shape_derived} lemma is added to the simplifier.
*}

lemma shape_derived [simp]: "shape (Array (shapelst s) v) = shape s"
by (simp add: shape_def)

lemma shape_vec: "shape (Array s v) = Vector s"
by (simp add: shape_def)

subsection {* Describing the elements of an array *}

text {*
Describing the elements of an array is slightly more complicated than 
talking about the structure of an array, that is, its shape and rank. 
Conceptually, APL arrays are accessed in row-major order, and the 
definitions here assume that the values list of an @{typ "'a array"} 
corresponds to a row-major unraveling of values. More importantly, 
however, an array created using @{term Array} may not actually be given 
a list of values that is equal in length to the number of elements that 
would be expected given the shape of the array. That is, a vector of 
shape 4 might be given only a single element in its values list. 

The above situation does not result in an invalid array being constructed.
Instead, these arrays are still considered valid, but the values list is 
treated as though it were extended to the appropriate size. This is done 
by a progressive repeating of the same values list over and over again until 
a values list of the right size is given. This is done implicitly in 
APL, but described explicitly here by the @{term sv2vl} function. Given 
an intended size of the eventual list and the original list, the 
function will return the appropriately sized list that corresponds to the 
logical values list of the array.
*}

definition sv2vl :: "nat \<Rightarrow> 'a::scalar list \<Rightarrow> 'a list" where 
  "sv2vl n ls \<equiv> 
     if ls = []
     then (replicate n fill)
     else take n (concat (replicate n ls))"

text {*
The complexity of the above function naturally leads to wanting some 
convenient theorems for working with it. The following two are of 
particular interest in a number of proofs that will follow. The first 
provides a simple means of eliminating @{term sv2vl} from an equation. The 
second allows for the removal of some of the more complicated parts of 
the definition.
*}

lemma sv2vl_id [simp]: "sv2vl (length l) l = l"
by (induct l) (auto simp: sv2vl_def)

lemma sv2vl_sub [simp]: "n \<le> length l \<Longrightarrow> sv2vl n l = take n l"
by (induct n) (auto simp: sv2vl_def)

text {*
To talk about the length of @{term sv2vl} in general takes more work. 
In particular, the length of any list returned by @{term sv2vl} should 
be the same as the first argument passed to @{term sv2vl}. 
Here's a general proof of this statement.
*}

lemma replicate_times [simp]: "listsum (replicate n (x::nat)) = (n * x)"
by (induct n) (auto)

lemma sv2vl_len [simp]: "length (sv2vl n ls) = n" 
by (induct ls) (auto simp: sv2vl_def length_concat)

text {*
A simple case shows up sometimes when dealing with empty 
vectors, so it just makes life easier if this is put into a simplification 
rule.
*}

lemma sv2vl_zero [simp]: "sv2vl 0 x = []"
by (simp add: sv2vl_def)

text {*
The @{term sv2vl} function is used throughout when talking about how 
value of arrays are stored. A thoroughly useful lemma follows, and credit
for the proof as presented here belongs to Andreas Lochbihler. 
The core assertion here is to relate the elements 
of the result returned by @{term sv2vl} to the original list. In this 
case, if the original list was non-empty, then the $i$th element of 
resulting list is the same as the @{term "i mod length ls"} element of 
the original list @{term ls}.
*}

lemma nth_concat_replicate:
  "i < n * length xs
  ==> concat (replicate n xs) ! i = xs ! (i mod length xs)"
by (induct n arbitrary: i) (auto simp add: nth_append mod_geq)

lemma sv2vl_mod [simp]:
  "i < n \<and> ls \<noteq> [] \<Longrightarrow> sv2vl n ls ! i = ls ! (i mod length ls)"
by (auto simp add: sv2vl_def neq_Nil_conv nth_concat_replicate)

text {*
Compositions of @{term sv2vl} may appear, and it is noted here that 
such compositions, provided that they do not change the intended length 
of the resulting list, do not affect the results.
*}

lemma sv2vl_idempotent [simp]: "sv2vl l (sv2vl l a) = sv2vl l a"
by (metis sv2vl_id sv2vl_len)

text {*
Given @{term sv2vl}, the logical values list of an array may be obtained 
fairly directly from the literal values list stored in the actual array 
data structure.
*}

definition valuelst :: "'a::scalar array \<Rightarrow> 'a::scalar list" 
where "valuelst a \<equiv> case a of Array s v \<Rightarrow> sv2vl (foldr times s 1) v"

text {*
When constructed with the @{term Scalar} or @{term Vector} functions, 
the values lists of the resulting arrays is simple and direct.
*}

lemma valuelst_Scalar [simp]: "valuelst (Scalar s) = [s]"
by (auto simp: valuelst_def Scalar_def sv2vl_def)

lemma valuelst_Scalar2 [simp]: "a \<noteq> [] \<Longrightarrow> valuelst (Array [] a) = [a ! 0]"
by (induct a) (auto simp: valuelst_def sv2vl_def)

lemma valuelst_Vector [simp]: "valuelst (Vector v) = v"
by (simp add: Vector_def valuelst_def)

lemma valuelst_Empty [simp]: "valuelst Empty = []"
by (auto simp:  Empty_def)

text {*
There are times when @{term valuelst} can be removed entirely from an 
equation without needing to do further work.
*}

lemma valuelst_known [simp]: "valuelst (Array [length ls] ls) = ls"
by (auto simp: valuelst_def)

subsection {* Equivalence of Arrays *}

text {*
It is now possible to describe the equivalence between two arrays.
Particularly, two arrays are considered @{term array_equiv} equivalent 
if and only if they have the same shape and their elements are the same.
This leads to the following definition of the @{term array_equiv} 
function.
*}

definition array_equiv :: "'a::scalar array \<Rightarrow> 'a array \<Rightarrow> bool" where 
  "array_equiv a b \<equiv> (shapelst a = (shapelst b)) \<and> (valuelst a = (valuelst b))"

text {*
And some simple, obvious properties ought to exist for this definition.
*}

lemma array_equiv_reflex [simp]: "array_equiv a a"
by (simp add: array_equiv_def)

subsection {* Accessing individual array elements *}

text {*
Before moving on to the description of how one accesses individual 
elements, the relationship between an array and its ``ravel'' should 
happen. Particularly, a ravel of an array is a vector whose elements 
correspond to the row-major selection of that array's elements. This 
is exactly the vector whose values list is the @{term valuelst} of the 
array.
*}

definition ravel :: "'a::scalar array \<Rightarrow> 'a::scalar array"
where "ravel a \<equiv> Vector (valuelst a)"

text {*
When the array in question is a scalar, then its ravel is just the 
vector containing that single element.
*}

lemma ravel_Scalar [simp]: "ravel (Scalar s) = Vector [s]"
by (simp add: ravel_def)

text {*
When raveling a vector, there is nothing to do, so the ravel is 
essentially a no-op.
*}

lemma ravel_Vector [simp]: "ravel (Vector v) = (Vector v)"
by (simp add: ravel_def)

lemma ravel_Empty [simp]: "ravel Empty = Empty"
by (simp add: Empty_def)

text {*
The definition of a values list and of ravel leads to the following 
interesting equality between the shape of a raveled array and the shape 
of the unraveled array
*}

lemma ravel_shape [simp]: "shape (ravel a) = Vector [foldr times (shapelst a) 1]"
by (simp add: ravel_def valuelst_def shapelst_def) (cases a, auto)

text {*
The mathematics of arrays defines two helper functions to describe relations 
between array functions. These are the @{term prod} and @{term total} 
functions, which receive arrays, but return natural numbers.
The @{term prod} function computes the product of a vectors elements.
The @{term total} function computes the total number of elements in an 
array.
*}

definition prod :: "nat array \<Rightarrow> nat"
where "prod a \<equiv> (foldr times (valuelst a) 1)"

definition total :: "'a::scalar array \<Rightarrow> nat"
where "total a \<equiv> prod (shape a)"

text {*
The values of @{term total} for some specific arrays can be simplified.
*}

lemma total_scalar [simp]: "total (Scalar s) = 1"
by (simp add: total_def Scalar_def shape_vec prod_def)

lemma total_vector [simp]: "total (Vector v) = length v"
by (simp add: total_def prod_def)

text {*
The following lemma then follows easily.
*}

lemma prod_total_rav [simp]: "shape (ravel a) = Vector [(total a)]"
proof -
  have "shapelst a = (valuelst (shape a))" by (simp add: shape_def)
  thus ?thesis by (simp add: total_def prod_def)
qed

text {*
Now, to precisely talk about the elements of an array and how they relate 
to indices, the following @{term gamma} function is used. It is the 
usual function used to map multi-dimensional arrays onto a single vector.
*}

fun lstgamma :: "nat list \<Rightarrow> nat list \<Rightarrow> nat" where
    "lstgamma i [] = 0"
  | "lstgamma [] s = 0"
  | "lstgamma [i] [s] = i"
  | "lstgamma (i # it) (s # st) = (foldr op * st i + lstgamma it st)"

definition gamma :: "nat array \<Rightarrow> nat array \<Rightarrow> nat"
where "gamma i s \<equiv> lstgamma (valuelst i) (valuelst s)"

text {*
The following lemmas make it easier to prove things about @{term gamma}.
*}

lemma gamma_Empty [simp]: 
  "gamma Empty Empty = 0"
by (auto simp: gamma_def Empty_def)

lemma gamma_Vector_Empty [simp]:
  "gamma (Vector []) (Vector []) = 0"
by (auto simp: gamma_def)

lemma gamma_Vector [simp]: 
  "gamma (Vector (i # it)) (Vector (s # st)) 
   = (foldr op * st i + gamma (Vector it) (Vector st))"
by (induct "(i # it) " "s # st" rule: lstgamma.induct) (auto simp: gamma_def)

text {* 
With the definition of @{term gamma}, a precise definition can be written 
that allows one to extract a single element from an array. This function 
is called @{term array_get} and expects a single vector array index 
and an array, and returns the element at that index.
*}

definition array_get :: "nat array \<Rightarrow> 'a::scalar array \<Rightarrow> 'a"
where "array_get i a \<equiv> (valuelst a) ! (gamma i (shape a))"

text {*
Accessing the @{term i}th element of the array @{term a} is only valid 
if the index vector @{term i} is in range of the shape @{term s} of 
@{term a}. This is expressed by the following definition of 
@{term in_range}.
*}

definition in_range :: "nat array \<Rightarrow> nat array \<Rightarrow> bool"
where "in_range i s \<equiv> (list_all2 op < (valuelst i) (valuelst s))"

text {*
A particular lemma that falls out of the concept of being in range 
relates to empty arrays. This is not including explicitly in the 
mathematics of arrays, but it makes a nice addition here to the set of 
lemmas to be used for proofs. In particular, if an index is in range, 
this implies that the shape vector has no zeros in it.
*}

lemma foldr_imp: "0 \<notin> set b \<Longrightarrow> 0 < foldr op * b (Suc 0)" 
by (induct b) (auto)

lemma listall_imp: "list_all2 op < a (b::nat list) \<Longrightarrow> 0 \<notin> set b"
  by (induct b arbitrary: a) (auto simp: list_all2_Cons2)

lemma in_range_nonzero [simp]: "in_range i s \<Longrightarrow> prod s \<noteq> 0"
by (simp add: in_range_def prod_def listall_imp foldr_imp)

text {*
Defining ranges over vectors also makes proofs easier.
*}

lemma in_range_Vector [simp]: "in_range (Vector i) (Vector s) = list_all2 op < i s"
by (auto simp: in_range_def)

text {*
When reasoning about the indexes of operations, it's important to be able 
to talk about the range of an index vector in relation to the range of 
the @{term gamma} function. The following range lemma relates the two.
*}

lemma irg_help: "foldr op * s x = x * foldr op * s (Suc 0)"
by (induct s) (auto)

lemma irg_help2 [simp]: 
  "(y::nat) < (x::nat) \<Longrightarrow> (i::nat) < (s::nat) \<Longrightarrow> i * x + y < s * x"
proof - 
  assume a: "i < s" and b: "y < x"
  from b have "(i * x) + y < (i * x) + x" by simp 
  moreover from a have "(i * x) + x \<le> s * x" by (induct s) (auto)
  ultimately show "i * x + y < s * x" by auto
qed

lemma in_range_gamma [simp]: 
  "in_range (Vector i) (Vector s) 
   \<Longrightarrow> gamma (Vector i) (Vector s) < foldr op * s (Suc 0)"
by (induct i s rule: lstgamma.induct, auto)
   (metis irg_help irg_help2,
    metis (full_types) irg_help irg_help2 nat_mult_assoc nat_mult_commute)

text {*
With the @{term in_range_gamma} it is now possible to state an useful 
theorem about the relationship between nth element of an original list 
and the result of @{term valuelst}.
*}

lemma valuelst_mod [simp]:
  "v \<noteq> [] \<and> in_range (Vector i) (Vector s)
   \<Longrightarrow> valuelst (Array s v) ! (gamma (Vector i) (Vector s))
       = v ! (gamma (Vector i) (Vector s) mod length v)"
by (auto simp: valuelst_def)

text {*
The @{term gammainv} function defines the inverse of the @{term gamma}
function.
*}

fun lstgammainv :: "nat \<Rightarrow> nat \<Rightarrow> nat list \<Rightarrow> nat list" where
    "lstgammainv d n [] = []"
  | "lstgammainv d n [x] = [n]"
  | "lstgammainv d n ls = (lstgammainv d (n div d) (butlast ls) @ [n mod d])"

definition gammainv :: "nat \<Rightarrow> nat array \<Rightarrow> nat array"
where "gammainv n x = Vector (lstgammainv (prod x) n (valuelst x))"

text {*
(Ed: We are missing some proofs of the inverseness of the 
@{term gammainv} function, but those should arrive at some point.)
*}

(* Need a proof of inverseness here!

lemma gammainv_inverse [simp]: "gamma (gammainv n x) x = n"
sorry

lemma gamma_inverse [simp]: "gammainv (gamma i x) x = i"
sorry

*)

subsection {* Constructing arrays *}

subsubsection {* Reshaping arrays *}

text {*
Most arrays in APL are created through means other than @{term Scalar}
or @{term Vector}. In particular, generally, arrays of higher dimensionality 
than 1 generally must be created---or should be created---by taking a 
vector or scalar array and reshaping it using the @{term reshape} function.
This function takes a new shape described by a @{typ "nat array"} and 
the old array, and returns the new array with the new shape.
*}

definition reshape :: "nat array \<Rightarrow> 'a::scalar array \<Rightarrow> 'a array"
where "reshape s a \<equiv> Array (valuelst s) (valuelst a)"

text {*
We want a lemma that describes the shape of a reshaped array 
simply, but we only care to state this about valid shapes, which are 
@{typ "nat array"} values of rank 1. 
*}

lemma reshape_shape [simp]: "shape (reshape (Vector s) a) = Vector s"
by (simp add: reshape_def shape_vec)

text {*
It also does not matter whether an array is raveled before being 
reshaped, as the resulting array is the same.
*}

lemma reshape_ravel [simp]: 
  "reshape (Vector s) (ravel a) = (reshape (Vector s) a)"
by (simp add: reshape_def ravel_def)

text {*
Empty arrays of different dimensions are created by giving a shape 
to @{term reshape} that contains a zero in it somewhere. The result 
is an array with an empty value list. These should really be equalities 
rather than implications, but that's for another day. In particular, these 
establish the basic property of what it means to be an empty array. The 
value list of an empty array is the nil list, and the shape of an empty 
array always has a zero in it somewhere. 
*}

(* XXX These should be stronger, using equality *)

lemma reshape_emptyshp [simp]: 
  "(prod s = 0) \<Longrightarrow> ((valuelst (reshape s x)) = [])"
by (simp add: prod_def valuelst_def reshape_def)

lemma emptyshape_emptyvl [simp]:
  "prod (Vector s) = 0 \<Longrightarrow> (valuelst (Array s x)) = []"
by (simp add: prod_def valuelst_def Vector_def)

text {*
Scalar arrays are created using reshape by reshaping an array by 
@{term Empty}. This leads to the following lemma. The precondition 
on the statement is necessary, as we must have a non-empty array 
for this to hold.
*}

lemma reshape_scalar [simp]: 
  "valuelst a \<noteq> [] \<Longrightarrow>
     (array_equiv 
       (reshape Empty a) 
       (Scalar (array_get (Vector [0]) (ravel a))))"
by (auto simp: array_equiv_def array_get_def reshape_def Scalar_def ravel_def)

text {*
The above lemmas serve to prompt a more general equivalence between an 
array and the reshapes of that array which use the same shape as the original 
array. Namely, reshaping an array with its own shape 
leads to an equivalent array, and reshaping an array's ravel with the 
shape of the array will also lead to an array that is equivalent to the 
original array. In order to prove these things, it is very helpful
to have a few lemmas that discuss the properties of some of the underlying 
functions that drive the definitions of @{term valuelst}. Namely, 
the composition or nesting of @{term sv2vl} calls does not affect the 
result, and constructing an array frxom the value list of another array 
will lead to equivalent value lists.
*}

lemma valuelst_equiv [simp]: 
  "valuelst (Array (shapelst a) (valuelst a)) = valuelst a"
by (cases a) (auto simp: valuelst_def)

text {*
With these helper lemmas out of the way, the equivalency of reshapes 
using an array's original shape can now be stated directly.
*}

lemma reshape_equiv [simp]: "array_equiv a (reshape (shape a) a)"
by (simp add: reshape_def array_equiv_def shape_def)

lemma reshape_ravel_equiv [simp]: "array_equiv a (reshape (shape a) (ravel a))"
by (simp add: reshape_def array_equiv_def shape_def ravel_def)

text {*
Proofs involving reshaping of vectors can be simplified using the following
lemma.
*}

lemma reshape_Vec [simp]: "reshape (Vector s) (Vector v) = (Array s v)"
by (auto simp: reshape_def)

text {*
Finally, before moving on, the results of indexing into a reshaped vector
can be state fairly easily. The proof here relies heavily on previous 
theorems @{term in_range_gamma} and @{term valuelst_mod}.
*}

instantiation nat :: semiring_div begin end

lemma vector_notempty_len [simp]: "(Empty \<noteq> Vector v) = (v \<noteq> [])"
by (simp add: Empty_def Vector_def)

lemma reshape_index_vec [simp]:
  "Empty \<noteq> (Vector v) \<and> Empty \<noteq> (Vector s) \<and> in_range (Vector i) (Vector s)
     \<Longrightarrow> (array_get (Vector i) (reshape (Vector s) (Vector v)) 
           = v ! (gamma (Vector i) (Vector s) mod (total (Vector v))))"
by (auto simp: array_get_def)

subsubsection {* Catenating Vectors *}

text {*
Catenating two vectors is the simpler operation than catenating full 
blown arrays. Thus, catenation of vectors will be defined here first, and 
later section will deal with the issues of extending this definition to 
handle higher dimension arrays.

Catenation of vectors definition looks like this:
*}

definition catvec :: "'a::scalar array \<Rightarrow> 'a array \<Rightarrow> 'a array" where
  "catvec a b \<equiv> 
    (Array [length (valuelst a) + (length (valuelst b))]
           (valuelst a @ valuelst b))"

text {*
The following lemmas describe how indexing behaves on catenated vectors.
(Ed: These indexing ones are a little tricky, as above, so I am not going 
to prove this one right now.)
*}

lemma catvec_index_first:
  "0 \<le> i \<and> i < (total (Vector x)) 
   \<and> in_range (Vector [i]) (shape (catvec (Vector x) (Vector y)))
   \<Longrightarrow> array_get (Vector [i]) (catvec (Vector x) (Vector y))
       = array_get (Vector [i]) (Vector x)"
by (auto simp: array_get_def catvec_def)
   (metis (lifting) length_append nth_append valuelst_known)

lemma catvec_index_second:
  "total (Vector x) \<le> i \<Longrightarrow> 
   array_get (Vector [i]) (catvec (Vector x) (Vector y))
   = array_get (Vector [i - (total (Vector x))]) (Vector y)"
by (auto simp: catvec_def array_get_def)
   (metis leD length_append nth_append valuelst_known)

text {*
The number of elements in a catenated array is a function of the 
elements in the arguments, stated as the following lemma.
*}

lemma catvec_total [simp]: 
  "total (catvec (Vector x) (Vector y)) = (total (Vector x)) + (total (Vector y))"
by (simp add: catvec_def total_def shape_def Vector_def prod_def valuelst_def)

text {*
Thus the shape of a catvec can be described using the following lemma.
*}

lemma catvec_shape [simp]:
  "shape (catvec (Vector x) (Vector y)) 
     = (Vector [((total (Vector x)) + (total (Vector y)))])"
by (simp add: catvec_def Vector_def shape_def total_def prod_def valuelst_def)

text {*
Vector catenation obeys the following common properties.
*}

lemma catvec_zero [simp]: "catvec Empty (Vector x) = (Vector x)"
by (simp add: Empty_def catvec_def Vector_def valuelst_def)

lemma catvec_zero2 [simp]: "catvec (Vector x) Empty = (Vector x)"
by (simp add: Empty_def catvec_def Vector_def valuelst_def)

lemma catvec_commute [simp]:
  "catvec (Vector x) (catvec (Vector y) (Vector z))
     = catvec (catvec (Vector x) (Vector y)) (Vector z)"
by (auto simp: catvec_def valuelst_def)

text {*
The above definition of vector catenation is nice because it also allows 
easy extension to handle scalars. The following lemmas follow from the 
above definition, and specify the behavior of scalar catenation with 
vectors as vector operations alone.
*}

lemma catvec_scalar [simp]: 
  "catvec (Scalar s) (Vector x) = catvec (Vector [s]) (Vector x)"
by (simp add: catvec_def)

lemma catvec_scalar2 [simp]:
  "catvec (Vector x) (Scalar s) = catvec (Vector x) (Vector [s])"
by (simp add: catvec_def)

lemma catvec_scalar3 [simp]:
  "catvec (Scalar s) (Scalar t) = catvec (Vector [s]) (Vector [t])"
by (simp add: catvec_def)

subsection {* Scalar functions over arrays *}

text {*
Scalar functions are those functions which operate on scalar elements 
inside of an array. To be able to take any function over 
scalar values and create a scalar apl function which is a point-wise 
and scalar extension of the original function, the following defines 
a higher-order operations @{term sclfunmon} and @{term sclfundya}
that create scalar apl functions 
given a normal scalar element function. They assume that the given 
arrays are of the same shape.
*}

definition sclfunmon :: "('a::scalar \<Rightarrow> 'b::scalar) \<Rightarrow> 'a array \<Rightarrow> 'b array"
where "sclfunmon f a \<equiv> Array (shapelst a) [f e. e \<leftarrow> valuelst a]"

definition sclfundya :: 
  "('a::scalar \<Rightarrow> 'b::scalar \<Rightarrow> 'c::scalar) \<Rightarrow> 'a array \<Rightarrow> 'b array \<Rightarrow> 'c array"
where 
  "sclfundya f a b \<equiv> Array (shapelst a) [f x y. x \<leftarrow> valuelst a, y \<leftarrow> valuelst b]"

text {*
The above definitions sufficiently implement the following specification, 
which captures the main intent behind scalar functions. Specifically, 
there are two primary lemmas which state the shape of the result of 
apply a scalar function and how indexing operations are affected.
Dealing with shapes first, a monadic function preserves the shape of 
its input in the output. A dyadic function preserves the shape 
of its inputs if they have the same shape.
*}

lemma sclfunmon_shape [simp]: "(array_equiv (shape a) (shape (sclfunmon f a)))"
by (simp add: sclfunmon_def del: shape_vec)

lemma sclfundya_shape [simp]:
  "(array_equiv (shape a) (shape b)) \<Longrightarrow> 
     (array_equiv (shape a) (shape (sclfundya f a b)))"
by (auto simp: sclfundya_def shape_def)

text {* 
Proving statements about the indexing of the scalar operations is a little 
more tricky, so this is left until later. (Ed: See the comments in the 
source file, as it contains the import elements and what I have managed 
to put together so far. Basically, I need some statements about valid 
indices before I can make things happen.)
*}

(*
lemma valuelst_map [simp]: 
  "valuelst (Array (shapelst a) (map f (valuelst a)))
     = (map f (valuelst a))"
sorry

lemma array_get_map [simp]:
  "array_get i (Array (shapelst a) (map f (valuelst a)))
     = f (array_get i a)"
apply (simp add: array_get_def)
find_theorems "map _ _ ! _" 

lemma sclfunmon_index [simp]: "array_get i (sclfunmon f a) = f (array_get i a)"
by (simp add: sclfunmon_def)
*)

subsection {* Constructing vectors of integers *}

subsection {* Take and Drop on Arrays *}

subsection {* Subarray indexing *}

subsection {* Reduce and Scan *}

subsection {* Catenation of Arrays of higher dimensionality *}

subsection {* Extending scan *}

subsection {* Properties for indexing operations and catenation *}

subsection {* Extending Iota for vectors *}

subsection {* Compress and Expand *}

subsection {* Reverse and rotate *}

subsection {* Take and Drop with Non-scalar left arguments *}

subsection {* Rotation of non-scalar left arguments *}

subsection {* Transposition *}

subsection {* Important lemmas for take, drop, rotate and catenate *}

subsection {* Higher-order Operations *}

subsubsection {* Omega Operator *}

subsubsection {* Outer and Inner Product *}

subsubsection {* Application to subarrays *}

end
