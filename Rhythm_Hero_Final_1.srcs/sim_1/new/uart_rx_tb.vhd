library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_uart_rx is
-- Testbench entity is empty
end tb_uart_rx;

architecture Behavioral of tb_uart_rx is

    -- Component Declaration
    component uart_rx
        Port ( 
            clk        : in STD_LOGIC; 
            reset      : in STD_LOGIC;  
            rx_line    : in STD_LOGIC;  
            data_out   : out STD_LOGIC_VECTOR(7 downto 0); 
            new_byte   : out STD_LOGIC  
        );
    end component;

    -- Signals
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal rx_line    : std_logic := '1'; -- UART idles HIGH
    signal data_out   : std_logic_vector(7 downto 0);
    signal new_byte   : std_logic;

    -- Clock period (100 MHz)
    constant clk_period : time := 10 ns;
    
    -- Baud rate period (9600 baud = 104.17 us per bit)
    constant bit_time : time := 104170 ns;

    -- Procedure to simulate an external device (like a Raspberry Pi) sending a UART byte
    procedure send_uart_byte (
        constant data      : in  std_logic_vector(7 downto 0);
        signal   tx_serial : out std_logic
    ) is
    begin
        -- 1. Send START bit (Drive line LOW)
        tx_serial <= '0';
        wait for bit_time;

        -- 2. Send 8 DATA bits (LSB First)
        for i in 0 to 7 loop
            tx_serial <= data(i);
            wait for bit_time;
        end loop;

        -- 3. Send STOP bit (Drive line HIGH)
        tx_serial <= '1';
        wait for bit_time;
        
        -- Add a tiny bit of idle time between bytes
        wait for bit_time;
    end procedure;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: uart_rx port map (
        clk        => clk,
        reset      => reset,
        rx_line    => rx_line,
        data_out   => data_out,
        new_byte   => new_byte
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

        -- 1. Send first test byte: x"A5" (Binary: 10100101)
        -- This is a great test byte because the bits alternate!
        send_uart_byte(x"A5", rx_line);
        
        wait for 500 us;

        -- 2. Send second test byte: x"3C" (Binary: 00111100)
        send_uart_byte(x"3C", rx_line);

        -- End simulation
        wait;
    end process;

end Behavioral;