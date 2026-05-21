import serial
import pygame
import csv
import time
import sys

# --- CONFIGURATION ---
CSV_FILE = './CSV_Files/CherryBlossoms.csv'      
AUDIO_FILE = './Audios/CheeryBlossoms.wav'       
SERIAL_PORT = '/dev/serial0'         
BAUD_RATE = 9600

# The Hardware Lookahead: 16 pixels/frame = 0.41 seconds to fall to the red line.
FALL_TIME_SECONDS = 0.41

# --- 1. INITIALIZE UART BRIDGE (LAPTOP SAFE) ---
HARDWARE_CONNECTED = False
try:
    print(f"Searching for hardware port {SERIAL_PORT}...")
    bridge = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=0) 
    HARDWARE_CONNECTED = True
    time.sleep(1) 
except (serial.SerialException, FileNotFoundError):
    print("⚠️ No Raspberry Pi pins detected. Running in LAPTOP TEST MODE.")

# --- 2. LOAD THE BEAT MAP ---
notes_queue = []
try:
    with open(CSV_FILE, mode='r') as file:
        csv_reader = csv.DictReader(file)
        for row in csv_reader:
            
            # --- FIX 1: Convert CSV number to FPGA Binary Bitmask ---
            lane_num = int(row['lane'])
            bitmask = 0x00
            if lane_num == 0: bitmask = 0x01 # 0000 0001
            elif lane_num == 1: bitmask = 0x02 # 0000 0010
            elif lane_num == 2: bitmask = 0x04 # 0000 0100
            elif lane_num == 3: bitmask = 0x08 # 0000 1000
            
            notes_queue.append({
                'time': float(row['timestamp']),
                'lane_mask': bytes([bitmask]), # The actual binary byte for the FPGA
                'lane_str': str(lane_num)      # Keep the string just for the terminal print
            })
    print(f"Loaded {len(notes_queue)} notes from {CSV_FILE}.")
except FileNotFoundError:
    print(f"ERROR: Could not find {CSV_FILE}.")
    sys.exit()

# --- 3. INITIALIZE AUDIO ---
pygame.mixer.init()
try:
    pygame.mixer.music.load(AUDIO_FILE)
    print("Audio loaded successfully.")
except pygame.error as e:
    print(f"ERROR: Could not load audio file. \n{e}")
    sys.exit()

# --- 4. THE GAME LOOP ---
print("\n--- RHYTHM HERO ENGINE STARTED ---")
print("Playing track in 3... 2... 1...")
time.sleep(3)

pygame.mixer.music.play()
start_time = time.time() 

try:
    while pygame.mixer.music.get_busy():
        current_time = time.time() - start_time
        
        # Check if it's time to fire the next note
        if len(notes_queue) > 0:
            next_note = notes_queue[0] 
            
            # --- FIX 2: The Hardware Lookahead ---
            # Fire the note EARLY so it has time to fall down the TV screen!
            if current_time >= (next_note['time'] - FALL_TIME_SECONDS):
                
                if HARDWARE_CONNECTED:
                    bridge.write(next_note['lane_mask']) 
                
                print(f"[{current_time:.3f}s] -> Fired Lane {next_note['lane_str']} (Hits at {next_note['time']:.3f}s)")
                notes_queue.pop(0) 

        # Listen for the FPGA 'X' (Fatal Miss)
        if HARDWARE_CONNECTED and bridge.in_waiting > 0:
            fpga_msg = bridge.read().decode('utf-8', errors='ignore')
            if fpga_msg == 'X':
                print("\n[!!!] FATAL MISS RECEIVED FROM FPGA [!!!]")
                print("Game Over. Stopping music.")
                pygame.mixer.music.stop()
                break 
            elif fpga_msg == 'S':
                print("\n[i] TRACK STOPPED EARLY BY PLAYER.")
                print("Check the Arcade Display for your final score!")
                pygame.mixer.music.stop()
                break
                
        time.sleep(0.001) 

except KeyboardInterrupt:
    print("\nForce quit by user.")

# --- CLEANUP ---
print("Closing connections...")
if HARDWARE_CONNECTED:
    bridge.close()
pygame.quit()
print("System Shutdown Complete.")
