library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_seven_segment_display is
-- Testbench entity is empty
end tb_seven_segment_display;

architecture Behavioral of tb_seven_segment_display is

    -- Component Declaration
    component seven_segment_display
        Port (
            clk     : in  STD_LOGIC; 
            reset   : in  STD_LOGIC;
            score   : in  unsigned(15 downto 0);
            seg     : out STD_LOGIC_VECTOR(6 downto 0); 
            an      : out STD_LOGIC_VECTOR(3 downto 0) 
        );
    end component;

    -- Signals
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal score   : unsigned(15 downto 0) := (others => '0');
    signal seg     : std_logic_vector(6 downto 0);
    signal an      : std_logic_vector(3 downto 0);

    -- 100 MHz Clock (10 ns period)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: seven_segment_display port map (
        clk   => clk,
        reset => reset,
        score => score,
        seg   => seg,
        an    => an
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
        -- 1. Initialize and Reset
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        
        -- 2. Set a test score: 1234
        -- This will allow us to see '1', '2', '3', and '4' on the segments
        score <= to_unsigned(1234, 16);
        
        -- Run long enough to see the anode refresh cycle (approx 10.5 ms)
        wait for 12 ms;

        -- 3. Update the score mid-simulation: 5678
        score <= to_unsigned(5678, 16);
        wait for 12 ms;

        wait;
    end process;

end Behavioral;