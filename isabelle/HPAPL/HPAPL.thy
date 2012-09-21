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

definition Vector :: "'a::scalar list => 'a::scalar array" 
where "Vector lst \<equiv> Array [length lst] lst"

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

(*

definition listprod :: "nat list \<Rightarrow> nat"
where "listprod x = foldr times x 1"

fun sv2vl :: "nat \<Rightarrow> 'a::scalar list \<Rightarrow> 'a::scalar list \<Rightarrow> 'a::scalar list" where
    "sv2vl 0 orig lst = []"
  | "sv2vl cnt [] [] = (replicate cnt fill)"
  | "sv2vl (Suc cnt) (oel # ors) [] = (oel # (sv2vl cnt (oel # ors) ors))"
  | "sv2vl (Suc cnt) orig (elm # rst) = (elm # (sv2vl cnt orig rst))"

lemma sv2vl_id [simp]: "sv2vl (length l) orig l = l"
by (induct l) simp_all

lemma sv2vl_len [simp]: "length (sv2vl x y z) = x"
by (induct x y z rule: sv2vl.induct) (auto)

definition valuelst :: "'a::scalar array \<Rightarrow> 'a::scalar list" 
where "valuelst a \<equiv> case a of Array s v \<Rightarrow> sv2vl (listprod s) v v"

lemma vector_valuelst [simp]: "valuelst (Vector a) = a"
by (simp add: Vector_def valuelst_def listprod_def)

lemma valuelst_length [simp]: "listprod (shapelst a) = (length (valuelst a))"
by (simp add: valuelst_def shapelst_def) (cases a, auto)

lemma natrank_Empty [simp]: "natrank Empty = 1"
by (simp add: Empty_def natrank_def shapelst_def)

definition vec2lst :: "'a::scalar array \<Rightarrow> 'a::scalar list"
where "vec2lst vec \<equiv> case vec of Array s v \<Rightarrow> v"

theorem vector_shape [simp]: "shapelst (Vector s) = [length s]"
by (simp add: Vector_def shapelst_def)

theorem vector_inverse [simp]: "vec2lst (Vector lst) = lst"
by (simp add: Vector_def vec2lst_def)

theorem vector_empty: "Vector [] = Empty"
by (simp add: Vector_def Empty_def)

theorem vec2lst_empty [simp]: "vec2lst Empty = []"
by (simp add: Empty_def vec2lst_def)

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

theorem index_vector [simp]: 
  "i < length l \<Longrightarrow> index (Vector [i]) (Vector l) = l ! i"
by (simp add: index_def Vector_def valuelst_def shapelst_def listprod_def
                 index_unraveled_def)

definition arrequal :: "'a::scalar array \<Rightarrow> 'a array \<Rightarrow> bool" where 
  "arrequal a b \<equiv> (shapelst a) = (shapelst b) \<and> (valuelst a) = (valuelst b)"

definition reshape :: "nat array \<Rightarrow> 'a::scalar array \<Rightarrow> 'a array"
where "reshape ns a \<equiv> Array (valuelst ns) (valuelst a)"

theorem shape_preserved [simp]: "arrequal a (reshape (shape a) a)"
by (simp add: arrequal_def reshape_def shape_def) (simp add: valuelst_def)

definition index_gen :: "nat array \<Rightarrow> nat array" where 
  "index_gen a \<equiv>
     case a of
         Array [] x \<Rightarrow> Array [hd (valuelst a)] (upt 0 (hd (valuelst a)))
       | Array [n] x \<Rightarrow> Empty"
(*
       | Array [n] x \<Rightarrow> Array [(listprod (valuelst a)), n] 
                         (flatten (map (idx_lst (valuelst a)) 
                                       [0..<listprod (valuelst a)]))"
*)

theorem index_gen_scl_len [simp]: 
  "length (valuelst (index_gen (Scalar n))) = n"
by (simp add: index_gen_def Scalar_def valuelst_def listprod_def)

lemma sv2vl_lst [simp]: "sv2vl n x [0..<n] = [0..<n]"
proof -
  have "sv2vl n x [0..<n] = (sv2vl (length [0..<n]) x [0..<n])" by simp
  also have "... = [0..<n]" unfolding sv2vl_id ..
  finally show "sv2vl n x [0..<n] = ([0..<n])" .
qed

theorem index_gen_scl_vl [simp]:
  "(valuelst (index_gen (Scalar n))) = (upt 0 n)"
by (simp add: index_gen_def Scalar_def valuelst_def listprod_def)

theorem index_gen_scl_shp [simp]:
  "(shapelst (index_gen (Scalar n))) = [n]"
by (simp add: index_gen_def Scalar_def valuelst_def listprod_def)

definition msop :: "('a::scalar \<Rightarrow> 'b::scalar) \<Rightarrow> 'a array \<Rightarrow> 'b array" 
where "msop f a \<equiv> Array (shapelst a) (map f (valuelst a))"

fun dsop :: "('a::scalar \<Rightarrow> 'b::scalar \<Rightarrow> 'c::scalar)
                         \<Rightarrow> 'a array \<Rightarrow> 'b array \<Rightarrow> 'c array"
where 
    "dsop f (Array [] a) (Array [] b) =
      (Array [] 
        [f av bv. 
         av \<leftarrow> (valuelst (Array [] a)), bv \<leftarrow> (valuelst (Array [] b))])"
  | "dsop f (Array (x # xs) a) (Array [] b) =
      (Array (x # xs) 
        [f av bv. 
         av \<leftarrow> (valuelst (Array (x # xs) a)),
         bv \<leftarrow> (valuelst (Array (x # xs) (valuelst (Array [] b))))])"
  | "dsop f (Array [] a) (Array (x # xs) b) =
      (Array (x # xs)
        [f av bv.
         av \<leftarrow> (valuelst (Array (x # xs) (valuelst (Array [] a)))),
         bv \<leftarrow> (valuelst (Array (x # xs) b))])"
  | "dsop f a b = 
      (Array (shapelst a) [f av bv. av \<leftarrow> (valuelst a), bv \<leftarrow> (valuelst b)])"

definition firstval :: "'a::scalar array \<Rightarrow> 'a"
where "firstval a \<equiv> hd (valuelst a)"

definition first :: "'a::scalar array \<Rightarrow> 'a array" 
where "first a \<equiv> Array [] [firstval a]"

definition msafun :: "('a::scalar array \<Rightarrow> 'b::scalar array) 
                      \<Rightarrow> 'a \<Rightarrow> 'b"
where "msafun f x \<equiv> firstval (f (Array [] [x]))"

definition dsafun :: "('a::scalar array \<Rightarrow> 'b::scalar array \<Rightarrow> 'c::scalar array)
                      \<Rightarrow> 'a \<Rightarrow> 'b \<Rightarrow> 'c"
where "dsafun f x y \<equiv> firstval (f (Array [] [x]) (Array [] [y]))"

definition eachm :: "('a::scalar array \<Rightarrow> 'b::scalar array)
                     \<Rightarrow> 'a array \<Rightarrow> 'b array"
where "eachm f a \<equiv> msop (msafun f) a"

definition eachd :: "('a::scalar array \<Rightarrow> 'b::scalar array \<Rightarrow> 'c::scalar array)
                     \<Rightarrow> 'a array \<Rightarrow> 'b array \<Rightarrow> 'c array"
where
  "eachd f a b \<equiv> dsop (dsafun f) a b"

primrec listscan :: "('a \<Rightarrow> 'a \<Rightarrow> 'a) \<Rightarrow> 'a list \<Rightarrow> 'a list \<Rightarrow> 'a list" where 
    "listscan f s [] = []"
  | "listscan f s (x # xs) = [foldr f s x] @ listscan f (s @ [x]) xs"

definition scan :: "('a::scalar array \<Rightarrow> 'a::scalar array \<Rightarrow> 'a::scalar array) 
                    \<Rightarrow> 'a array \<Rightarrow> 'a array"
where "scan f a \<equiv> Array (shapelst a) (listscan (dsafun f) [] (valuelst a))"

definition reduce :: "('a::scalar array \<Rightarrow> 'a::scalar array \<Rightarrow> 'a::scalar array)
                      \<Rightarrow> 'a array \<Rightarrow> 'a array"
where "reduce f a \<equiv> Array [] [last (valuelst (scan f a))]"
*)
(* datatype prog = Prog sig "stmt list"
      and sig = Mon string string "string list"
              | Dya string string string "string list"
              | MonMonOp string string string "string list"
              | MonDyaOp string string string string "string list"
              | DyaMonOp string string string string "string list"
              | DyaDyaOp string string string string string "string list"
     and stmt = EStmt exp | AStmt string exp | FStmt string func
              | OStmt string oper | SelStmt exp exp
              | IfEStmt exp exp | IfAStmt exp string exp | IfFStmt string func
              | IfOStmt string oper | IfSelStmt exp exp
      and exp = ValNat "nat list" | ValInt "int list" | Var string 
              | Zilde | Donut | Alpha | Omega | AlphaAlpha | OmegaOmega
              | MApp func exp | DApp func exp exp 
     and func = AnonF "stmt list" | FNam string | PrimF primf
              | DFFOp oper func func | DFEOp oper func exp 
              | DEFOp oper exp func | DEEOp oper exp exp
              | MFOp oper func | MEOp oper exp
     and oper = AnonO "stmt list" | ONam string | PrimO primo
    and primf = Rho | Iota | Drop | Take | Index | First | Plus | And 
              | Bang | Comma | Ceil | Floor | Circ | Hook | Decode | Encode 
              | Equiv | Times | Div | Enclose | Memb | Eq | Tilde
              | Expand | Exp | Find | GradeD | GradeU | GrThn | LsThn 
              | GrThnEq | LsThnEq | LTack | RTack | Intersect | Union
              | Log | Bar | Domino | Minus | Nand | Nor | NotEq 
              | Or | Power | Replicate | Rot | Transp
    and primo = Each | Reduce | Scan | Axis | Commute | Compose | InProd
              | OutProd | PowerOp | Spawn | Parallel
*)

end
