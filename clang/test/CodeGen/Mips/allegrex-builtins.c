// REQUIRES: mips-registered-target
// RUN: %clang_cc1 -triple mipsel-unknown-elf -emit-llvm %s \
// RUN:            -target-cpu allegrex -target-feature +allegrex -o - \
// RUN:   | FileCheck %s

// Allegrex scalar bit builtins. cto (count trailing ones) previously failed to
// compile because the builtin had no backing intrinsic.

// CHECK-LABEL: define {{.*}}i32 @test_cto(
int test_cto(int x) {
  // CHECK: call i32 @llvm.mips.allegrex.cto(i32 %{{.*}})
  return __builtin_allegrex_cto(x);
}

// CHECK-LABEL: define {{.*}}i32 @test_clo(
int test_clo(int x) {
  // CHECK: call i32 @llvm.mips.allegrex.clo(i32 %{{.*}})
  return __builtin_allegrex_clo(x);
}

// CHECK-LABEL: define {{.*}}i32 @test_bitrev(
int test_bitrev(int x) {
  // CHECK: call i32 @llvm.mips.allegrex.bitrev(i32 %{{.*}})
  return __builtin_allegrex_bitrev(x);
}

// The *_w_s conversions return int (i32), matching GCC's MIPS_SI_FTYPE_SF.

// CHECK-LABEL: define {{.*}}i32 @test_ceil_w_s(
int test_ceil_w_s(float x) {
  // CHECK: call i32 @llvm.mips.allegrex.ceil.w.s(float %{{.*}})
  return __builtin_allegrex_ceil_w_s(x);
}

// CHECK-LABEL: define {{.*}}i32 @test_trunc_w_s(
int test_trunc_w_s(float x) {
  // CHECK: call i32 @llvm.mips.allegrex.trunc.w.s(float %{{.*}})
  return __builtin_allegrex_trunc_w_s(x);
}
