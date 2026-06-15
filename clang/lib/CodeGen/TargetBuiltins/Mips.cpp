//===-------- Mips.cpp - Emit LLVM Code for builtins ----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This contains code to emit Mips/Allegrex (VFPU) builtin calls as LLVM code.
//
//===----------------------------------------------------------------------===//

#include "CodeGenFunction.h"
#include "clang/Basic/TargetBuiltins.h"
#include "llvm/IR/IntrinsicsMips.h"

using namespace clang;
using namespace CodeGen;
using namespace llvm;

// The width-overloaded VFPU intrinsics (anyvector) cannot be ClangBuiltin
// auto-mapped, so their per-width C builtins are lowered here. Each builtin maps
// to its overloaded intrinsic; OverloadArg is the argument whose type selects
// the overload (the vector operand). vrot/vi2*/vf2* are non-overloaded and are
// auto-mapped instead.
static std::pair<Intrinsic::ID, unsigned>
getMipsAllegrexOverloadedIntrinsic(unsigned BuiltinID) {
  switch (BuiltinID) {
#define VFPU_OVL(BN, INTR, OARG)                                               \
  case Mips::BI__builtin_allegrex_##BN:                                        \
    return {Intrinsic::mips_allegrex_##INTR, OARG};
  // Unary same-width.
  VFPU_OVL(vsat0_p, vsat0, 0) VFPU_OVL(vsat0_t, vsat0, 0) VFPU_OVL(vsat0_q, vsat0, 0)
  VFPU_OVL(vsat1_p, vsat1, 0) VFPU_OVL(vsat1_t, vsat1, 0) VFPU_OVL(vsat1_q, vsat1, 0)
  VFPU_OVL(vsgn_p, vsgn, 0) VFPU_OVL(vsgn_t, vsgn, 0) VFPU_OVL(vsgn_q, vsgn, 0)
  VFPU_OVL(vocp_p, vocp, 0) VFPU_OVL(vocp_t, vocp, 0) VFPU_OVL(vocp_q, vocp, 0)
  VFPU_OVL(vrcp_p, vrcp, 0) VFPU_OVL(vrcp_t, vrcp, 0) VFPU_OVL(vrcp_q, vrcp, 0)
  VFPU_OVL(vrsq_p, vrsq, 0) VFPU_OVL(vrsq_t, vrsq, 0) VFPU_OVL(vrsq_q, vrsq, 0)
  VFPU_OVL(vasin_p, vasin, 0) VFPU_OVL(vasin_t, vasin, 0) VFPU_OVL(vasin_q, vasin, 0)
  VFPU_OVL(vnrcp_p, vnrcp, 0) VFPU_OVL(vnrcp_t, vnrcp, 0) VFPU_OVL(vnrcp_q, vnrcp, 0)
  VFPU_OVL(vnsin_p, vnsin, 0) VFPU_OVL(vnsin_t, vnsin, 0) VFPU_OVL(vnsin_q, vnsin, 0)
  VFPU_OVL(vrexp2_p, vrexp2, 0) VFPU_OVL(vrexp2_t, vrexp2, 0) VFPU_OVL(vrexp2_q, vrexp2, 0)
  // Lane shuffles.
  VFPU_OVL(vbfy1_p, vbfy1, 0) VFPU_OVL(vbfy1_q, vbfy1, 0)
  VFPU_OVL(vbfy2_q, vbfy2, 0)
  VFPU_OVL(vsrt1_q, vsrt1, 0) VFPU_OVL(vsrt2_q, vsrt2, 0)
  VFPU_OVL(vsrt3_q, vsrt3, 0) VFPU_OVL(vsrt4_q, vsrt4, 0)
  // Vector scaled by a scalar.
  VFPU_OVL(vscl_p, vscl, 0) VFPU_OVL(vscl_t, vscl, 0) VFPU_OVL(vscl_q, vscl, 0)
  // Dot products / reductions (vec -> scalar; overload is still the vector arg).
  VFPU_OVL(vdot_p, vdot, 0) VFPU_OVL(vdot_t, vdot, 0) VFPU_OVL(vdot_q, vdot, 0)
  VFPU_OVL(vhdp_p, vhdp, 0) VFPU_OVL(vhdp_t, vhdp, 0) VFPU_OVL(vhdp_q, vhdp, 0)
  VFPU_OVL(vfad_p, vfad, 0) VFPU_OVL(vfad_t, vfad, 0) VFPU_OVL(vfad_q, vfad, 0)
  VFPU_OVL(vavg_p, vavg, 0) VFPU_OVL(vavg_t, vavg, 0) VFPU_OVL(vavg_q, vavg, 0)
  // Lane-wise comparisons.
  VFPU_OVL(vsge_p, vsge, 0) VFPU_OVL(vsge_t, vsge, 0) VFPU_OVL(vsge_q, vsge, 0)
  VFPU_OVL(vslt_p, vslt, 0) VFPU_OVL(vslt_t, vslt, 0) VFPU_OVL(vslt_q, vslt, 0)
  VFPU_OVL(vscmp_p, vscmp, 0) VFPU_OVL(vscmp_t, vscmp, 0) VFPU_OVL(vscmp_q, vscmp, 0)
  // 3D-math specials.
  VFPU_OVL(vqmul_q, vqmul, 0)
  VFPU_OVL(vcrs_t, vcrs, 0)
  VFPU_OVL(vdet_p, vdet, 0)
  // vcmp: the vector operands are args 1/2, so the overload arg is 1.
  VFPU_OVL(vcmp_p, vcmp, 1) VFPU_OVL(vcmp_t, vcmp, 1) VFPU_OVL(vcmp_q, vcmp, 1)
#undef VFPU_OVL
  default:
    return {Intrinsic::not_intrinsic, 0};
  }
}

Value *CodeGenFunction::EmitMipsBuiltinExpr(unsigned BuiltinID,
                                            const CallExpr *E) {
  auto [ID, OverloadArg] = getMipsAllegrexOverloadedIntrinsic(BuiltinID);
  if (ID == Intrinsic::not_intrinsic)
    return nullptr;

  SmallVector<Value *, 4> Ops;
  for (unsigned i = 0, n = E->getNumArgs(); i != n; ++i)
    Ops.push_back(EmitScalarExpr(E->getArg(i)));

  Function *F = CGM.getIntrinsic(ID, {Ops[OverloadArg]->getType()});
  return Builder.CreateCall(F, Ops);
}
