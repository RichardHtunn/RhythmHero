-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2026 04:09:30 AM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 


entity uart_rx is
  Port ( 
      clk        : in STD_LOGIC; 
      reset      : in STD_LOGIC;  
      rx_line    : in STD_LOGIC;  
      data_out   : out STD_LOGIC_VECTOR(7 downto 0); 
      new_byte   : out STD_LOGIC  
   );
end uart_rx;

architecture Behavioral of uart_rx is
     constant BIT_PERIOD : integer := 10417;
     
     type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT); 
     signal state      : state_type := IDLE;
     signal clk_count  : integer range 0 to BIT_PERIOD := 0; 
     signal bit_index  : integer range 0 to 7 := 0; 
     signal rx_reg     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); 
     
begin

    process(clk, reset) 
    begin 
        if reset = '1' then 
            state <= IDLE;
            new_byte <= '0'; 
            data_out <= (others => '0'); 
        elsif rising_edge(clk) then 
            case state is 
            
                when IDLE => 
                    new_byte <= '0'; 
                    clk_count <= 0; 
                    bit_index <= 0; 
                    if rx_line = '0' then 
                        state <= START_BIT; 
                    end if;
                
                when START_BIT => 
                    if clk_count = (BIT_PERIOD / 2) then 
                        if rx_line = '0' then    
                            clk_count <= 0; 
                            state <= DATA_BITS; 
                        else 
                            state <= IDLE; 
                        end if; 
                    else  
                       clk_count <= clk_count + 1; 
                    end if; 

                when DATA_BITS =>
                    if clk_count < BIT_PERIOD - 1 then
                        clk_count <= clk_count + 1;
                    else
                        clk_count <= 0;
                        rx_reg(bit_index) <= rx_line; 
                        if bit_index < 7 then
                            bit_index <= bit_index + 1;
                        else
                            state <= STOP_BIT;
                        end if;
                    end if;
                  
                when STOP_BIT => 
                    if clk_count < BIT_PERIOD - 1 then 
                        clk_count <= clk_count + 1; 
                    else  
                        data_out <= rx_reg; 
                        new_byte <= '1';
                        state <= IDLE; 
                    end if;
                    
                when others => 
                    state <= IDLE; 
                  
          end case; 
      end if; 
end process; 

end Behavioral;
