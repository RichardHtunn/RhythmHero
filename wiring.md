# Hardware Wiring & GPIO Mapping

This document details the physical connection between the Basys3 FPGA (Visuals/Logic) and the Raspberry Pi (Audio). 

## Logic Level Compatibility
The Basys3 Pmod headers operate at a 3.3V logic level, which is natively compatible with the Raspberry Pi's 3.3V GPIO pins. Therefore, direct wiring was used without the need for a logic level converter.

## Pinout Mapping

To transmit the 4 distinct audio triggers (corresponding to the 4 arcade buttons) from the FPGA to the Pi, we utilized the **JA Pmod Header** on the Basys3.

| Trigger Event | Basys3 Pin (Pmod JA) | Raspberry Pi Pin (Physical) | Raspberry Pi GPIO (BCM) |
| :--- | :--- | :--- | :--- |
| **Track 1 / Button A** | JA1 (Pin 1) | Pin 11 | GPIO 17 |
| **Track 2 / Button B** | JA2 (Pin 2) | Pin 13 | GPIO 27 |
| **Track 3 / Button C** | JA3 (Pin 3) | Pin 15 | GPIO 22 |
| **Track 4 / Button D** | JA4 (Pin 4) | Pin 16 | GPIO 23 |
| **Common Ground** | GND (Pin 5) | Pin 14 | GND |

> **⚠️ Critical Note:** The Common Ground connection is strictly required to ensure both boards share the same voltage reference, preventing floating signals and false audio triggers.

## Arcade Button Inputs
The physical arcade buttons are connected to the Basys3 via the **JB Pmod Header**, utilizing internal pull-up resistors configured in the VHDL constraints (`.xdc`) file. Hardware debouncing is handled entirely on the FPGA side before any signal is sent to the Raspberry Pi.
