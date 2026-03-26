import serial
import pygame
import csv
import time
import sys

# --- CONFIGURATION ---
CSV_FILE = './CSV_Files/CherryBlossoms.csv'      
AUDIO_FILE = './Audios/CheeryBlossoms.mp3'       
SERIAL_PORT = '/dev/serial0'         
BAUD_RATE = 9600

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
            notes_queue.append({
                'time': float(row['timestamp']),
                'lane': str(row['lane']).encode() 
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
            
            if current_time >= next_note['time']:
                # Only fire the physical wire if we are actually on the Pi
                if HARDWARE_CONNECTED:
                    bridge.write(next_note['lane']) 
                
                print(f"[{current_time:.3f}s] -> Fired Lane {next_note['lane'].decode()}")
                notes_queue.pop(0) 

        # Only listen for the FPGA 'X' if we are actually on the Pi
        if HARDWARE_CONNECTED and bridge.in_waiting > 0:
            fpga_msg = bridge.read().decode('utf-8')
            if fpga_msg == 'X':
                print("\n[!!!] FATAL MISS RECEIVED FROM FPGA [!!!]")
                print("Game Over. Stopping music.")
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