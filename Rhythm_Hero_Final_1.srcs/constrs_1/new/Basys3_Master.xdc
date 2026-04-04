set_property PACKAGE_PIN W5 [get_ports clk]              
  set_property IOSTANDARD LVCMOS33 [get_ports clk]
  create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# 2. THE 16 GREEN LEDS
set_property PACKAGE_PIN U16 [get_ports {led[0]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {led[8]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
set_property PACKAGE_PIN V3 [get_ports {led[9]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]
set_property PACKAGE_PIN W3 [get_ports {led[10]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
set_property PACKAGE_PIN U3 [get_ports {led[11]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
set_property PACKAGE_PIN P3 [get_ports {led[12]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
set_property PACKAGE_PIN N3 [get_ports {led[13]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]
set_property PACKAGE_PIN P1 [get_ports {led[14]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
set_property PACKAGE_PIN L1 [get_ports {led[15]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]

# 3. THE 4 PHYSICAL ARCADE BUTTONS

# Lane 1 (PMOD JA, Top Row, Pin 1)
set_property PACKAGE_PIN J1 [get_ports {btn_ext[0]}]            
  set_property IOSTANDARD LVCMOS33 [get_ports {btn_ext[0]}]
  set_property PULLDOWN true [get_ports {btn_ext[0]}] 

# Lane 2 (PMOD JA, Bottom Row, Pin 7)
set_property PACKAGE_PIN H1 [get_ports {btn_ext[1]}]            
  set_property IOSTANDARD LVCMOS33 [get_ports {btn_ext[1]}]
  set_property PULLDOWN true [get_ports {btn_ext[1]}] 

# Lane 3 (PMOD JB, Top Row, Pin 1)
set_property PACKAGE_PIN A14 [get_ports {btn_ext[2]}]            
  set_property IOSTANDARD LVCMOS33 [get_ports {btn_ext[2]}]
  set_property PULLDOWN true [get_ports {btn_ext[2]}] 

# Lane 4 (PMOD JB, Bottom Row, Pin 7)
set_property PACKAGE_PIN A15 [get_ports {btn_ext[3]}]            
  set_property IOSTANDARD LVCMOS33 [get_ports {btn_ext[3]}]
  set_property PULLDOWN true [get_ports {btn_ext[3]}] 

# ==========================================
# 4. RASPBERRY PI UART BRIDGE
# ==========================================
# TX Line (Basys TX -> Pi RX) - PMOD JC, Top Row, Pin 2
set_property PACKAGE_PIN M18 [get_ports tx_line]          
  set_property IOSTANDARD LVCMOS33 [get_ports tx_line]


# Plug the TX wire from your Raspberry Pi into PMOD JC, Top Row, Pin 1
set_property PACKAGE_PIN K17 [get_ports rx_line]          
  set_property IOSTANDARD LVCMOS33 [get_ports rx_line]
  

# 5. ONBOARD SYSTEM CONTROLS

# Center Button (Start Game)
set_property PACKAGE_PIN U18 [get_ports btnC]            
  set_property IOSTANDARD LVCMOS33 [get_ports btnC]
# Top Button (Fake Miss / Kill Switch)
set_property PACKAGE_PIN T18 [get_ports btnU]            
  set_property IOSTANDARD LVCMOS33 [get_ports btnU]


# 6. VGA DISPLAY PINS

# Red Color Pins
set_property PACKAGE_PIN G19 [get_ports {vgaRed[0]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[0]}]
set_property PACKAGE_PIN H19 [get_ports {vgaRed[1]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[1]}]
set_property PACKAGE_PIN J19 [get_ports {vgaRed[2]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[2]}]
set_property PACKAGE_PIN N19 [get_ports {vgaRed[3]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[3]}]

# Blue Color Pins
set_property PACKAGE_PIN N18 [get_ports {vgaBlue[0]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[0]}]
set_property PACKAGE_PIN L18 [get_ports {vgaBlue[1]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[1]}]
set_property PACKAGE_PIN K18 [get_ports {vgaBlue[2]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[2]}]
set_property PACKAGE_PIN J18 [get_ports {vgaBlue[3]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[3]}]

# Green Color Pins
set_property PACKAGE_PIN J17 [get_ports {vgaGreen[0]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[0]}]
set_property PACKAGE_PIN H17 [get_ports {vgaGreen[1]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[1]}]
set_property PACKAGE_PIN G17 [get_ports {vgaGreen[2]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[2]}]
set_property PACKAGE_PIN D17 [get_ports {vgaGreen[3]}]        
  set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[3]}]

# VGA Synchronization Pulses
set_property PACKAGE_PIN P19 [get_ports Hsync]            
  set_property IOSTANDARD LVCMOS33 [get_ports Hsync]
set_property PACKAGE_PIN R19 [get_ports Vsync]            
  set_property IOSTANDARD LVCMOS33 [get_ports Vsync]
  

# 7. SEVEN-SEGMENT DISPLAY (Scoreboard)

set_property PACKAGE_PIN W7 [get_ports {seg[0]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


# EXTERNAL ARCADE CONTROLS (Start & Reset)

# External Start Button (PMOD JC, Top Row, Pin 3)
set_property PACKAGE_PIN N17 [get_ports btnC]          
  set_property IOSTANDARD LVCMOS33 [get_ports btnC]
  set_property PULLDOWN true [get_ports btnC]

# External Reset / Kill Switch (PMOD JC, Top Row, Pin 4)
set_property PACKAGE_PIN P18 [get_ports btnU]          
  set_property IOSTANDARD LVCMOS33 [get_ports btnU]
  set_property PULLDOWN true [get_ports btnU]


# EXTERNAL 7-SEGMENT DISPLAY (5461AS)

# Pin 11 (Seg A) -> JXADC Pin 1
set_property PACKAGE_PIN J3 [get_ports {seg[0]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
# Pin 7 (Seg B) -> JXADC Pin 2
set_property PACKAGE_PIN L3 [get_ports {seg[1]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
# Pin 4 (Seg C) -> JXADC Pin 3
set_property PACKAGE_PIN M2 [get_ports {seg[2]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
# Pin 2 (Seg D) -> JXADC Pin 4
set_property PACKAGE_PIN N2 [get_ports {seg[3]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
# Pin 1 (Seg E) -> JXADC Pin 7
set_property PACKAGE_PIN K3 [get_ports {seg[4]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
# Pin 10 (Seg F) -> JXADC Pin 8
set_property PACKAGE_PIN M3 [get_ports {seg[5]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
# Pin 5 (Seg G) -> JXADC Pin 9
set_property PACKAGE_PIN M1 [get_ports {seg[6]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

# Pin 12 (Digit 1 - Far Left) -> PMOD JB Pin 2
set_property PACKAGE_PIN A16 [get_ports {an[3]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
# Pin 9 (Digit 2 - Mid Left) -> PMOD JB Pin 3
set_property PACKAGE_PIN B15 [get_ports {an[2]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
# Pin 8 (Digit 3 - Mid Right) -> PMOD JB Pin 4
set_property PACKAGE_PIN B16 [get_ports {an[1]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
# Pin 6 (Digit 4 - Far Right) -> PMOD JB Pin 8
set_property PACKAGE_PIN A17 [get_ports {an[0]}]          
  set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]