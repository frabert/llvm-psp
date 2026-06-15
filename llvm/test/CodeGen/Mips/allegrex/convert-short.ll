; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; Integer <-> packed-short conversions. vi2s/vi2us narrow i32 lanes to packed
; 16-bit shorts; vs2i/vus2i widen them back. The single (packed-word) end
; crosses a GPR via mfv/mtv; pair/quad ends stay in VFPU regs. Encodings
; byte-validated against psp-as.

declare i32         @llvm.mips.allegrex.vi2s.p(<2 x i32>)
declare <2 x i32>   @llvm.mips.allegrex.vi2s.q(<4 x i32>)
declare <2 x i32>   @llvm.mips.allegrex.vs2i.s(i32)
declare <4 x i32>   @llvm.mips.allegrex.vus2i.p(<2 x i32>)

define i32 @pack_p(<2 x i32> %v) {
; CHECK-LABEL: pack_p:
; CHECK: vi2s.p [[S:S[0-9]+]], {{C[0-9]+}}
; CHECK: mfv $2, [[S]]
  %r = call i32 @llvm.mips.allegrex.vi2s.p(<2 x i32> %v)
  ret i32 %r
}

define <2 x i32> @pack_q(<4 x i32> %v) {
; CHECK-LABEL: pack_q:
; CHECK: vi2s.q {{C[0-9]+}}, {{C[0-9]+}}
  %r = call <2 x i32> @llvm.mips.allegrex.vi2s.q(<4 x i32> %v)
  ret <2 x i32> %r
}

define <2 x i32> @unpack_s(i32 %v) {
; CHECK-LABEL: unpack_s:
; CHECK: mtv $4, [[S:S[0-9]+]]
; CHECK: vs2i.s {{C[0-9]+}}, [[S]]
  %r = call <2 x i32> @llvm.mips.allegrex.vs2i.s(i32 %v)
  ret <2 x i32> %r
}

define <4 x i32> @unpack_p(<2 x i32> %v) {
; CHECK-LABEL: unpack_p:
; CHECK: vus2i.p {{C[0-9]+}}, {{C[0-9]+}}
  %r = call <4 x i32> @llvm.mips.allegrex.vus2i.p(<2 x i32> %v)
  ret <4 x i32> %r
}
