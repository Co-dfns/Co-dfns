; ModuleID = 'Unamed Namespace'
target triple = "x86_64-redhat-linux-gnu"

%Array.0 = type { i16, i64, i8, i32*, i8* }

@elems = global [1 x i64] [i64 5]
@shape = global [0 x i32] zeroinitializer
@LC0 = global %Array.0 { i16 0, i64 1, i8 2, i32* getelementptr inbounds ([0 x i32]* @shape, i32 0, i32 0), i8* bitcast ([1 x i64]* @elems to i8*) }
@elems1 = global [1 x i64] [i64 1]
@shape2 = global [0 x i32] zeroinitializer
@LC1 = global %Array.0 { i16 0, i64 1, i8 2, i32* getelementptr inbounds ([0 x i32]* @shape2, i32 0, i32 0), i8* bitcast ([1 x i64]* @elems1 to i8*) }

@fd = alias i32 (%Array.0*, %Array.0*, %Array.0*)* @fm
@gd = alias i32 (%Array.0*, %Array.0*, %Array.0*)* @gm

declare void @clean_env(%Array.0*, i32)
declare void @init_env(%Array.0*, i32)
declare i32 @array_cp(%Array.0*, %Array.0*)
declare i32 @codfns_addd(%Array.0*, %Array.0*, %Array.0*)

define i32 @fm(%Array.0*, %Array.0*, %Array.0*) {
  %env0 = alloca %Array.0
  call void @init_env(%Array.0* %env0, i32 1)
  %X = getelementptr %Array.0* %env0, i32 0
  %4 = call i32 @array_cp(%Array.0* %X, %Array.0* @LC0)
  %5 = call i32 @array_cp(%Array.0* %0, %Array.0* %X)
  call void @clean_env(%Array.0* %env0, i32 1)
  ret i32 0
}

define i32 @gm(%Array.0*, %Array.0*, %Array.0*) {
  %env0 = alloca %Array.0
  call void @init_env(%Array.0* %env0, i32 1)
  %X = getelementptr %Array.0* %env0, i32 0
  %4 = call i32 @array_cp(%Array.0* %X, %Array.0* @LC1)
  %5 = call i32 @codfns_addd(%Array.0* %0, %Array.0* %X, %Array.0* %2)
  call void @clean_env(%Array.0* %env0, i32 1)
  ret i32 0
}

define i32 @Init(%Array.0*, %Array.0*, %Array.0*) {
  ret i32 0
}
