library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_score_tracker is
-- Testbench entity is empty
end tb_score_tracker;

architecture Behavioral of tb_score_tracker is

    -- Component Declaration
    component score_tracker
        Port (
            clk          : in  STD_LOGIC;
            reset        : in  STD_LOGIC;
            perfect_hit  : in  STD_LOGIC; 
            good_hit     : in  STD_LOGIC; 
            total_score  : out unsigned(15 downto 0)
        );
    end component;

    -- Signals
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal perfect_hit  : std_logic := '0';
    signal good_hit     : std_logic := '0';
    signal total_score  : unsigned(15 downto 0);

    -- 100 MHz Clock
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: score_tracker port map (
        clk          => clk,
        reset        => reset,
        perfect_hit  => perfect_hit,
        good_hit     => good_hit,
        total_score  => total_score
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
        -- 1. Initialize System
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- 2. Simulate a PERFECT hit (+10 points)
        perfect_hit <= '1';
        wait for clk_period;
        perfect_hit <= '0';
        wait for 30 ns;

        -- 3. Simulate a SECOND PERFECT hit (+10 points)
        perfect_hit <= '1';
        wait for clk_period;
        perfect_hit <= '0';
        wait for 30 ns;

        -- 4. Simulate a GOOD hit (+5 points)
        good_hit <= '1';
        wait for clk_period;
        good_hit <= '0';
        wait for 30 ns;

        -- 5. Simulate a SECOND GOOD hit (+5 points)
        good_hit <= '1';
        wait for clk_period;
        good_hit <= '0';
        wait for 30 ns;

        wait;
    end process;

end Behavioral;