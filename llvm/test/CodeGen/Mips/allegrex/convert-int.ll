; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; Same-width VFPU float<->int conversions (.q). v4i32 shares the VFPUQ quad
; register file with v4f32, so it loads/stores natively through lv.q/sv.q and
; the conversion is a single vf2i*/vi2f. Encodings were byte-validated against
; pspdev binutils' psp-as.

declare <4 x i32> @llvm.mips.allegrex.vf2in.q(<4 x float>, i32 immarg)
declare <4 x i32> @llvm.mips.allegrex.vf2iz.q(<4 x float>, i32 immarg)
declare <4 x i32> @llvm.mips.allegrex.vf2iu.q(<4 x float>, i32 immarg)
declare <4 x i32> @llvm.mips.allegrex.vf2id.q(<4 x float>, i32 immarg)
declare <4 x float> @llvm.mips.allegrex.vi2f.q(<4 x i32>, i32 immarg)

define void @cvt_f2in(ptr %src, ptr %dst) {
; CHECK-LABEL: cvt_f2in:
; CHECK: lv.q [[V:C[0-9]+]], 0($4)
; CHECK: vf2in.q [[V]], [[V]], 5
; CHECK: sv.q [[V]], 0($5)
  %f = load <4 x float>, ptr %src, align 16
  %i = call <4 x i32> @llvm.mips.allegrex.vf2in.q(<4 x float> %f, i32 5)
  store <4 x i32> %i, ptr %dst, align 16
  ret void
}

define void @cvt_f2iz(ptr %src, ptr %dst) {
; CHECK-LABEL: cvt_f2iz:
; CHECK: vf2iz.q {{C[0-9]+}}, {{C[0-9]+}}, 2
  %f = load <4 x float>, ptr %src, align 16
  %i = call <4 x i32> @llvm.mips.allegrex.vf2iz.q(<4 x float> %f, i32 2)
  store <4 x i32> %i, ptr %dst, align 16
  ret void
}

define void @cvt_f2iu(ptr %src, ptr %dst) {
; CHECK-LABEL: cvt_f2iu:
; CHECK: vf2iu.q {{C[0-9]+}}, {{C[0-9]+}}, 0
  %f = load <4 x float>, ptr %src, align 16
  %i = call <4 x i32> @llvm.mips.allegrex.vf2iu.q(<4 x float> %f, i32 0)
  store <4 x i32> %i, ptr %dst, align 16
  ret void
}

define void @cvt_f2id(ptr %src, ptr %dst) {
; CHECK-LABEL: cvt_f2id:
; CHECK: vf2id.q {{C[0-9]+}}, {{C[0-9]+}}, 1
  %f = load <4 x float>, ptr %src, align 16
  %i = call <4 x i32> @llvm.mips.allegrex.vf2id.q(<4 x float> %f, i32 1)
  store <4 x i32> %i, ptr %dst, align 16
  ret void
}

; vf2iz then vi2f back to float, exercising v4i32 -> v4f32.
define void @cvt_roundtrip(ptr %src, ptr %dst) {
; CHECK-LABEL: cvt_roundtrip:
; CHECK: vf2iz.q [[V:C[0-9]+]], {{C[0-9]+}}, 0
; CHECK: vi2f.q {{C[0-9]+}}, [[V]], 0
  %f = load <4 x float>, ptr %src, align 16
  %i = call <4 x i32> @llvm.mips.allegrex.vf2iz.q(<4 x float> %f, i32 0)
  %g = call <4 x float> @llvm.mips.allegrex.vi2f.q(<4 x i32> %i, i32 0)
  store <4 x float> %g, ptr %dst, align 16
  ret void
}
