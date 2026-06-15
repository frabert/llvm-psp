; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; Integer -> packed-byte color conversion (vi2c/vi2uc, .q). Four i32 lanes pack
; into one 32-bit word (RGBA8888). The op writes a VFPU scalar slice; mfv brings
; the packed word to a GPR. Encodings byte-validated against psp-as.

declare <4 x i32> @llvm.mips.allegrex.vf2in.q(<4 x float>, i32 immarg)
declare i32 @llvm.mips.allegrex.vi2c.q(<4 x i32>)
declare i32 @llvm.mips.allegrex.vi2uc.q(<4 x i32>)

; canonical pack: convert four float channels to int then pack to RGBA8888.
define i32 @pack_rgba(ptr %src) {
; CHECK-LABEL: pack_rgba:
; CHECK: lv.q [[V:C[0-9]+]], 0($4)
; CHECK: vf2in.q [[V]], [[V]], 23
; CHECK: vi2c.q [[S:S[0-9]+]], [[V]]
; CHECK: mfv $2, [[S]]
  %f = load <4 x float>, ptr %src, align 16
  %i = call <4 x i32> @llvm.mips.allegrex.vf2in.q(<4 x float> %f, i32 23)
  %c = call i32 @llvm.mips.allegrex.vi2c.q(<4 x i32> %i)
  ret i32 %c
}

define i32 @pack_rgba_u(<4 x i32> %i) {
; CHECK-LABEL: pack_rgba_u:
; CHECK: vi2uc.q [[S:S[0-9]+]], {{C[0-9]+}}
; CHECK: mfv $2, [[S]]
  %c = call i32 @llvm.mips.allegrex.vi2uc.q(<4 x i32> %i)
  ret i32 %c
}
