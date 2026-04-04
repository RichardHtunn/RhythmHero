library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clock_divider is
-- Testbench entity is empty
end tb_clock_divider;

architecture Behavioral of tb_clock_divider is

    -- Component Declaration
    component clock_divider
        Port ( 
            clk_100mhz    : in STD_LOGIC;
            rst           : in STD_LOGIC;
            clk_25_175mhz : out STD_LOGIC; 
            clk_1khz      : out STD_LOGIC
        );
    end component;

    -- Signals
    signal clk_100mhz    : std_logic := '0';
    signal rst           : std_logic := '0';
    signal clk_25_175mhz : std_logic;
    signal clk_1khz      : std_logic;

    -- 100 MHz Clock (10 ns period)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: clock_divider port map (
        clk_100mhz    => clk_100mhz,
        rst           => rst,
        clk_25_175mhz => clk_25_175mhz,
        clk_1khz      => clk_1khz
    );

    -- Clock process
    clk_process : process
    begin
        clk_100mhz <= '0';
        wait for clk_period/2;
        clk_100mhz <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- 1. Initialize and Reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        
        -- 2. Run long enough to see the 1kHz clock toggle
        -- Since the toggle happens every 50,000 cycles (0.5 ms),
        -- we need at least 1ms to see a full high/low cycle.
        wait for 2 ms;

        wait;
    end process;

end Behavioral;