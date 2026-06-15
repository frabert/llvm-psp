; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; A vector select whose mask is a VFPU float compare lowers to vcmp (writing the
; per-lane VFPU condition codes) followed by a per-lane vcmovt (cnd=6), instead
; of scalarizing. VfpuCMov(false, true) ties the dest to the false value and
; moves in the true value where the lane's VCC bit is set. Encodings byte-
; validated against psp-as.

; max(a, b): a > b ? a : b
define <4 x float> @vmax_q(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: vmax_q:
; CHECK: vcmp.q GT, [[A:C[0-9]+]], [[B:C[0-9]+]]
; CHECK: vcmovt.q [[B]], [[A]], 6
  %m = fcmp ogt <4 x float> %a, %b
  %r = select <4 x i1> %m, <4 x float> %a, <4 x float> %b
  ret <4 x float> %r
}

; independent true/false operands: a < b ? c : d
define <4 x float> @vsel_cd(<4 x float> %a, <4 x float> %b, <4 x float> %c, <4 x float> %d) {
; CHECK-LABEL: vsel_cd:
; CHECK: vcmp.q LT, {{C[0-9]+}}, {{C[0-9]+}}
; CHECK: vcmovt.q [[D:C[0-9]+]], [[C:C[0-9]+]], 6
  %m = fcmp olt <4 x float> %a, %b
  %r = select <4 x i1> %m, <4 x float> %c, <4 x float> %d
  ret <4 x float> %r
}

define <2 x float> @vmin_p(<2 x float> %a, <2 x float> %b) {
; CHECK-LABEL: vmin_p:
; CHECK: vcmp.p LT, [[A:C[0-9]+]], [[B:C[0-9]+]]
; CHECK: vcmovt.p [[B]], [[A]], 6
  %m = fcmp olt <2 x float> %a, %b
  %r = select <2 x i1> %m, <2 x float> %a, <2 x float> %b
  ret <2 x float> %r
}
