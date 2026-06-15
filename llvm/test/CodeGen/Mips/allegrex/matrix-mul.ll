; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; vmmul.q matrix product. The first operand is read through the transposed M4I
; (E-view) of its register; COPY_TO_REGCLASS rebinds it to that view, and since
; the two views alias the rebind costs nothing when it lands on the same
; register. The dest is @earlyclobber (cannot overlap a source). Encodings
; byte-validated against psp-as.

declare <16 x float> @llvm.mips.allegrex.vmmul.q(<16 x float>, <16 x float>)

define void @mm(ptr %a, ptr %b, ptr %d) {
; CHECK-LABEL: mm:
; CHECK-NOT: vmmov
; CHECK: vmmul.q [[D:M[0-9]+]], {{M[0-9]+}}, {{M[0-9]+}}
  %ma = load <16 x float>, ptr %a, align 16
  %mb = load <16 x float>, ptr %b, align 16
  %r = call <16 x float> @llvm.mips.allegrex.vmmul.q(<16 x float> %ma, <16 x float> %mb)
  store <16 x float> %r, ptr %d, align 16
  ret void
}

; chained product reusing %ma keeps it in one register; no transpose copy.
define void @mm_chain(ptr %a, ptr %b, ptr %d, ptr %e) {
; CHECK-LABEL: mm_chain:
; CHECK: vmmul.q {{M[0-9]+}}, [[A:M[0-9]+]], {{M[0-9]+}}
; CHECK: vmmul.q {{M[0-9]+}}, [[A]], {{M[0-9]+}}
  %ma = load <16 x float>, ptr %a, align 16
  %mb = load <16 x float>, ptr %b, align 16
  %r = call <16 x float> @llvm.mips.allegrex.vmmul.q(<16 x float> %ma, <16 x float> %mb)
  store <16 x float> %r, ptr %d, align 16
  %r2 = call <16 x float> @llvm.mips.allegrex.vmmul.q(<16 x float> %ma, <16 x float> %r)
  store <16 x float> %r2, ptr %e, align 16
  ret void
}
