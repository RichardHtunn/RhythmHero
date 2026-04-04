library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_lane_shift_register is
-- Testbench entity is empty
end tb_lane_shift_register;

architecture Behavioral of tb_lane_shift_register is

    -- Component Declaration
    component lane_shift_register
        Port (
            clk          : in  STD_LOGIC;
            reset        : in  STD_LOGIC;
            frame_tick   : in  STD_LOGIC; 
            spawn_note   : in  STD_LOGIC; 
            clear_lowest : in  STD_LOGIC; 
            valid_bus    : out STD_LOGIC_VECTOR(3 downto 0);
            y_bus        : out STD_LOGIC_VECTOR(39 downto 0) 
        );
    end component;

    -- Signals
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal frame_tick   : std_logic := '0';
    signal spawn_note   : std_logic := '0';
    signal clear_lowest : std_logic := '0';
    signal valid_bus    : std_logic_vector(3 downto 0);
    signal y_bus        : std_logic_vector(39 downto 0);

    -- 100 MHz Clock
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: lane_shift_register port map (
        clk          => clk,
        reset        => reset,
        frame_tick   => frame_tick,
        spawn_note   => spawn_note,
        clear_lowest => clear_lowest,
        valid_bus    => valid_bus,
        y_bus        => y_bus
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
        wait for 30 ns;
        reset <= '0';
        wait for 30 ns;

        -- 2. Spawn the FIRST note
        spawn_note <= '1';
        wait for clk_period;
        spawn_note <= '0';
        wait for 50 ns;

        -- 3. Simulate 5 VGA frames to let the first note fall down the screen
        for i in 1 to 5 loop
            frame_tick <= '1';
            wait for clk_period;
            frame_tick <= '0';
            wait for 40 ns;
        end loop;

        -- 4. Spawn a SECOND note in the same lane
        spawn_note <= '1';
        wait for clk_period;
        spawn_note <= '0';
        wait for 50 ns;

        -- 5. Simulate 3 more VGA frames so BOTH notes fall simultaneously
        for i in 1 to 3 loop
            frame_tick <= '1';
            wait for clk_period;
            frame_tick <= '0';
            wait for 40 ns;
        end loop;

        -- 6. Player hits the button! Clear the lowest note (the first one)
        clear_lowest <= '1';
        wait for clk_period;
        clear_lowest <= '0';
        wait for 100 ns;

        wait;
    end process;

end Behavioral;