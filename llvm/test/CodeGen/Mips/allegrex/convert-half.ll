; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; Half (f16) pack/unpack. vf2h narrows float lanes to packed half-pairs; vh2f
; widens them back. Packed-half data is two halves per 32-bit lane, carried in
; VFPU float registers, so it is modelled as the float type of the right width.
; Encodings byte-validated against psp-as.

declare float        @llvm.mips.allegrex.vf2h.p(<2 x float>)
declare <2 x float>  @llvm.mips.allegrex.vf2h.q(<4 x float>)
declare <2 x float>  @llvm.mips.allegrex.vh2f.s(float)
declare <4 x float>  @llvm.mips.allegrex.vh2f.p(<2 x float>)

define void @pack_q(ptr %s, ptr %d) {
; CHECK-LABEL: pack_q:
; CHECK: vf2h.q {{C[0-9]+}}, {{C[0-9]+}}
  %f = load <4 x float>, ptr %s, align 16
  %h = call <2 x float> @llvm.mips.allegrex.vf2h.q(<4 x float> %f)
  store <2 x float> %h, ptr %d, align 8
  ret void
}

define float @pack_p(<2 x float> %f) {
; CHECK-LABEL: pack_p:
; CHECK: vf2h.p {{S[0-9]+}}, {{C[0-9]+}}
  %h = call float @llvm.mips.allegrex.vf2h.p(<2 x float> %f)
  ret float %h
}

define <4 x float> @unpack_p(<2 x float> %h) {
; CHECK-LABEL: unpack_p:
; CHECK: vh2f.p {{C[0-9]+}}, {{C[0-9]+}}
  %f = call <4 x float> @llvm.mips.allegrex.vh2f.p(<2 x float> %h)
  ret <4 x float> %f
}

define <2 x float> @unpack_s(float %h) {
; CHECK-LABEL: unpack_s:
; CHECK: vh2f.s {{C[0-9]+}}, {{S[0-9]+}}
  %f = call <2 x float> @llvm.mips.allegrex.vh2f.s(float %h)
  ret <2 x float> %f
}
