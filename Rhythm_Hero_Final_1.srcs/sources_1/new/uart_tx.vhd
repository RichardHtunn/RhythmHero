library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity uart_tx is
  Port (
      clk          : in  STD_LOGIC;  
      reset        : in  STD_LOGIC; 
      send_trigger : in  STD_LOGIC;
      data_in      : in  STD_LOGIC_VECTOR(7 downto 0);
      tx_line      : out STD_LOGIC;     
      busy         : out STD_LOGIC                 
   );
end uart_tx;

architecture Behavioral of uart_tx is 
    constant BIT_PERIOD : integer := 10417;
    
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state       : state_type := IDLE;
    signal clk_count   : integer range 0 to BIT_PERIOD := 0;
    signal bit_index   : integer range 0 to 7 := 0;
    
    signal tx_reg      : STD_LOGIC := '1'; 

begin

    tx_line <= tx_reg;

    process(clk, reset) 
    begin 
        if reset = '1' then 
            state <= IDLE;
            tx_reg <= '1';
            busy <= '0';
            
        elsif rising_edge(clk) then 
            case state is 
            
                when IDLE => 
                    busy <= '0';
                    tx_reg <= '1'; 
                    if send_trigger = '1' then 
                        state <= START_BIT;
                        busy <= '1'; 
                        clk_count <= 0; 
                    end if; 
                    
                when START_BIT => 
                    tx_reg <= '0';
                    if clk_count < BIT_PERIOD - 1 then 
                        clk_count <= clk_count + 1;
                    else 
                        clk_count <= 0;
                        bit_index <= 0; 
                        state <= DATA_BITS; 
                    end if; 
                
                when DATA_BITS => 
                    tx_reg <= data_in(bit_index); 
                    
                    if clk_count < BIT_PERIOD - 1 then 
                        clk_count <= clk_count + 1;
                    else 
                        clk_count <= 0;
                        if bit_index < 7 then 
                            bit_index <= bit_index + 1;
                        else  
                            state <= STOP_BIT;
                        end if; 
                    end if; 
                 
                when STOP_BIT => 
                    tx_reg <= '1'; 
                    if clk_count < BIT_PERIOD - 1 then 
                        clk_count <= clk_count + 1;
                    else   
                        state <= IDLE;
                    end if; 
                  
                when others => 
                    state <= IDLE;
            end case; 
       end if; 
   end process; 
          
end Behavioral;