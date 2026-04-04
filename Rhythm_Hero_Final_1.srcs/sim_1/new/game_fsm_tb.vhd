library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_game_fsm is
-- Testbench entity is empty
end tb_game_fsm;

architecture Behavioral of tb_game_fsm is

    -- Component Declaration
    component game_fsm
        Port (
            clk           : in  STD_LOGIC;
            reset         : in  STD_LOGIC;
            btn_start     : in  STD_LOGIC;
            fatal_miss_in : in  STD_LOGIC;
            game_state    : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    -- Signals
    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal btn_start     : std_logic := '0';
    signal fatal_miss_in : std_logic := '0';
    signal game_state    : std_logic_vector(1 downto 0);

    -- 100 MHz Clock
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: game_fsm port map (
        clk           => clk,
        reset         => reset,
        btn_start     => btn_start,
        fatal_miss_in => fatal_miss_in,
        game_state    => game_state
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
        -- 1. Initialize System (Starts in IDLE "00")
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- 2. Player presses START 
        -- (Simulating the 1-cycle pulse from your single_pulser)
        btn_start <= '1';
        wait for 10 ns; 
        btn_start <= '0';
        
        -- Game is now in PLAY mode ("01")
        wait for 40 ns;

        -- 3. Player misses a note / presses Graceful Exit
        fatal_miss_in <= '1';
        wait for 10 ns;
        fatal_miss_in <= '0';
        
        -- Game is now in GAME OVER mode ("10")
        wait for 40 ns;
        
        -- 4. Player presses START again to return to the Main Menu
        btn_start <= '1';
        wait for 10 ns;
        btn_start <= '0';
        
        -- Game is back in IDLE mode ("00")
        wait for 40 ns;

        wait;
    end process;

end Behavioral;