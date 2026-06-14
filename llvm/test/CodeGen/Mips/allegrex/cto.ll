; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; __builtin_allegrex_cto (count trailing ones) has no native opcode; it lowers
; to bitrev followed by clo, matching GCC's allegrex_ctosi2 expansion.

declare i32 @llvm.mips.allegrex.cto(i32)

define i32 @test_cto(i32 %x) {
; CHECK-LABEL: test_cto:
; CHECK: bitrev $[[R:[0-9]+]], ${{[0-9]+}}
; CHECK: clo ${{[0-9]+}}, $[[R]]
  %r = call i32 @llvm.mips.allegrex.cto(i32 %x)
  ret i32 %r
}
