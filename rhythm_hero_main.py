import serial
import pygame
import time
import csv
import sys
import os

# ==========================================
# CONFIGURATION
# ==========================================
CSV_FILE = './CSV_Files/CherryBlossoms.csv'      
AUDIO_FILE = './Audios/CheeryBlossoms.wav'       
SERIAL_PORT = '/dev/serial0'         
BAUD_RATE = 9600

# Updated Hardware Lookahead for a FALL_SPEED of 3
FALL_TIME_SECONDS = 2.22

# ==========================================
# INITIALIZATION
# ==========================================
print("[i] Initializing Rhythm Hero Engine...")

# 1. Start Serial Bridge
try:
    bridge = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=0.1)
    HARDWARE_CONNECTED = True
    print("[+] FPGA Serial Bridge Connected.")
except Exception as e:
    print(f"[!] Warning: Could not connect to FPGA on {SERIAL_PORT}.")
    print(f"[!] Error: {e}")
    HARDWARE_CONNECTED = False

# 2. Start Audio Engine
pygame.mixer.init()
try:
    pygame.mixer.music.load(AUDIO_FILE)
    print(f"[+] Audio loaded: {AUDIO_FILE}")
except Exception as e:
    print(f"[!] Critical Error: Could not load audio. {e}")
    sys.exit(1)

# 3. Load Beatmap (CSV)
notes = []
try:
    with open(CSV_FILE, 'r') as f:
        reader = csv.reader(f)
        next(reader, None) # Skip the header row
        for row in reader:
            if len(row) >= 2:
                timestamp = float(row[0])
                lane_data = int(row[1]) 
                notes.append({'time': timestamp, 'lanes': lane_data, 'spawned': False})
    print(f"[+] Beatmap loaded: {len(notes)} notes found.")
except Exception as e:
    print(f"[!] Critical Error: Could not load CSV. {e}")
    sys.exit(1)

# ==========================================
# MAIN GAME LOOP
# ==========================================
print("\n[*] READY. Waiting for the track to begin...")
print("Press ENTER in this terminal to start the music!")
input()

pygame.mixer.music.play()
start_time = time.time()

print("[*] Playing...")

try:
    while pygame.mixer.music.get_busy():
        current_time = time.time() - start_time
        
        # --- 1. Spawn Notes ---
        for note in notes:
            if not note['spawned']:
                # Spawn the note exactly FALL_TIME_SECONDS before it hits the line
                if current_time >= (note['time'] - FALL_TIME_SECONDS):
                    if HARDWARE_CONNECTED:
                        # Convert the lane integer into a raw byte and send it
                        spawn_byte = bytes([note['lanes']])
                        bridge.write(spawn_byte)
                    note['spawned'] = True
        
        # --- 2. Listen to FPGA (The Exit/Miss Logic) ---
        if HARDWARE_CONNECTED and bridge.in_waiting > 0:
            fpga_msg = bridge.read().decode('utf-8', errors='ignore')
            
            if fpga_msg == 'X':
                print("\n[!!!] FATAL MISS: TILE DROPPED [!!!]")
                print("Game Over. Stopping music.")
                pygame.mixer.music.stop()
                break 
                
            elif fpga_msg == 'S':
                print("\n[i] TRACK STOPPED EARLY BY PLAYER.")
                print("Check the Arcade Display for your final score!")
                pygame.mixer.music.stop()
                break 
                
        # Small sleep to keep the Raspberry Pi CPU cool
        time.sleep(0.005)

except KeyboardInterrupt:
    print("\n[i] Script interrupted by user (Ctrl+C).")

finally:
    pygame.mixer.music.stop()
    if HARDWARE_CONNECTED:
        bridge.close()
    print("[*] Engine shutdown complete.")