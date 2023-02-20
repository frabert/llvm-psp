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
defm VMMUL : VFPU_A_SPTQ_FMT<0xf0000000, "vmmul", null_frag, 0, 1, 1, 1,
                             MatrixOperands, IMatrixOperands, MatrixOperands>;
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

def VCMP_S : VCMP_SPTQ_FMT<"vcmp.s", 0, VFPUSOpnd>, INSN_ALLEGREX;
def VCMP_P : VCMP_SPTQ_FMT<"vcmp.p", 1, VFPUPOpnd>, INSN_ALLEGREX;
def VCMP_T : VCMP_SPTQ_FMT<"vcmp.t", 2, VFPUTOpnd>, INSN_ALLEGREX;
def VCMP_Q : VCMP_SPTQ_FMT<"vcmp.q", 3, VFPUQOpnd>, INSN_ALLEGREX;

def : MipsInstAlias<"vcmp.s\t$cmp, $rs",
  (VCMP_S VFPUConditionOpnd:$cmp, VFPUSOpnd:$rs, S000)>, INSN_ALLEGREX;
def : MipsInstAlias<"vcmp.s\t$cmp",
  (VCMP_S VFPUConditionOpnd:$cmp, S000, S000)>, INSN_ALLEGREX;

def : MipsInstAlias<"vcmp.p\t$cmp, $rs",
  (VCMP_P VFPUConditionOpnd:$cmp, VFPUPOpnd:$rs, C000_P)>, INSN_ALLEGREX;
def : MipsInstAlias<"vcmp.p\t$cmp",
  (VCMP_P VFPUConditionOpnd:$cmp, C000_P, C000_P)>, INSN_ALLEGREX;

def : MipsInstAlias<"vcmp.t\t$cmp, $rs",
  (VCMP_T VFPUConditionOpnd:$cmp, VFPUTOpnd:$rs, C000_T)>, INSN_ALLEGREX;
def : MipsInstAlias<"vcmp.t\t$cmp",
  (VCMP_T VFPUConditionOpnd:$cmp, C000_T, C000_T)>, INSN_ALLEGREX;

def : MipsInstAlias<"vcmp.q\t$cmp, $rs",
  (VCMP_Q VFPUConditionOpnd:$cmp, VFPUQOpnd:$rs, C000_Q)>, INSN_ALLEGREX;
def : MipsInstAlias<"vcmp.q\t$cmp",
  (VCMP_Q VFPUConditionOpnd:$cmp, C000_Q, C000_Q)>, INSN_ALLEGREX;

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
  string DecoderMethod = "DecodeMem";
}

def LV_Q  : VFPU_LOADSTORE_FMT<0b110110, "lv.q",
              (outs VFPUQOpnd:$rt), (ins mem:$addr),
              [(set VFPUQOpnd:$rt, (v4f32 (alignedload addr:$addr)))]>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeMem";
}

def VWB_Q : VFPU_LOADSTORE_FMT<0b111110, "vwb.q",
              (outs), (ins VFPUQOpnd:$rt, mem:$addr)>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeMem";
  let Inst{1} = 1;
}

def SV_S  : VFPU_LOADSTORE_FMT<0b111010, "sv.s",
              (outs), (ins VFPUSOpnd:$rt, mem:$addr),
              [(store (f32 VFPUSOpnd:$rt), addr:$addr)]>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeMem";
}

def SVL_Q : VFPU_LOADSTORE_FMT<0b111101, "svl.q",
              (outs), (ins VFPUQOpnd:$rt, mem:$addr)>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeMem";
}

def SVR_Q : SVR_Q_FMT<(outs), (ins VFPUQOpnd:$rt, mem:$addr, VFPUWriteBackOpnd:$wb)>, INSN_ALLEGREX;

def SV_Q : SV_Q_FMT<(outs), (ins VFPUQOpnd:$rt, mem:$addr, VFPUWriteBackOpnd:$wb)>, INSN_ALLEGREX;
def : MipsInstAlias<"sv.q\t$rt, $addr", (SV_Q VFPUQOpnd:$rt, mem:$addr, 1)>, INSN_ALLEGREX
{
  string DecoderMethod = "DecodeMem";
}
def : MipsPat<(alignedstore (v4f32 VFPUQOpnd:$rt), addr:$addr), (SV_Q VFPUQOpnd:$rt, addr:$addr, 1)>
{
  string DecoderMethod = "DecodeMem";
}

defm VF2IN : VFPU_BITCAST_SPTQ_FMT<"vf2in", 0b11010010000>;
defm VF2IZ : VFPU_BITCAST_SPTQ_FMT<"vf2iz", 0b11010010001>;
defm VF2IU : VFPU_BITCAST_SPTQ_FMT<"vf2iu", 0b11010010010>;
defm VF2ID : VFPU_BITCAST_SPTQ_FMT<"vf2id", 0b11010010011>;
defm VI2F  : VFPU_BITCAST_SPTQ_FMT<"vi2f" , 0b11010010100>;

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

def VROT_P : VROT_FMT<0xf3a00080, "vrot.p", VFPUPOpnd, VFPUPRotationOpnd>,
             INSN_ALLEGREX;
def VROT_T : VROT_FMT<0xf3a08000, "vrot.t", VFPUTOpnd, VFPUTRotationOpnd>,
             INSN_ALLEGREX;
def VROT_Q : VROT_FMT<0xf3a08080, "vrot.q", VFPUQOpnd, VFPUQRotationOpnd>,
             INSN_ALLEGREX;

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
def : MipsPat<(f32 (int_mips_allegrex_ceil_w_s FGR32Opnd:$rhs)),
              (CEIL_W_S FGR32Opnd:$rhs)>;
def : MipsPat<(f32 (int_mips_allegrex_floor_w_s FGR32Opnd:$rhs)),
              (FLOOR_W_S FGR32Opnd:$rhs)>;
def : MipsPat<(f32 (int_mips_allegrex_round_w_s FGR32Opnd:$rhs)),
              (ROUND_W_S FGR32Opnd:$rhs)>;
def : MipsPat<(f32 (int_mips_allegrex_trunc_w_s FGR32Opnd:$rhs)),
              (TRUNC_W_S FGR32Opnd:$rhs)>;