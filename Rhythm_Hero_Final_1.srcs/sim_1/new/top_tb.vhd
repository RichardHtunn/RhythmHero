library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rhythm_hero_top_tb is
end rhythm_hero_top_tb;

architecture behavior of rhythm_hero_top_tb is

    -- 1. Declare your Top-Level Component
    -- MAKE SURE THESE NAMES MATCH YOUR ACTUAL TOP MODULE!
    component rhythm_hero_top
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        
        btn_start   : in  STD_LOGIC;
        btn_0       : in  STD_LOGIC;
        btn_1       : in  STD_LOGIC;
        btn_2       : in  STD_LOGIC;
        btn_3       : in  STD_LOGIC;
        
        hsync       : out STD_LOGIC;
        vsync       : out STD_LOGIC;
        vga_red     : out STD_LOGIC_VECTOR(3 downto 0);
        vga_green   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_blue    : out STD_LOGIC_VECTOR(3 downto 0);
        seg         : out STD_LOGIC_VECTOR(6 downto 0);
        an          : out STD_LOGIC_VECTOR(3 downto 0)
    );
    end component;

    -- 2. Input Signals (Idle at '0')
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal btn_start : std_logic := '0'; 
    signal btn_0     : std_logic := '0';
    signal btn_1     : std_logic := '0';
    signal btn_2     : std_logic := '0';
    signal btn_3     : std_logic := '0';

    -- 3. Output Signals
    signal hsync     : std_logic;
    signal vsync     : std_logic;
    signal vga_red   : std_logic_vector(3 downto 0);
    signal vga_green : std_logic_vector(3 downto 0);
    signal vga_blue  : std_logic_vector(3 downto 0);
    signal seg       : std_logic_vector(6 downto 0);
    signal an        : std_logic_vector(3 downto 0);

    -- 100MHz Basys 3 Clock Period
    constant clk_period : time := 10 ns;

begin

    -- 4. Instantiate the Top Module
    uut: rhythm_hero_top PORT MAP (
        clk       => clk,
        reset     => reset,
        btn_start => btn_start,
        btn_0     => btn_0,
        btn_1     => btn_1,
        btn_2     => btn_2,
        btn_3     => btn_3,
        hsync     => hsync,
        vsync     => vsync,
        vga_red   => vga_red,
        vga_green => vga_green,
        vga_blue  => vga_blue,
        seg       => seg,
        an        => an
    );

    -- 5. Simulate the 100MHz Basys 3 Quartz Oscillator
    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- 6. Simulate the Human Player
    stim_proc: process
    begin
        -- Give the system time to stabilize
        wait for 100 ns;

        -- A. Turn the board on (System Reset)
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- B. Human presses the START button
        -- We MUST hold it for 15ms so the debouncer accepts it!
        btn_start <= '1'; 
        wait for 15 ms;   
        btn_start <= '0'; 
        
        -- Let the game run for a bit so the VGA starts drawing notes
        wait for 20 ms;

        -- C. Human presses the button for Lane 0
        btn_0 <= '1'; 
        wait for 15 ms; 
        btn_0 <= '0';

        -- D. Let the game run for a bit longer to see the reaction
        wait for 20 ms;

        wait; -- Stop simulation
    end process;

end behavior;