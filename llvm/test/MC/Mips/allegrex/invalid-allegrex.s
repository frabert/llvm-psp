# RUN: not llvm-mc %s -triple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex 2>&1 \
# RUN:   | FileCheck %s

# Negative tests for Allegrex/VFPU operand parsing.

        lvl.q $4, 0($5)
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: invalid operand for instruction

        vuc2ifs.s S000, S010
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: invalid operand for instruction

        vcmov.s S000, S010
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: too few operands for instruction

        vadd.q C000, C010
# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: too few operands for instruction
