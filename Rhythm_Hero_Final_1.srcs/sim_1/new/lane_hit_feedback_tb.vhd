library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_led_hit_feedback is
-- Testbench entity is empty
end tb_led_hit_feedback;

architecture Behavioral of tb_led_hit_feedback is

    -- Component Declaration
    component led_hit_feedback
        Port (
            clk         : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            perfect_in  : in  STD_LOGIC;
            good_in     : in  STD_LOGIC;
            led_perfect : out STD_LOGIC;
            led_good    : out STD_LOGIC  
        );
    end component;

    -- Signals
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal perfect_in  : std_logic := '0';
    signal good_in     : std_logic := '0';
    signal led_perfect : std_logic;
    signal led_good    : std_logic;

    -- 100 MHz Clock (10 ns period)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: led_hit_feedback port map (
        clk         => clk,
        reset       => reset,
        perfect_in  => perfect_in,
        good_in     => good_in,
        led_perfect => led_perfect,
        led_good    => led_good
    );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- 1. Initialize and Reset
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 1 ms;
        
        -- 2. Trigger a PERFECT hit
        -- Pulse it for only 1 clock cycle (10 ns)
        perfect_in <= '1';
        wait for clk_period;
        perfect_in <= '0';
        
        -- Wait for the 50ms flash to finish
        wait for 60 ms;

        -- 3. Trigger a GOOD hit
        good_in <= '1';
        wait for clk_period;
        good_in <= '0';
        
        -- Wait for the 50ms flash to finish
        wait for 60 ms;

        wait;
    end process;

end Behavioral;