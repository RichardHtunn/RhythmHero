library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity score_tracker is
    Port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;
        
        perfect_hit  : in  STD_LOGIC; 
        good_hit     : in  STD_LOGIC; 
        
        total_score  : out unsigned(15 downto 0)
    );
end score_tracker;

architecture Behavioral of score_tracker is
    signal current_score : unsigned(15 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_score <= (others => '0');
        elsif rising_edge(clk) then
            if perfect_hit = '1' then
                current_score <= current_score + 10;
            elsif good_hit = '1' then
                current_score <= current_score + 5;
            end if;
        end if;
    end process;

    total_score <= current_score;
end Behavioral;