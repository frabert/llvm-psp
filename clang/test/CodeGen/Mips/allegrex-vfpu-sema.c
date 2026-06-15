// REQUIRES: mips-registered-target
// RUN: %clang_cc1 -triple mipsel-unknown-elf -target-cpu allegrex \
// RUN:            -target-feature +allegrex -fsyntax-only -verify %s

// The immediate arguments of the VFPU builtins are range-checked in Sema.

typedef float v4 __attribute__((vector_size(16)));
typedef int   v4i __attribute__((vector_size(16)));

int test_vcmp_range(v4 a, v4 b, int n) {
  (void)__builtin_allegrex_vcmp_q(2, a, b);   // ok
  (void)__builtin_allegrex_vcmp_q(16, a, b);  // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  (void)__builtin_allegrex_vcmp_q(n, a, b);   // expected-error {{argument to '__builtin_allegrex_vcmp_q' must be a constant integer}}
  return 0;
}

v4 test_vrot_range(float a, int n) {
  (void)__builtin_allegrex_vrot_q(a, 3);   // ok
  (void)__builtin_allegrex_vrot_q(a, 32);  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  return __builtin_allegrex_vrot_q(a, n);  // expected-error {{argument to '__builtin_allegrex_vrot_q' must be a constant integer}}
}

v4i test_vf2in_const(v4 f, int n) {
  return __builtin_allegrex_vf2in_q(f, n);  // expected-error {{argument to '__builtin_allegrex_vf2in_q' must be a constant integer}}
}
