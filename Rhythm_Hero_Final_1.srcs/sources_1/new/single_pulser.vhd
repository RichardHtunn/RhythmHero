library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity single_pulser is
    Port (
        clk       : in  STD_LOGIC;
        btn_in    : in  STD_LOGIC;  
        pulse_out : out STD_LOGIC   
    );
end single_pulser;

architecture Behavioral of single_pulser is
    
    signal btn_prev : STD_LOGIC := '0';

begin
    process(clk)
    begin
        if rising_edge(clk) then
            btn_prev <= btn_in;
        end if;
    end process;

    pulse_out <= btn_in and (not btn_prev);

end Behavioral;