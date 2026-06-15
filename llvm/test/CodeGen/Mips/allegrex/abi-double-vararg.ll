; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; The Allegrex C ABI delegates to O32, so f64 splits across the FPU arg pair and
; varargs spill the integer arg registers. These tests pin that behaviour.

; double passed in $f12/$f14, returned in $f0 (O32 hard-float).
define double @dadd(double %a, double %b) {
; CHECK-LABEL: dadd:
; CHECK: add.d $f0, $f12, $f14
  %r = fadd double %a, %b
  ret double %r
}

declare void @llvm.va_start(ptr)

; vararg: the named arg is in $a1 ($5), the rest of the integer registers spill
; to the caller-provided save area.
define i32 @first_vararg(i32 %n, ...) {
; CHECK-LABEL: first_vararg:
; CHECK: sw $7,
; CHECK: sw $6,
; CHECK: sw $5,
  %ap = alloca ptr
  call void @llvm.va_start(ptr %ap)
  %v = va_arg ptr %ap, i32
  ret i32 %v
}
