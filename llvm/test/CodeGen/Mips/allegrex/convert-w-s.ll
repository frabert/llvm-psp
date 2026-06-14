; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; The Allegrex float-to-int conversions return the integer word (i32). The
; result is produced in an FP register and moved to a GPR via mfc1.

declare i32 @llvm.mips.allegrex.ceil.w.s(float)
declare i32 @llvm.mips.allegrex.floor.w.s(float)
declare i32 @llvm.mips.allegrex.round.w.s(float)
declare i32 @llvm.mips.allegrex.trunc.w.s(float)

define i32 @test_ceil(float %x) {
; CHECK-LABEL: test_ceil:
; CHECK: ceil.w.s $f[[F:[0-9]+]], $f{{[0-9]+}}
; CHECK: mfc1 ${{[0-9]+}}, $f[[F]]
  %r = call i32 @llvm.mips.allegrex.ceil.w.s(float %x)
  ret i32 %r
}

define i32 @test_floor(float %x) {
; CHECK-LABEL: test_floor:
; CHECK: floor.w.s $f[[F:[0-9]+]], $f{{[0-9]+}}
; CHECK: mfc1 ${{[0-9]+}}, $f[[F]]
  %r = call i32 @llvm.mips.allegrex.floor.w.s(float %x)
  ret i32 %r
}

define i32 @test_round(float %x) {
; CHECK-LABEL: test_round:
; CHECK: round.w.s $f[[F:[0-9]+]], $f{{[0-9]+}}
; CHECK: mfc1 ${{[0-9]+}}, $f[[F]]
  %r = call i32 @llvm.mips.allegrex.round.w.s(float %x)
  ret i32 %r
}

define i32 @test_trunc(float %x) {
; CHECK-LABEL: test_trunc:
; CHECK: trunc.w.s $f[[F:[0-9]+]], $f{{[0-9]+}}
; CHECK: mfc1 ${{[0-9]+}}, $f[[F]]
  %r = call i32 @llvm.mips.allegrex.trunc.w.s(float %x)
  ret i32 %r
}
