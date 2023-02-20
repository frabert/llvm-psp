//=- MipsAllegrexInstrFormats.td - Mips Instruction Formats --*- tablegen -*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes Allegrex instruction formats.
//
//===----------------------------------------------------------------------===//

def II_ALLEGREX : InstrItinClass;

def VFPUConstantAsmOpnd : AsmOperandClass {
  let Name = "VFPUConstant";
  let PredicateMethod = "isVFPUConstant";
  let ParserMethod = "parseVFPUConstant";
}

def VFPUConstant : Operand<i32> {
  let PrintMethod = "printVFPUConstant";
  let ParserMatchClass = VFPUConstantAsmOpnd;
  let OperandType = "OPERAND_IMMEDIATE";
}

class VFPUOperands {
  DAGOperand S;
  DAGOperand P;
  DAGOperand T;
  DAGOperand Q;
}

def LinearOperands : VFPUOperands {
  let S = VFPUSOpnd;
  let P = VFPUPOpnd;
  let T = VFPUTOpnd;
  let Q = VFPUQOpnd;
}

class UniformOperands<DAGOperand opnd> : VFPUOperands {
  let S = opnd;
  let P = opnd;
  let T = opnd;
  let Q = opnd;
}

def ScalarOperands : UniformOperands<VFPUSOpnd>;

def DoubleOperands : VFPUOperands {
  let S = VFPUPOpnd;
  let P = VFPUQOpnd;
}

def HalfOperands : VFPUOperands {
  let P = VFPUSOpnd;
  let Q = VFPUPOpnd;
}

def MatrixOperands : VFPUOperands {
  let P = VFPUM2Opnd;
  let T = VFPUM3Opnd;
  let Q = VFPUM4Opnd;
}

def IMatrixOperands : VFPUOperands {
  let P = VFPUM2IOpnd;
  let T = VFPUM3IOpnd;
  let Q = VFPUM4IOpnd;
}

class VFPU_A_FMT<bits<32> instr, bits<2> sz, dag outs, dag ins, string name,
         list<dag> pattern>:
  InstSE<outs, ins, !strconcat(name, "\t$rd, $rs, $rt"), pattern, II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;
  bits<7> rs;
  bits<7> rt;

  let Opcode      = instr{31-26};

  let Inst{25-23} = instr{25-23};
  let Inst{22-16} = rt;
  let Inst{15}    = sz{1};
  let Inst{14-8}  = rs;
  let Inst{7}     = sz{0};
  let Inst{6-0}   = rd;
}

class VFPU_B_FMT<bits<32> instr, bits<2> sz, dag outs, dag ins, string name,
         list<dag> pattern>:
  InstSE<outs, ins, !strconcat(name, "\t$rd, $rs"), pattern, II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;
  bits<7> rs;

  let Opcode      = instr{31-26};

  let Inst{25-16} = instr{25-16};
  let Inst{15}    = sz{1};
  let Inst{14-8}  = rs;
  let Inst{7}     = sz{0};
  let Inst{6-0}   = rd;
}

class VFPU_C_FMT<bits<32> instr, bits<2> sz, dag outs, string name,
         list<dag> pattern>:
  InstSE<outs, (ins), !strconcat(name, "\t$rd"), pattern, II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;

  let Opcode      = instr{31-26};

  let Inst{25-16} = instr{25-16};
  let Inst{15}    = sz{1};
  let Inst{14-8}  = instr{14-8};
  let Inst{7}     = sz{0};
  let Inst{6-0}   = rd;
}

multiclass VFPU_A_SPTQ_FMT<bits<32> instr, string name, SDPatternOperator OpNode,
                   int hasS, int hasP, int hasT, int hasQ,
                   VFPUOperands rd = LinearOperands,
                   VFPUOperands rs = LinearOperands,
                   VFPUOperands rt = LinearOperands>
{
  if hasS then {
    def _S : VFPU_A_FMT<instr, 0, (outs rd.S:$rd), (ins rs.S:$rs, rt.S:$rt),
                   !strconcat(name, ".s"),
                   [(set rd.S:$rd, (OpNode rs.S:$rs, rt.S:$rt))]>, INSN_ALLEGREX;
  }

  if hasP then {
    def _P : VFPU_A_FMT<instr, 1, (outs rd.P:$rd), (ins rs.P:$rs, rt.P:$rt),
                   !strconcat(name, ".p"),
                   [(set rd.P:$rd, (OpNode rs.P:$rs, rt.P:$rt))]>, INSN_ALLEGREX;
  }

  if hasT then {
    def _T : VFPU_A_FMT<instr, 2, (outs rd.T:$rd), (ins rs.T:$rs, rt.T:$rt),
                   !strconcat(name, ".t"),
                   [(set rd.T:$rd, (OpNode rs.T:$rs, rt.T:$rt))]>, INSN_ALLEGREX;
  }

  if hasQ then {
    def _Q : VFPU_A_FMT<instr, 3, (outs rd.Q:$rd), (ins rs.Q:$rs, rt.Q:$rt),
                   !strconcat(name, ".q"),
                   [(set rd.Q:$rd, (OpNode rs.Q:$rs, rt.Q:$rt))]>, INSN_ALLEGREX;
  }
}

multiclass VFPU_B_SPTQ_FMT<bits<32> instr, string name, SDPatternOperator OpNode,
                   int hasS, int hasP, int hasT, int hasQ,
                   VFPUOperands rd = LinearOperands,
                   VFPUOperands rs = LinearOperands>
{
  if hasS then {
    def _S : VFPU_B_FMT<instr, 0, (outs rd.S:$rd), (ins rs.S:$rs),
                 !strconcat(name, ".s"),
                   [(set rd.S:$rd, (OpNode rs.S:$rs))]>, INSN_ALLEGREX;
  }

  if hasP then {
    def _P : VFPU_B_FMT<instr, 1, (outs rd.P:$rd), (ins rs.P:$rs),
                 !strconcat(name, ".p"),
                   [(set rd.P:$rd, (OpNode rs.P:$rs))]>, INSN_ALLEGREX;
  }

  if hasT then {
    def _T : VFPU_B_FMT<instr, 2, (outs rd.T:$rd), (ins rs.T:$rs),
                 !strconcat(name, ".t"),
                   [(set rd.T:$rd, (OpNode rs.T:$rs))]>, INSN_ALLEGREX;
  }

  if hasQ then {
    def _Q : VFPU_B_FMT<instr, 3, (outs rd.Q:$rd), (ins rs.Q:$rs),
                 !strconcat(name, ".q"),
                   [(set rd.Q:$rd, (OpNode rs.Q:$rs))]>, INSN_ALLEGREX;
  }
}

multiclass VFPU_C_SPTQ_FMT<bits<32> instr, string name, list<dag> pattern,
                   int hasS, int hasP, int hasT, int hasQ,
                   VFPUOperands rd = LinearOperands>
{
  if hasS then {
    def _S : VFPU_C_FMT<instr, 0, (outs rd.S:$rd),
                !strconcat(name, ".s"), pattern>, INSN_ALLEGREX;
  }

  if hasP then {
    def _P : VFPU_C_FMT<instr, 1, (outs rd.P:$rd),
                !strconcat(name, ".p"), pattern>, INSN_ALLEGREX;
  }

  if hasT then {
    def _T : VFPU_C_FMT<instr, 2, (outs rd.T:$rd),
                !strconcat(name, ".t"), pattern>, INSN_ALLEGREX;
  }

  if hasQ then {
    def _Q : VFPU_C_FMT<instr, 3, (outs rd.Q:$rd),
                !strconcat(name, ".q"), pattern>, INSN_ALLEGREX;
  }
}

class VCST_SPTQ_FMT<bits<2> sz, string asmstr, DAGOperand out,
         list<dag> pattern>:
  InstSE<(outs out:$rd), (ins VFPUConstant:$cst), asmstr, pattern, II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;
  bits<5> cst;
  bits<2> size = sz;

  let Opcode      = 0b110100;

  let Inst{25-23} = 0b000;
  let Inst{22-21} = 0b11;
  let Inst{20-16} = cst;
  let Inst{15}    = size{1};
  let Inst{14-8}  = 0b0000000;
  let Inst{7}     = size{0};
  let Inst{6-0}   = rd;
}

class VSYNC_FMT
  : InstSE<(outs), (ins i16imm:$num), "vsync\t$num", [], II_ALLEGREX, FrmI>
{
  bits<16> num;

  let Inst{31-16} = 0xffff;
  let Inst{15-0}  = num;
}

class VFIIM_FMT<string name, bits<32> instr, DAGOperand opnd, list<dag> pattern>
  : InstSE<(outs VFPUSOpnd:$rd), (ins opnd:$num), !strconcat(name, "\t$rd, $num"), pattern, II_ALLEGREX, FrmI>
{
  bits<7> rd;
  bits<16> num;

  let Inst{31-23} = instr{31-23};
  let Inst{22-16} = rd;
  let Inst{15-0}  = num;
}

let OperandType = "OPERAND_IMMEDIATE" in {
  def f16imm : Operand<f16>;
}

def VFPUConditionClass : AsmOperandClass
{
  let Name = "VFPUCondition";
  let PredicateMethod = "isVFPUCondition";
  let ParserMethod = "parseVFPUCondition";
}

def VFPUConditionOpnd : Operand<i32> {
  let PrintMethod = "printVFPUCondition";
  let ParserMatchClass = VFPUConditionClass;
  let OperandType = "OPERAND_IMMEDIATE";
}

class VCMP_SPTQ_FMT<string name, bits<2> size, DAGOperand opnd>
  : InstSE<(outs), (ins VFPUConditionOpnd:$cmp, opnd:$rs, opnd:$rt),
    !strconcat(name, "\t$cmp, $rs, $rt"), [], II_ALLEGREX, FrmI>
{
  string Name = name;
  bits<4> cmp;
  bits<7> rs;
  bits<7> rt;

  let Inst{31-23} = 0b011011000;
  let Inst{22-16} = rt;
  let Inst{15}    = size{1};
  let Inst{14-8}  = rs;
  let Inst{7}     = size{0};
  let Inst{6-4}   = 0b000;
  let Inst{3-0}   = cmp;
}

class VFPU_VRNDS_FMT<bits<32> instr, list<dag> pattern>:
  InstSE<(outs VFPUSOpnd:$rs), (ins), "vrnds.s\t$rs", pattern, II_ALLEGREX, FrmVFPU>
{
  bits<7> rs;

  let Opcode      = instr{31-26};

  let Inst{25-16} = instr{25-16};
  let Inst{15}    = 0;
  let Inst{14-8}  = rs;
  let Inst{7}     = 0;
  let Inst{6-0}   = instr{6-0};
}

def VFPUWriteBackClass : AsmOperandClass
{
  let Name = "VFPUWriteBack";
  let PredicateMethod = "isVFPUWriteBack";
  let ParserMethod = "parseVFPUWriteBack";
}

def VFPUWriteBackOpnd : Operand<i32> {
  let PrintMethod = "printVFPUWriteBack";
  let ParserMatchClass = VFPUWriteBackClass;
  let OperandType = "OPERAND_IMMEDIATE";
}

class VFPU_LOADSTORE_FMT<bits<6> op, string name,
                          dag o, dag i, list<dag> patterns = []>
  : InstSE<o, i,
    !strconcat(name, "\t$rt, $addr"), patterns, II_ALLEGREX, FrmI>
{
  bits<7> rt;
  bits<21> addr;

  let Inst{31-26} = op;
  let Inst{25-21} = addr{20-16};
  let Inst{20-16} = rt{6-2};
  let Inst{15-2}  = addr{13-0};
  let Inst{1-0}   = rt{1-0};
}

class SVR_Q_FMT<dag o, dag i, list<dag> patterns = []>
  : InstSE<o, i, "svr.q\t$rt, $addr", patterns, II_ALLEGREX, FrmI>
{
  let DecoderMethod = "DecodeMem";
  bits<7> rt;
  bits<21> addr;

  let Inst{31-26} = 0b111101;
  let Inst{25-21} = addr{20-16};
  let Inst{20-16} = rt{6-2};
  let Inst{15-2}  = addr{13-0};
  let Inst{1}     = 0b1;
  let Inst{0}     = rt{0};
}

class SV_Q_FMT<dag o, dag i, list<dag> patterns = []>
  : InstSE<o, i, "sv.q\t$rt, $addr, $wb", patterns, II_ALLEGREX, FrmI>
{
  let DecoderMethod = "DecodeMem";
  bits<7> rt;
  bits<21> addr;
  bits<1> wb;

  let Inst{31-26} = 0b111110;
  let Inst{25-21} = addr{20-16};
  let Inst{20-16} = rt{6-2};
  let Inst{15-2}  = addr{13-0};
  let Inst{1}     = wb;
  let Inst{0}     = rt{0};
}

def ScaleOpnd : Operand<i32>;

class VFPU_BITCAST_FMT<string name, bits<11> opcode,
                       bits<2> size, DAGOperand opnd>
  : InstSE<(outs opnd:$rd), (ins opnd:$rs, ScaleOpnd:$scale),
    !strconcat(name, "\t$rd, $rs, $scale"), [], II_ALLEGREX, FrmI>
{
  bits<7> rd;
  bits<7> rs;
  bits<5> scale;

  let Inst{31-21} = opcode;
  let Inst{20-16} = scale;
  let Inst{15}    = size{1};
  let Inst{14-8}  = rs;
  let Inst{7}     = size{0};
  let Inst{6-0}   = rd;
}

multiclass VFPU_BITCAST_SPTQ_FMT<string name, bits<11> opcode>
{
  def _S : VFPU_BITCAST_FMT<!strconcat(name, ".s"), opcode, 0, VFPUSOpnd>,
           INSN_ALLEGREX;
  def _P : VFPU_BITCAST_FMT<!strconcat(name, ".p"), opcode, 1, VFPUPOpnd>,
           INSN_ALLEGREX;
  def _T : VFPU_BITCAST_FMT<!strconcat(name, ".t"), opcode, 2, VFPUTOpnd>,
           INSN_ALLEGREX;
  def _Q : VFPU_BITCAST_FMT<!strconcat(name, ".q"), opcode, 3, VFPUQOpnd>,
           INSN_ALLEGREX;
}

class MFV_FMT<bits<32> instr, dag outs, dag ins, string asmstr,
         list<dag> pattern>:
  InstSE<outs, ins, asmstr, pattern, II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;
  bits<5> rt;

  let Opcode      = instr{31-26};

  let Inst{25-21} = instr{25-21};
  let Inst{20-16} = rt;
  let Inst{15-7}  = instr{15-7};
  let Inst{6-0}   = rd;
}

foreach I = 0-255 in def VCR#I : MipsReg<I, ""#I>;
def VCR : RegisterClass<"Mips", [i32], 32, (sequence "VCR%u", 0, 255)>,
          Unallocatable;

def VCRAsmOperand : MipsAsmRegOperand {
  let Name = "VCRAsmReg";
  let ParserMethod = "parseVCRRegister";
}

def VCROpnd : RegisterOperand<VCR> {
  let ParserMatchClass = VCRAsmOperand;
}

class MFVC_FMT<bits<32> instr, string name, dag outs, dag ins>:
  InstSE<outs, ins, !strconcat(name, "\t$rt, $rd"), [], II_ALLEGREX, FrmVFPU>
{
  bits<8> rd;
  bits<5> rt;

  let Inst{31-21} = instr{31-21};
  let Inst{20-16} = rt;
  let Inst{15-8}  = instr{15-8};
  let Inst{7-0}   = rd;
}

class VCMOV_FMT<bits<32> instr, string name, bits<2> sz, DAGOperand opnd>:
  InstSE<(outs opnd:$rd), (ins opnd:$rs, i8imm:$cnd),
         !strconcat(name, "\t$rd, $rs, $cnd"), [], II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;
  bits<7> rs;
  bits<3> cnd;
  let Inst{31-19} = instr{31-19};
  let Inst{18-16} = cnd;
  let Inst{15}    = sz{1};
  let Inst{14-8}  = rs;
  let Inst{7}     = sz{0};
  let Inst{6-0}   = rd;
}

multiclass VCMOV_SPTQ_FMT<bits<32> instr, string name>
{
  def _S : VCMOV_FMT<instr, !strconcat(name, ".s"), 0, VFPUSOpnd>,
           INSN_ALLEGREX;
  def _P : VCMOV_FMT<instr, !strconcat(name, ".p"), 1, VFPUPOpnd>,
           INSN_ALLEGREX;
  def _T : VCMOV_FMT<instr, !strconcat(name, ".t"), 2, VFPUTOpnd>,
           INSN_ALLEGREX;
  def _Q : VCMOV_FMT<instr, !strconcat(name, ".q"), 3, VFPUQOpnd>,
           INSN_ALLEGREX;
}

class VFPU_BRANCH_FMT<bits<32> instr, string name> :
  InstSE<(outs), (ins i8imm:$op, brtarget:$offset),
         !strconcat(name, "\t$op, $offset"), [], II_ALLEGREX, FrmI> {
  let isBranch = 1;
  let isTerminator = 1;
  let hasDelaySlot = 1;
  bit isCTI = 1;

  bits<3> op;
  bits<16> offset;

  let Inst = instr;
  let Inst{20-18} = op;
  let Inst{15-0} = offset;
}

def VFPUPRotationClass : AsmOperandClass
{
  let Name = "VFPUPRotation";
  let PredicateMethod = "isVFPURotation";
  let RenderMethod = "addVFPURotationOperands";
  let ParserMethod = "parseVFPUPRotation";
}

def VFPUPRotationOpnd : Operand<i32> {
  let PrintMethod = "printVFPUPRotation";
  let ParserMatchClass = VFPUPRotationClass;
  let OperandType = "OPERAND_IMMEDIATE";
}

def VFPUTRotationClass : AsmOperandClass
{
  let Name = "VFPUTRotation";
  let PredicateMethod = "isVFPURotation";
  let RenderMethod = "addVFPURotationOperands";
  let ParserMethod = "parseVFPUTRotation";
}

def VFPUTRotationOpnd : Operand<i32> {
  let PrintMethod = "printVFPUTRotation";
  let ParserMatchClass = VFPUTRotationClass;
  let OperandType = "OPERAND_IMMEDIATE";
}

def VFPUQRotationClass : AsmOperandClass
{
  let Name = "VFPUQRotation";
  let PredicateMethod = "isVFPURotation";
  let RenderMethod = "addVFPURotationOperands";
  let ParserMethod = "parseVFPUQRotation";
}

def VFPUQRotationOpnd : Operand<i32> {
  let PrintMethod = "printVFPUQRotation";
  let ParserMatchClass = VFPUQRotationClass;
  let OperandType = "OPERAND_IMMEDIATE";
}

class VROT_FMT<bits<32> instr, string name, DAGOperand reg, DAGOperand rot>
  : InstSE<(outs reg:$rd), (ins VFPUSOpnd:$rs, rot:$rot),
           !strconcat(name, "\t$rd, $rs, $rot"), [], II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;
  bits<7> rs;
  bits<5> rot;
  
  let Inst        = instr;
  let Inst{20-16} = rot;
  let Inst{14-8}  = rs;
  let Inst{6-0}   = rd;
}

def VFPUSwizzleClass : AsmOperandClass
{
  let Name = "VFPUSwizzle";
  let PredicateMethod = "isVFPUSwizzle";
  let RenderMethod = "addVFPUSwizzleOperands";
  let ParserMethod = "parseVFPUSwizzle";
}

def VFPUSwizzleOpnd : Operand<i8> {
  let PrintMethod = "printVFPUSwizzle";
  let ParserMatchClass = VFPUSwizzleClass;
  let OperandType = "OPERAND_IMMEDIATE";
}

class VPFXST_FMT<bits<32> instr, string name>
  : InstSE<(outs), (ins VFPUSwizzleOpnd:$a,
                        VFPUSwizzleOpnd:$b,
                        VFPUSwizzleOpnd:$c,
                        VFPUSwizzleOpnd:$d),
           !strconcat(name, "\t$a, $b, $c, $d"), [], II_ALLEGREX, FrmVFPU>
{
  bits<5> a;
  bits<5> b;
  bits<5> c;
  bits<5> d;

  let Inst      = instr;
  let Inst{19}  = a{4};
  let Inst{18}  = b{4};
  let Inst{17}  = c{4};
  let Inst{16}  = d{4};

  let Inst{15}  = a{3};
  let Inst{14}  = b{3};
  let Inst{13}  = c{3};
  let Inst{12}  = d{3};

  let Inst{11}  = a{2};
  let Inst{10}  = b{2};
  let Inst{9}   = c{2};
  let Inst{8}   = d{2};

  let Inst{7-6} = a{1-0};
  let Inst{5-4} = b{1-0};
  let Inst{3-2} = c{1-0};
  let Inst{1-0} = d{1-0};
}