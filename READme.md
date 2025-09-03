# RISC-V Single-Cycle CPU in Verilog

This project implements a **single-cycle RISC-V RV32I CPU core** in Verilog.  
It was built as a **learning and portfolio project** to demonstrate skills in **digital design, CPU microarchitecture, and hardware verification**.  

The CPU supports a subset of the **RISC-V RV32I instruction set** and runs real machine code instructions such as arithmetic, branches, memory loads/stores, and function calls with jumps.

---

##  Why This Project?
Modern hardware companies (FAANG, NVIDIA, AMD, ARM, Intel, etc.) expect strong fundamentals in **processor design and verification**.  
This project was built to:
- Gain **hands-on experience** in CPU architecture.
- Practice **RTL design in Verilog** and debugging with simulators.
- Showcase ability to build a **working RISC-V core** from scratch.
- Prepare for roles in **CPU design, SoC architecture, FPGA/ASIC verification, and digital logic design**.

---

##  Features
-  **Instruction Fetch / Decode / Execute / Write-back**
-  **Arithmetic & Logic**: ADD, SUB, AND, OR, XOR, shifts, immediate ops
-  **Branching**: BEQ tested and working
-  **Memory Operations**: LW, SW with data memory
-  **Control Flow**: JAL, JALR for function calls/returns
-  **Program Termination**: ECALL instruction
- Modular design with separate files for ALU, regfile, control, etc.
- Testbenches included with `$monitor` and waveform dumps

---

## 📂 Project Structure
riscv_cpu/
│
├── cpu_top.v        # Top-level CPU integration
├── pc.v             # Program counter
├── instr_mem.v      # Instruction memory (with test programs)
├── regfile.v        # 32x32 register file
├── alu.v            # Arithmetic Logic Unit
├── alu_control.v    # ALU control logic
├── control.v        # Main control unit
├── imm_gen.v        # Immediate generator
├── data_mem.v       # Data memory for LW/SW
├── tb_cpu.v         # Testbench
└── README.md        # Project documentation

---

## How to Run

### 1. Install Tools (macOS with Homebrew)
```bash
brew install icarus-verilog gtkwave

 Compile and Run Testbench
iverilog -o tb_cpu.vvp pc.v instr_mem.v regfile.v imm_gen.v control.v alu_control.v alu.v data_mem.v cpu_top.v tb_cpu.v
vvp tb_cpu.vvp

View Waveforms
gtkwave tb_cpu.vcd

Example Outputs

Arithmetic + Branch (BEQ)
T=25000 | PC=00000008 | x1=1 x2=1 x3=x x4=x | alu_res=0 zero=1 branch=1 imm=8
 Branch was taken because x1 == x2, PC jumped forward correctly.

Memory Test (LW/SW)
x1 = 10
x2 = 20
x3 = 10   <- value stored in memory and loaded back
Data memory works with load/store.

JAL + JALR Test (Function Call + Return)
x1 = 5
x2 = 12
x5 = 0x08   <- link register (return address)

Waveform Demo (control.v only)
<img width="1440" height="900" alt="Screenshot 2025-09-02 at 10 24 29 PM" src="https://github.com/user-attachments/assets/0c1841ad-9f25-471f-8afc-c969590d8073" />

Future Work
	•	Add full RV32I ISA coverage (e.g., SLT, LBU, SB, BNE, etc.)
	•	Extend to a 5-stage pipeline (IF, ID, EX, MEM, WB) with hazard detection
	•	Explore FPGA synthesis on Xilinx Artix-7 or similar boards

Skills Demonstrated
	•	Digital design in Verilog (RTL coding)
	•	CPU microarchitecture (datapath + control integration)
	•	Simulation & debugging with Icarus Verilog / GTKWave
	•	GitHub project documentation and organization
	•	Strong foundation in computer architecture (RISC-V ISA)
	•	Readiness for FPGA/ASIC/SoC design and verification roles


License
This project is released under the MIT License.
Author: VNP012
