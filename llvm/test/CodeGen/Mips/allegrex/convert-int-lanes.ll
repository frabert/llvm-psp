; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; v4i32 integer-lane access. An integer lane lives in a VFPU scalar slice (raw
; 32 bits), so it crosses to/from a GPR with mfv/mtv. This lets a converted
; v4i32 hand individual ints back to integer code, and lets a v4i32 be assembled
; from GPR ints and fed to vi2f. Encodings byte-validated against psp-as.

declare <4 x i32> @llvm.mips.allegrex.vf2in.q(<4 x float>, i32 immarg)
declare <4 x float> @llvm.mips.allegrex.vi2f.q(<4 x i32>, i32 immarg)

; extractelement of a converted lane: mfv pulls slice sub_vfpus_3 (lane 2).
define i32 @extract_lane2(ptr %src) {
; CHECK-LABEL: extract_lane2:
; CHECK: vf2in.q
; CHECK: mfv $2, S{{[0-9]}}02
  %f = load <4 x float>, ptr %src, align 16
  %i = call <4 x i32> @llvm.mips.allegrex.vf2in.q(<4 x float> %f, i32 0)
  %e = extractelement <4 x i32> %i, i32 2
  ret i32 %e
}

; build a v4i32 from four GPR ints (one mtv per lane) then convert to float.
define void @build_then_vi2f(i32 %a, i32 %b, i32 %c, i32 %d, ptr %dst) {
; CHECK-LABEL: build_then_vi2f:
; CHECK: mtv $4, S{{[0-9]}}00
; CHECK: mtv $5, S{{[0-9]}}01
; CHECK: mtv $6, S{{[0-9]}}02
; CHECK: mtv $7, S{{[0-9]}}03
; CHECK: vi2f.q
  %v0 = insertelement <4 x i32> undef, i32 %a, i32 0
  %v1 = insertelement <4 x i32> %v0, i32 %b, i32 1
  %v2 = insertelement <4 x i32> %v1, i32 %c, i32 2
  %v3 = insertelement <4 x i32> %v2, i32 %d, i32 3
  %f = call <4 x float> @llvm.mips.allegrex.vi2f.q(<4 x i32> %v3, i32 0)
  store <4 x float> %f, ptr %dst, align 16
  ret void
}
