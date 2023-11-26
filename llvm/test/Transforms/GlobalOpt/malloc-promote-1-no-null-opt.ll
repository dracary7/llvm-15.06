; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals
; RUN: opt < %s -passes=globalopt -S | FileCheck %s
target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

@G = internal global i32* null          ; <i32**> [#uses=3]

;.
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = internal unnamed_addr global i32* null
;.
define void @init() #0 {
; CHECK-LABEL: @init(
; CHECK-NEXT:    [[MALLOCCALL:%.*]] = tail call i8* @malloc(i64 4)
; CHECK-NEXT:    [[P:%.*]] = bitcast i8* [[MALLOCCALL]] to i32*
; CHECK-NEXT:    store i32* [[P]], i32** @G, align 8
; CHECK-NEXT:    [[GV:%.*]] = load i32*, i32** @G, align 8
; CHECK-NEXT:    store i32 0, i32* [[GV]], align 4
; CHECK-NEXT:    ret void
;
  %malloccall = tail call i8* @malloc(i64 4)
  %P = bitcast i8* %malloccall to i32*
  store i32* %P, i32** @G
  %GV = load i32*, i32** @G
  store i32 0, i32* %GV
  ret void
}

declare noalias i8* @malloc(i64)

define i32 @get() #0 {
; CHECK-LABEL: @get(
; CHECK-NEXT:    [[GV:%.*]] = load i32*, i32** @G, align 8
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[GV]], align 4
; CHECK-NEXT:    ret i32 [[V]]
;
  %GV = load i32*, i32** @G
  %V = load i32, i32* %GV
  ret i32 %V
}

attributes #0 = { null_pointer_is_valid }
;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { null_pointer_is_valid }
;.