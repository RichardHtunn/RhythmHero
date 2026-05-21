# Rhythm Hero: FPGA Arcade Game

**A hardware-based rhythm game (inspired by "Piano Tiles") utilizing an FPGA for visual rendering and digital logic, paired with a Raspberry Pi for audio management.**

This repository contains the VHDL source code, pin constraints, and hardware documentation for an arcade-style rhythm game. Built around the Basys3 FPGA board, this project demonstrates advanced hardware-software synchronization, custom VGA driver implementation, and physical input debouncing.

## 🕹️ Project Showcase
<img width="1280" height="720" alt="RhythmOne" src="https://github.com/user-attachments/assets/2ed33a01-c1f2-4f35-91b4-f0aeddd906b8" />
<img width="1280" height="720" alt="RhythmTwo" src="https://github.com/user-attachments/assets/03c857f7-ed55-487a-929c-c0a7f462e09a" />
<img width="1280" height="720" alt="RhythmThree" src="https://github.com/user-attachments/assets/ce3fdf6e-a84b-41c6-b477-ec325ba49ea0" />



## 🛠️ System Architecture
The game relies on a distributed hardware model to handle high-speed visual rendering and complex audio playback simultaneously.

* **Visual Engine & Logic (FPGA):** A Digilent Basys3 board running custom VHDL. It handles the game state machine, collision detection, and generates the VGA timing signals to draw the falling tiles on the screen.
* **Audio Management (Raspberry Pi):** Receives trigger signals from the FPGA to manage multi-track audio playback and sound effects, ensuring zero-latency audio synchronization with the visual gameplay.
* **User Input:** Physical arcade buttons integrated with hardware debouncing logic on the FPGA.

*(See `BOM.md` for a complete hardware list and `schematic.png` for the GPIO wiring between the FPGA and Raspberry Pi).*

## 💻 Code Structure
* `/Rhythm_Hero_Final_1.srcs/sources_1/new`: Contains all VHDL files for the Basys3 board (Game state machine, VGA controller, debouncers).
* `/Rhythm_hero_Final_1.srcs/constrs_1/new`: Contains the `.xdc` file mapping the VHDL logic to the physical pins on the Basys3.
* `/src_pi`: Contains the script (e.g., Python) running on the Raspberry Pi to listen for GPIO triggers and play corresponding audio files.

## 🚀 How to Run
### FPGA Setup
1. Open the project in Xilinx Vivado.
2. Generate the bitstream from the provided VHDL files and constraints.
3. Program the Basys3 board via the Hardware Manager.

### Audio Setup
1. Connect the designated GPIO pins from the Basys3 Pmod ports to the Raspberry Pi GPIO headers.
2. Run the audio listener script on the Raspberry Pi:
   ```bash
   python rhythm_hero_main.py
