; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; VFPU ops whose signatures don't fit the same-width unary multiclass.

declare float @llvm.mips.allegrex.vsbn(float, float)
declare float @llvm.mips.allegrex.vsbz(float)
declare float @llvm.mips.allegrex.vlgb(float)
declare <2 x float> @llvm.mips.allegrex.vsocp.s(float)
declare <4 x float> @llvm.mips.allegrex.vsocp.p(<2 x float>)
declare <2 x float> @llvm.mips.allegrex.vrot.p(float, i32 immarg)
declare <3 x float> @llvm.mips.allegrex.vrot.t(float, i32 immarg)
declare <4 x float> @llvm.mips.allegrex.vrot.q(float, i32 immarg)

define float @sbn(float %a, float %b) {
; CHECK-LABEL: sbn:
; CHECK: vsbn.s {{S[0-9]+}}, {{S[0-9]+}}, {{S[0-9]+}}
  %r = call float @llvm.mips.allegrex.vsbn(float %a, float %b)
  ret float %r
}

define float @sbz(float %a) {
; CHECK-LABEL: sbz:
; CHECK: vsbz.s {{S[0-9]+}}, {{S[0-9]+}}
  %r = call float @llvm.mips.allegrex.vsbz(float %a)
  ret float %r
}

define float @lgb(float %a) {
; CHECK-LABEL: lgb:
; CHECK: vlgb.s {{S[0-9]+}}, {{S[0-9]+}}
  %r = call float @llvm.mips.allegrex.vlgb(float %a)
  ret float %r
}

; one's-complement widens scalar -> pair.
define void @socp_s(float %a, ptr %r) {
; CHECK-LABEL: socp_s:
; CHECK: vsocp.s {{C[0-9]+}}, {{S[0-9]+}}
  %v = call <2 x float> @llvm.mips.allegrex.vsocp.s(float %a)
  store <2 x float> %v, ptr %r, align 8
  ret void
}

; ...and pair -> quad.
define void @socp_p(ptr %a, ptr %r) {
; CHECK-LABEL: socp_p:
; CHECK: vsocp.p {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <2 x float>, ptr %a, align 8
  %v = call <4 x float> @llvm.mips.allegrex.vsocp.p(<2 x float> %x)
  store <4 x float> %v, ptr %r, align 16
  ret void
}

; vrot builds a rotation vector; the immediate selects the lane pattern.
define void @rot_q(float %a, ptr %r) {
; CHECK-LABEL: rot_q:
; CHECK: vrot.q {{C[0-9]+}}, {{S[0-9]+}}, {{\[.*\]}}
  %v = call <4 x float> @llvm.mips.allegrex.vrot.q(float %a, i32 3)
  store <4 x float> %v, ptr %r, align 16
  ret void
}

define void @rot_p(float %a, ptr %r) {
; CHECK-LABEL: rot_p:
; CHECK: vrot.p {{C[0-9]+}}, {{S[0-9]+}}, {{\[.*\]}}
  %v = call <2 x float> @llvm.mips.allegrex.vrot.p(float %a, i32 1)
  store <2 x float> %v, ptr %r, align 8
  ret void
}
