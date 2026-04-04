library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity game_fsm is
    Port (
        clk             : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        btn_start       : in  STD_LOGIC;
        fatal_miss_in   : in  STD_LOGIC; 
        
        game_state      : out STD_LOGIC_VECTOR(1 downto 0) 
    );
end game_fsm;

architecture Behavioral of game_fsm is
    type state_type is (IDLE, PLAY, GAME_OVER);
    signal current_state, next_state : state_type;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, btn_start, fatal_miss_in)
    begin
        next_state <= current_state; 
        
        case current_state is
            when IDLE =>
                game_state <= "00";
                if btn_start = '1' then
                    next_state <= PLAY;
                end if;
                
            when PLAY =>
                game_state <= "01";
                if fatal_miss_in = '1' then
                    next_state <= GAME_OVER;
                end if;
                
            when GAME_OVER =>
                game_state <= "10";
                if btn_start = '1' then
                    next_state <= IDLE;
            end if;
                
            when others =>
                next_state <= IDLE;
        end case;
    end process;
end Behavioral;