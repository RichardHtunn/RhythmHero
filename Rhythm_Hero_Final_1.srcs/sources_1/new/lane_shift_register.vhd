library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lane_shift_register is
    Port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;
        frame_tick   : in  STD_LOGIC; 
        spawn_note   : in  STD_LOGIC; 
        clear_lowest : in  STD_LOGIC; 
        
        valid_bus    : out STD_LOGIC_VECTOR(3 downto 0);
        y_bus        : out STD_LOGIC_VECTOR(39 downto 0) 
    );
end lane_shift_register;

architecture Behavioral of lane_shift_register is
    constant FALL_SPEED : integer := 3; 
    type y_array is array (0 to 3) of unsigned(9 downto 0);
    signal active_arr : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal y_arr      : y_array := (others => (others => '0'));
    signal spawn_prev : STD_LOGIC := '0';
begin
    process(clk, reset)
        variable lowest_idx : integer := -1;
        variable max_y      : unsigned(9 downto 0) := (others => '0');
    begin
        if reset = '1' then
            active_arr <= "0000";
            y_arr <= (others => (others => '0'));
            spawn_prev <= '0';
        elsif rising_edge(clk) then
            spawn_prev <= spawn_note;

            if spawn_note = '1' and spawn_prev = '0' then
                if active_arr(0) = '0' then active_arr(0) <= '1'; y_arr(0) <= (others => '0');
                elsif active_arr(1) = '0' then active_arr(1) <= '1'; y_arr(1) <= (others => '0');
                elsif active_arr(2) = '0' then active_arr(2) <= '1'; y_arr(2) <= (others => '0');
                elsif active_arr(3) = '0' then active_arr(3) <= '1'; y_arr(3) <= (others => '0');
                end if;
            end if;

            if clear_lowest = '1' then
                lowest_idx := -1; max_y := (others => '0');
                for i in 0 to 3 loop
                    if active_arr(i) = '1' and y_arr(i) >= max_y then
                        max_y := y_arr(i); lowest_idx := i;
                    end if;
                end loop;
                if lowest_idx /= -1 then
                    active_arr(lowest_idx) <= '0';
                end if;
            end if;

            if frame_tick = '1' then
                for i in 0 to 3 loop
                    if active_arr(i) = '1' then
                        y_arr(i) <= y_arr(i) + FALL_SPEED;
                        if y_arr(i) > to_unsigned(480, 10) then 
                            active_arr(i) <= '0';
                        end if;
                    end if;
                end loop;
            end if;
        end if;
    end process;

    valid_bus <= active_arr;
    y_bus(9 downto 0)   <= std_logic_vector(y_arr(0));
    y_bus(19 downto 10) <= std_logic_vector(y_arr(1));
    y_bus(29 downto 20) <= std_logic_vector(y_arr(2));
    y_bus(39 downto 30) <= std_logic_vector(y_arr(3));
end Behavioral;