library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_display is
    Port (
        clk     : in  STD_LOGIC; 
        reset   : in  STD_LOGIC;
        score   : in  unsigned(15 downto 0);
        
        seg     : out STD_LOGIC_VECTOR(6 downto 0); 
        an      : out STD_LOGIC_VECTOR(3 downto 0) 
    );
end seven_segment_display;

architecture Behavioral of seven_segment_display is
    
    component bin_to_bcd
        Port (
            bin_in   : in  STD_LOGIC_VECTOR (13 downto 0);
            ones     : out STD_LOGIC_VECTOR (3 downto 0);
            tens     : out STD_LOGIC_VECTOR (3 downto 0);
            hundreds : out STD_LOGIC_VECTOR (3 downto 0);
            thousands: out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal active_digit    : STD_LOGIC_VECTOR(1 downto 0);
    
    signal bcd_ones      : STD_LOGIC_VECTOR(3 downto 0);
    signal bcd_tens      : STD_LOGIC_VECTOR(3 downto 0);
    signal bcd_hundreds  : STD_LOGIC_VECTOR(3 downto 0);
    signal bcd_thousands : STD_LOGIC_VECTOR(3 downto 0);
    
    signal current_val   : STD_LOGIC_VECTOR(3 downto 0);

begin

    BCD_INST: bin_to_bcd
        port map (
            bin_in    => std_logic_vector(score(13 downto 0)),
            ones      => bcd_ones,
            tens      => bcd_tens,
            hundreds  => bcd_hundreds,
            thousands => bcd_thousands
        );

    process(clk, reset)
    begin
        if reset = '1' then
            refresh_counter <= (others => '0');
        elsif rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;

    active_digit <= std_logic_vector(refresh_counter(19 downto 18));

    process(active_digit, bcd_thousands, bcd_hundreds, bcd_tens, bcd_ones)
    begin
        case active_digit is
            when "00" =>
                an <= "0111";
                current_val <= bcd_thousands;
            when "01" =>
                an <= "1011";
                current_val <= bcd_hundreds;
            when "10" =>
                an <= "1101";
                current_val <= bcd_tens;
            when "11" =>
                an <= "1110";
                current_val <= bcd_ones;
            when others =>
                an <= "1111";
                current_val <= "0000";
        end case;
    end process;

    process(current_val)
    begin
        case current_val is
            when "0000" => seg <= "0111111"; 
            when "0001" => seg <= "0000110"; 
            when "0010" => seg <= "1011011"; 
            when "0011" => seg <= "1001111"; 
            when "0100" => seg <= "1100110"; 
            when "0101" => seg <= "1101101"; 
            when "0110" => seg <= "1111101"; 
            when "0111" => seg <= "0000111"; 
            when "1000" => seg <= "1111111"; 
            when "1001" => seg <= "1101111"; 
            when others => seg <= "0000000"; 
        end case;
    end process;
end Behavioral;