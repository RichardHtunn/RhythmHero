library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port ( clk_100mhz    : in STD_LOGIC;
           rst           : in STD_LOGIC;
           clk_25_175mhz : out STD_LOGIC; 
           clk_1khz      : out STD_LOGIC
           );
end clock_divider;

architecture Behavioral of clock_divider is

    signal count_25   : integer range 0 to 1 := 0;
    signal clk_25_reg : std_logic := '0';

    constant MAX_COUNT : integer := 49999;
    signal count_1k    : integer range 0 to MAX_COUNT := 0;
    signal clk_1k_reg  : std_logic := '0';

begin
    
    process(clk_100mhz, rst)
    begin
        if rst = '1' then
            count_25   <= 0;
            clk_25_reg <= '0';
            count_1k   <= 0;
            clk_1k_reg <= '0';
            
        elsif rising_edge(clk_100mhz) then
            
            if count_25 = 1 then
                clk_25_reg <= not clk_25_reg;
                count_25 <= 0;
            else
                count_25 <= count_25 + 1;
            end if;

            if count_1k = MAX_COUNT then
                clk_1k_reg <= not clk_1k_reg;
                count_1k <= 0;
            else
                count_1k <= count_1k + 1;
            end if;
            
        end if;
    end process;
    
    clk_25_175mhz <= clk_25_reg;
    clk_1khz      <= clk_1k_reg;

end Behavioral;