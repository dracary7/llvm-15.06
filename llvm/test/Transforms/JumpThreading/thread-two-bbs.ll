; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -jump-threading -S -verify | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@a = global i32 0, align 4

; Verify that we branch (twice) on cond2 without checking ptr.
; Verify that we eliminate "bb.file".

define void @foo(i32 %cond1, i32 %cond2) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[COND1:%.*]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[BB_COND2_THREAD:%.*]], label [[BB_COND2:%.*]]
; CHECK:       bb.cond2:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    [[TOBOOL1:%.*]] = icmp eq i32 [[COND2:%.*]], 0
; CHECK-NEXT:    br i1 [[TOBOOL1]], label [[BB_F4:%.*]], label [[BB_F2:%.*]]
; CHECK:       bb.cond2.thread:
; CHECK-NEXT:    [[TOBOOL12:%.*]] = icmp eq i32 [[COND2]], 0
; CHECK-NEXT:    br i1 [[TOBOOL12]], label [[BB_F3:%.*]], label [[BB_F2]]
; CHECK:       bb.f2:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       bb.f3:
; CHECK-NEXT:    call void @f3()
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       bb.f4:
; CHECK-NEXT:    [[PTR3:%.*]] = phi i32* [ null, [[BB_COND2]] ]
; CHECK-NEXT:    call void @f4()
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %tobool = icmp eq i32 %cond1, 0
  br i1 %tobool, label %bb.cond2, label %bb.f1

bb.f1:
  call void @f1()
  br label %bb.cond2

bb.cond2:
  %ptr = phi i32* [ null, %bb.f1 ], [ @a, %entry ]
  %tobool1 = icmp eq i32 %cond2, 0
  br i1 %tobool1, label %bb.file, label %bb.f2

bb.f2:
  call void @f2()
  br label %exit

bb.file:
  %cmp = icmp eq i32* %ptr, null
  br i1 %cmp, label %bb.f4, label %bb.f3

bb.f3:
  call void @f3()
  br label %exit

bb.f4:
  call void @f4()
  br label %exit

exit:
  ret void
}

declare void @f1()
declare void @f2()
declare void @f3()
declare void @f4()


; Verify that we branch (twice) on cond2 without checking tobool again.
; Verify that we eliminate "bb.cond1again".

define void @foo2(i32 %cond1, i32 %cond2) {
; CHECK-LABEL: @foo2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[COND1:%.*]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[BB_COND2:%.*]], label [[BB_COND2_THREAD:%.*]]
; CHECK:       bb.cond2:
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    [[TOBOOL1:%.*]] = icmp eq i32 [[COND2:%.*]], 0
; CHECK-NEXT:    br i1 [[TOBOOL1]], label [[EXIT:%.*]], label [[BB_F3:%.*]]
; CHECK:       bb.cond2.thread:
; CHECK-NEXT:    call void @f2()
; CHECK-NEXT:    [[TOBOOL11:%.*]] = icmp eq i32 [[COND2]], 0
; CHECK-NEXT:    br i1 [[TOBOOL11]], label [[EXIT]], label [[BB_F4:%.*]]
; CHECK:       bb.f3:
; CHECK-NEXT:    call void @f3()
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       bb.f4:
; CHECK-NEXT:    call void @f4()
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %tobool = icmp ne i32 %cond1, 0
  br i1 %tobool, label %bb.f1, label %bb.f2

bb.f1:
  call void @f1()
  br label %bb.cond2

bb.f2:
  call void @f2()
  br label %bb.cond2

bb.cond2:
  %tobool1 = icmp eq i32 %cond2, 0
  br i1 %tobool1, label %exit, label %bb.cond1again

bb.cond1again:
  br i1 %tobool, label %bb.f3, label %bb.f4

bb.f3:
  call void @f3()
  br label %exit

bb.f4:
  call void @f4()
  br label %exit

exit:
  ret void
}


; Verify that we do *not* thread any edge.  We used to evaluate
; constant expressions like:
;
;   icmp ugt i8* null, inttoptr (i64 4 to i8*)
;
; as "true", causing jump threading to a wrong destination.

define void @icmp_ult_null_constexpr(i8* %arg1, i8* %arg2) {
; CHECK-LABEL: @icmp_ult_null_constexpr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8* [[ARG1:%.*]], null
; CHECK-NEXT:    br i1 [[CMP1]], label [[BB_BAR1:%.*]], label [[BB_END:%.*]]
; CHECK:       bb_bar1:
; CHECK-NEXT:    call void @bar(i32 1)
; CHECK-NEXT:    br label [[BB_END]]
; CHECK:       bb_end:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8* [[ARG2:%.*]], null
; CHECK-NEXT:    br i1 [[CMP2]], label [[BB_CONT:%.*]], label [[BB_BAR2:%.*]]
; CHECK:       bb_bar2:
; CHECK-NEXT:    call void @bar(i32 2)
; CHECK-NEXT:    br label [[BB_EXIT:%.*]]
; CHECK:       bb_cont:
; CHECK-NEXT:    [[CMP3:%.*]] = icmp ult i8* [[ARG1]], inttoptr (i64 4 to i8*)
; CHECK-NEXT:    br i1 [[CMP3]], label [[BB_EXIT]], label [[BB_BAR3:%.*]]
; CHECK:       bb_bar3:
; CHECK-NEXT:    call void @bar(i32 3)
; CHECK-NEXT:    br label [[BB_EXIT]]
; CHECK:       bb_exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp1 = icmp eq i8* %arg1, null
  br i1 %cmp1, label %bb_bar1, label %bb_end

bb_bar1:
  call void @bar(i32 1)
  br label %bb_end

bb_end:
  %cmp2 = icmp ne i8* %arg2, null
  br i1 %cmp2, label %bb_cont, label %bb_bar2

bb_bar2:
  call void @bar(i32 2)
  br label %bb_exit

bb_cont:
  %cmp3 = icmp ult i8* %arg1, inttoptr (i64 4 to i8*)
  br i1 %cmp3, label %bb_exit, label %bb_bar3

bb_bar3:
  call void @bar(i32 3)
  br label %bb_exit

bb_exit:
  ret void
}

; This is a special-case of the above pattern:
; Null is guaranteed to be unsigned <= all values.

define void @icmp_ule_null_constexpr(i8* %arg1, i8* %arg2) {
; CHECK-LABEL: @icmp_ule_null_constexpr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8* [[ARG1:%.*]], null
; CHECK-NEXT:    br i1 [[CMP1]], label [[BB_END_THREAD:%.*]], label [[BB_END:%.*]]
; CHECK:       bb_end:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8* [[ARG2:%.*]], null
; CHECK-NEXT:    br i1 [[CMP2]], label [[BB_CONT:%.*]], label [[BB_BAR2:%.*]]
; CHECK:       bb_end.thread:
; CHECK-NEXT:    call void @bar(i32 1)
; CHECK-NEXT:    [[CMP21:%.*]] = icmp ne i8* [[ARG2]], null
; CHECK-NEXT:    br i1 [[CMP21]], label [[BB_EXIT:%.*]], label [[BB_BAR2]]
; CHECK:       bb_bar2:
; CHECK-NEXT:    call void @bar(i32 2)
; CHECK-NEXT:    br label [[BB_EXIT]]
; CHECK:       bb_cont:
; CHECK-NEXT:    [[CMP3:%.*]] = icmp ule i8* [[ARG1]], inttoptr (i64 4 to i8*)
; CHECK-NEXT:    br i1 [[CMP3]], label [[BB_EXIT]], label [[BB_BAR3:%.*]]
; CHECK:       bb_bar3:
; CHECK-NEXT:    call void @bar(i32 3)
; CHECK-NEXT:    br label [[BB_EXIT]]
; CHECK:       bb_exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp1 = icmp eq i8* %arg1, null
  br i1 %cmp1, label %bb_bar1, label %bb_end

bb_bar1:
  call void @bar(i32 1)
  br label %bb_end

bb_end:
  %cmp2 = icmp ne i8* %arg2, null
  br i1 %cmp2, label %bb_cont, label %bb_bar2

bb_bar2:
  call void @bar(i32 2)
  br label %bb_exit

bb_cont:
  %cmp3 = icmp ule i8* %arg1, inttoptr (i64 4 to i8*)
  br i1 %cmp3, label %bb_exit, label %bb_bar3

bb_bar3:
  call void @bar(i32 3)
  br label %bb_exit

bb_exit:
  ret void
}

declare void @bar(i32)


;; Test that we skip unconditional PredBB when threading jumps through two
;; successive basic blocks.

define i32 @foo4(i32* %0) {
; CHECK-LABEL: @foo4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SIZE:%.*]] = call i64 @get_size(i32* [[TMP0:%.*]])
; CHECK-NEXT:    [[GOOD:%.*]] = icmp ugt i64 [[SIZE]], 3
; CHECK-NEXT:    br i1 [[GOOD]], label [[PRED_BB:%.*]], label [[PRED_PRED_BB:%.*]]
; CHECK:       pred.pred.bb:
; CHECK-NEXT:    call void @effect()
; CHECK-NEXT:    br label [[PRED_BB]]
; CHECK:       pred.bb:
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[TMP0]], align 4
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    call void @effect1(i8* blockaddress(@foo4, [[BB]]))
; CHECK-NEXT:    br i1 [[GOOD]], label [[EXIT:%.*]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[V]]
;
entry:
  %size = call i64 @get_size(i32* %0)
  %good = icmp ugt i64 %size, 3
  br i1 %good, label %pred.bb, label %pred.pred.bb

pred.pred.bb:                                        ; preds = %entry
  call void @effect()
  br label %pred.bb
pred.bb:                                             ; preds = %pred.pred.bb, %entry
  %v = load i32, i32* %0
  br label %bb

bb:                                                  ; preds = %pred.bb
  call void @effect1(i8* blockaddress(@foo4, %bb))
  br i1 %good, label %cont2, label %cont1

cont1:                                               ; preds = %bb
  br i1 %good, label %exit, label %cont2
cont2:                                               ; preds = %bb
  br label %exit
exit:                                                ; preds = %cont1, %cont2
  ret i32 %v
}

declare i64 @get_size(i32*)
declare void @effect()
declare void @effect1(i8*)