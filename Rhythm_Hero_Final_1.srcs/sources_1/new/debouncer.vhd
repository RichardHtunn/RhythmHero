library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    Port ( 
        clk     : in  STD_LOGIC;
        btn_in  : in  STD_LOGIC;
        btn_out : out STD_LOGIC
    );
end debouncer;

architecture Behavioral of debouncer is
    signal flipflops   : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal counter_set : STD_LOGIC;
    signal counter_out : unsigned(19 downto 0) := (others => '0');
begin
    
    counter_set <= flipflops(0) xor flipflops(1);
    
    process(clk)
    begin
        if rising_edge(clk) then
            flipflops(0) <= btn_in;
            flipflops(1) <= flipflops(0);
            
            if (counter_set = '1') then
                counter_out <= (others => '0');
            elsif (counter_out(19) = '0') then
                counter_out <= counter_out + 1;
            else
                btn_out <= flipflops(1);
            end if;
        end if;
    end process;
end Behavioral;