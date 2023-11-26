; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv32 -mattr=+m | FileCheck %s --check-prefix=RV32I
; RUN: llc < %s -mtriple=riscv64 -mattr=+m | FileCheck %s --check-prefix=RV64I
; RUN: llc < %s -mtriple=riscv32 -mattr=+m,+zbb | FileCheck %s --check-prefix=RV32IZbb
; RUN: llc < %s -mtriple=riscv64 -mattr=+m,+zbb | FileCheck %s --check-prefix=RV64IZbb

declare i4 @llvm.uadd.sat.i4(i4, i4)
declare i8 @llvm.uadd.sat.i8(i8, i8)
declare i16 @llvm.uadd.sat.i16(i16, i16)
declare i32 @llvm.uadd.sat.i32(i32, i32)
declare i64 @llvm.uadd.sat.i64(i64, i64)

define signext i32 @func(i32 signext %x, i32 signext %y) nounwind {
; RV32I-LABEL: func:
; RV32I:       # %bb.0:
; RV32I-NEXT:    mv a2, a0
; RV32I-NEXT:    add a1, a0, a1
; RV32I-NEXT:    li a0, -1
; RV32I-NEXT:    bltu a1, a2, .LBB0_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:  .LBB0_2:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func:
; RV64I:       # %bb.0:
; RV64I-NEXT:    mv a2, a0
; RV64I-NEXT:    addw a1, a0, a1
; RV64I-NEXT:    li a0, -1
; RV64I-NEXT:    bltu a1, a2, .LBB0_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB0_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    not a2, a1
; RV32IZbb-NEXT:    minu a0, a0, a2
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    not a2, a1
; RV64IZbb-NEXT:    minu a0, a0, a2
; RV64IZbb-NEXT:    addw a0, a0, a1
; RV64IZbb-NEXT:    ret
  %tmp = call i32 @llvm.uadd.sat.i32(i32 %x, i32 %y);
  ret i32 %tmp;
}

define i64 @func2(i64 %x, i64 %y) nounwind {
; RV32I-LABEL: func2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a3, a1, a3
; RV32I-NEXT:    add a2, a0, a2
; RV32I-NEXT:    sltu a4, a2, a0
; RV32I-NEXT:    add a3, a3, a4
; RV32I-NEXT:    beq a3, a1, .LBB1_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu a4, a3, a1
; RV32I-NEXT:  .LBB1_2:
; RV32I-NEXT:    li a0, -1
; RV32I-NEXT:    li a1, -1
; RV32I-NEXT:    bnez a4, .LBB1_4
; RV32I-NEXT:  # %bb.3:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    mv a1, a3
; RV32I-NEXT:  .LBB1_4:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    mv a2, a0
; RV64I-NEXT:    add a1, a0, a1
; RV64I-NEXT:    li a0, -1
; RV64I-NEXT:    bltu a1, a2, .LBB1_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB1_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func2:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    add a3, a1, a3
; RV32IZbb-NEXT:    add a2, a0, a2
; RV32IZbb-NEXT:    sltu a4, a2, a0
; RV32IZbb-NEXT:    add a3, a3, a4
; RV32IZbb-NEXT:    beq a3, a1, .LBB1_2
; RV32IZbb-NEXT:  # %bb.1:
; RV32IZbb-NEXT:    sltu a4, a3, a1
; RV32IZbb-NEXT:  .LBB1_2:
; RV32IZbb-NEXT:    li a0, -1
; RV32IZbb-NEXT:    li a1, -1
; RV32IZbb-NEXT:    bnez a4, .LBB1_4
; RV32IZbb-NEXT:  # %bb.3:
; RV32IZbb-NEXT:    mv a0, a2
; RV32IZbb-NEXT:    mv a1, a3
; RV32IZbb-NEXT:  .LBB1_4:
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func2:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    not a2, a1
; RV64IZbb-NEXT:    minu a0, a0, a2
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    ret
  %tmp = call i64 @llvm.uadd.sat.i64(i64 %x, i64 %y);
  ret i64 %tmp;
}

define zeroext i16 @func16(i16 zeroext %x, i16 zeroext %y) nounwind {
; RV32I-LABEL: func16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 16
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    bltu a0, a1, .LBB2_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:  .LBB2_2:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 16
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    bltu a0, a1, .LBB2_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB2_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func16:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    lui a1, 16
; RV32IZbb-NEXT:    addi a1, a1, -1
; RV32IZbb-NEXT:    minu a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func16:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    lui a1, 16
; RV64IZbb-NEXT:    addiw a1, a1, -1
; RV64IZbb-NEXT:    minu a0, a0, a1
; RV64IZbb-NEXT:    ret
  %tmp = call i16 @llvm.uadd.sat.i16(i16 %x, i16 %y);
  ret i16 %tmp;
}

define zeroext i8 @func8(i8 zeroext %x, i8 zeroext %y) nounwind {
; RV32I-LABEL: func8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    li a1, 255
; RV32I-NEXT:    bltu a0, a1, .LBB3_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    li a0, 255
; RV32I-NEXT:  .LBB3_2:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    li a1, 255
; RV64I-NEXT:    bltu a0, a1, .LBB3_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    li a0, 255
; RV64I-NEXT:  .LBB3_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func8:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    li a1, 255
; RV32IZbb-NEXT:    minu a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func8:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    li a1, 255
; RV64IZbb-NEXT:    minu a0, a0, a1
; RV64IZbb-NEXT:    ret
  %tmp = call i8 @llvm.uadd.sat.i8(i8 %x, i8 %y);
  ret i8 %tmp;
}

define zeroext i4 @func3(i4 zeroext %x, i4 zeroext %y) nounwind {
; RV32I-LABEL: func3:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    li a1, 15
; RV32I-NEXT:    bltu a0, a1, .LBB4_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    li a0, 15
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func3:
; RV64I:       # %bb.0:
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    li a1, 15
; RV64I-NEXT:    bltu a0, a1, .LBB4_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    li a0, 15
; RV64I-NEXT:  .LBB4_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func3:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    li a1, 15
; RV32IZbb-NEXT:    minu a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func3:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    li a1, 15
; RV64IZbb-NEXT:    minu a0, a0, a1
; RV64IZbb-NEXT:    ret
  %tmp = call i4 @llvm.uadd.sat.i4(i4 %x, i4 %y);
  ret i4 %tmp;
}