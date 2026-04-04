library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity four_judge_manager is
    Port (
        clk            : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        v_0, v_1, v_2, v_3 : in STD_LOGIC_VECTOR(3 downto 0);
        y_0, y_1, y_2, y_3 : in STD_LOGIC_VECTOR(39 downto 0);
        btn_pulse      : in STD_LOGIC_VECTOR(3 downto 0);
        
        any_perfect    : out STD_LOGIC;
        any_good       : out STD_LOGIC;
        any_fatal_miss : out STD_LOGIC;
        clear_lanes    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end four_judge_manager;

architecture Structural of four_judge_manager is
    signal p, g, f : STD_LOGIC_VECTOR(3 downto 0);
begin
    J0: entity work.hit_judge port map(clk=>clk, reset=>reset, valid_bus=>v_0, y_bus=>y_0, btn_pressed=>btn_pulse(0), score_perfect=>p(0), score_good=>g(0), fatal_miss=>f(0), clear_lowest=>clear_lanes(0));
    J1: entity work.hit_judge port map(clk=>clk, reset=>reset, valid_bus=>v_1, y_bus=>y_1, btn_pressed=>btn_pulse(1), score_perfect=>p(1), score_good=>g(1), fatal_miss=>f(1), clear_lowest=>clear_lanes(1));
    J2: entity work.hit_judge port map(clk=>clk, reset=>reset, valid_bus=>v_2, y_bus=>y_2, btn_pressed=>btn_pulse(2), score_perfect=>p(2), score_good=>g(2), fatal_miss=>f(2), clear_lowest=>clear_lanes(2));
    J3: entity work.hit_judge port map(clk=>clk, reset=>reset, valid_bus=>v_3, y_bus=>y_3, btn_pressed=>btn_pulse(3), score_perfect=>p(3), score_good=>g(3), fatal_miss=>f(3), clear_lowest=>clear_lanes(3));
    
    any_perfect    <= p(0) or p(1) or p(2) or p(3);
    any_good       <= g(0) or g(1) or g(2) or g(3);
    any_fatal_miss <= f(0) or f(1) or f(2) or f(3);
end Structural;