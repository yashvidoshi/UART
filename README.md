# UART Transmitter and Receiver in Verilog

A simple UART (Universal Asynchronous Receiver Transmitter) implementation in Verilog including:

- UART Transmitter (TX)
- UART Receiver (RX)
- Testbench
- Waveform Verification using Surfer/VCD

---

# Features

✅ UART TX Module  
✅ UART RX Module  
✅ Configurable Baud Timing  
✅ FSM-Based Design  
✅ Simulation using Icarus Verilog  
✅ Waveform Analysis using Surfer  
✅ Successfully Transmits and Receives ASCII Character `'I'`

---

# Project Structure

```text
uart/
│── tx.v
│── rx.v
│── tb_uart.v
│── dump.vcd
│── README.md
```

---

# UART Frame Format

```text
| Start Bit | 8 Data Bits | Stop Bit |
|     0     |   LSB First |     1    |
```

---

# Tools Used

- Verilog HDL
- Icarus Verilog
- Surfer Waveform Viewer
- macOS Terminal

---

# Compilation and Simulation

## Compile

```bash
iverilog -o uart_sim tb_uart.v tx.v rx.v
```

## Run Simulation

```bash
vvp uart_sim
```

## Open Waveform

```bash
surfer dump.vcd
```

---

# Simulation Output

```text
=================================
Time = 9925
Received Data = 01001001
Received Character = I
=================================
```

---

# Waveform

<img width="1191" height="439" alt="waveform" src="https://github.com/user-attachments/assets/4aeb0a16-94c2-4b79-a1a7-65ae6fed979c" />

---

# How UART TX Works

The transmitter:

1. Waits for `tx_start`
2. Sends Start Bit (`0`)
3. Sends 8 Data Bits
4. Sends Stop Bit (`1`)
5. Returns to IDLE state

---

# How UART RX Works

The receiver:

1. Detects Start Bit
2. Samples incoming bits using baud timing
3. Stores received bits
4. Reconstructs the byte
5. Sets `rx_done = 1`

---

# FSM States

## TX FSM

```text
IDLE -> START -> DATA -> STOP -> IDLE
```

## RX FSM

```text
IDLE -> START -> DATA -> STOP -> IDLE
```

---

# Example Transmission

Character Sent:

```text
'I'
```

ASCII:

```text
01001001
```

Hex:

```text
0x49
```

---

# Internal Signals Observed

## TX Signals

- `tx`
- `tx_data`
- `tx_start`

## RX Signals

- `rx_data`
- `rx_done`

## Common Signals

- `clk`
- `rst`
- `serial_line`

---

# Waveform Verification

The waveform confirms:

✅ Start Bit Detection  
✅ Correct Bit Timing  
✅ Serial Transmission  
✅ Correct Data Reconstruction  
✅ Successful UART Communication

---

# Future Improvements

- Configurable Baud Rate
- Parity Bit Support
- FIFO Buffer
- Full Duplex UART
- FPGA Implementation
- Error Detection

---

# Author

Yashvi Doshi
