library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_top is
-- Testbench entities are always empty
end tb_top;

architecture Behavioral of tb_top is

    -- Inputs
    signal clk     : std_logic := '0';
    signal btn_ext : std_logic_vector(3 downto 0) := (others => '0');
    signal btnC    : std_logic := '0';
    signal btnU    : std_logic := '0';
    signal rx_line : std_logic := '1'; -- UART idles HIGH

    -- Outputs
    signal tx_line  : std_logic;
    signal led      : std_logic_vector(15 downto 0);
    signal seg      : std_logic_vector(6 downto 0);
    signal an       : std_logic_vector(3 downto 0);
    signal vgaRed   : std_logic_vector(3 downto 0);
    signal vgaBlue  : std_logic_vector(3 downto 0);
    signal vgaGreen : std_logic_vector(3 downto 0);
    signal Hsync    : std_logic;
    signal Vsync    : std_logic;

    -- Clock period definition (100 MHz for Basys 3)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: entity work.top
        port map (
            clk      => clk,
            btn_ext  => btn_ext,
            btnC     => btnC,
            btnU     => btnU,
            rx_line  => rx_line,
            tx_line  => tx_line,
            led      => led,
            seg      => seg,
            an       => an,
            vgaRed   => vgaRed,
            vgaBlue  => vgaBlue,
            vgaGreen => vgaGreen,
            Hsync    => Hsync,
            Vsync    => Vsync
        );

    -- Clock process definition
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
        -- Hold initial state for 100 ns
        wait for 100 ns;
        
        -- 1. Press Start Button (btnC) to wake up the FSM
        -- We wait 50ms to ensure the signal gets through your debouncer
        btnC <= '1';
        wait for 50 ms; 
        btnC <= '0';
        wait for 50 ms;
        
        -- 2. Simulate hitting the Lane 0 Arcade Button
        btn_ext(0) <= '1';
        wait for 50 ms;
        btn_ext(0) <= '0';
        wait for 100 ms;
        
        -- 3. Press Graceful Exit / Reset Button (btnU) to trigger the 'S' UART send
        btnU <= '1';
        wait for 50 ms;
        btnU <= '0';
        wait for 50 ms;

        -- End the simulation
        wait;
    end process;

end Behavioral;