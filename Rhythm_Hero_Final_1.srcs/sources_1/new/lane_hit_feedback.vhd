library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_hit_feedback is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        
        perfect_in  : in  STD_LOGIC;
        good_in     : in  STD_LOGIC;
        
        led_perfect : out STD_LOGIC;
        led_good    : out STD_LOGIC  
    );
end led_hit_feedback;

architecture Behavioral of led_hit_feedback is
    constant FLASH_TIME : integer := 5000000; 
    
    signal perf_counter : integer range 0 to FLASH_TIME := 0;
    signal good_counter : integer range 0 to FLASH_TIME := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            perf_counter <= 0;
            good_counter <= 0;
            led_perfect <= '0';
            led_good <= '0';
            
        elsif rising_edge(clk) then
            if perfect_in = '1' then
                perf_counter <= FLASH_TIME;
                led_perfect <= '1';
            elsif perf_counter > 0 then
                perf_counter <= perf_counter - 1;
                led_perfect <= '1';
            else
                led_perfect <= '0';
            end if;

            if good_in = '1' then
                good_counter <= FLASH_TIME;
                led_good <= '1';
            elsif good_counter > 0 then
                good_counter <= good_counter - 1;
                led_good <= '1';
            else
                led_good <= '0';
            end if;
        end if;
    end process;
end Behavioral;