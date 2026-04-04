library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_four_judge_manager is
-- Testbench entity is empty
end tb_four_judge_manager;

architecture Behavioral of tb_four_judge_manager is

    -- Component Declaration
    component four_judge_manager
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
    end component;

    -- Signals
    signal clk            : std_logic := '0';
    signal reset          : std_logic := '0';
    signal v_0, v_1, v_2, v_3 : std_logic_vector(3 downto 0) := (others => '0');
    signal y_0, y_1, y_2, y_3 : std_logic_vector(39 downto 0) := (others => '0');
    signal btn_pulse      : std_logic_vector(3 downto 0) := (others => '0');
    
    signal any_perfect    : std_logic;
    signal any_good       : std_logic;
    signal any_fatal_miss : std_logic;
    signal clear_lanes    : std_logic_vector(3 downto 0);

    -- 100 MHz Clock
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: four_judge_manager port map (
        clk            => clk,
        reset          => reset,
        v_0 => v_0, v_1 => v_1, v_2 => v_2, v_3 => v_3,
        y_0 => y_0, y_1 => y_1, y_2 => y_2, y_3 => y_3,
        btn_pulse      => btn_pulse,
        any_perfect    => any_perfect,
        any_good       => any_good,
        any_fatal_miss => any_fatal_miss,
        clear_lanes    => clear_lanes
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

        -- 2. Test a PERFECT hit in Lane 0
        -- Y = 400 is dead center of the Perfect zone (390-410)
        v_0(0) <= '1'; 
        y_0(9 downto 0) <= std_logic_vector(to_unsigned(400, 10));
        wait for 10 ns;
        
        btn_pulse(0) <= '1'; -- Press Lane 0 button
        wait for clk_period;
        btn_pulse(0) <= '0';
        
        -- Clear Lane 0 data for the next test
        v_0(0) <= '0';
        wait for 30 ns;

        -- 3. Test a GOOD hit in Lane 1
        -- Y = 380 is inside the early Good zone (370-389)
        v_1(0) <= '1';
        y_1(9 downto 0) <= std_logic_vector(to_unsigned(380, 10));
        wait for 10 ns;
        
        btn_pulse(1) <= '1'; -- Press Lane 1 button
        wait for clk_period;
        btn_pulse(1) <= '0';
        
        -- Clear Lane 1 data
        v_1(0) <= '0';
        wait for 30 ns;

        -- 4. Test a FATAL MISS in Lane 2
        -- Y = 450 has fallen completely past the hit zones
        v_2(0) <= '1';
        y_2(9 downto 0) <= std_logic_vector(to_unsigned(450, 10));
        wait for clk_period; 
        
        -- No button press needed! The hardware should flag a miss automatically
        -- because the Y coordinate is too high.
        wait for 30 ns;

        wait;
    end process;

end Behavioral;