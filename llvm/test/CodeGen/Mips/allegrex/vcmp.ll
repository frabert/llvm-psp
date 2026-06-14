; RUN: llc -mtriple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex < %s | FileCheck %s

; vcmp.{p,t,q} writes the VFPU condition codes. The intrinsic reads them back
; into a GPR with mfvc; a branch on a single condition bit folds to bvt/bvf.
; vcmp must always print all three operands (the short forms are parse-only):
; pspdev's binutils rejects the operand-omitted spelling for non-FL/TR codes.

declare i32 @llvm.mips.allegrex.vcmp.v4f32(i32 immarg, <4 x float>, <4 x float>)
declare i32 @llvm.mips.allegrex.vcmp.v3f32(i32 immarg, <3 x float>, <3 x float>)

; The condition-code word is materialised with mfvc when it is used as a value.
define i32 @vcmp_read_q(ptr %a, ptr %b) {
; CHECK-LABEL: vcmp_read_q:
; CHECK: vcmp.q LT, {{C[0-9]+}}, {{C[0-9]+}}
; CHECK: mfvc $2, $131
  %x = load <4 x float>, ptr %a, align 16
  %y = load <4 x float>, ptr %b, align 16
  %r = call i32 @llvm.mips.allegrex.vcmp.v4f32(i32 2, <4 x float> %x, <4 x float> %y)
  ret i32 %r
}

define i32 @vcmp_read_t(ptr %a, ptr %b) {
; CHECK-LABEL: vcmp_read_t:
; CHECK: vcmp.t EQ, {{C[0-9]+}}, {{C[0-9]+}}
; CHECK: mfvc $2, $131
  %x = load <3 x float>, ptr %a, align 16
  %y = load <3 x float>, ptr %b, align 16
  %r = call i32 @llvm.mips.allegrex.vcmp.v3f32(i32 1, <3 x float> %x, <3 x float> %y)
  ret i32 %r
}

; Branch taken when all lanes compare true (bit 5): vcmp + a condition-bit
; branch, with no mfvc materialisation.
define void @vcmp_branch_all(ptr %a, ptr %b, ptr %sink) {
; CHECK-LABEL: vcmp_branch_all:
; CHECK: vcmp.q LT, {{C[0-9]+}}, {{C[0-9]+}}
; CHECK: bv{{[tf]}} 5, {{\$BB[0-9_]+}}
; CHECK-NOT: mfvc
  %x = load <4 x float>, ptr %a, align 16
  %y = load <4 x float>, ptr %b, align 16
  %bits = call i32 @llvm.mips.allegrex.vcmp.v4f32(i32 2, <4 x float> %x, <4 x float> %y)
  %t = and i32 %bits, 32
  %c = icmp ne i32 %t, 0
  br i1 %c, label %taken, label %done
taken:
  store float 1.0, ptr %sink, align 4
  br label %done
done:
  ret void
}

; Branch taken when no lane compares true (bit 4 clear): folds to the opposite
; condition-bit branch.
define void @vcmp_branch_none(ptr %a, ptr %b, ptr %sink) {
; CHECK-LABEL: vcmp_branch_none:
; CHECK: vcmp.q EQ, {{C[0-9]+}}, {{C[0-9]+}}
; CHECK: bv{{[tf]}} 4, {{\$BB[0-9_]+}}
; CHECK-NOT: mfvc
  %x = load <4 x float>, ptr %a, align 16
  %y = load <4 x float>, ptr %b, align 16
  %bits = call i32 @llvm.mips.allegrex.vcmp.v4f32(i32 1, <4 x float> %x, <4 x float> %y)
  %t = and i32 %bits, 16
  %c = icmp eq i32 %t, 0
  br i1 %c, label %taken, label %done
taken:
  store float 1.0, ptr %sink, align 4
  br label %done
done:
  ret void
}
