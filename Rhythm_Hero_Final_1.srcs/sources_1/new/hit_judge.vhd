library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hit_judge is
    Port (
        clk             : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        valid_bus       : in  STD_LOGIC_VECTOR(3 downto 0);
        y_bus           : in  STD_LOGIC_VECTOR(39 downto 0);
        btn_pressed     : in  STD_LOGIC;
        
        score_perfect   : out STD_LOGIC;
        score_good      : out STD_LOGIC;
        fatal_miss      : out STD_LOGIC;
        clear_lowest    : out STD_LOGIC
    );
end hit_judge;

architecture Behavioral of hit_judge is
    constant Y_GOOD_EARLY  : unsigned(9 downto 0) := to_unsigned(370, 10);
    constant Y_PERFECT_MIN : unsigned(9 downto 0) := to_unsigned(390, 10);
    constant Y_PERFECT_MAX : unsigned(9 downto 0) := to_unsigned(410, 10);
    constant Y_GOOD_LATE   : unsigned(9 downto 0) := to_unsigned(430, 10);
begin
    process(clk, reset)
        variable max_y : unsigned(9 downto 0);
        variable idx   : integer;
        variable y0, y1, y2, y3 : unsigned(9 downto 0);
    begin
        if reset = '1' then
            score_perfect <= '0'; score_good <= '0'; fatal_miss <= '0'; clear_lowest <= '0';
        elsif rising_edge(clk) then
            score_perfect <= '0'; score_good <= '0'; fatal_miss <= '0'; clear_lowest <= '0';
            
            y0 := unsigned(y_bus(9 downto 0));
            y1 := unsigned(y_bus(19 downto 10));
            y2 := unsigned(y_bus(29 downto 20));
            y3 := unsigned(y_bus(39 downto 30));

            if (valid_bus(0)='1' and y0 > Y_GOOD_LATE) or 
               (valid_bus(1)='1' and y1 > Y_GOOD_LATE) or 
               (valid_bus(2)='1' and y2 > Y_GOOD_LATE) or 
               (valid_bus(3)='1' and y3 > Y_GOOD_LATE) then
                fatal_miss <= '1';
                clear_lowest <= '1'; 
            end if;

            if btn_pressed = '1' then
                max_y := (others => '0'); idx := -1;
                if valid_bus(0)='1' and y0 >= max_y then max_y := y0; idx := 0; end if;
                if valid_bus(1)='1' and y1 >= max_y then max_y := y1; idx := 1; end if;
                if valid_bus(2)='1' and y2 >= max_y then max_y := y2; idx := 2; end if;
                if valid_bus(3)='1' and y3 >= max_y then max_y := y3; idx := 3; end if;

                if idx = -1 then
                    fatal_miss <= '1';
                else
                    if max_y < Y_GOOD_EARLY then
                        fatal_miss <= '1'; clear_lowest <= '1';
                    elsif max_y >= Y_GOOD_EARLY and max_y < Y_PERFECT_MIN then
                        score_good <= '1'; clear_lowest <= '1';
                    elsif max_y >= Y_PERFECT_MIN and max_y <= Y_PERFECT_MAX then
                        score_perfect <= '1'; clear_lowest <= '1';
                    elsif max_y > Y_PERFECT_MAX and max_y <= Y_GOOD_LATE then
                        score_good <= '1'; clear_lowest <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;