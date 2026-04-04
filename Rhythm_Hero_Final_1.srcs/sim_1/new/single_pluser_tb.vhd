library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_single_pulser is
-- Testbench entity is empty
end tb_single_pulser;

architecture Behavioral of tb_single_pulser is

    -- Component Declaration
    component single_pulser
        Port (
            clk       : in  STD_LOGIC;
            btn_in    : in  STD_LOGIC;
            pulse_out : out STD_LOGIC
        );
    end component;

    -- Signals
    signal clk       : std_logic := '0';
    signal btn_in    : std_logic := '0';
    signal pulse_out : std_logic;

    -- 100 MHz Clock (Basys 3)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: single_pulser port map (
        clk       => clk,
        btn_in    => btn_in,
        pulse_out => pulse_out
    );

    -- Clock process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Hold initial state
        wait for 25 ns;
        
        -- 1. Simulate a long button press
        -- Notice how btn_in stays HIGH for 50 ns, but pulse_out will only spike for 10 ns!
        btn_in <= '1';
        wait for 50 ns;
        
        -- Release the button
        btn_in <= '0';
        wait for 30 ns;
        
        -- 2. Simulate another press to prove it resets correctly
        btn_in <= '1';
        wait for 40 ns;
        
        btn_in <= '0';

        wait;
    end process;

end Behavioral;