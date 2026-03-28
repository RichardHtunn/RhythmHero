import csv
import sys

OSU_FILE = './OSU_Files/DiscoPrince.osu'  
OUTPUT_CSV = './CSV_Files/DiscoPrince.csv'   

notes = []
parsing_objects = False

try:
    with open(OSU_FILE, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
        
            if line == '[HitObjects]':
                parsing_objects = True
                continue
                
            if parsing_objects and line:
                parts = line.split(',')
                if len(parts) >= 3:
                    x = int(parts[0])
                    time_ms = int(parts[2])
                    
                    # Convert the X-coordinate on the screen into Lane 1, 2, 3, or 4
                    # The osu! playing field is 512 units wide. 512 / 4 lanes = 128 units per lane.
                    if x < 128:
                        lane = 1
                    elif x < 256:
                        lane = 2
                    elif x < 384:
                        lane = 3
                    else:
                        lane = 4
                        
                    # Convert their milliseconds into your decimal seconds (e.g., 1050ms -> 1.050s)
                    timestamp = round(time_ms / 1000.0, 3)
                    notes.append((timestamp, lane))

    # Save your new, perfectly mapped CSV!
    if notes:
        print(f"Success! Found {len(notes)} notes.")
        print(f"Saving to {OUTPUT_CSV}...")
        
        with open(OUTPUT_CSV, mode='w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['timestamp', 'lane'])
            for note in notes:
                writer.writerow([note[0], note[1]])
                
        print("Your professional Beat Map is ready to play!")
    else:
        print("No notes found. Are you sure this is an osu!mania map?")

except FileNotFoundError:
    print(f"ERROR: Could not find {OSU_FILE}. Check the file name in the configuration.")   