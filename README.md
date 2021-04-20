# SingleCycleCPU
This is a 64-bit, single-cycle CPU written in VHDL that supports the LEGv8 instruction set.

Features include:
- 32 64-bit registers
- 32-bit instructions
- A 64-bit ALU that supports AND, OR, ADD, SUB, NOR, and pass input B. 
  - Operation is selected by a 4-bit ALU-specific opcode
  - Contains a flag for branching statements that is asserted when the output is equal to 0
- ALU control unit for generating ALU opcode from instruction opcode
- Clock-driven Program Counter (PC)
- 32-to-64 bit sign extender
- Data memory with supported byte-addressing
- Control unit for generating control flags
- Various test benches
