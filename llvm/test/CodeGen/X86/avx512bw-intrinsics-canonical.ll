; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl -mattr=+avx512bw | FileCheck %s --check-prefix=AVX512BW
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu -mcpu=knl -mattr=+avx512bw | FileCheck %s --check-prefix=AVX512F-32

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/avx512bw-builtins.c

;
; Signed Saturation
;

define <32 x i16> @test_mask_adds_epi16_rr_512(<32 x i16> %a, <32 x i16> %b) {
; AVX512BW-LABEL: test_mask_adds_epi16_rr_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpaddsw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epi16_rr_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    vpaddsw %zmm1, %zmm0, %zmm0
; AVX512F-32-NEXT:    retl
  %res = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  ret <32 x i16> %res
}
declare <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16>, <32 x i16>)

define <32 x i16> @test_mask_adds_epi16_rrk_512(<32 x i16> %a, <32 x i16> %b, <32 x i16> %passThru, i32 %mask) {
; AVX512BW-LABEL: test_mask_adds_epi16_rrk_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vpaddsw %zmm1, %zmm0, %zmm2 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epi16_rrk_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpaddsw %zmm1, %zmm0, %zmm2 {%k1}
; AVX512F-32-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512F-32-NEXT:    retl
  %1 = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %2 = bitcast i32 %mask to <32 x i1>
  %3 = select <32 x i1> %2, <32 x i16> %1, <32 x i16> %passThru
  ret <32 x i16> %3
}

define <32 x i16> @test_mask_adds_epi16_rrkz_512(<32 x i16> %a, <32 x i16> %b, i32 %mask) {
; AVX512BW-LABEL: test_mask_adds_epi16_rrkz_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vpaddsw %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epi16_rrkz_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpaddsw %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512F-32-NEXT:    retl
  %1 = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %2 = bitcast i32 %mask to <32 x i1>
  %3 = select <32 x i1> %2, <32 x i16> %1, <32 x i16> zeroinitializer
  ret <32 x i16> %3
}

define <32 x i16> @test_mask_adds_epi16_rm_512(<32 x i16> %a, ptr %ptr_b) {
; AVX512BW-LABEL: test_mask_adds_epi16_rm_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpaddsw (%rdi), %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epi16_rm_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    vpaddsw (%eax), %zmm0, %zmm0
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %1 = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  ret <32 x i16> %1
}

define <32 x i16> @test_mask_adds_epi16_rmk_512(<32 x i16> %a, ptr %ptr_b, <32 x i16> %passThru, i32 %mask) {
; AVX512BW-LABEL: test_mask_adds_epi16_rmk_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %esi, %k1
; AVX512BW-NEXT:    vpaddsw (%rdi), %zmm0, %zmm1 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epi16_rmk_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpaddsw (%eax), %zmm0, %zmm1 {%k1}
; AVX512F-32-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %1 = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %2 = bitcast i32 %mask to <32 x i1>
  %3 = select <32 x i1> %2, <32 x i16> %1, <32 x i16> %passThru
  ret <32 x i16> %3
}

define <32 x i16> @test_mask_adds_epi16_rmkz_512(<32 x i16> %a, ptr %ptr_b, i32 %mask) {
; AVX512BW-LABEL: test_mask_adds_epi16_rmkz_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %esi, %k1
; AVX512BW-NEXT:    vpaddsw (%rdi), %zmm0, %zmm0 {%k1} {z}
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epi16_rmkz_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpaddsw (%eax), %zmm0, %zmm0 {%k1} {z}
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %1 = call <32 x i16> @llvm.sadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %2 = bitcast i32 %mask to <32 x i1>
  %3 = select <32 x i1> %2, <32 x i16> %1, <32 x i16> zeroinitializer
  ret <32 x i16> %3
}

define <32 x i16> @test_mask_subs_epi16_rr_512(<32 x i16> %a, <32 x i16> %b) {
; AVX512BW-LABEL: test_mask_subs_epi16_rr_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpsubsw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epi16_rr_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    vpsubsw %zmm1, %zmm0, %zmm0
; AVX512F-32-NEXT:    retl
  %sub = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  ret <32 x i16> %sub
}
declare <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16>, <32 x i16>)

define <32 x i16> @test_mask_subs_epi16_rrk_512(<32 x i16> %a, <32 x i16> %b, <32 x i16> %passThru, i32 %mask) {
; AVX512BW-LABEL: test_mask_subs_epi16_rrk_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vpsubsw %zmm1, %zmm0, %zmm2 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epi16_rrk_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpsubsw %zmm1, %zmm0, %zmm2 {%k1}
; AVX512F-32-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512F-32-NEXT:    retl
  %sub = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %bc = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %bc, <32 x i16> %sub, <32 x i16> %passThru
  ret <32 x i16> %res
}

define <32 x i16> @test_mask_subs_epi16_rrkz_512(<32 x i16> %a, <32 x i16> %b, i32 %mask) {
; AVX512BW-LABEL: test_mask_subs_epi16_rrkz_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vpsubsw %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epi16_rrkz_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpsubsw %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512F-32-NEXT:    retl
  %sub = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %bc = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %bc, <32 x i16> %sub, <32 x i16> zeroinitializer
  ret <32 x i16> %res
}

define <32 x i16> @test_mask_subs_epi16_rm_512(<32 x i16> %a, ptr %ptr_b) {
; AVX512BW-LABEL: test_mask_subs_epi16_rm_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpsubsw (%rdi), %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epi16_rm_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    vpsubsw (%eax), %zmm0, %zmm0
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %sub = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  ret <32 x i16> %sub
}

define <32 x i16> @test_mask_subs_epi16_rmk_512(<32 x i16> %a, ptr %ptr_b, <32 x i16> %passThru, i32 %mask) {
; AVX512BW-LABEL: test_mask_subs_epi16_rmk_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %esi, %k1
; AVX512BW-NEXT:    vpsubsw (%rdi), %zmm0, %zmm1 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epi16_rmk_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpsubsw (%eax), %zmm0, %zmm1 {%k1}
; AVX512F-32-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %sub = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %bc = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %bc, <32 x i16> %sub, <32 x i16> %passThru
  ret <32 x i16> %res
}

define <32 x i16> @test_mask_subs_epi16_rmkz_512(<32 x i16> %a, ptr %ptr_b, i32 %mask) {
; AVX512BW-LABEL: test_mask_subs_epi16_rmkz_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %esi, %k1
; AVX512BW-NEXT:    vpsubsw (%rdi), %zmm0, %zmm0 {%k1} {z}
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epi16_rmkz_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpsubsw (%eax), %zmm0, %zmm0 {%k1} {z}
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %sub = call <32 x i16> @llvm.ssub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %bc = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %bc, <32 x i16> %sub, <32 x i16> zeroinitializer
  ret <32 x i16> %res
}


define <64 x i16> @test_mask_adds_epi16_rr_1024(<64 x i16> %a, <64 x i16> %b) {
; AVX512BW-LABEL: test_mask_adds_epi16_rr_1024:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpaddsw %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpaddsw %zmm3, %zmm1, %zmm1
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epi16_rr_1024:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    pushl %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa_offset 8
; AVX512F-32-NEXT:    .cfi_offset %ebp, -8
; AVX512F-32-NEXT:    movl %esp, %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa_register %ebp
; AVX512F-32-NEXT:    andl $-64, %esp
; AVX512F-32-NEXT:    subl $64, %esp
; AVX512F-32-NEXT:    vpaddsw %zmm2, %zmm0, %zmm0
; AVX512F-32-NEXT:    vpaddsw 8(%ebp), %zmm1, %zmm1
; AVX512F-32-NEXT:    movl %ebp, %esp
; AVX512F-32-NEXT:    popl %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa %esp, 4
; AVX512F-32-NEXT:    retl
  %1 = call <64 x i16> @llvm.sadd.sat.v64i16(<64 x i16> %a, <64 x i16> %b)
  ret <64 x i16> %1
}
declare <64 x i16> @llvm.sadd.sat.v64i16(<64 x i16>, <64 x i16>)

define <64 x i16> @test_mask_subs_epi16_rr_1024(<64 x i16> %a, <64 x i16> %b) {
; AVX512BW-LABEL: test_mask_subs_epi16_rr_1024:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpsubsw %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpsubsw %zmm3, %zmm1, %zmm1
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epi16_rr_1024:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    pushl %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa_offset 8
; AVX512F-32-NEXT:    .cfi_offset %ebp, -8
; AVX512F-32-NEXT:    movl %esp, %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa_register %ebp
; AVX512F-32-NEXT:    andl $-64, %esp
; AVX512F-32-NEXT:    subl $64, %esp
; AVX512F-32-NEXT:    vpsubsw %zmm2, %zmm0, %zmm0
; AVX512F-32-NEXT:    vpsubsw 8(%ebp), %zmm1, %zmm1
; AVX512F-32-NEXT:    movl %ebp, %esp
; AVX512F-32-NEXT:    popl %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa %esp, 4
; AVX512F-32-NEXT:    retl
  %sub = call <64 x i16> @llvm.ssub.sat.v64i16(<64 x i16> %a, <64 x i16> %b)
  ret <64 x i16> %sub
}
declare <64 x i16> @llvm.ssub.sat.v64i16(<64 x i16>, <64 x i16>);

;
; Unsigned Saturation
;

define <32 x i16> @test_mask_adds_epu16_rr_512(<32 x i16> %a, <32 x i16> %b) {
; AVX512BW-LABEL: test_mask_adds_epu16_rr_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpaddusw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epu16_rr_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    vpaddusw %zmm1, %zmm0, %zmm0
; AVX512F-32-NEXT:    retl
  %res = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  ret <32 x i16> %res
}
declare <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16>, <32 x i16>)

define <32 x i16> @test_mask_adds_epu16_rrk_512(<32 x i16> %a, <32 x i16> %b, <32 x i16> %passThru, i32 %mask) {
; AVX512BW-LABEL: test_mask_adds_epu16_rrk_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vpaddusw %zmm1, %zmm0, %zmm2 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epu16_rrk_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpaddusw %zmm1, %zmm0, %zmm2 {%k1}
; AVX512F-32-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512F-32-NEXT:    retl
  %1 = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %2 = bitcast i32 %mask to <32 x i1>
  %3 = select <32 x i1> %2, <32 x i16> %1, <32 x i16> %passThru
  ret <32 x i16> %3
}

define <32 x i16> @test_mask_adds_epu16_rrkz_512(<32 x i16> %a, <32 x i16> %b, i32 %mask) {
; AVX512BW-LABEL: test_mask_adds_epu16_rrkz_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vpaddusw %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epu16_rrkz_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpaddusw %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512F-32-NEXT:    retl
  %1 = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %2 = bitcast i32 %mask to <32 x i1>
  %3 = select <32 x i1> %2, <32 x i16> %1, <32 x i16> zeroinitializer
  ret <32 x i16> %3
}

define <32 x i16> @test_mask_adds_epu16_rm_512(<32 x i16> %a, ptr %ptr_b) {
; AVX512BW-LABEL: test_mask_adds_epu16_rm_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpaddusw (%rdi), %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epu16_rm_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    vpaddusw (%eax), %zmm0, %zmm0
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %1 = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  ret <32 x i16> %1
}

define <32 x i16> @test_mask_adds_epu16_rmk_512(<32 x i16> %a, ptr %ptr_b, <32 x i16> %passThru, i32 %mask) {
; AVX512BW-LABEL: test_mask_adds_epu16_rmk_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %esi, %k1
; AVX512BW-NEXT:    vpaddusw (%rdi), %zmm0, %zmm1 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epu16_rmk_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpaddusw (%eax), %zmm0, %zmm1 {%k1}
; AVX512F-32-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %1 = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %2 = bitcast i32 %mask to <32 x i1>
  %3 = select <32 x i1> %2, <32 x i16> %1, <32 x i16> %passThru
  ret <32 x i16> %3
}

define <32 x i16> @test_mask_adds_epu16_rmkz_512(<32 x i16> %a, ptr %ptr_b, i32 %mask) {
; AVX512BW-LABEL: test_mask_adds_epu16_rmkz_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %esi, %k1
; AVX512BW-NEXT:    vpaddusw (%rdi), %zmm0, %zmm0 {%k1} {z}
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epu16_rmkz_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpaddusw (%eax), %zmm0, %zmm0 {%k1} {z}
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %1 = call <32 x i16> @llvm.uadd.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %2 = bitcast i32 %mask to <32 x i1>
  %3 = select <32 x i1> %2, <32 x i16> %1, <32 x i16> zeroinitializer
  ret <32 x i16> %3
}

define <32 x i16> @test_mask_subs_epu16_rr_512(<32 x i16> %a, <32 x i16> %b) {
; AVX512BW-LABEL: test_mask_subs_epu16_rr_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpsubusw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epu16_rr_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    vpsubusw %zmm1, %zmm0, %zmm0
; AVX512F-32-NEXT:    retl
  %sub = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  ret <32 x i16> %sub
}
declare <32 x i16> @llvm.usub.sat.v32i16(<32 x i16>, <32 x i16>)

define <32 x i16> @test_mask_subs_epu16_rrk_512(<32 x i16> %a, <32 x i16> %b, <32 x i16> %passThru, i32 %mask) {
; AVX512BW-LABEL: test_mask_subs_epu16_rrk_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vpsubusw %zmm1, %zmm0, %zmm2 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epu16_rrk_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpsubusw %zmm1, %zmm0, %zmm2 {%k1}
; AVX512F-32-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512F-32-NEXT:    retl
  %sub = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %bc = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %bc, <32 x i16> %sub, <32 x i16> %passThru
  ret <32 x i16> %res
}

define <32 x i16> @test_mask_subs_epu16_rrkz_512(<32 x i16> %a, <32 x i16> %b, i32 %mask) {
; AVX512BW-LABEL: test_mask_subs_epu16_rrkz_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %edi, %k1
; AVX512BW-NEXT:    vpsubusw %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epu16_rrkz_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpsubusw %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512F-32-NEXT:    retl
  %sub = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %bc = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %bc, <32 x i16> %sub, <32 x i16> zeroinitializer
  ret <32 x i16> %res
}

define <32 x i16> @test_mask_subs_epu16_rm_512(<32 x i16> %a, ptr %ptr_b) {
; AVX512BW-LABEL: test_mask_subs_epu16_rm_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpsubusw (%rdi), %zmm0, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epu16_rm_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    vpsubusw (%eax), %zmm0, %zmm0
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %sub = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  ret <32 x i16> %sub
}

define <32 x i16> @test_mask_subs_epu16_rmk_512(<32 x i16> %a, ptr %ptr_b, <32 x i16> %passThru, i32 %mask) {
; AVX512BW-LABEL: test_mask_subs_epu16_rmk_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %esi, %k1
; AVX512BW-NEXT:    vpsubusw (%rdi), %zmm0, %zmm1 {%k1}
; AVX512BW-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epu16_rmk_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpsubusw (%eax), %zmm0, %zmm1 {%k1}
; AVX512F-32-NEXT:    vmovdqa64 %zmm1, %zmm0
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %sub = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %bc = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %bc, <32 x i16> %sub, <32 x i16> %passThru
  ret <32 x i16> %res
}

define <32 x i16> @test_mask_subs_epu16_rmkz_512(<32 x i16> %a, ptr %ptr_b, i32 %mask) {
; AVX512BW-LABEL: test_mask_subs_epu16_rmkz_512:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    kmovd %esi, %k1
; AVX512BW-NEXT:    vpsubusw (%rdi), %zmm0, %zmm0 {%k1} {z}
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epu16_rmkz_512:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512F-32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; AVX512F-32-NEXT:    vpsubusw (%eax), %zmm0, %zmm0 {%k1} {z}
; AVX512F-32-NEXT:    retl
  %b = load <32 x i16>, ptr %ptr_b
  %sub = call <32 x i16> @llvm.usub.sat.v32i16(<32 x i16> %a, <32 x i16> %b)
  %bc = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %bc, <32 x i16> %sub, <32 x i16> zeroinitializer
  ret <32 x i16> %res
}


define <64 x i16> @test_mask_adds_epu16_rr_1024(<64 x i16> %a, <64 x i16> %b) {
; AVX512BW-LABEL: test_mask_adds_epu16_rr_1024:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpaddusw %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpaddusw %zmm3, %zmm1, %zmm1
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_adds_epu16_rr_1024:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    pushl %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa_offset 8
; AVX512F-32-NEXT:    .cfi_offset %ebp, -8
; AVX512F-32-NEXT:    movl %esp, %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa_register %ebp
; AVX512F-32-NEXT:    andl $-64, %esp
; AVX512F-32-NEXT:    subl $64, %esp
; AVX512F-32-NEXT:    vpaddusw %zmm2, %zmm0, %zmm0
; AVX512F-32-NEXT:    vpaddusw 8(%ebp), %zmm1, %zmm1
; AVX512F-32-NEXT:    movl %ebp, %esp
; AVX512F-32-NEXT:    popl %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa %esp, 4
; AVX512F-32-NEXT:    retl
  %1 = call <64 x i16> @llvm.uadd.sat.v64i16(<64 x i16> %a, <64 x i16> %b)
  ret <64 x i16> %1
}
declare <64 x i16> @llvm.uadd.sat.v64i16(<64 x i16>, <64 x i16>)

define <64 x i16> @test_mask_subs_epu16_rr_1024(<64 x i16> %a, <64 x i16> %b) {
; AVX512BW-LABEL: test_mask_subs_epu16_rr_1024:
; AVX512BW:       ## %bb.0:
; AVX512BW-NEXT:    vpsubusw %zmm2, %zmm0, %zmm0
; AVX512BW-NEXT:    vpsubusw %zmm3, %zmm1, %zmm1
; AVX512BW-NEXT:    retq
;
; AVX512F-32-LABEL: test_mask_subs_epu16_rr_1024:
; AVX512F-32:       # %bb.0:
; AVX512F-32-NEXT:    pushl %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa_offset 8
; AVX512F-32-NEXT:    .cfi_offset %ebp, -8
; AVX512F-32-NEXT:    movl %esp, %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa_register %ebp
; AVX512F-32-NEXT:    andl $-64, %esp
; AVX512F-32-NEXT:    subl $64, %esp
; AVX512F-32-NEXT:    vpsubusw %zmm2, %zmm0, %zmm0
; AVX512F-32-NEXT:    vpsubusw 8(%ebp), %zmm1, %zmm1
; AVX512F-32-NEXT:    movl %ebp, %esp
; AVX512F-32-NEXT:    popl %ebp
; AVX512F-32-NEXT:    .cfi_def_cfa %esp, 4
; AVX512F-32-NEXT:    retl
  %sub = call <64 x i16> @llvm.usub.sat.v64i16(<64 x i16> %a, <64 x i16> %b)
  ret <64 x i16> %sub
}
declare <64 x i16> @llvm.usub.sat.v64i16(<64 x i16>, <64 x i16>)