# Two-Stage Pipelined AES-128 Encryption on FPGA

This repository contains the design and implementation of a **high-throughput, two-stage pipelined AES-128 encryption core** implemented in **Verilog** and deployed on an **FPGA**.  
The design focuses on **performance, parallelism, and hardware–software integration**, achieving one ciphertext output per clock cycle after pipeline fill.

---

## 📌 Project Overview

Advanced Encryption Standard (AES-128) is a widely used symmetric-key encryption algorithm.  
In this project, AES-128 is implemented as a **fully pipelined hardware architecture**, where each encryption round is split into two synchronized pipeline stages.

Key objectives:
- High throughput using deep pipelining
- Clean separation of combinational and sequential logic
- Parallel key expansion aligned with the data path
- End-to-end validation on FPGA using a host application

---

## 🏗️ Architecture

### Two-Stage Pipeline per AES Round

Each AES round is divided into two pipeline stages:

**Stage 1**
- SubBytes
- ShiftRows  
- Output registered into a 128-bit pipeline register

**Stage 2**
- MixColumns (omitted in final round)
- AddRoundKey  
- Output registered and forwarded to the next round

This structure allows:
- New plaintext blocks to enter the pipeline every cycle
- One 128-bit ciphertext output per clock cycle after pipeline fill

---

## 🔑 Key Expansion

- AES-128 key expansion is implemented **in parallel** with the data path
- Round keys are generated on-the-fly and synchronized with pipeline stages
- No additional control logic is required to align keys with data

---

## 🚀 Performance Metrics

| Metric | Value |
|------|------|
| Maximum Frequency | **214 MHz** |
| Throughput | **27.4 Gbps** |
| Pipeline Latency | **20 clock cycles** |
| FPGA Slices Used | **2958** |
| Throughput / Area | **9.27 Mbps per slice** |

After initial pipeline fill, the design produces **one ciphertext per clock cycle**.

---

## 🧪 Verification & Validation

- Functional verification performed using **Verilog testbenches**
- Timing and area verified using FPGA synthesis tools
- Hardware validation performed on **PYNQ-Z2 FPGA**
- A **Vitis-based C host application** is used for:
  - Data transfer
  - Control and execution
  - Output validation against known AES test vectors

---

## 📁 Repository Structure

```
.
├── rtl
│   ├── AESEncrypt.v
│   ├── AddRoundKey.v
│   ├── SubBytes.v
│   ├── ShiftRows.v
│   ├── MixColumns.v
│   ├── KeyGen.v
│   ├── SubTable.v
│   └── Update.v
├── software
│   └── vitis.c
├── testbench
│   └── test_AES128.v
├── report
│   └── Pipelined_AES_Encryption.pdf
└── README.md
```
