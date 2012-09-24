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
an intended size of the eventual list, the original list, and 
the actual list being processed (the original list and actual list should 
be the same list when the function is called first, and the actual list 
should only be different from the original list when recuring), the 
function will return the appropriately sized list that corresponds to the 
logical values list of the array.
*}

fun sv2vl :: "nat \<Rightarrow> 'a::scalar list \<Rightarrow> 'a::scalar list \<Rightarrow> 'a::scalar list" where
    "sv2vl 0 orig lst = []"
  | "sv2vl cnt [] [] = (replicate cnt fill)"
  | "sv2vl (Suc cnt) (oel # ors) [] = (oel # (sv2vl cnt (oel # ors) ors))"
  | "sv2vl (Suc cnt) orig (elm # rst) = (elm # (sv2vl cnt orig rst))"

text {*
The complexity of the above function naturally leads to wanting some 
convenient theorems for working with it. The following two are of 
particular interest in a number of proofs that will follow.
*}

lemma sv2vl_id [simp]: "sv2vl (length l) orig l = l"
by (induct l) simp_all

lemma sv2vl_len [simp]: "length (sv2vl x y z) = x"
by (induct x y z rule: sv2vl.induct) (auto)

text {*
Given @{term sv2vl}, the logical values list of an array may be obtained 
fairly directly from the literal values list stored in the actual array 
data structure.
*}

definition valuelst :: "'a::scalar array \<Rightarrow> 'a::scalar list" 
where "valuelst a \<equiv> case a of Array s v \<Rightarrow> sv2vl (foldr times s 1) v v"

text {*
When constructed with the @{term Scalar} or @{term Vector} functions, 
the values lists of the resulting arrays is simple and direct.
*}

lemma valuelst_Scalar [simp]: "valuelst (Scalar s) = [s]"
by (simp add: valuelst_def Scalar_def)

lemma valuelst_Vector [simp]: "valuelst (Vector v) = v"
by (simp add: Vector_def valuelst_def)

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
    "lstgamma [] [] = 0"
  | "lstgamma [a] [b] = a"
  | "lstgamma a b = (last a) + (last b * (lstgamma (butlast a) (butlast b)))"

definition gamma :: "nat array \<Rightarrow> nat array \<Rightarrow> nat"
where "gamma a b \<equiv> lstgamma (valuelst a) (valuelst b)"

text {* 
With the definition of @{term gamma}, a precise definition can be written 
that allows one to extract a single element from an array. This function 
is called @{term array_get} and expects a single vector array index 
and an array, and returns the element at that index.
*}

definition array_get :: "nat array \<Rightarrow> 'a::scalar array \<Rightarrow> 'a"
where "array_get i a \<equiv> (valuelst a) ! (gamma i (shape a))"

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
vector or scalar array and reshaping it using the @{term reshap} function.
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
by (simp add: reshape_def shape_def)

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

lemma valuelst_scalar [simp]: "a \<noteq> [] \<Longrightarrow> valuelst (Array [] a) = [a ! 0]"
by (induct a) (simp_all add: valuelst_def)

lemma reshape_scalar [simp]: 
  "valuelst a \<noteq> [] \<Longrightarrow>
     (array_equiv 
       (reshape Empty a) 
       (Scalar (array_get (Vector [0]) (ravel a))))"
by (simp add: ravel_def array_get_def gamma_def Scalar_def reshape_def
                 Empty_def array_equiv_def)

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
result, and constructing an array from the value list of another array 
will lead to equivalent value lists.
*}

lemma sv2vl_idempotent [simp]: 
  "sv2vl l (sv2vl l a b) (sv2vl l a b) = sv2vl l a b"
by (metis sv2vl_id sv2vl_len)

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
Finally, before moving on, the results of indexing into a reshaped vector
can be state fairly easily. (Ed: Unfortunately, it takes a bit more thought to 
actually prove the thing, so I am leaving this until later.)
*}

(*
lemma reshape_index_vec [simp]:
  "array_get i (reshape s (Vector v)) = v ! (gamma i s) mod (total (Vector v))"
*)

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
The following lemma describes how indexing behaves on catenated vectors.
(Ed: These indexing ones are a little tricky, as above, so I am not going 
to prove this one right now.)
*}

(*
lemma catvec_index:
  "array_get (Vector [i]) (catvec (Vector x) (Vector y))
     = (if (0 \<le> i \<and> i < (total (Vector x)))
       then array_get (Vector [i]) (Vector x)
       else array_get (Vector [i - (total (Vector x))]) (Vector y))"
*)

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
by (auto simp: catvec_def valuelst_def Vector_def)
   (metis append_assoc length_append sv2vl_id)

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

end
