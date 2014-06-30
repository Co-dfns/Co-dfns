; ModuleID = 'Unamed Namespace'
target triple = "x86_64-redhat-linux-gnu"

%Array.1 = type { i16, i64, i8, i32*, i8* }

@elems = global [1 x i64] [i64 5]
@shape = global [0 x i32] zeroinitializer
@LC0 = global %Array.1 { i16 0, i64 1, i8 2, i32* getelementptr inbounds ([0 x i32]* @shape, i32 0, i32 0), i8* bitcast ([1 x i64]* @elems to i8*) }

declare void @clean_env(%Array.1*, i32)

declare void @init_env(%Array.1*, i32)

declare i32 @array_cp(%Array.1*, %Array.1*)

declare i32 @array_free(%Array.1*, %Array.1*)

declare i32 @codfns_add(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_subtract(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_divide(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_multiply(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_residue(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_power(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_log(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_max(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_min(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_less(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_less_or_equal(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_equal(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_not_equal(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_greater_or_equal(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_greater(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_squad(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_reshape(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_catenate(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_indexgen(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_ptred(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_index(%Array.1*, %Array.1*, %Array.1*)

declare i32 @codfns_each(%Array.1*, %Array.1*, %Array.1*, i32 (%Array.1*, %Array.1*, %Array.1*, %Array.1**)*, %Array.1**)

define i32 @f(%Array.1*, %Array.1*, %Array.1*) {
  %env0 = alloca %Array.1
  call void @init_env(%Array.1* %env0, i32 1)
  %4 = call i32 @array_cp(%Array.1* %0, %Array.1* @LC0)
  call void @clean_env(%Array.1* %env0, i32 1)
  ret i32 0
}

define i32 @Init(%Array.1*, %Array.1*, %Array.1*) {
  ret i32 0
}
