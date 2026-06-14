; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; Aligned v4f32 load/store + elementwise arithmetic map directly to the VFPU
; quad load/store and vadd.q. Lane-manipulation ops (build/extract) have no
; native VFPU lowering yet, so they are expanded through the stack rather than
; crashing in ISel.

define void @vadd_q(ptr %a, ptr %b, ptr %r) {
; CHECK-LABEL: vadd_q:
; CHECK-DAG: lv.q [[A:C[0-9]+]], 0($4)
; CHECK-DAG: lv.q [[B:C[0-9]+]], 0($5)
; CHECK: vadd.q [[D:C[0-9]+]], {{C[0-9]+}}, {{C[0-9]+}}
; CHECK: sv.q [[D]], 0($6)
  %va = load <4 x float>, ptr %a, align 16
  %vb = load <4 x float>, ptr %b, align 16
  %vr = fadd <4 x float> %va, %vb
  store <4 x float> %vr, ptr %r, align 16
  ret void
}

define float @extract_q(ptr %a) {
; load + extractelement of a constant lane folds to a single scalar load of that
; lane (lane 2 -> byte offset 8).
; CHECK-LABEL: extract_q:
; CHECK: lwc1 $f0, 8($4)
  %v = load <4 x float>, ptr %a, align 16
  %e = extractelement <4 x float> %v, i32 2
  ret float %e
}

define void @build_q(ptr %r, float %x, float %y, float %z, float %w) {
; BUILD_VECTOR assembles the quad lane-by-lane in the VFPU scalar slices, then
; stores it. Each lane gets a distinct scalar (no native pair/triple memory op).
; CHECK-LABEL: build_q:
; CHECK-DAG: mtv {{\$[0-9]+}}, S000
; CHECK-DAG: mtv {{\$[0-9]+}}, S001
; CHECK-DAG: mtv {{\$[0-9]+}}, S002
; CHECK-DAG: mtv {{\$[0-9]+}}, S003
; CHECK: sv.q C000, 0($4)
  %v0 = insertelement <4 x float> undef, float %x, i32 0
  %v1 = insertelement <4 x float> %v0, float %y, i32 1
  %v2 = insertelement <4 x float> %v1, float %z, i32 2
  %v3 = insertelement <4 x float> %v2, float %w, i32 3
  store <4 x float> %v3, ptr %r, align 16
  ret void
}

define void @vadd_p(ptr %a, ptr %b, ptr %r) {
; v2f32 has no native pair load/store, so it is scalarized into per-lane loads,
; a vadd.p, and per-lane stores.
; CHECK-LABEL: vadd_p:
; CHECK: vadd.p
  %va = load <2 x float>, ptr %a, align 8
  %vb = load <2 x float>, ptr %b, align 8
  %vr = fadd <2 x float> %va, %vb
  store <2 x float> %vr, ptr %r, align 8
  ret void
}
