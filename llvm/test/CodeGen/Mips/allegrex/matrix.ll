; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; 4x4 VFPU matrices are column-major v16f32 in the VFPUM4 register file. Memory
; traffic is four lv.q/sv.q columns 16 bytes apart; matrix ops are native.

declare <16 x float> @llvm.mips.allegrex.vmzero.q()
declare <16 x float> @llvm.mips.allegrex.vmone.q()
declare <16 x float> @llvm.mips.allegrex.vmidt.q()
declare <16 x float> @llvm.mips.allegrex.vmmov.q(<16 x float>)
declare <16 x float> @llvm.mips.allegrex.vmscl.q(<16 x float>, float)
declare <4 x float> @llvm.mips.allegrex.vtfm4(<16 x float>, <4 x float>)
declare <4 x float> @llvm.mips.allegrex.vhtfm4(<16 x float>, <4 x float>)

define void @midt(ptr %r) {
; CHECK-LABEL: midt:
; CHECK: vmidt.q M{{[0-9]+}}
; CHECK-DAG: sv.q {{C[0-9]+}}, 0($4)
; CHECK-DAG: sv.q {{C[0-9]+}}, 16($4)
; CHECK-DAG: sv.q {{C[0-9]+}}, 32($4)
; CHECK-DAG: sv.q {{C[0-9]+}}, 48($4)
  %m = call <16 x float> @llvm.mips.allegrex.vmidt.q()
  store <16 x float> %m, ptr %r, align 16
  ret void
}

define void @mzero(ptr %r) {
; CHECK-LABEL: mzero:
; CHECK: vmzero.q M{{[0-9]+}}
  %m = call <16 x float> @llvm.mips.allegrex.vmzero.q()
  store <16 x float> %m, ptr %r, align 16
  ret void
}

define void @mone(ptr %r) {
; CHECK-LABEL: mone:
; CHECK: vmone.q M{{[0-9]+}}
  %m = call <16 x float> @llvm.mips.allegrex.vmone.q()
  store <16 x float> %m, ptr %r, align 16
  ret void
}

define void @mmov(ptr %a, ptr %r) {
; CHECK-LABEL: mmov:
; CHECK: vmmov.q M{{[0-9]+}}, M{{[0-9]+}}
  %m = load <16 x float>, ptr %a, align 16
  %n = call <16 x float> @llvm.mips.allegrex.vmmov.q(<16 x float> %m)
  store <16 x float> %n, ptr %r, align 16
  ret void
}

define void @mscl(ptr %a, float %s, ptr %r) {
; CHECK-LABEL: mscl:
; CHECK: vmscl.q M{{[0-9]+}}, M{{[0-9]+}}, S{{[0-9]+}}
  %m = load <16 x float>, ptr %a, align 16
  %n = call <16 x float> @llvm.mips.allegrex.vmscl.q(<16 x float> %m, float %s)
  store <16 x float> %n, ptr %r, align 16
  ret void
}

define void @tfm4(ptr %a, ptr %v, ptr %r) {
; CHECK-LABEL: tfm4:
; CHECK: vtfm4.q {{C[0-9]+}}, M{{[0-9]+}}, {{C[0-9]+}}
  %m = load <16 x float>, ptr %a, align 16
  %x = load <4 x float>, ptr %v, align 16
  %y = call <4 x float> @llvm.mips.allegrex.vtfm4(<16 x float> %m, <4 x float> %x)
  store <4 x float> %y, ptr %r, align 16
  ret void
}

define void @htfm4(ptr %a, ptr %v, ptr %r) {
; CHECK-LABEL: htfm4:
; CHECK: vhtfm4.q {{C[0-9]+}}, M{{[0-9]+}}, {{C[0-9]+}}
  %m = load <16 x float>, ptr %a, align 16
  %x = load <4 x float>, ptr %v, align 16
  %y = call <4 x float> @llvm.mips.allegrex.vhtfm4(<16 x float> %m, <4 x float> %x)
  store <4 x float> %y, ptr %r, align 16
  ret void
}
