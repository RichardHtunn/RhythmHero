library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_render is
    Port (
        video_on   : in  STD_LOGIC;                     
        pixel_x    : in  STD_LOGIC_VECTOR (9 downto 0); 
        pixel_y    : in  STD_LOGIC_VECTOR (9 downto 0); 
        game_state : in  STD_LOGIC_VECTOR (1 downto 0); 
        
        v_0, v_1, v_2, v_3 : in STD_LOGIC_VECTOR(3 downto 0);
        y_0, y_1, y_2, y_3 : in STD_LOGIC_VECTOR(39 downto 0);
        
        vga_red    : out STD_LOGIC_VECTOR (3 downto 0);
        vga_green  : out STD_LOGIC_VECTOR (3 downto 0);
        vga_blue   : out STD_LOGIC_VECTOR (3 downto 0)
    );
end vga_render;

architecture Behavioral of vga_render is
    signal x, y : integer range 0 to 1023;
begin
    x <= to_integer(unsigned(pixel_x));
    y <= to_integer(unsigned(pixel_y));

    process(video_on, x, y, game_state, v_0, v_1, v_2, v_3, y_0, y_1, y_2, y_3)
        variable draw_note : boolean;
        variable ty : integer;
    begin
        vga_red <= "0010"; vga_green <= "0010"; vga_blue <= "0010";

        if video_on = '1' then
            if game_state = "00" then
                vga_red <= "0000"; vga_green <= "1000"; vga_blue <= "1000";
                if (x >= 220 and x <= 420) and (y >= 200 and y <= 280) then
                    vga_red <= "1111"; vga_green <= "1111"; vga_blue <= "0000";
                    if (x >= 300 and x <= 340) and (y >= 220 and y <= 260) then
                        vga_red <= "0000"; vga_green <= "1111"; vga_blue <= "0000";
                    end if;
                end if;

            elsif game_state = "01" then
                if (x >= 120 and x <= 520) then
                    vga_red <= "1111"; vga_green <= "1111"; vga_blue <= "1111";
                    if (x >= 218 and x <= 222) or (x >= 318 and x <= 322) or (x >= 418 and x <= 422) then
                        vga_red <= "0000"; vga_green <= "0000"; vga_blue <= "0000";
                    end if;
                    if (y >= 400 and y <= 405) then
                        vga_red <= "1111"; vga_green <= "0000"; vga_blue <= "0000";
                    end if;
                    
                    draw_note := false;
                    for i in 0 to 3 loop
                        if v_0(i)='1' then ty := to_integer(unsigned(y_0(i*10+9 downto i*10))); if x>=120 and x<218 and y>=ty and y<=ty+80 then draw_note:=true; end if; end if;
                        if v_1(i)='1' then ty := to_integer(unsigned(y_1(i*10+9 downto i*10))); if x>222 and x<318 and y>=ty and y<=ty+80 then draw_note:=true; end if; end if;
                        if v_2(i)='1' then ty := to_integer(unsigned(y_2(i*10+9 downto i*10))); if x>322 and x<418 and y>=ty and y<=ty+80 then draw_note:=true; end if; end if;
                        if v_3(i)='1' then ty := to_integer(unsigned(y_3(i*10+9 downto i*10))); if x>422 and x<=520 and y>=ty and y<=ty+80 then draw_note:=true; end if; end if;
                    end loop;
                    if draw_note then
                        vga_red <= "0000"; vga_green <= "0000"; vga_blue <= "0000";
                    end if;
                end if;

            elsif game_state = "10" then
                vga_red <= "1111"; vga_green <= "0000"; vga_blue <= "0000";
                if (x >= 220 and x <= 420) and (y >= 200 and y <= 280) then
                    vga_red <= "1111"; vga_green <= "1111"; vga_blue <= "1111";
                    if (x >= 300 and x <= 340) and (y >= 220 and y <= 260) then
                        vga_red <= "0000"; vga_green <= "0000"; vga_blue <= "1111";
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;