----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2026 11:52:56 PM
-- Design Name: 
-- Module Name: bin_to_bcd - Behavioral
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

entity bin_to_bcd is
    Port (
        bin_in   : in  STD_LOGIC_VECTOR (13 downto 0);
        ones     : out STD_LOGIC_VECTOR (3 downto 0);
        tens     : out STD_LOGIC_VECTOR (3 downto 0);
        hundreds : out STD_LOGIC_VECTOR (3 downto 0);
        thousands: out STD_LOGIC_VECTOR (3 downto 0)
    );
end bin_to_bcd;

architecture Behavioral of bin_to_bcd is
begin
    process(bin_in)
        variable temp : UNSIGNED(29 downto 0);
        variable bcd_ones, bcd_tens, bcd_hundreds, bcd_thousands : UNSIGNED(3 downto 0);
    begin
        temp := (others => '0');
        temp(13 downto 0) := UNSIGNED(bin_in);

        for i in 0 to 13 loop
            bcd_ones      := temp(17 downto 14);
            bcd_tens      := temp(21 downto 18);
            bcd_hundreds  := temp(25 downto 22);
            bcd_thousands := temp(29 downto 26);

            if bcd_ones >= 5 then bcd_ones := bcd_ones + 3; end if;
            if bcd_tens >= 5 then bcd_tens := bcd_tens + 3; end if;
            if bcd_hundreds >= 5 then bcd_hundreds := bcd_hundreds + 3; end if;
            if bcd_thousands >= 5 then bcd_thousands := bcd_thousands + 3; end if;

            temp(29 downto 14) := bcd_thousands & bcd_hundreds & bcd_tens & bcd_ones;
            
            temp := temp(28 downto 0) & '0';
        end loop;

        ones      <= std_logic_vector(temp(17 downto 14));
        tens      <= std_logic_vector(temp(21 downto 18));
        hundreds  <= std_logic_vector(temp(25 downto 22));
        thousands <= std_logic_vector(temp(29 downto 26));
    end process;
end Behavioral;