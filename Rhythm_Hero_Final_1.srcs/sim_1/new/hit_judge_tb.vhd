library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_hit_judge is
-- Testbench entity is empty
end tb_hit_judge;

architecture Behavioral of tb_hit_judge is

    -- Component Declaration
    component hit_judge
        Port (
            clk             : in  STD_LOGIC;
            reset           : in  STD_LOGIC;
            valid_bus       : in  STD_LOGIC_VECTOR(3 downto 0);
            y_bus           : in  STD_LOGIC_VECTOR(39 downto 0);
            btn_pressed     : in  STD_LOGIC;
            score_perfect   : out STD_LOGIC;
            score_good      : out STD_LOGIC;
            fatal_miss      : out STD_LOGIC;
            clear_lowest    : out STD_LOGIC
        );
    end component;

    -- Signals
    signal clk             : std_logic := '0';
    signal reset           : std_logic := '0';
    signal valid_bus       : std_logic_vector(3 downto 0) := (others => '0');
    signal y_bus           : std_logic_vector(39 downto 0) := (others => '0');
    signal btn_pressed     : std_logic := '0';
    
    signal score_perfect   : std_logic;
    signal score_good      : std_logic;
    signal fatal_miss      : std_logic;
    signal clear_lowest    : std_logic;

    -- 100 MHz Clock
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: hit_judge port map (
        clk           => clk,
        reset         => reset,
        valid_bus     => valid_bus,
        y_bus         => y_bus,
        btn_pressed   => btn_pressed,
        score_perfect => score_perfect,
        score_good    => score_good,
        fatal_miss    => fatal_miss,
        clear_lowest  => clear_lowest
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

        -- Test 1: Button mashed with NO notes in the lane
        btn_pressed <= '1';
        wait for clk_period;
        btn_pressed <= '0';
        wait for 30 ns;

        -- Test 2: Button pressed TOO EARLY (Y = 350, before the 370 Good Zone)
        valid_bus(0) <= '1';
        y_bus(9 downto 0) <= std_logic_vector(to_unsigned(350, 10));
        wait for 10 ns;
        btn_pressed <= '1';
        wait for clk_period;
        btn_pressed <= '0';
        valid_bus(0) <= '0'; -- clear lane
        wait for 30 ns;

        -- Test 3: Button pressed in EARLY GOOD ZONE (Y = 380)
        valid_bus(1) <= '1'; -- testing slot 1 just to be thorough
        y_bus(19 downto 10) <= std_logic_vector(to_unsigned(380, 10));
        wait for 10 ns;
        btn_pressed <= '1';
        wait for clk_period;
        btn_pressed <= '0';
        valid_bus(1) <= '0';
        wait for 30 ns;

        -- Test 4: Button pressed in PERFECT ZONE (Y = 400)
        valid_bus(0) <= '1'; 
        y_bus(9 downto 0) <= std_logic_vector(to_unsigned(400, 10));
        wait for 10 ns;
        btn_pressed <= '1';
        wait for clk_period;
        btn_pressed <= '0';
        valid_bus(0) <= '0';
        wait for 30 ns;

        -- Test 5: NOTE DROPS OFF SCREEN (Y = 435, past the 430 Late Good Zone)
        -- No button press required!
        valid_bus(2) <= '1';
        y_bus(29 downto 20) <= std_logic_vector(to_unsigned(435, 10));
        wait for 40 ns;

        wait;
    end process;

end Behavioral;