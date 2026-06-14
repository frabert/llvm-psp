# RUN: llvm-mc %s -triple=mipsel-none-elf -mcpu=allegrex -mattr=+allegrex | FileCheck %s

# VFPU quad loads/stores with a symbolic (absolute) address must expand the
# address into AT rather than mis-parsing the symbol as a base register.

# lv.q already worked; kept here as the reference expansion.
  lv.q C000, sym
# CHECK:      lui   $1, %hi(sym)
# CHECK-NEXT: lv.q  C000, %lo(sym)($1)

  lvl.q C000, sym
# CHECK:      lui   $1, %hi(sym)
# CHECK-NEXT: lvl.q C000, %lo(sym)($1)

  lvr.q C000, sym
# CHECK:      lui   $1, %hi(sym)
# CHECK-NEXT: lvr.q C000, %lo(sym)($1)

  svl.q C000, sym
# CHECK:      lui   $1, %hi(sym)
# CHECK-NEXT: svl.q C000, %lo(sym)($1)

# sv.q / svr.q carry a write-back operand, so the full address is materialized
# into AT and the store uses a zero displacement.
  sv.q C000, sym
# CHECK:      lui   $1, %hi(sym)
# CHECK-NEXT: addiu $1, $1, %lo(sym)
# CHECK-NEXT: sv.q  C000, 0($1)

  svr.q C000, sym
# CHECK:      lui   $1, %hi(sym)
# CHECK-NEXT: addiu $1, $1, %lo(sym)
# CHECK-NEXT: svr.q C000, 0($1)

# A symbol added to a base register keeps the base in the materialized address.
  sv.q C000, sym($a0)
# CHECK:      lui   $1, %hi(sym)
# CHECK-NEXT: addiu $1, $1, %lo(sym)
# CHECK-NEXT: addu  $1, $1, $4
# CHECK-NEXT: sv.q  C000, 0($1)

# Plain in-range immediate offsets are left untouched (no expansion).
  sv.q C000, 8($a0)
# CHECK:      sv.q  C000, 8($4)
  lvl.q C000, 16($a0)
# CHECK:      lvl.q C000, 16($4)
