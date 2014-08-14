; ModuleID = 'Unamed Namespace'
target triple = "x86_64-redhat-linux-gnu"

%Array = type { i16, i64, i8, i32*, i8* }

@elems = global [1 x i64] [i64 1]
@shape = global [0 x i32] zeroinitializer
@LC0 = global %Array { i16 0, i64 1, i8 2, i32* getelementptr inbounds ([0 x i32]* @shape, i32 0, i32 0), i8* bitcast ([1 x i64]* @elems to i8*) }

@hd = alias i32 (%Array*, %Array*, %Array*)* @hm

declare void @clean_env(%Array*, i32)
declare void @init_env(%Array*, i32)
declare i32 @array_cp(%Array*, %Array*)
declare i32 @codfns_addd(%Array*, %Array*, %Array*)

define i32 @hm(%Array*, %Array*, %Array*) {
  %env0 = alloca %Array, i32 2
  call void @init_env(%Array* %env0, i32 2)
  %X = getelementptr %Array* %env0, i32 0
  %4 = call i32 @array_cp(%Array* %X, %Array* @LC0)
  %exv = getelementptr %Array* %env0, i32 1
  %5 = call i32 @codfns_addd(%Array* %exv, %Array* %1, %Array* %2)
  %6 = call i32 @codfns_addd(%Array* %0, %Array* %X, %Array* %exv)
  call void @clean_env(%Array* %env0, i32 2)
  ret i32 0
}

define i32 @Init(%Array*, %Array*, %Array*) {
  ret i32 0
}
