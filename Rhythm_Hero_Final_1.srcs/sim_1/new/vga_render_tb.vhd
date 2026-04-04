library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_vga_render is
-- Testbench entity is empty
end tb_vga_render;

architecture Behavioral of tb_vga_render is

    -- Signals to drive the Unit Under Test (UUT)
    signal video_on   : STD_LOGIC := '0';
    signal pixel_x    : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal pixel_y    : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal game_state : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal v_0, v_1, v_2, v_3 : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal y_0, y_1, y_2, y_3 : STD_LOGIC_VECTOR(39 downto 0) := (others => '0');
    
    signal vga_red    : STD_LOGIC_VECTOR(3 downto 0);
    signal vga_green  : STD_LOGIC_VECTOR(3 downto 0);
    signal vga_blue   : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: entity work.vga_render
        port map (
            video_on   => video_on,
            pixel_x    => pixel_x,
            pixel_y    => pixel_y,
            game_state => game_state,
            v_0 => v_0, v_1 => v_1, v_2 => v_2, v_3 => v_3,
            y_0 => y_0, y_1 => y_1, y_2 => y_2, y_3 => y_3,
            vga_red    => vga_red,
            vga_green  => vga_green,
            vga_blue   => vga_blue
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Initial State: Monitor is off
        video_on <= '0';
        wait for 20 ns;
        video_on <= '1';
        
        -- ---------------------------------------------------------
        -- SCENARIO 1: MAIN MENU (State 00)
        -- ---------------------------------------------------------
        game_state <= "00";
        -- Test background color (should be teal/cyan)
        pixel_x <= std_logic_vector(to_unsigned(10, 10));
        pixel_y <= std_logic_vector(to_unsigned(10, 10));
        wait for 20 ns;
        
        -- Test inside start button area (220-420, 200-280)
        pixel_x <= std_logic_vector(to_unsigned(320, 10)); -- Center
        pixel_y <= std_logic_vector(to_unsigned(240, 10)); -- Center
        wait for 20 ns;

        -- ---------------------------------------------------------
        -- SCENARIO 2: GAMEPLAY (State 01)
        -- ---------------------------------------------------------
        game_state <= "01";
        -- Setup a note in Lane 0 at Y = 100
        v_0(0) <= '1';
        y_0(9 downto 0) <= std_logic_vector(to_unsigned(100, 10));
        
        -- Test background of the lane (White)
        pixel_x <= std_logic_vector(to_unsigned(150, 10));
        pixel_y <= std_logic_vector(to_unsigned(50, 10));
        wait for 20 ns;
        
        -- Test the pixel directly on the note (should flip to Black)
        pixel_y <= std_logic_vector(to_unsigned(110, 10)); 
        wait for 20 ns;

        -- ---------------------------------------------------------
        -- SCENARIO 3: GAME OVER (State 10)
        -- ---------------------------------------------------------
        game_state <= "10";
        -- Background should be Red
        pixel_x <= std_logic_vector(to_unsigned(10, 10));
        pixel_y <= std_logic_vector(to_unsigned(10, 10));
        wait for 20 ns;

        wait;
    end process;

end Behavioral;