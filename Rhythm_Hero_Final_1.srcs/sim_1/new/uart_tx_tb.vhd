library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_uart_tx is
-- Testbench entity is empty
end tb_uart_tx;

architecture Behavioral of tb_uart_tx is

    -- Component Declaration
    component uart_tx
        Port (
            clk          : in  STD_LOGIC;  
            reset        : in  STD_LOGIC; 
            send_trigger : in  STD_LOGIC;
            data_in      : in  STD_LOGIC_VECTOR(7 downto 0);
            tx_line      : out STD_LOGIC;     
            busy         : out STD_LOGIC                 
        );
    end component;

    -- Signals
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal send_trigger : std_logic := '0';
    signal data_in      : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_line      : std_logic;
    signal busy         : std_logic;

    -- 100 MHz Clock (Basys 3)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: uart_tx port map (
        clk          => clk,
        reset        => reset,
        send_trigger => send_trigger,
        data_in      => data_in,
        tx_line      => tx_line,
        busy         => busy
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
        -- Hold reset state initially
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 us;

        -- 1. Send the 'Fatal Miss' character: 'X' (Hex: 58, Binary: 01011000)
        data_in <= x"58";
        send_trigger <= '1';
        wait for clk_period; -- Pulse the trigger for exactly 1 clock cycle
        send_trigger <= '0';
        
        -- Wait for the transmission to completely finish (approx 1.05 ms)
        wait for 1.5 ms;

        -- 2. Send the 'Graceful Stop' character: 'S' (Hex: 53, Binary: 01010011)
        data_in <= x"53";
        send_trigger <= '1';
        wait for clk_period;
        send_trigger <= '0';

        wait;
    end process;

end Behavioral;