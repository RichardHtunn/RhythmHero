library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_four_lane_manager is
-- Testbench entity is empty
end tb_four_lane_manager;

architecture Behavioral of tb_four_lane_manager is

    -- Component Declaration
    component four_lane_manager
        Port (
            clk          : in  STD_LOGIC;
            reset        : in  STD_LOGIC;
            frame_tick   : in  STD_LOGIC;
            spawn_lanes  : in  STD_LOGIC_VECTOR(3 downto 0); 
            clear_lanes  : in  STD_LOGIC_VECTOR(3 downto 0); 
            v_0, v_1, v_2, v_3 : out STD_LOGIC_VECTOR(3 downto 0);
            y_0, y_1, y_2, y_3 : out STD_LOGIC_VECTOR(39 downto 0)
        );
    end component;

    -- Signals
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal frame_tick   : std_logic := '0';
    signal spawn_lanes  : std_logic_vector(3 downto 0) := "0000";
    signal clear_lanes  : std_logic_vector(3 downto 0) := "0000";
    
    signal v_0, v_1, v_2, v_3 : std_logic_vector(3 downto 0);
    signal y_0, y_1, y_2, y_3 : std_logic_vector(39 downto 0);

    -- 100 MHz Clock
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: four_lane_manager port map (
        clk          => clk,
        reset        => reset,
        frame_tick   => frame_tick,
        spawn_lanes  => spawn_lanes,
        clear_lanes  => clear_lanes,
        v_0 => v_0, v_1 => v_1, v_2 => v_2, v_3 => v_3,
        y_0 => y_0, y_1 => y_1, y_2 => y_2, y_3 => y_3
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
        wait for 50 ns;
        reset <= '0';
        wait for 50 ns;

        -- 2. Spawn a note in Lane 0 and Lane 2 simultaneously
        spawn_lanes <= "0101"; 
        wait for clk_period;
        spawn_lanes <= "0000";
        wait for 100 ns;

        -- 3. Simulate 3 rapid VGA frames to make the notes "fall"
        for i in 1 to 3 loop
            frame_tick <= '1';
            wait for clk_period;
            frame_tick <= '0';
            wait for 100 ns;
        end loop;

        -- 4. Spawn a SECOND note in Lane 0 (testing multiple notes in one lane)
        spawn_lanes <= "0001";
        wait for clk_period;
        spawn_lanes <= "0000";
        wait for 100 ns;

        -- 5. Simulate 2 more VGA frames so both notes in Lane 0 move down
        for i in 1 to 2 loop
            frame_tick <= '1';
            wait for clk_period;
            frame_tick <= '0';
            wait for 100 ns;
        end loop;

        -- 6. Player successfully hits the lowest note in Lane 0! Clear it!
        clear_lanes <= "0001";
        wait for clk_period;
        clear_lanes <= "0000";
        wait for 100 ns;

        wait;
    end process;

end Behavioral;