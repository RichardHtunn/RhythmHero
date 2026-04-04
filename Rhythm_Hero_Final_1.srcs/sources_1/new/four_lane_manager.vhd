library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity four_lane_manager is
    Port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;
        frame_tick   : in  STD_LOGIC;
        spawn_lanes  : in  STD_LOGIC_VECTOR(3 downto 0); 
        clear_lanes  : in  STD_LOGIC_VECTOR(3 downto 0); 
        
        v_0, v_1, v_2, v_3 : out STD_LOGIC_VECTOR(3 downto 0);
        y_0, y_1, y_2, y_3 : out STD_LOGIC_VECTOR(39 downto 0)
    );
end four_lane_manager;

architecture Structural of four_lane_manager is
begin
    L0: entity work.lane_shift_register port map(clk=>clk, reset=>reset, frame_tick=>frame_tick, spawn_note=>spawn_lanes(0), clear_lowest=>clear_lanes(0), valid_bus=>v_0, y_bus=>y_0);
    L1: entity work.lane_shift_register port map(clk=>clk, reset=>reset, frame_tick=>frame_tick, spawn_note=>spawn_lanes(1), clear_lowest=>clear_lanes(1), valid_bus=>v_1, y_bus=>y_1);
    L2: entity work.lane_shift_register port map(clk=>clk, reset=>reset, frame_tick=>frame_tick, spawn_note=>spawn_lanes(2), clear_lowest=>clear_lanes(2), valid_bus=>v_2, y_bus=>y_2);
    L3: entity work.lane_shift_register port map(clk=>clk, reset=>reset, frame_tick=>frame_tick, spawn_note=>spawn_lanes(3), clear_lowest=>clear_lanes(3), valid_bus=>v_3, y_bus=>y_3);
end Structural;