# MIPS-Processor

# Simple MIPS-like Processor – Verilog HDL

This repository contains the implementation of a **simple 8-bit single-cycle MIPS-like processor** developed as part of **CO224 – Computer Architecture** laboratory sessions at the **Department of Computer Engineering**.

The processor is designed and implemented using **Verilog HDL**, following a step-by-step approach from basic components to a fully working CPU with flow control instructions.


# Features

* **8-bit ALU** supporting:

  * `add`, `sub`, `and`, `or`, `mov`, `loadi`
* **8×8 Register File**

  * Two asynchronous read ports
  * One synchronous write port
* **Single-cycle CPU**

  * Instruction fetch, decode, execute, and write-back in one cycle
* **Flow control instructions**

  * `j` (jump)
  * `beq` (branch if equal)
* **32-bit fixed-length instruction format**
* Artificial delays added to simulate realistic hardware latencies

---

## 🧠 Supported Instruction Set

| Instruction        | Description          |
| ------------------ | -------------------- |
| `add rd rs rt`     | rd ← rs + rt         |
| `sub rd rs rt`     | rd ← rs − rt         |
| `and rd rs rt`     | Bitwise AND          |
| `or rd rs rt`      | Bitwise OR           |
| `mov rd rs`        | Copy rs to rd        |
| `loadi rd imm`     | Load immediate value |
| `j offset`         | Jump relative to PC  |
| `beq offset rs rt` | Branch if rs == rt   |

---

## 🏗️ Project Structure

```
├── alu.v           # 8-bit ALU implementation
├── reg_file.v      # 8x8 register file
├── cpu.v           # Top-level CPU with control logic
├── testbench.v     # Testbench with hardcoded programs
├── diagrams/       # Timing diagrams & datapath diagrams
└── README.md
```

---

## ⏱️ Timing Model

* Single-cycle CPU (8 time units per instruction)
* Artificial delays added for:

  * Instruction memory read
  * Decode
  * ALU operations
  * Register read/write
  * PC update

These delays help visualize datapath behavior using tools like **GTKWave**.

---

## 🧪 Testing

* Instructions are hardcoded in the testbench as machine code
* Multiple test programs used to validate:

  * Arithmetic operations
  * Register writes
  * Branching and jumping
* Timing diagrams verified using **GTKWave**

---

## 🛠️ Tools & Technologies

* Verilog HDL
* GTKWave
* Icarus Verilog / ModelSim (for simulation)


