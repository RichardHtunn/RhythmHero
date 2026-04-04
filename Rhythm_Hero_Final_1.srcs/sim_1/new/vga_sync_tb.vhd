library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_vga_sync is
-- Testbench entity is empty
end tb_vga_sync;

architecture Behavioral of tb_vga_sync is

    -- Component Declaration
    component vga_sync
        Port (
            clk_25mhz : in  STD_LOGIC; 
            rst       : in  STD_LOGIC;
            hsync     : out STD_LOGIC;
            vsync     : out STD_LOGIC;
            video_on  : out STD_LOGIC; 
            pixel_x   : out STD_LOGIC_VECTOR (9 downto 0);
            pixel_y   : out STD_LOGIC_VECTOR (9 downto 0)
        );
    end component;

    -- Signals
    signal clk_25mhz : std_logic := '0';
    signal rst       : std_logic := '0';
    signal hsync     : std_logic;
    signal vsync     : std_logic;
    signal video_on  : std_logic;
    signal pixel_x   : std_logic_vector(9 downto 0);
    signal pixel_y   : std_logic_vector(9 downto 0);

    -- 25 MHz Clock Period (40 ns)
    constant clk_period : time := 40 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: vga_sync port map (
        clk_25mhz => clk_25mhz,
        rst       => rst,
        hsync     => hsync,
        vsync     => vsync,
        video_on  => video_on,
        pixel_x   => pixel_x,
        pixel_y   => pixel_y
    );

    -- Clock process
    clk_process: process
    begin
        clk_25mhz <= '0';
        wait for clk_period/2;
        clk_25mhz <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize System
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        
        -- Run for long enough to see at least one full vsync cycle
        wait for 20 ms;

        wait;
    end process;

end Behavioral;