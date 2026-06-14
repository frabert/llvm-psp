; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; The Allegrex C ABI delegates to O32: integer args in $a0-$a3 then stack, i32
; return in $v0; f32 args in $f12/$f14, f32 return in $f0. VFPU vectors stay out
; of the C ABI (handled by E, not here).

define i32 @add_i32(i32 %a, i32 %b) {
; CHECK-LABEL: add_i32:
; CHECK: addu $2, $4, $5
  %r = add i32 %a, %b
  ret i32 %r
}

define float @add_f32(float %a, float %b) {
; CHECK-LABEL: add_f32:
; CHECK: add.s $f0, $f12, $f14
  %r = fadd float %a, %b
  ret float %r
}

define i32 @call_i32(i32 %x) {
; CHECK-LABEL: call_i32:
; The first argument stays in $a0; the constant goes into $a1 (delay slot).
; CHECK: jal add_i32
; CHECK: addiu $5, $zero, 7
  %r = call i32 @add_i32(i32 %x, i32 7)
  ret i32 %r
}
