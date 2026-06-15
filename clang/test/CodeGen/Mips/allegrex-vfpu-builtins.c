// REQUIRES: mips-registered-target
// RUN: %clang_cc1 -triple mipsel-unknown-elf -emit-llvm %s \
// RUN:            -target-cpu allegrex -target-feature +allegrex -o - \
// RUN:   | FileCheck %s

// VFPU matrix / scalar builtins reachable from C. Matrices are column-major
// <16 x float>; the builtins map straight to the overloaded-by-shape intrinsics.

typedef float m4 __attribute__((vector_size(64)));
typedef float v4 __attribute__((vector_size(16)));
typedef float v2 __attribute__((vector_size(8)));

// CHECK-LABEL: define {{.*}}@test_vmidt(
m4 test_vmidt(void) {
  // CHECK: call <16 x float> @llvm.mips.allegrex.vmidt.q()
  return __builtin_allegrex_vmidt_q();
}

// CHECK-LABEL: define {{.*}}@test_vtfm4(
v4 test_vtfm4(m4 m, v4 v) {
  // CHECK: call <4 x float> @llvm.mips.allegrex.vtfm4(<16 x float> %{{.*}}, <4 x float> %{{.*}})
  return __builtin_allegrex_vtfm4(m, v);
}

// CHECK-LABEL: define {{.*}}@test_vmscl(
m4 test_vmscl(m4 m, float s) {
  // CHECK: call <16 x float> @llvm.mips.allegrex.vmscl.q(<16 x float> %{{.*}}, float %{{.*}})
  return __builtin_allegrex_vmscl_q(m, s);
}

// CHECK-LABEL: define {{.*}}@test_vmmov(
m4 test_vmmov(m4 m) {
  // CHECK: call <16 x float> @llvm.mips.allegrex.vmmov.q(<16 x float> %{{.*}})
  return __builtin_allegrex_vmmov_q(m);
}

// CHECK-LABEL: define {{.*}}@test_vsbn(
float test_vsbn(float a, float b) {
  // CHECK: call float @llvm.mips.allegrex.vsbn(float %{{.*}}, float %{{.*}})
  return __builtin_allegrex_vsbn(a, b);
}

// CHECK-LABEL: define {{.*}}@test_vsocp(
v2 test_vsocp(float a) {
  // CHECK: call <2 x float> @llvm.mips.allegrex.vsocp.s(float %{{.*}})
  return __builtin_allegrex_vsocp_s(a);
}

typedef int v4i __attribute__((vector_size(16)));

// Float<->int conversions with an immediate scale.
// CHECK-LABEL: define {{.*}}@test_vf2in(
v4i test_vf2in(v4 f) {
  // CHECK: call <4 x i32> @llvm.mips.allegrex.vf2in.q(<4 x float> %{{.*}}, i32 5)
  return __builtin_allegrex_vf2in_q(f, 5);
}

// CHECK-LABEL: define {{.*}}@test_vi2f(
v4 test_vi2f(v4i i) {
  // CHECK: call <4 x float> @llvm.mips.allegrex.vi2f.q(<4 x i32> %{{.*}}, i32 2)
  return __builtin_allegrex_vi2f_q(i, 2);
}

// Pack four ints into one RGBA8888 word.
// CHECK-LABEL: define {{.*}}@test_vi2c(
int test_vi2c(v4i i) {
  // CHECK: call i32 @llvm.mips.allegrex.vi2c.q(<4 x i32> %{{.*}})
  return __builtin_allegrex_vi2c_q(i);
}

// Half pack/unpack.
// CHECK-LABEL: define {{.*}}@test_vf2h(
v2 test_vf2h(v4 f) {
  // CHECK: call <2 x float> @llvm.mips.allegrex.vf2h.q(<4 x float> %{{.*}})
  return __builtin_allegrex_vf2h_q(f);
}

// CHECK-LABEL: define {{.*}}@test_vh2f(
v4 test_vh2f(v2 h) {
  // CHECK: call <4 x float> @llvm.mips.allegrex.vh2f.p(<2 x float> %{{.*}})
  return __builtin_allegrex_vh2f_p(h);
}

// Per-width C aliases for the width-overloaded intrinsics (EmitMipsBuiltinExpr).
// CHECK-LABEL: define {{.*}}@test_vdot(
float test_vdot(v4 a, v4 b) {
  // CHECK: call float @llvm.mips.allegrex.vdot.v4f32(<4 x float> %{{.*}}, <4 x float> %{{.*}})
  return __builtin_allegrex_vdot_q(a, b);
}

// CHECK-LABEL: define {{.*}}@test_vsat0(
v4 test_vsat0(v4 a) {
  // CHECK: call <4 x float> @llvm.mips.allegrex.vsat0.v4f32(<4 x float> %{{.*}})
  return __builtin_allegrex_vsat0_q(a);
}

// CHECK-LABEL: define {{.*}}@test_vscl(
v4 test_vscl(v4 a, float s) {
  // CHECK: call <4 x float> @llvm.mips.allegrex.vscl.v4f32(<4 x float> %{{.*}}, float %{{.*}})
  return __builtin_allegrex_vscl_q(a, s);
}

// CHECK-LABEL: define {{.*}}@test_vcmp(
int test_vcmp(v4 a, v4 b) {
  // CHECK: call i32 @llvm.mips.allegrex.vcmp.v4f32(i32 2, <4 x float> %{{.*}}, <4 x float> %{{.*}})
  return __builtin_allegrex_vcmp_q(2, a, b);
}

// CHECK-LABEL: define {{.*}}@test_vrot(
v4 test_vrot(float a) {
  // CHECK: call <4 x float> @llvm.mips.allegrex.vrot.q(float %{{.*}}, i32 3)
  return __builtin_allegrex_vrot_q(a, 3);
}
