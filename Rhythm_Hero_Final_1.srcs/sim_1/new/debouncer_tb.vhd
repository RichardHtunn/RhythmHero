library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_debouncer is
-- Empty entity for testbench
end tb_debouncer;

architecture Behavioral of tb_debouncer is

    -- Component Declaration
    component debouncer
        Port ( 
            clk     : in  STD_LOGIC;
            btn_in  : in  STD_LOGIC;
            btn_out : out STD_LOGIC
        );
    end component;

    -- Signals
    signal clk     : std_logic := '0';
    signal btn_in  : std_logic := '0';
    signal btn_out : std_logic;

    -- 100 MHz Clock (Basys 3)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: debouncer port map (
        clk     => clk,
        btn_in  => btn_in,
        btn_out => btn_out
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
        -- Initial wait
        wait for 100 us;

        -- 1. Simulate Button BOUNCE (Physical mechanical noise)
        -- We will rapidly toggle it in sub-millisecond bursts
        btn_in <= '1'; wait for 500 us;
        btn_in <= '0'; wait for 200 us;
        btn_in <= '1'; wait for 300 us;
        btn_in <= '0'; wait for 400 us;

        -- 2. Simulate STABLE Press
        -- The 20-bit counter requires ~5.24 ms of stable high to register
        btn_in <= '1';
        wait for 10 ms; -- Hold it long enough to pass the filter!

        -- 3. Simulate Button BOUNCE on Release
        btn_in <= '0'; wait for 300 us;
        btn_in <= '1'; wait for 200 us;
        btn_in <= '0'; wait for 500 us;

        -- 4. Simulate STABLE Release
        btn_in <= '0';
        wait for 10 ms; -- Hold long enough to clear the filter

        wait;
    end process;

end Behavioral;