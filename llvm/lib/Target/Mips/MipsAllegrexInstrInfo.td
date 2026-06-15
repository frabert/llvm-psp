//=- MipsAllegrexInstrInfo.td - Mips Instruction Formats -*- tablegen -*- -===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes Mips Allegrex instructions.
//
//===----------------------------------------------------------------------===//

defm VADD  : VFPU_A_SPTQ_FMT<0x60000000, "vadd" , fadd, 1, 1, 1, 1>;
defm VSUB  : VFPU_A_SPTQ_FMT<0x60800000, "vsub" , fsub, 1, 1, 1, 1>;
defm VDIV  : VFPU_A_SPTQ_FMT<0x63800000, "vdiv" , fdiv, 1, 1, 1, 1>;
defm VMUL  : VFPU_A_SPTQ_FMT<0x64000000, "vmul" , fmul, 1, 1, 1, 1>;
defm VMIN  : VFPU_A_SPTQ_FMT<0x6d000000, "vmin" , fminimum, 1, 1, 1, 1>;
defm VMAX  : VFPU_A_SPTQ_FMT<0x6d800000, "vmax" , fmaximum, 1, 1, 1, 1>;
defm VSCMP : VFPU_A_SPTQ_FMT<0x6e800000, "vscmp", null_frag, 1, 1, 1, 1>;
defm VSGE  : VFPU_A_SPTQ_FMT<0x6f000000, "vsge" , null_frag, 1, 1, 1, 1>;
defm VSLT  : VFPU_A_SPTQ_FMT<0x6f800000, "vslt" , null_frag, 1, 1, 1, 1>;
// vqmul's destination must not overlap a source (see the matrix-transform note).
let Constraints = "@earlyclobber $rd" in
defm VQMUL : VFPU_A_SPTQ_FMT<0xf2800000, "vqmul", null_frag, 0, 0, 0, 1>;
defm VSBN  : VFPU_A_SPTQ_FMT<0x61000000, "vsbn" , null_frag, 1, 0, 0, 0>;
defm VSCL  : VFPU_A_SPTQ_FMT<0x65000000, "vscl" , null_frag, 0, 1, 1, 1,
                             LinearOperands, LinearOperands, ScalarOperands>;
defm VCRSP : VFPU_A_SPTQ_FMT<0xf2800000, "vcrsp", null_frag, 0, 0, 1, 0>;
defm VCRS  : VFPU_A_SPTQ_FMT<0x66808000, "vcrs" , null_frag, 0, 0, 1, 0>;
defm VDOT  : VFPU_A_SPTQ_FMT<0x64800000, "vdot" , null_frag, 0, 1, 1, 1,
                             ScalarOperands>;
defm VDET  : VFPU_A_SPTQ_FMT<0x67000000, "vdet" , null_frag, 0, 1, 0, 0,
                             ScalarOperands>;
defm VHDP  : VFPU_A_SPTQ_FMT<0x66000000, "vhdp" , null_frag, 0, 1, 1, 1,
                             ScalarOperands>;
defm VMSCL : VFPU_A_SPTQ_FMT<0xf2000000, "vmscl", null_frag, 0, 1, 1, 1,
                             MatrixOperands, MatrixOperands, ScalarOperands>;
// vmmul reads rs in the transposed (M4I / E-view) matrix and, like the other
// matrix-transform ops, forbids the destination from overlapping a source
// (psp-as rejects the overlap as a "destination register conflict").
let Constraints = "@earlyclobber $rd" in
defm VMMUL : VFPU_A_SPTQ_FMT<0xf0000000, "vmmul", null_frag, 0, 1, 1, 1,
                             MatrixOperands, IMatrixOperands, MatrixOperands>;
// The (homogeneous) matrix-transform ops read the source matrix column-by-column
// while writing the result, so the hardware forbids the destination from
// overlapping any source register (the reference assembler rejects it as a
// "destination register conflict"). Mark the destination earlyclobber so the
// register allocator never aliases it with a source.
let Constraints = "@earlyclobber $rd" in {
def VHTFM2_P : VFPU_A_FMT<0xf0800000, 0,
                          (outs VFPUPOpnd:$rd),
                          (ins VFPUPOpnd:$rt, VFPUM2Opnd:$rs),
                          "vhtfm2.p", []>, INSN_ALLEGREX;
def VHTFM3_T : VFPU_A_FMT<0xf1000000, 1,
                          (outs VFPUTOpnd:$rd),
                          (ins VFPUTOpnd:$rt, VFPUM3Opnd:$rs),
                          "vhtfm3.t", []>, INSN_ALLEGREX;
def VHTFM4_Q : VFPU_A_FMT<0xf1800000, 2,
                          (outs VFPUQOpnd:$rd),
                          (ins VFPUQOpnd:$rt, VFPUM4Opnd:$rs),
                          "vhtfm4.q", []>, INSN_ALLEGREX;
def VTFM2_P : VFPU_A_FMT<0xf0800000, 1,
                         (outs VFPUPOpnd:$rd),
                         (ins VFPUPOpnd:$rt, VFPUM2Opnd:$rs),
                         "vtfm2.p", []>, INSN_ALLEGREX;
def VTFM3_T : VFPU_A_FMT<0xf1000000, 2,
                         (outs VFPUTOpnd:$rd),
                         (ins VFPUTOpnd:$rt, VFPUM3Opnd:$rs),
                         "vtfm3.t", []>, INSN_ALLEGREX;
def VTFM4_Q : VFPU_A_FMT<0xf1800000, 3,
                         (outs VFPUQOpnd:$rd),
                         (ins VFPUQOpnd:$rt, VFPUM4Opnd:$rs),
                         "vtfm4.q", []>, INSN_ALLEGREX;
}

defm VABS   : VFPU_B_SPTQ_FMT<0xd0010000, "vabs"  , fabs, 1, 1, 1, 1>;
defm VNEG   : VFPU_B_SPTQ_FMT<0xd0020000, "vneg"  , fneg, 1, 1, 1, 1>;
defm VBFY1  : VFPU_B_SPTQ_FMT<0xd0420000, "vbfy1" , null_frag, 0, 1, 0, 1>;
defm VBFY2  : VFPU_B_SPTQ_FMT<0xd0430000, "vbfy2" , null_frag, 0, 0, 0, 1>;
defm VMOV   : VFPU_B_SPTQ_FMT<0xd0000000, "vmov"  , null_frag, 1, 1, 1, 1>;
defm VSAT0  : VFPU_B_SPTQ_FMT<0xd0040000, "vsat0" , null_frag, 1, 1, 1, 1>;
defm VSAT1  : VFPU_B_SPTQ_FMT<0xd0050000, "vsat1" , null_frag, 1, 1, 1, 1>;
defm VSRT4  : VFPU_B_SPTQ_FMT<0xd0490000, "vsrt4" , null_frag, 0, 0, 0, 1>;
defm VSRT3  : VFPU_B_SPTQ_FMT<0xd0480000, "vsrt3" , null_frag, 0, 0, 0, 1>;
defm VSRT2  : VFPU_B_SPTQ_FMT<0xd0410000, "vsrt2" , null_frag, 0, 0, 0, 1>;
defm VSRT1  : VFPU_B_SPTQ_FMT<0xd0400000, "vsrt1" , null_frag, 0, 0, 0, 1>;
defm VSBZ   : VFPU_B_SPTQ_FMT<0xd0360000, "vsbz"  , null_frag, 1, 0, 0, 0>;
defm VT5650 : VFPU_B_SPTQ_FMT<0xd05b0000, "vt5650", null_frag, 0, 0, 0, 1,
                              HalfOperands>;
defm VT5551 : VFPU_B_SPTQ_FMT<0xd05a0000, "vt5551", null_frag, 0, 0, 0, 1,
                              HalfOperands>;
defm VT4444 : VFPU_B_SPTQ_FMT<0xd0590000, "vt4444", null_frag, 0, 0, 0, 1,
                              HalfOperands>;
defm VF2H   : VFPU_B_SPTQ_FMT<0xd0320000, "vf2h"  , null_frag, 0, 1, 0, 1,
                              HalfOperands>;
defm VUS2I  : VFPU_B_SPTQ_FMT<0xd03a0000, "vus2i" , null_frag, 1, 1, 0, 0,
                              DoubleOperands>;
defm VS2I   : VFPU_B_SPTQ_FMT<0xd03b0000, "vs2i"  , null_frag, 1, 1, 0, 0,
                              DoubleOperands>;
defm VSOCP  : VFPU_B_SPTQ_FMT<0xd0450000, "vsocp" , null_frag, 1, 1, 0, 0,
                              DoubleOperands>;
defm VRCP   : VFPU_B_SPTQ_FMT<0xd0100000, "vrcp"  , null_frag, 1, 1, 1, 1>;
defm VRSQ   : VFPU_B_SPTQ_FMT<0xd0110000, "vrsq"  , null_frag, 1, 1, 1, 1>;
defm VSIN   : VFPU_B_SPTQ_FMT<0xd0120000, "vsin"  , fsin, 1, 1, 1, 1>;
defm VCOS   : VFPU_B_SPTQ_FMT<0xd0130000, "vcos"  , fcos, 1, 1, 1, 1>;
defm VEXP2  : VFPU_B_SPTQ_FMT<0xd0140000, "vexp2" , fexp2, 1, 1, 1, 1>;
defm VLOG2  : VFPU_B_SPTQ_FMT<0xd0150000, "vlog2" , flog2, 1, 1, 1, 1>;
defm VSQRT  : VFPU_B_SPTQ_FMT<0xd0160000, "vsqrt" , fsqrt, 1, 1, 1, 1>;
defm VASIN  : VFPU_B_SPTQ_FMT<0xd0170000, "vasin" , null_frag, 1, 1, 1, 1>;
defm VNRCP  : VFPU_B_SPTQ_FMT<0xd0180000, "vnrcp" , null_frag, 1, 1, 1, 1>;
defm VNSIN  : VFPU_B_SPTQ_FMT<0xd01a0000, "vnsin" , null_frag, 1, 1, 1, 1>;
defm VREXP2 : VFPU_B_SPTQ_FMT<0xd01c0000, "vrexp2", null_frag, 1, 1, 1, 1>;
defm VOCP   : VFPU_B_SPTQ_FMT<0xd0440000, "vocp"  , null_frag, 1, 1, 1, 1>;
defm VAVG   : VFPU_B_SPTQ_FMT<0xd0470000, "vavg"  , null_frag, 0, 1, 1, 1,
                              ScalarOperands>;
defm VFAD   : VFPU_B_SPTQ_FMT<0xd0460000, "vfad"  , null_frag, 0, 1, 1, 1,
                              ScalarOperands>;
defm VSGN   : VFPU_B_SPTQ_FMT<0xd04a0000, "vsgn"  , null_frag, 1, 1, 1, 1>;
defm VH2F   : VFPU_B_SPTQ_FMT<0xd0330000, "vh2f"  , null_frag, 1, 1, 0, 0,
                              DoubleOperands>;
defm VI2C   : VFPU_B_SPTQ_FMT<0xd03d8080, "vi2c"  , null_frag, 0, 0, 0, 1,
                              ScalarOperands>;
defm VI2S   : VFPU_B_SPTQ_FMT<0xd03f0000, "vi2s"  , null_frag, 0, 1, 0, 1,
                              HalfOperands>;
defm VI2US  : VFPU_B_SPTQ_FMT<0xd03e0000, "vi2us" , null_frag, 0, 1, 0, 1,
                              HalfOperands>;
defm VLGB   : VFPU_B_SPTQ_FMT<0xd0370000, "vlgb"  , null_frag, 1, 0, 0, 0>;
defm VI2UC  : VFPU_B_SPTQ_FMT<0xd03c0000, "vi2uc" , null_frag, 0, 0, 0, 1,
                              ScalarOperands>;
// Unsigned-char-to-int: reads one packed-byte scalar and writes four ints to a
// quad, so the source/dest widths differ and it can't use the SPTQ multiclass.
def VUC2IFS_S : VFPU_B_FMT<0xd0380000, 0, (outs VFPUQOpnd:$rd),
                           (ins VFPUSOpnd:$rs), "vuc2ifs.s", []>, INSN_ALLEGREX;
defm VMMOV : VFPU_B_SPTQ_FMT<0xf3800000, "vmmov", null_frag, 0, 1, 1, 1,
                             MatrixOperands, MatrixOperands>;

defm VIDT   : VFPU_C_SPTQ_FMT<0xd0030000, "vidt"  , [], 0, 1, 0, 1>;
defm VZERO  : VFPU_C_SPTQ_FMT<0xd0060000, "vzero" , [], 1, 1, 1, 1>;
defm VONE   : VFPU_C_SPTQ_FMT<0xd0070000, "vone"  , [], 1, 1, 1, 1>;
defm VRNDF1 : VFPU_C_SPTQ_FMT<0xd0220000, "vrndf1", [], 1, 1, 1, 1>;
defm VRNDF2 : VFPU_C_SPTQ_FMT<0xd0230000, "vrndf2", [], 1, 1, 1, 1>;
defm VRNDI  : VFPU_C_SPTQ_FMT<0xd0210000, "vrndi" , [], 1, 1, 1, 1>;
def VRNDS_S : VFPU_VRNDS_FMT< 0xd0200000, []>, INSN_ALLEGREX;
defm VMIDT  : VFPU_C_SPTQ_FMT<0xf3830000, "vmidt" , [], 0, 1, 1, 1,
                              MatrixOperands>;
defm VMZERO : VFPU_C_SPTQ_FMT<0xf3860000, "vmzero", [], 0, 1, 1, 1,
                              MatrixOperands>;
defm VMONE  : VFPU_C_SPTQ_FMT<0xf3870000, "vmone" , [], 0, 1, 1, 1,
                              MatrixOperands>;

def VCST_S : VCST_SPTQ_FMT<0, "vcst.s\t$rd, $cst", VFPUSOpnd, []>,
             INSN_ALLEGREX;
def VCST_P : VCST_SPTQ_FMT<1, "vcst.p\t$rd, $cst", VFPUPOpnd, []>,
             INSN_ALLEGREX;
def VCST_T : VCST_SPTQ_FMT<2, "vcst.t\t$rd, $cst", VFPUTOpnd, []>,
             INSN_ALLEGREX;
def VCST_Q : VCST_SPTQ_FMT<3, "vcst.q\t$rd, $cst", VFPUQOpnd, []>,
             INSN_ALLEGREX;

let Inst = 0x70000000 in {
  def HALT : InstSE<(outs), (ins), "halt", [], II_ALLEGREX, FrmI>,
             INSN_ALLEGREX;
}

let Inst = 0x7000003f in {
  def DBREAK : InstSE<(outs), (ins), "dbreak", [], II_ALLEGREX, FrmI>,
               INSN_ALLEGREX;
}

let Inst = 0x7000003e in {
  def DRET : InstSE<(outs), (ins), "dret", [], II_ALLEGREX, FrmI>,
             INSN_ALLEGREX;
}

let Inst = 0xffff040d in {
  def VFLUSH : InstSE<(outs), (ins), "vflush", [], II_ALLEGREX, FrmI>,
               INSN_ALLEGREX;
}

def VIIM_S : VFIIM_FMT<"viim.s", 0xdf000000, i16imm,
                       [(set VFPUSOpnd:$rd, (sint_to_fp i16:$num))]>, INSN_ALLEGREX;
def VFIM_S : VFIIM_FMT<"vfim.s", 0xdf800000, f16imm,
                       [(set VFPUSOpnd:$rd, (fpextend f16:$num))]>, INSN_ALLEGREX;

def VSYNC : VSYNC_FMT, INSN_ALLEGREX;
def : MipsInstAlias<"vsync", (VSYNC 0x0320)>, INSN_ALLEGREX;

let Inst = 0xffff0000 in {
  def VNOP : InstSE<(outs), (ins), "vnop", [], II_ALLEGREX, FrmI>,
             INSN_ALLEGREX;
}

let rs = 0b00000, shamt = 0b00000 in {
  def MFIC : FR<0b011100, 0b100100, (outs GPR32Opnd:$rt), (ins GPR32Opnd:$rd),
                "mfic\t$rt, $rd", [], II_ALLEGREX>, INSN_ALLEGREX;
  def MTIC : FR<0b011100, 0b100110, (outs GPR32Opnd:$rd), (ins GPR32Opnd:$rt),
                "mtic\t$rt, $rd", [], II_ALLEGREX>, INSN_ALLEGREX;
}

let rs = 0b00000, shamt = 0b00011 in {
  def WSBW : FR<0b011111, 0b100000, (outs GPR32Opnd:$rd), (ins GPR32Opnd:$rt),
                "wsbw\t$rd, $rt",
                [(set GPR32Opnd:$rd, (int_mips_allegrex_wsbw GPR32Opnd:$rt))],
                II_ALLEGREX>, INSN_ALLEGREX;
}

let shamt = 0b00000 in {
  def MAX : FR<0b000000, 0b101100, (outs GPR32Opnd:$rd),
               (ins GPR32Opnd:$rs, GPR32Opnd:$rt),
               "max\t$rd, $rs, $rt",
               [(set GPR32Opnd:$rd, (smax GPR32Opnd:$rs, GPR32Opnd:$rt))],
               II_ALLEGREX>, INSN_ALLEGREX;
  def MIN : FR<0b000000, 0b101101, (outs GPR32Opnd:$rd),
               (ins GPR32Opnd:$rs, GPR32Opnd:$rt),
               "min\t$rd, $rs, $rt",
               [(set GPR32Opnd:$rd, (smin GPR32Opnd:$rs, GPR32Opnd:$rt))],
               II_ALLEGREX>, INSN_ALLEGREX;
}

def VCMP_S : VCMP_SPTQ_FMT<"vcmp.s", 0, VFPUSOpnd, f32>, INSN_ALLEGREX;
def VCMP_P : VCMP_SPTQ_FMT<"vcmp.p", 1, VFPUPOpnd, v2f32>, INSN_ALLEGREX;
def VCMP_T : VCMP_SPTQ_FMT<"vcmp.t", 2, VFPUTOpnd, v3f32>, INSN_ALLEGREX;
def VCMP_Q : VCMP_SPTQ_FMT<"vcmp.q", 3, VFPUQOpnd, v4f32>, INSN_ALLEGREX;

// These short forms are parse-only conveniences (Emit=0): the reference
// assembler only accepts the omitted-operand spelling for FL/TR, so printing
// them for an arbitrary condition (when rs/rt happen to be C000) produces
// assembly pspdev's binutils rejects. Always print the canonical 3-operand form.
def : MipsInstAlias<"vcmp.s\t$cmp, $rs",
  (VCMP_S VFPUConditionOpnd:$cmp, VFPUSOpnd:$rs, S000), 0>, INSN_ALLEGREX;
def : MipsInstAlias<"vcmp.s\t$cmp",
  (VCMP_S VFPUConditionOpnd:$cmp, S000, S000), 0>, INSN_ALLEGREX;

def : MipsInstAlias<"vcmp.p\t$cmp, $rs",
  (VCMP_P VFPUConditionOpnd:$cmp, VFPUPOpnd:$rs, C000_P), 0>, INSN_ALLEGREX;
def : MipsInstAlias<"vcmp.p\t$cmp",
  (VCMP_P VFPUConditionOpnd:$cmp, C000_P, C000_P), 0>, INSN_ALLEGREX;

def : MipsInstAlias<"vcmp.t\t$cmp, $rs",
  (VCMP_T VFPUConditionOpnd:$cmp, VFPUTOpnd:$rs, C000_T), 0>, INSN_ALLEGREX;
def : MipsInstAlias<"vcmp.t\t$cmp",
  (VCMP_T VFPUConditionOpnd:$cmp, C000_T, C000_T), 0>, INSN_ALLEGREX;

def : MipsInstAlias<"vcmp.q\t$cmp, $rs",
  (VCMP_Q VFPUConditionOpnd:$cmp, VFPUQOpnd:$rs, C000_Q), 0>, INSN_ALLEGREX;
def : MipsInstAlias<"vcmp.q\t$cmp",
  (VCMP_Q VFPUConditionOpnd:$cmp, C000_Q, C000_Q), 0>, INSN_ALLEGREX;

// Like 'store', but always requires vector size alignment.
def alignedstore : PatFrag<(ops node:$val, node:$ptr),
                           (store node:$val, node:$ptr), [{
  auto *St = cast<StoreSDNode>(N);
  return St->getAlign() >= St->getMemoryVT().getStoreSize();
}]>;

// Like 'load', but always requires vector size alignment.
def alignedload : PatFrag<(ops node:$ptr), (load node:$ptr), [{
  auto *Ld = cast<LoadSDNode>(N);
  return Ld->getAlign() >= Ld->getMemoryVT().getStoreSize();
}]>;

def LV_S  : VFPU_LOADSTORE_FMT<0b110010, "lv.s",
              (outs VFPUSOpnd:$rt), (ins mem:$addr),
              [(set VFPUSOpnd:$rt, (f32 (load addr:$addr)))]>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeVFPUMemS";
  // Shares the LWC2 primary opcode; kept in a separate decoder table.
  let DecoderNamespace = "Allegrex";
}

def LV_Q  : VFPU_LOADSTORE_FMT<0b110110, "lv.q",
              (outs VFPUQOpnd:$rt), (ins mem:$addr),
              [(set VFPUQOpnd:$rt, (v4f32 (alignedload addr:$addr)))]>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeVFPUMemQ";
  // Shares the LDC2 primary opcode; kept in a separate decoder table.
  let DecoderNamespace = "Allegrex";
}

def LVL_Q : VFPU_LOADSTORE_FMT<0b110101, "lvl.q",
              (outs VFPUQOpnd:$rt), (ins mem:$addr)>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeVFPUMemQ";
  // Shares the LDC1 primary opcode; kept in a separate decoder table.
  let DecoderNamespace = "Allegrex";
  // No ISel pattern, so mayLoad must be set explicitly; without it the
  // asm parser's symbol/large-offset mem expansion is skipped.
  let mayLoad = 1;
}

def LVR_Q : LVR_Q_FMT<(outs VFPUQOpnd:$rt), (ins mem:$addr)>, INSN_ALLEGREX {
  // Encoding overlaps lvl.q, so this is an assembler-only mnemonic; that
  // encoding disassembles back as lvl.q.
  let isAsmParserOnly = 1;
  let mayLoad = 1;
}

def VWB_Q : VFPU_LOADSTORE_FMT<0b111110, "vwb.q",
              (outs), (ins VFPUQOpnd:$rt, mem:$addr)>, INSN_ALLEGREX
{
  // Encoding overlaps the write-back form of sv.q, so this is an assembler-only
  // mnemonic; that encoding disassembles back as sv.q.
  let isAsmParserOnly = 1;
  let Inst{1} = 1;
}

def SV_S  : VFPU_LOADSTORE_FMT<0b111010, "sv.s",
              (outs), (ins VFPUSOpnd:$rt, mem:$addr),
              [(store (f32 VFPUSOpnd:$rt), addr:$addr)]>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeVFPUMemS";
  // Shares the SWC2 primary opcode; kept in a separate decoder table.
  let DecoderNamespace = "Allegrex";
}

def SVL_Q : VFPU_LOADSTORE_FMT<0b111101, "svl.q",
              (outs), (ins VFPUQOpnd:$rt, mem:$addr)>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeVFPUMemQ";
  // Shares the SDC1 primary opcode; kept in a separate decoder table.
  let DecoderNamespace = "Allegrex";
  // No ISel pattern, so mayStore must be set explicitly (see LVL_Q).
  let mayStore = 1;
}

def SVR_Q : SVR_Q_FMT<(outs), (ins VFPUQOpnd:$rt, mem:$addr, VFPUWriteBackOpnd:$wb)>, INSN_ALLEGREX {
  // Encoding overlaps svl.q, so this is an assembler-only mnemonic; that
  // encoding disassembles back as svl.q.
  let isAsmParserOnly = 1;
  let mayStore = 1;
}

def SV_Q : SV_Q_FMT<(outs), (ins VFPUQOpnd:$rt, mem:$addr, VFPUWriteBackOpnd:$wb)>, INSN_ALLEGREX
{
  let DecoderMethod = "DecodeVFPUMemQWriteBack";
  // Shares the SDC2 primary opcode; kept in a separate decoder table.
  let DecoderNamespace = "Allegrex";
}
def : MipsInstAlias<"sv.q\t$rt, $addr", (SV_Q VFPUQOpnd:$rt, mem:$addr, 1)>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeMem";
}
def : MipsPat<(alignedstore (v4f32 VFPUQOpnd:$rt), addr:$addr), (SV_Q VFPUQOpnd:$rt, addr:$addr, 1)>
{
  string DecoderMethod = "DecodeMem";
}

//===----------------------------------------------------------------------===//
// VFPU vector lane access (D1/E1).
//
// A VFPU vector is held in the column-major register file where lane i is the
// scalar subregister sub_vfpus_(i+1). EXTRACT/INSERT/SCALAR_TO_VECTOR therefore
// lower directly to subregister copies, with no memory traffic; BUILD_VECTOR is
// custom-lowered to a chain of these inserts (see MipsSEISelLowering.cpp).
//
// Guarded by HasAllegrex so these generic-node patterns do not interfere with
// the MSA v4f32 lane patterns on non-Allegrex subtargets.
//===----------------------------------------------------------------------===//

let Predicates = [HasAllegrex] in {

// EXTRACT_VECTOR_ELT: pull lane i out as a VFPU scalar.
def : MipsPat<(f32 (vector_extract (v4f32 VFPUQOpnd:$v), (i32 0))),
              (f32 (EXTRACT_SUBREG VFPUQOpnd:$v, sub_vfpus_1))>;
def : MipsPat<(f32 (vector_extract (v4f32 VFPUQOpnd:$v), (i32 1))),
              (f32 (EXTRACT_SUBREG VFPUQOpnd:$v, sub_vfpus_2))>;
def : MipsPat<(f32 (vector_extract (v4f32 VFPUQOpnd:$v), (i32 2))),
              (f32 (EXTRACT_SUBREG VFPUQOpnd:$v, sub_vfpus_3))>;
def : MipsPat<(f32 (vector_extract (v4f32 VFPUQOpnd:$v), (i32 3))),
              (f32 (EXTRACT_SUBREG VFPUQOpnd:$v, sub_vfpus_4))>;
def : MipsPat<(f32 (vector_extract (v3f32 VFPUTOpnd:$v), (i32 0))),
              (f32 (EXTRACT_SUBREG VFPUTOpnd:$v, sub_vfpus_1))>;
def : MipsPat<(f32 (vector_extract (v3f32 VFPUTOpnd:$v), (i32 1))),
              (f32 (EXTRACT_SUBREG VFPUTOpnd:$v, sub_vfpus_2))>;
def : MipsPat<(f32 (vector_extract (v3f32 VFPUTOpnd:$v), (i32 2))),
              (f32 (EXTRACT_SUBREG VFPUTOpnd:$v, sub_vfpus_3))>;
def : MipsPat<(f32 (vector_extract (v2f32 VFPUPOpnd:$v), (i32 0))),
              (f32 (EXTRACT_SUBREG VFPUPOpnd:$v, sub_vfpus_1))>;
def : MipsPat<(f32 (vector_extract (v2f32 VFPUPOpnd:$v), (i32 1))),
              (f32 (EXTRACT_SUBREG VFPUPOpnd:$v, sub_vfpus_2))>;

// INSERT_VECTOR_ELT: drop a VFPU scalar into lane i.
def : MipsPat<(v4f32 (vector_insert (v4f32 VFPUQOpnd:$v), (f32 VFPUSOpnd:$s), (i32 0))),
              (INSERT_SUBREG VFPUQOpnd:$v, VFPUSOpnd:$s, sub_vfpus_1)>;
def : MipsPat<(v4f32 (vector_insert (v4f32 VFPUQOpnd:$v), (f32 VFPUSOpnd:$s), (i32 1))),
              (INSERT_SUBREG VFPUQOpnd:$v, VFPUSOpnd:$s, sub_vfpus_2)>;
def : MipsPat<(v4f32 (vector_insert (v4f32 VFPUQOpnd:$v), (f32 VFPUSOpnd:$s), (i32 2))),
              (INSERT_SUBREG VFPUQOpnd:$v, VFPUSOpnd:$s, sub_vfpus_3)>;
def : MipsPat<(v4f32 (vector_insert (v4f32 VFPUQOpnd:$v), (f32 VFPUSOpnd:$s), (i32 3))),
              (INSERT_SUBREG VFPUQOpnd:$v, VFPUSOpnd:$s, sub_vfpus_4)>;
def : MipsPat<(v3f32 (vector_insert (v3f32 VFPUTOpnd:$v), (f32 VFPUSOpnd:$s), (i32 0))),
              (INSERT_SUBREG VFPUTOpnd:$v, VFPUSOpnd:$s, sub_vfpus_1)>;
def : MipsPat<(v3f32 (vector_insert (v3f32 VFPUTOpnd:$v), (f32 VFPUSOpnd:$s), (i32 1))),
              (INSERT_SUBREG VFPUTOpnd:$v, VFPUSOpnd:$s, sub_vfpus_2)>;
def : MipsPat<(v3f32 (vector_insert (v3f32 VFPUTOpnd:$v), (f32 VFPUSOpnd:$s), (i32 2))),
              (INSERT_SUBREG VFPUTOpnd:$v, VFPUSOpnd:$s, sub_vfpus_3)>;
def : MipsPat<(v2f32 (vector_insert (v2f32 VFPUPOpnd:$v), (f32 VFPUSOpnd:$s), (i32 0))),
              (INSERT_SUBREG VFPUPOpnd:$v, VFPUSOpnd:$s, sub_vfpus_1)>;
def : MipsPat<(v2f32 (vector_insert (v2f32 VFPUPOpnd:$v), (f32 VFPUSOpnd:$s), (i32 1))),
              (INSERT_SUBREG VFPUPOpnd:$v, VFPUSOpnd:$s, sub_vfpus_2)>;

// SCALAR_TO_VECTOR: a scalar becomes lane 0 of a fresh vector.
def : MipsPat<(v4f32 (scalar_to_vector (f32 VFPUSOpnd:$s))),
              (INSERT_SUBREG (v4f32 (IMPLICIT_DEF)), VFPUSOpnd:$s, sub_vfpus_1)>;
def : MipsPat<(v3f32 (scalar_to_vector (f32 VFPUSOpnd:$s))),
              (INSERT_SUBREG (v3f32 (IMPLICIT_DEF)), VFPUSOpnd:$s, sub_vfpus_1)>;
def : MipsPat<(v2f32 (scalar_to_vector (f32 VFPUSOpnd:$s))),
              (INSERT_SUBREG (v2f32 (IMPLICIT_DEF)), VFPUSOpnd:$s, sub_vfpus_1)>;

//===----------------------------------------------------------------------===//
// VFPU intrinsic-backed ops (D3). Each intrinsic is overloaded on the vector
// width; one MipsPat per concrete width selects the matching .p/.t/.q op.
//===----------------------------------------------------------------------===//

// Unary same-width: vsat0 / vsat1 / vsgn / vocp.
multiclass VFPUUnaryIntrPat<Intrinsic Op, string Inst> {
  def : MipsPat<(v2f32 (Op (v2f32 VFPUPOpnd:$rs))),
                (!cast<Instruction>(Inst#"_P") VFPUPOpnd:$rs)>;
  def : MipsPat<(v3f32 (Op (v3f32 VFPUTOpnd:$rs))),
                (!cast<Instruction>(Inst#"_T") VFPUTOpnd:$rs)>;
  def : MipsPat<(v4f32 (Op (v4f32 VFPUQOpnd:$rs))),
                (!cast<Instruction>(Inst#"_Q") VFPUQOpnd:$rs)>;
}
defm : VFPUUnaryIntrPat<int_mips_allegrex_vsat0, "VSAT0">;
defm : VFPUUnaryIntrPat<int_mips_allegrex_vsat1, "VSAT1">;
defm : VFPUUnaryIntrPat<int_mips_allegrex_vsgn,  "VSGN">;
defm : VFPUUnaryIntrPat<int_mips_allegrex_vocp,  "VOCP">;
defm : VFPUUnaryIntrPat<int_mips_allegrex_vrcp,  "VRCP">;
defm : VFPUUnaryIntrPat<int_mips_allegrex_vrsq,  "VRSQ">;
defm : VFPUUnaryIntrPat<int_mips_allegrex_vasin, "VASIN">;
defm : VFPUUnaryIntrPat<int_mips_allegrex_vnrcp, "VNRCP">;
defm : VFPUUnaryIntrPat<int_mips_allegrex_vnsin, "VNSIN">;
defm : VFPUUnaryIntrPat<int_mips_allegrex_vrexp2,"VREXP2">;

// Unary lane shuffles with hardware-restricted widths. vbfy1 is .p/.q; vbfy2
// and vsrt1-4 are .q only, so they get explicit per-width patterns rather than
// the .p/.t/.q multiclass.
def : MipsPat<(v2f32 (int_mips_allegrex_vbfy1 (v2f32 VFPUPOpnd:$rs))),
              (VBFY1_P VFPUPOpnd:$rs)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vbfy1 (v4f32 VFPUQOpnd:$rs))),
              (VBFY1_Q VFPUQOpnd:$rs)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vbfy2 (v4f32 VFPUQOpnd:$rs))),
              (VBFY2_Q VFPUQOpnd:$rs)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vsrt1 (v4f32 VFPUQOpnd:$rs))),
              (VSRT1_Q VFPUQOpnd:$rs)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vsrt2 (v4f32 VFPUQOpnd:$rs))),
              (VSRT2_Q VFPUQOpnd:$rs)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vsrt3 (v4f32 VFPUQOpnd:$rs))),
              (VSRT3_Q VFPUQOpnd:$rs)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vsrt4 (v4f32 VFPUQOpnd:$rs))),
              (VSRT4_Q VFPUQOpnd:$rs)>;

// Reductions vector -> scalar: vfad / vavg.
multiclass VFPUReduceIntrPat<Intrinsic Op, string Inst> {
  def : MipsPat<(f32 (Op (v2f32 VFPUPOpnd:$rs))),
                (!cast<Instruction>(Inst#"_P") VFPUPOpnd:$rs)>;
  def : MipsPat<(f32 (Op (v3f32 VFPUTOpnd:$rs))),
                (!cast<Instruction>(Inst#"_T") VFPUTOpnd:$rs)>;
  def : MipsPat<(f32 (Op (v4f32 VFPUQOpnd:$rs))),
                (!cast<Instruction>(Inst#"_Q") VFPUQOpnd:$rs)>;
}
defm : VFPUReduceIntrPat<int_mips_allegrex_vfad, "VFAD">;
defm : VFPUReduceIntrPat<int_mips_allegrex_vavg, "VAVG">;

// Dot products (two same-width vectors -> scalar): vdot / vhdp.
multiclass VFPUDotIntrPat<Intrinsic Op, string Inst> {
  def : MipsPat<(f32 (Op (v2f32 VFPUPOpnd:$rs), (v2f32 VFPUPOpnd:$rt))),
                (!cast<Instruction>(Inst#"_P") VFPUPOpnd:$rs, VFPUPOpnd:$rt)>;
  def : MipsPat<(f32 (Op (v3f32 VFPUTOpnd:$rs), (v3f32 VFPUTOpnd:$rt))),
                (!cast<Instruction>(Inst#"_T") VFPUTOpnd:$rs, VFPUTOpnd:$rt)>;
  def : MipsPat<(f32 (Op (v4f32 VFPUQOpnd:$rs), (v4f32 VFPUQOpnd:$rt))),
                (!cast<Instruction>(Inst#"_Q") VFPUQOpnd:$rs, VFPUQOpnd:$rt)>;
}
defm : VFPUDotIntrPat<int_mips_allegrex_vdot, "VDOT">;
defm : VFPUDotIntrPat<int_mips_allegrex_vhdp, "VHDP">;

// Vector scaled by scalar: vscl.{p,t,q}.
def : MipsPat<(v2f32 (int_mips_allegrex_vscl (v2f32 VFPUPOpnd:$rs), (f32 VFPUSOpnd:$rt))),
              (VSCL_P VFPUPOpnd:$rs, VFPUSOpnd:$rt)>;
def : MipsPat<(v3f32 (int_mips_allegrex_vscl (v3f32 VFPUTOpnd:$rs), (f32 VFPUSOpnd:$rt))),
              (VSCL_T VFPUTOpnd:$rs, VFPUSOpnd:$rt)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vscl (v4f32 VFPUQOpnd:$rs), (f32 VFPUSOpnd:$rt))),
              (VSCL_Q VFPUQOpnd:$rs, VFPUSOpnd:$rt)>;

// Lane-wise compares producing a mask vector: vsge / vslt (same-width binary).
multiclass VFPUCmpIntrPat<Intrinsic Op, string Inst> {
  def : MipsPat<(v2f32 (Op (v2f32 VFPUPOpnd:$rs), (v2f32 VFPUPOpnd:$rt))),
                (!cast<Instruction>(Inst#"_P") VFPUPOpnd:$rs, VFPUPOpnd:$rt)>;
  def : MipsPat<(v3f32 (Op (v3f32 VFPUTOpnd:$rs), (v3f32 VFPUTOpnd:$rt))),
                (!cast<Instruction>(Inst#"_T") VFPUTOpnd:$rs, VFPUTOpnd:$rt)>;
  def : MipsPat<(v4f32 (Op (v4f32 VFPUQOpnd:$rs), (v4f32 VFPUQOpnd:$rt))),
                (!cast<Instruction>(Inst#"_Q") VFPUQOpnd:$rs, VFPUQOpnd:$rt)>;
}
defm : VFPUCmpIntrPat<int_mips_allegrex_vsge, "VSGE">;
defm : VFPUCmpIntrPat<int_mips_allegrex_vslt, "VSLT">;
defm : VFPUCmpIntrPat<int_mips_allegrex_vscmp, "VSCMP">;

// Single-width 3D specials.
def : MipsPat<(v4f32 (int_mips_allegrex_vqmul (v4f32 VFPUQOpnd:$rs), (v4f32 VFPUQOpnd:$rt))),
              (VQMUL_Q VFPUQOpnd:$rs, VFPUQOpnd:$rt)>;
def : MipsPat<(v3f32 (int_mips_allegrex_vcrs (v3f32 VFPUTOpnd:$rs), (v3f32 VFPUTOpnd:$rt))),
              (VCRS_T VFPUTOpnd:$rs, VFPUTOpnd:$rt)>;
def : MipsPat<(f32 (int_mips_allegrex_vdet (v2f32 VFPUPOpnd:$rs), (v2f32 VFPUPOpnd:$rt))),
              (VDET_P VFPUPOpnd:$rs, VFPUPOpnd:$rt)>;

// ---- 4x4 VFPU matrices (v16f32, the VFPUM4 register file) ----
// A matrix's four columns are its sub_vfpuq_* subregisters; load/store and
// build go through these column copies.
def : MipsPat<(v4f32 (extract_subvector (v16f32 VFPUM4Opnd:$m), (i32 0))),
              (EXTRACT_SUBREG VFPUM4Opnd:$m, sub_vfpuq_1)>;
def : MipsPat<(v4f32 (extract_subvector (v16f32 VFPUM4Opnd:$m), (i32 4))),
              (EXTRACT_SUBREG VFPUM4Opnd:$m, sub_vfpuq_2)>;
def : MipsPat<(v4f32 (extract_subvector (v16f32 VFPUM4Opnd:$m), (i32 8))),
              (EXTRACT_SUBREG VFPUM4Opnd:$m, sub_vfpuq_3)>;
def : MipsPat<(v4f32 (extract_subvector (v16f32 VFPUM4Opnd:$m), (i32 12))),
              (EXTRACT_SUBREG VFPUM4Opnd:$m, sub_vfpuq_4)>;
def : MipsPat<(v16f32 (insert_subvector (v16f32 VFPUM4Opnd:$m),
                                        (v4f32 VFPUQOpnd:$c), (i32 0))),
              (INSERT_SUBREG VFPUM4Opnd:$m, VFPUQOpnd:$c, sub_vfpuq_1)>;
def : MipsPat<(v16f32 (insert_subvector (v16f32 VFPUM4Opnd:$m),
                                        (v4f32 VFPUQOpnd:$c), (i32 4))),
              (INSERT_SUBREG VFPUM4Opnd:$m, VFPUQOpnd:$c, sub_vfpuq_2)>;
def : MipsPat<(v16f32 (insert_subvector (v16f32 VFPUM4Opnd:$m),
                                        (v4f32 VFPUQOpnd:$c), (i32 8))),
              (INSERT_SUBREG VFPUM4Opnd:$m, VFPUQOpnd:$c, sub_vfpuq_3)>;
def : MipsPat<(v16f32 (insert_subvector (v16f32 VFPUM4Opnd:$m),
                                        (v4f32 VFPUQOpnd:$c), (i32 12))),
              (INSERT_SUBREG VFPUM4Opnd:$m, VFPUQOpnd:$c, sub_vfpuq_4)>;

// Constant-matrix generators (no inputs) and matrix move/scale/transform.
def : MipsPat<(v16f32 (int_mips_allegrex_vmzero_q)), (VMZERO_Q)>;
def : MipsPat<(v16f32 (int_mips_allegrex_vmone_q)),  (VMONE_Q)>;
def : MipsPat<(v16f32 (int_mips_allegrex_vmidt_q)),  (VMIDT_Q)>;
def : MipsPat<(v16f32 (int_mips_allegrex_vmmov_q (v16f32 VFPUM4Opnd:$rs))),
              (VMMOV_Q VFPUM4Opnd:$rs)>;
def : MipsPat<(v16f32 (int_mips_allegrex_vmscl_q (v16f32 VFPUM4Opnd:$rs),
                                                 (f32 VFPUSOpnd:$rt))),
              (VMSCL_Q VFPUM4Opnd:$rs, VFPUSOpnd:$rt)>;
// vtfm4/vhtfm4 transform a 4-vector by a matrix; the instruction takes the
// vector ($rt) then the matrix ($rs) in its operand list.
def : MipsPat<(v4f32 (int_mips_allegrex_vtfm4 (v16f32 VFPUM4Opnd:$rs),
                                              (v4f32 VFPUQOpnd:$rt))),
              (VTFM4_Q VFPUQOpnd:$rt, VFPUM4Opnd:$rs)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vhtfm4 (v16f32 VFPUM4Opnd:$rs),
                                               (v4f32 VFPUQOpnd:$rt))),
              (VHTFM4_Q VFPUQOpnd:$rt, VFPUM4Opnd:$rs)>;
// vmmul reads its first source ($rs) through the transposed M4I (E-view) of the
// same physical matrix register; COPY_TO_REGCLASS rebinds the value to that
// view (the two views alias, so copyPhysReg makes the rebind a vmmov data copy
// that the allocator coalesces away when it lands on the aliased register).
def : MipsPat<(v16f32 (int_mips_allegrex_vmmul_q (v16f32 VFPUM4Opnd:$rs),
                                                 (v16f32 VFPUM4Opnd:$rt))),
              (VMMUL_Q (v16f32 (COPY_TO_REGCLASS VFPUM4Opnd:$rs, VFPUM4I)),
                       VFPUM4Opnd:$rt)>;

// ---- Odd-signature unary/auxiliary ops ----
def : MipsPat<(f32 (int_mips_allegrex_vsbn (f32 VFPUSOpnd:$rs),
                                           (f32 VFPUSOpnd:$rt))),
              (VSBN_S VFPUSOpnd:$rs, VFPUSOpnd:$rt)>;
def : MipsPat<(f32 (int_mips_allegrex_vsbz (f32 VFPUSOpnd:$rs))),
              (VSBZ_S VFPUSOpnd:$rs)>;
def : MipsPat<(f32 (int_mips_allegrex_vlgb (f32 VFPUSOpnd:$rs))),
              (VLGB_S VFPUSOpnd:$rs)>;
// Width-expanding one's-complement: s->pair, pair->quad.
def : MipsPat<(v2f32 (int_mips_allegrex_vsocp_s (f32 VFPUSOpnd:$rs))),
              (VSOCP_S VFPUSOpnd:$rs)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vsocp_p (v2f32 VFPUPOpnd:$rs))),
              (VSOCP_P VFPUPOpnd:$rs)>;

// Read the VFPU condition codes (control register 131, "VFPU_CC") into a GPR.
// Codegen-only form of mfvc with the control register fixed; it consumes the
// implicit VFPUCC written by the preceding vcmp.
let Uses = [VFPUCC], isCodeGenOnly = 1 in
def ReadVFPUCC : InstSE<(outs GPR32Opnd:$rt), (ins),
    "mfvc\t$rt, $$131", [(set GPR32Opnd:$rt, (i32 (MipsVfpuMfvc)))],
    II_ALLEGREX, FrmVFPU>, INSN_ALLEGREX {
  bits<5> rt;
  let Inst{31-21} = 0b01001000011;
  let Inst{20-16} = rt;
  let Inst{15-8}  = 0b00000000;
  let Inst{7-0}   = 131;
}

} // Predicates = [HasAllegrex]

// Unaligned quad load/store (A4). binutils expands these to a left/right pair
// addressing the high and low ends of the (possibly unaligned) 16-byte slot:
//   ulv.q vt, off(b) -> lvl.q vt, off+12(b) ; lvr.q vt, off(b)
//   usv.q vt, off(b) -> svl.q vt, off+12(b) ; svr.q vt, off(b)
// Expanded in MipsAsmParser::expandUnalignedVFPUStore/Load.
let isPseudo = 1, isCodeGenOnly = 0 in {
def ULV_Q : MipsAsmPseudoInst<(outs VFPUQOpnd:$rt), (ins mem:$addr),
                              "ulv.q\t$rt, $addr">, INSN_ALLEGREX;
def USV_Q : MipsAsmPseudoInst<(outs), (ins VFPUQOpnd:$rt, mem:$addr),
                              "usv.q\t$rt, $addr">, INSN_ALLEGREX;
}

defm VF2IN : VFPU_BITCAST_SPTQ_FMT<"vf2in", 0b11010010000>;
defm VF2IZ : VFPU_BITCAST_SPTQ_FMT<"vf2iz", 0b11010010001>;
defm VF2IU : VFPU_BITCAST_SPTQ_FMT<"vf2iu", 0b11010010010>;
defm VF2ID : VFPU_BITCAST_SPTQ_FMT<"vf2id", 0b11010010011>;
defm VI2F  : VFPU_BITCAST_SPTQ_FMT<"vi2f" , 0b11010010100>;

let Predicates = [HasAllegrex] in {
// v4i32 transport: native quad load/store (raw 128 bits) and a free bitcast to
// v4f32 (same register file). Mirrors the v4f32 lv.q/sv.q patterns. (v2i32/
// v3i32 have no native pair/triple memory op and are custom-scalarized.)
def : MipsPat<(v4i32 (alignedload addr:$addr)), (LV_Q addr:$addr)>;
def : MipsPat<(alignedstore (v4i32 VFPUQOpnd:$rt), addr:$addr),
              (SV_Q VFPUQOpnd:$rt, addr:$addr, 1)>;
// Free bitcast between the int and float view of each VFPU vector width.
def : MipsPat<(v4i32 (bitconvert (v4f32 VFPUQOpnd:$v))), (v4i32 VFPUQOpnd:$v)>;
def : MipsPat<(v4f32 (bitconvert (v4i32 VFPUQOpnd:$v))), (v4f32 VFPUQOpnd:$v)>;
def : MipsPat<(v2i32 (bitconvert (v2f32 VFPUPOpnd:$v))), (v2i32 VFPUPOpnd:$v)>;
def : MipsPat<(v2f32 (bitconvert (v2i32 VFPUPOpnd:$v))), (v2f32 VFPUPOpnd:$v)>;
def : MipsPat<(v3i32 (bitconvert (v3f32 VFPUTOpnd:$v))), (v3i32 VFPUTOpnd:$v)>;
def : MipsPat<(v3f32 (bitconvert (v3i32 VFPUTOpnd:$v))), (v3f32 VFPUTOpnd:$v)>;

// Same-width float<->int conversions (.s/.p/.t/.q) with a fractional-bit scale
// immediate. vf2i*: float vector -> int vector; vi2f: int vector -> float.
multiclass VFPUCvtFI<Intrinsic OpP, Intrinsic OpT, Intrinsic OpQ, string Inst> {
  def : MipsPat<(v2i32 (OpP (v2f32 VFPUPOpnd:$rs), timm:$scale)),
                (!cast<Instruction>(Inst#"_P") VFPUPOpnd:$rs, timm:$scale)>;
  def : MipsPat<(v3i32 (OpT (v3f32 VFPUTOpnd:$rs), timm:$scale)),
                (!cast<Instruction>(Inst#"_T") VFPUTOpnd:$rs, timm:$scale)>;
  def : MipsPat<(v4i32 (OpQ (v4f32 VFPUQOpnd:$rs), timm:$scale)),
                (!cast<Instruction>(Inst#"_Q") VFPUQOpnd:$rs, timm:$scale)>;
}
defm : VFPUCvtFI<int_mips_allegrex_vf2in_p, int_mips_allegrex_vf2in_t,
                 int_mips_allegrex_vf2in_q, "VF2IN">;
defm : VFPUCvtFI<int_mips_allegrex_vf2iz_p, int_mips_allegrex_vf2iz_t,
                 int_mips_allegrex_vf2iz_q, "VF2IZ">;
defm : VFPUCvtFI<int_mips_allegrex_vf2iu_p, int_mips_allegrex_vf2iu_t,
                 int_mips_allegrex_vf2iu_q, "VF2IU">;
defm : VFPUCvtFI<int_mips_allegrex_vf2id_p, int_mips_allegrex_vf2id_t,
                 int_mips_allegrex_vf2id_q, "VF2ID">;
def : MipsPat<(v2f32 (int_mips_allegrex_vi2f_p (v2i32 VFPUPOpnd:$rs), timm:$scale)),
              (VI2F_P VFPUPOpnd:$rs, timm:$scale)>;
def : MipsPat<(v3f32 (int_mips_allegrex_vi2f_t (v3i32 VFPUTOpnd:$rs), timm:$scale)),
              (VI2F_T VFPUTOpnd:$rs, timm:$scale)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vi2f_q (v4i32 VFPUQOpnd:$rs), timm:$scale)),
              (VI2F_Q VFPUQOpnd:$rs, timm:$scale)>;

// Half pack/unpack (vf2h/vh2f): packed-half data is a float-typed VFPU value.
def : MipsPat<(f32 (int_mips_allegrex_vf2h_p (v2f32 VFPUPOpnd:$rs))),
              (VF2H_P VFPUPOpnd:$rs)>;
def : MipsPat<(v2f32 (int_mips_allegrex_vf2h_q (v4f32 VFPUQOpnd:$rs))),
              (VF2H_Q VFPUQOpnd:$rs)>;
def : MipsPat<(v2f32 (int_mips_allegrex_vh2f_s (f32 VFPUSOpnd:$rs))),
              (VH2F_S VFPUSOpnd:$rs)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vh2f_p (v2f32 VFPUPOpnd:$rs))),
              (VH2F_P VFPUPOpnd:$rs)>;
} // Predicates = [HasAllegrex]

let shamt = 0b00000 in {
  let rs = 0b00010 in {
    def CFC0 : FR<0b010000, 0b000000,
                  (outs GPR32Opnd:$rt), (ins COP0Opnd:$rd),
                  "cfc0\t$rt, $rd", [], II_ALLEGREX>, INSN_ALLEGREX;
  }

  let rs = 0b00110 in {
    def CTC0 : FR<0b010000, 0b000000,
                  (outs COP0Opnd:$rd), (ins GPR32Opnd:$rt),
                  "ctc0\t$rt, $rd", [], II_ALLEGREX>, INSN_ALLEGREX;
  }
}

let shamt = 0b00000 in {
  let rs = 0b00000 in {
    def MFDR : FR<0b011100, 0b111101,
                  (outs GPR32Opnd:$rt), (ins COP0Opnd:$rd),
                  "mfdr\t$rt, $rd", [], II_ALLEGREX>, INSN_ALLEGREX;
  }

  let rs = 0b00100 in {
    def MTDR : FR<0b011100, 0b111101,
                (outs COP0Opnd:$rd), (ins GPR32Opnd:$rt),
                  "mtdr\t$rt, $rd", [], II_ALLEGREX>, INSN_ALLEGREX;
  }
}

def MFV : MFV_FMT<0x48600000, (outs GPR32Opnd:$rt), (ins VFPUSOpnd:$rd),
                  "mfv\t$rt, $rd", [/*(set GPR32Opnd:$rt, VFPUSOpnd:$rd)*/]>, INSN_ALLEGREX;

def MTV : MFV_FMT<0x48e00000, (outs VFPUSOpnd:$rd), (ins GPR32Opnd:$rt),
                  "mtv\t$rt, $rd", [/*(set VFPUSOpnd:$rd, GPR32Opnd:$rt)*/]>, INSN_ALLEGREX;

// Integer (v2i32/v3i32/v4i32) lane access. A VFPU scalar slice holds raw 32
// bits, so an integer lane crosses to/from a GPR with mfv/mtv. EXTRACT pulls
// lane i out as a GPR i32; INSERT/SCALAR_TO_VECTOR drop a GPR i32 into a slice.
// (Defined here, after mfv/mtv; guarded by HasAllegrex like the f32 lane
// patterns above.)
let Predicates = [HasAllegrex] in {
multiclass VFPUIntLanePat<ValueType vt, DAGOperand opnd, list<int> lanes> {
  foreach i = lanes in {
    def : MipsPat<(i32 (vector_extract (vt opnd:$v), (i32 !add(i, -1)))),
                  (MFV (f32 (EXTRACT_SUBREG opnd:$v, !cast<SubRegIndex>("sub_vfpus_"#i))))>;
    def : MipsPat<(vt (vector_insert (vt opnd:$v), (i32 GPR32Opnd:$s), (i32 !add(i, -1)))),
                  (INSERT_SUBREG opnd:$v, (MTV GPR32Opnd:$s), !cast<SubRegIndex>("sub_vfpus_"#i))>;
  }
  def : MipsPat<(vt (scalar_to_vector (i32 GPR32Opnd:$s))),
                (INSERT_SUBREG (vt (IMPLICIT_DEF)), (MTV GPR32Opnd:$s), sub_vfpus_1)>;
}
defm : VFPUIntLanePat<v2i32, VFPUPOpnd, [1, 2]>;
defm : VFPUIntLanePat<v3i32, VFPUTOpnd, [1, 2, 3]>;
defm : VFPUIntLanePat<v4i32, VFPUQOpnd, [1, 2, 3, 4]>;

// Integer -> packed-byte color (vi2c/vi2uc, .q): v4i32 -> one packed word. The
// op writes a VFPU scalar slice; mfv brings the packed i32 to a GPR.
def : MipsPat<(i32 (int_mips_allegrex_vi2c_q (v4i32 VFPUQOpnd:$rs))),
              (MFV (VI2C_Q VFPUQOpnd:$rs))>;
def : MipsPat<(i32 (int_mips_allegrex_vi2uc_q (v4i32 VFPUQOpnd:$rs))),
              (MFV (VI2UC_Q VFPUQOpnd:$rs))>;

// Integer <-> packed-short. The .p/.s forms whose single end is a packed word
// cross that word through a GPR (mfv/mtv); the pair/quad ends stay in VFPU regs.
def : MipsPat<(i32 (int_mips_allegrex_vi2s_p (v2i32 VFPUPOpnd:$rs))),
              (MFV (VI2S_P VFPUPOpnd:$rs))>;
def : MipsPat<(i32 (int_mips_allegrex_vi2us_p (v2i32 VFPUPOpnd:$rs))),
              (MFV (VI2US_P VFPUPOpnd:$rs))>;
def : MipsPat<(v2i32 (int_mips_allegrex_vi2s_q (v4i32 VFPUQOpnd:$rs))),
              (VI2S_Q VFPUQOpnd:$rs)>;
def : MipsPat<(v2i32 (int_mips_allegrex_vi2us_q (v4i32 VFPUQOpnd:$rs))),
              (VI2US_Q VFPUQOpnd:$rs)>;
def : MipsPat<(v2i32 (int_mips_allegrex_vs2i_s (i32 GPR32Opnd:$rs))),
              (VS2I_S (MTV GPR32Opnd:$rs))>;
def : MipsPat<(v2i32 (int_mips_allegrex_vus2i_s (i32 GPR32Opnd:$rs))),
              (VUS2I_S (MTV GPR32Opnd:$rs))>;
def : MipsPat<(v4i32 (int_mips_allegrex_vs2i_p (v2i32 VFPUPOpnd:$rs))),
              (VS2I_P VFPUPOpnd:$rs)>;
def : MipsPat<(v4i32 (int_mips_allegrex_vus2i_p (v2i32 VFPUPOpnd:$rs))),
              (VUS2I_P VFPUPOpnd:$rs)>;
} // Predicates = [HasAllegrex]

def MFVC : MFVC_FMT<0x48600000, "mfvc",
                    (outs VCROpnd:$rd), (ins GPR32Opnd:$rt)>, INSN_ALLEGREX;
def MTVC : MFVC_FMT<0x48e00000, "mtvc",
                    (outs GPR32Opnd:$rt), (ins VCROpnd:$rd)>, INSN_ALLEGREX;

def VMFVC:
  InstSE<(outs VCROpnd:$rd), (ins VFPUSOpnd:$rt),
         "vmfvc\t$rt, $rd", [], II_ALLEGREX, FrmVFPU>, INSN_ALLEGREX
{
  bits<8> rd;
  bits<7> rt;

  let Inst{31-16} = 0xd050;
  let Inst{15-8}  = rd;
  let Inst{7}     = 0;
  let Inst{6-0}   = rt;
}

def VMTVC:
  InstSE<(outs VFPUSOpnd:$rt), (ins VCROpnd:$rd),
         "vmtvc\t$rd, $rt", [], II_ALLEGREX, FrmVFPU>, INSN_ALLEGREX
{
  bits<8> rd;
  bits<7> rt;

  let Inst{31-16} = 0xd051;
  let Inst{15}    = 0;
  let Inst{14-8}  = rt;
  let Inst{7-0}   = rd;
}

defm VCMOVT : VCMOV_SPTQ_FMT<0xd2a00000, "vcmovt">;
defm VCMOVF : VCMOV_SPTQ_FMT<0xd2a80000, "vcmovf">;

// The bare `vcmov` macro is an alias for `vcmovt`: binutils always expands it to
// the true-condition form, passing the move-condition immediate through.
def : MipsInstAlias<"vcmov.s\t$rd, $rs, $cnd",
                    (VCMOVT_S VFPUSOpnd:$rd, VFPUSOpnd:$rs, i8imm:$cnd), 0>,
                    INSN_ALLEGREX;
def : MipsInstAlias<"vcmov.p\t$rd, $rs, $cnd",
                    (VCMOVT_P VFPUPOpnd:$rd, VFPUPOpnd:$rs, i8imm:$cnd), 0>,
                    INSN_ALLEGREX;
def : MipsInstAlias<"vcmov.t\t$rd, $rs, $cnd",
                    (VCMOVT_T VFPUTOpnd:$rd, VFPUTOpnd:$rs, i8imm:$cnd), 0>,
                    INSN_ALLEGREX;
def : MipsInstAlias<"vcmov.q\t$rd, $rs, $cnd",
                    (VCMOVT_Q VFPUQOpnd:$rd, VFPUQOpnd:$rs, i8imm:$cnd), 0>,
                    INSN_ALLEGREX;

// Codegen-only per-lane select: vcmovt.{s,p,t,q} with cnd=6, $rd tied to the
// false value, reading the VFPUCC the preceding vcmp wrote (glued in). Selects
// from MipsVfpuCMov (see lowerVSELECT).
let Uses = [VFPUCC], isCodeGenOnly = 1, Constraints = "$fd = $rd",
    Predicates = [HasAllegrex] in
class VCMOVSEL_FMT<bits<2> sz, string suf, DAGOperand opnd, ValueType vt> :
  InstSE<(outs opnd:$rd), (ins opnd:$fd, opnd:$rs),
         "vcmovt"#suf#"\t$rd, $rs, 6",
         [(set (vt opnd:$rd), (MipsVfpuCMov (vt opnd:$fd), (vt opnd:$rs)))],
         II_ALLEGREX, FrmVFPU> {
  bits<7> rd;
  bits<7> rs;
  let Inst{31-19} = 0b1101001010100;  // vcmovt base
  let Inst{18-16} = 0b110;            // cnd = 6 (per-lane)
  let Inst{15}    = sz{1};
  let Inst{14-8}  = rs;
  let Inst{7}     = sz{0};
  let Inst{6-0}   = rd;
}
def VCMOVSEL_S : VCMOVSEL_FMT<0, ".s", VFPUSOpnd, f32>, INSN_ALLEGREX;
def VCMOVSEL_P : VCMOVSEL_FMT<1, ".p", VFPUPOpnd, v2f32>, INSN_ALLEGREX;
def VCMOVSEL_T : VCMOVSEL_FMT<2, ".t", VFPUTOpnd, v3f32>, INSN_ALLEGREX;
def VCMOVSEL_Q : VCMOVSEL_FMT<3, ".q", VFPUQOpnd, v4f32>, INSN_ALLEGREX;

def VWBN_S:
  InstSE<(outs VFPUSOpnd:$rd), (ins VFPUSOpnd:$rs, i8imm:$exp),
         "vwbn.s\t$rd, $rs, $exp", [], II_ALLEGREX, FrmVFPU>, INSN_ALLEGREX
{
  bits<7> rd;
  bits<7> rs;
  bits<8> exp;

  let Inst        = 0xd3000000;
  let Inst{23-16} = exp;
  let Inst{14-8}  = rs;
  let Inst{6-0}   = rd;
}

def BVF  : VFPU_BRANCH_FMT<0x49000000, "bvf">, INSN_ALLEGREX;
def BVT  : VFPU_BRANCH_FMT<0x49010000, "bvt">, INSN_ALLEGREX;
def BVFL : VFPU_BRANCH_FMT<0x49020000, "bvfl">, INSN_ALLEGREX;
def BVTL : VFPU_BRANCH_FMT<0x49030000, "bvtl">, INSN_ALLEGREX;

// Branch on a VFPU condition-code bit: VfpuBrcond(sense, bit, target). sense==1
// selects bvt (branch when the bit is set), sense==0 selects bvf. The bit index
// rides the node as i32 but the bvt/bvf encoding field is i8, so narrow it.
def vfpu_cc_bit : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(N->getZExtValue() & 7, SDLoc(N), MVT::i8);
}]>;
let Predicates = [HasAllegrex] in {
def : Pat<(MipsVfpuBrcond (i32 1), imm:$bit, bb:$tgt),
          (BVT (vfpu_cc_bit imm:$bit), bb:$tgt)>;
def : Pat<(MipsVfpuBrcond (i32 0), imm:$bit, bb:$tgt),
          (BVF (vfpu_cc_bit imm:$bit), bb:$tgt)>;
}

let shamt = 0b10100 in {
  let rs = 0b00000 in {
    def BITREV_V : FR<0b011111, 0b100000,
                      (outs GPR32Opnd:$rd), (ins GPR32Opnd:$rt),
                      "bitrev\t$rd, $rt",
                      [(set GPR32Opnd:$rd,
                        (int_mips_allegrex_bitrev GPR32Opnd:$rt))],
                      II_ALLEGREX>, INSN_ALLEGREX;
  }
}

def LDL_V:
  InstSE<(outs GPR32Opnd:$rt), (ins mem:$addr),
         "ldl\t$rt, $addr", [], II_ALLEGREX, FrmI>, INSN_ALLEGREX
{
  let DecoderMethod = "DecodeMem";
  bits<5> rt;
  bits<21> addr;

  let Inst{31-26} = 0b011010;
  let Inst{25-21} = rt;
  let Inst{20-0}  = addr;
}

def SDL_V:
  InstSE<(outs), (ins mem:$addr, GPR32Opnd:$rt),
         "sdl\t$rt, $addr", [], II_ALLEGREX, FrmI>, INSN_ALLEGREX
{
  let DecoderMethod = "DecodeMem";
  bits<5> rt;
  bits<21> addr;

  let Inst{31-26} = 0b101100;
  let Inst{25-21} = rt;
  let Inst{20-0}  = addr;
}

// vrot reads the angle scalar while writing every lane, so the destination must
// not overlap the source (the reference assembler rejects the conflict).
let Constraints = "@earlyclobber $rd" in {
def VROT_P : VROT_FMT<0xf3a00080, "vrot.p", VFPUPOpnd, VFPUPRotationOpnd>,
             INSN_ALLEGREX;
def VROT_T : VROT_FMT<0xf3a08000, "vrot.t", VFPUTOpnd, VFPUTRotationOpnd>,
             INSN_ALLEGREX;
def VROT_Q : VROT_FMT<0xf3a08080, "vrot.q", VFPUQOpnd, VFPUQRotationOpnd>,
             INSN_ALLEGREX;
}

// vrot: angle in a scalar register, rotation pattern as an immediate selector.
let Predicates = [HasAllegrex] in {
def : MipsPat<(v2f32 (int_mips_allegrex_vrot_p (f32 VFPUSOpnd:$rs), timm:$rot)),
              (VROT_P VFPUSOpnd:$rs, timm:$rot)>;
def : MipsPat<(v3f32 (int_mips_allegrex_vrot_t (f32 VFPUSOpnd:$rs), timm:$rot)),
              (VROT_T VFPUSOpnd:$rs, timm:$rot)>;
def : MipsPat<(v4f32 (int_mips_allegrex_vrot_q (f32 VFPUSOpnd:$rs), timm:$rot)),
              (VROT_Q VFPUSOpnd:$rs, timm:$rot)>;
}

def VPFXS : VPFXST_FMT<0xdc000000, "vpfxs">, INSN_ALLEGREX;
def VPFXT : VPFXST_FMT<0xdd000000, "vpfxt">, INSN_ALLEGREX;

def VFPUSaturationClass : AsmOperandClass
{
  let Name = "VFPUSaturation";
  let PredicateMethod = "isVFPUSaturation";
  let RenderMethod = "addVFPUSaturationOperands";
  let ParserMethod = "parseVFPUSaturation";
}

def VFPUSaturationOpnd : Operand<i8> {
  let PrintMethod = "printVFPUSaturation";
  let ParserMatchClass = VFPUSaturationClass;
  let OperandType = "OPERAND_IMMEDIATE";
}

def VPFXD
  : InstSE<(outs), (ins VFPUSaturationOpnd:$a,
                        VFPUSaturationOpnd:$b,
                        VFPUSaturationOpnd:$c,
                        VFPUSaturationOpnd:$d),
           "vpfxd\t$a, $b, $c, $d", [], II_ALLEGREX, FrmVFPU>,
    INSN_ALLEGREX
{
  bits<3> a;
  bits<3> b;
  bits<3> c;
  bits<3> d;

  let Inst = 0xde000000;
  let Inst{11}  = d{2};
  let Inst{10}  = c{2};
  let Inst{9}   = b{2};
  let Inst{8}   = a{2};
  let Inst{7-6} = d{1-0};
  let Inst{5-4} = c{1-0};
  let Inst{3-2} = b{1-0};
  let Inst{1-0} = a{1-0};
}

def ROTL : MipsAsmPseudoInst<(outs GPR32Opnd:$rd),
                             (ins GPR32Opnd:$rt, simm16:$imm),
                             "rotl $rd, $rt, $imm">,
           INSN_ALLEGREX;

def : MipsPat<(i32 (int_mips_allegrex_wsbh GPR32Opnd:$rhs)),
              (WSBH GPR32Opnd:$rhs)>;
def : MipsPat<(i32 (int_mips_allegrex_clz GPR32Opnd:$rhs)),
              (CLZ GPR32Opnd:$rhs)>;
def : MipsPat<(i32 (int_mips_allegrex_clo GPR32Opnd:$rhs)),
              (CLO GPR32Opnd:$rhs)>;
// Count trailing ones: reverse the bits, then count leading ones (matches GCC's
// allegrex_ctosi2 expansion: bitrev followed by clo).
def : MipsPat<(i32 (int_mips_allegrex_cto GPR32Opnd:$rhs)),
              (CLO (BITREV_V GPR32Opnd:$rhs))>;
def : MipsPat<(i32 (int_mips_allegrex_rotr GPR32Opnd:$rhs1, imm:$rhs2)),
              (ROTR GPR32Opnd:$rhs1, imm:$rhs2)>;
def : MipsPat<(i32 (int_mips_allegrex_max GPR32Opnd:$a, GPR32Opnd:$b)),
              (MAX GPR32Opnd:$a, GPR32Opnd:$b)>;
def : MipsPat<(i32 (int_mips_allegrex_min GPR32Opnd:$a, GPR32Opnd:$b)),
              (MIN GPR32Opnd:$a, GPR32Opnd:$b)>;
def : MipsPat<(i32 (int_mips_allegrex_seb GPR32Opnd:$rhs)),
              (SEB GPR32Opnd:$rhs)>;
def : MipsPat<(i32 (int_mips_allegrex_seh GPR32Opnd:$rhs)),
              (SEH GPR32Opnd:$rhs)>;
def : MipsPat<(int_mips_allegrex_sync), (SYNC 0)>;
def : MipsPat<(int_mips_allegrex_cache imm:$op, addr:$addr),
              (CACHE addr:$addr, imm:$op)>;
def : MipsPat<(f32 (int_mips_allegrex_sqrt_s FGR32Opnd:$rhs)),
              (FSQRT_S FGR32Opnd:$rhs)>;
// These conversions leave their integer result in an FP register, so move it
// into a GPR (mfc1) to produce the i32 the intrinsics now return.
def : MipsPat<(i32 (int_mips_allegrex_ceil_w_s FGR32Opnd:$rhs)),
              (MFC1 (CEIL_W_S FGR32Opnd:$rhs))>;
def : MipsPat<(i32 (int_mips_allegrex_floor_w_s FGR32Opnd:$rhs)),
              (MFC1 (FLOOR_W_S FGR32Opnd:$rhs))>;
def : MipsPat<(i32 (int_mips_allegrex_round_w_s FGR32Opnd:$rhs)),
              (MFC1 (ROUND_W_S FGR32Opnd:$rhs))>;
def : MipsPat<(i32 (int_mips_allegrex_trunc_w_s FGR32Opnd:$rhs)),
              (MFC1 (TRUNC_W_S FGR32Opnd:$rhs))>;