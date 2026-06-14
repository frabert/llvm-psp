; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; VFPU intrinsic-backed ops (D3). The intrinsics are overloaded on the vector
; width; each selects the matching .p/.t/.q VFPU instruction.

declare float @llvm.mips.allegrex.vdot.v4f32(<4 x float>, <4 x float>)
declare float @llvm.mips.allegrex.vdot.v3f32(<3 x float>, <3 x float>)
declare float @llvm.mips.allegrex.vhdp.v4f32(<4 x float>, <4 x float>)
declare <4 x float> @llvm.mips.allegrex.vsat0.v4f32(<4 x float>)
declare <2 x float> @llvm.mips.allegrex.vsat1.v2f32(<2 x float>)
declare <4 x float> @llvm.mips.allegrex.vsgn.v4f32(<4 x float>)
declare <4 x float> @llvm.mips.allegrex.vocp.v4f32(<4 x float>)
declare <4 x float> @llvm.mips.allegrex.vscl.v4f32(<4 x float>, float)
declare float @llvm.mips.allegrex.vfad.v4f32(<4 x float>)
declare float @llvm.mips.allegrex.vavg.v4f32(<4 x float>)

define float @dot_q(ptr %a, ptr %b) {
; CHECK-LABEL: dot_q:
; CHECK: vdot.q {{S[0-9]+}}, {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = load <4 x float>, ptr %b, align 16
  %r = call float @llvm.mips.allegrex.vdot.v4f32(<4 x float> %x, <4 x float> %y)
  ret float %r
}

define float @hdp_q(ptr %a, ptr %b) {
; CHECK-LABEL: hdp_q:
; CHECK: vhdp.q {{S[0-9]+}}, {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = load <4 x float>, ptr %b, align 16
  %r = call float @llvm.mips.allegrex.vhdp.v4f32(<4 x float> %x, <4 x float> %y)
  ret float %r
}

define void @sat0_q(ptr %a, ptr %r) {
; CHECK-LABEL: sat0_q:
; CHECK: vsat0.q {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = call <4 x float> @llvm.mips.allegrex.vsat0.v4f32(<4 x float> %x)
  store <4 x float> %y, ptr %r, align 16
  ret void
}

define void @sgn_q(ptr %a, ptr %r) {
; CHECK-LABEL: sgn_q:
; CHECK: vsgn.q {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = call <4 x float> @llvm.mips.allegrex.vsgn.v4f32(<4 x float> %x)
  store <4 x float> %y, ptr %r, align 16
  ret void
}

define void @scl_q(ptr %a, float %s, ptr %r) {
; CHECK-LABEL: scl_q:
; CHECK: vscl.q {{C[0-9]+}}, {{C[0-9]+}}, {{S[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = call <4 x float> @llvm.mips.allegrex.vscl.v4f32(<4 x float> %x, float %s)
  store <4 x float> %y, ptr %r, align 16
  ret void
}

define float @fad_q(ptr %a) {
; CHECK-LABEL: fad_q:
; CHECK: vfad.q {{S[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %r = call float @llvm.mips.allegrex.vfad.v4f32(<4 x float> %x)
  ret float %r
}

declare <4 x float> @llvm.mips.allegrex.vsge.v4f32(<4 x float>, <4 x float>)
declare <4 x float> @llvm.mips.allegrex.vqmul.v4f32(<4 x float>, <4 x float>)
declare float @llvm.mips.allegrex.vdet.v2f32(<2 x float>, <2 x float>)

define void @sge_q(ptr %a, ptr %b, ptr %r) {
; CHECK-LABEL: sge_q:
; CHECK: vsge.q {{C[0-9]+}}, {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = load <4 x float>, ptr %b, align 16
  %z = call <4 x float> @llvm.mips.allegrex.vsge.v4f32(<4 x float> %x, <4 x float> %y)
  store <4 x float> %z, ptr %r, align 16
  ret void
}

define void @qmul_q(ptr %a, ptr %b, ptr %r) {
; CHECK-LABEL: qmul_q:
; CHECK: vqmul.q {{C[0-9]+}}, {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = load <4 x float>, ptr %b, align 16
  %z = call <4 x float> @llvm.mips.allegrex.vqmul.v4f32(<4 x float> %x, <4 x float> %y)
  store <4 x float> %z, ptr %r, align 16
  ret void
}

define float @det_p(ptr %a, ptr %b) {
; CHECK-LABEL: det_p:
; CHECK: vdet.p {{S[0-9]+}}, {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <2 x float>, ptr %a, align 8
  %y = load <2 x float>, ptr %b, align 8
  %z = call float @llvm.mips.allegrex.vdet.v2f32(<2 x float> %x, <2 x float> %y)
  ret float %z
}

declare <2 x float> @llvm.mips.allegrex.vbfy1.v2f32(<2 x float>)
declare <4 x float> @llvm.mips.allegrex.vbfy1.v4f32(<4 x float>)
declare <4 x float> @llvm.mips.allegrex.vbfy2.v4f32(<4 x float>)
declare <4 x float> @llvm.mips.allegrex.vsrt1.v4f32(<4 x float>)
declare <4 x float> @llvm.mips.allegrex.vsrt4.v4f32(<4 x float>)

define void @bfy1_p(ptr %a, ptr %r) {
; CHECK-LABEL: bfy1_p:
; CHECK: vbfy1.p {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <2 x float>, ptr %a, align 8
  %y = call <2 x float> @llvm.mips.allegrex.vbfy1.v2f32(<2 x float> %x)
  store <2 x float> %y, ptr %r, align 8
  ret void
}

define void @bfy1_q(ptr %a, ptr %r) {
; CHECK-LABEL: bfy1_q:
; CHECK: vbfy1.q {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = call <4 x float> @llvm.mips.allegrex.vbfy1.v4f32(<4 x float> %x)
  store <4 x float> %y, ptr %r, align 16
  ret void
}

define void @bfy2_q(ptr %a, ptr %r) {
; CHECK-LABEL: bfy2_q:
; CHECK: vbfy2.q {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = call <4 x float> @llvm.mips.allegrex.vbfy2.v4f32(<4 x float> %x)
  store <4 x float> %y, ptr %r, align 16
  ret void
}

define void @srt1_q(ptr %a, ptr %r) {
; CHECK-LABEL: srt1_q:
; CHECK: vsrt1.q {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = call <4 x float> @llvm.mips.allegrex.vsrt1.v4f32(<4 x float> %x)
  store <4 x float> %y, ptr %r, align 16
  ret void
}

define void @srt4_q(ptr %a, ptr %r) {
; CHECK-LABEL: srt4_q:
; CHECK: vsrt4.q {{C[0-9]+}}, {{C[0-9]+}}
  %x = load <4 x float>, ptr %a, align 16
  %y = call <4 x float> @llvm.mips.allegrex.vsrt4.v4f32(<4 x float> %x)
  store <4 x float> %y, ptr %r, align 16
  ret void
}
