----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2026 02:19:53 AM
-- Design Name: 
-- Module Name: vga_sync - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_sync is
    Port (
        clk_25mhz : in  STD_LOGIC; 
        rst       : in  STD_LOGIC;
        hsync     : out STD_LOGIC;
        vsync     : out STD_LOGIC;
        video_on  : out STD_LOGIC; 
        pixel_x   : out STD_LOGIC_VECTOR (9 downto 0);
        pixel_y   : out STD_LOGIC_VECTOR (9 downto 0)
    );
end vga_sync;

architecture Behavioral of vga_sync is

    constant HD : integer := 640; 
    constant HF : integer := 16;  
    constant HB : integer := 48;  
    constant HR : integer := 96;  
    constant HMAX : integer := HD + HF + HB + HR - 1; 

    constant VD : integer := 480; 
    constant VF : integer := 10;  
    constant VB : integer := 33;  
    constant VR : integer := 2;   
    constant VMAX : integer := VD + VF + VB + VR - 1; 

    signal h_count_reg, h_count_next : unsigned(9 downto 0) := (others => '0');
    signal v_count_reg, v_count_next : unsigned(9 downto 0) := (others => '0');

begin

    process(clk_25mhz, rst)
    begin
        if rst = '1' then
            h_count_reg <= (others => '0');
            v_count_reg <= (others => '0');
        elsif rising_edge(clk_25mhz) then
            h_count_reg <= h_count_next;
            v_count_reg <= v_count_next;
        end if;
    end process;

    process(h_count_reg, v_count_reg)
    begin
        h_count_next <= h_count_reg;
        v_count_next <= v_count_reg;

        if h_count_reg = HMAX then
            h_count_next <= (others => '0');
            if v_count_reg = VMAX then
                v_count_next <= (others => '0');
            else
                v_count_next <= v_count_reg + 1;
            end if;
        else
            h_count_next <= h_count_reg + 1;
        end if;
    end process;

    hsync <= '0' when (h_count_reg >= (HD + HF)) and (h_count_reg <= (HD + HF + HR - 1)) else '1';
    vsync <= '0' when (v_count_reg >= (VD + VF)) and (v_count_reg <= (VD + VF + VR - 1)) else '1';

    video_on <= '1' when (h_count_reg < HD) and (v_count_reg < VD) else '0';

    pixel_x <= std_logic_vector(h_count_reg);
    pixel_y <= std_logic_vector(v_count_reg);

end Behavioral;