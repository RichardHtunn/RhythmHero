library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_bin_to_bcd is
-- Testbench entity is empty
end tb_bin_to_bcd;

architecture Behavioral of tb_bin_to_bcd is

    -- Component Declaration
    component bin_to_bcd
        Port (
            bin_in   : in  STD_LOGIC_VECTOR (13 downto 0);
            ones     : out STD_LOGIC_VECTOR (3 downto 0);
            tens     : out STD_LOGIC_VECTOR (3 downto 0);
            hundreds : out STD_LOGIC_VECTOR (3 downto 0);
            thousands: out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- Signals
    signal bin_in    : STD_LOGIC_VECTOR(13 downto 0) := (others => '0');
    signal ones      : STD_LOGIC_VECTOR(3 downto 0);
    signal tens      : STD_LOGIC_VECTOR(3 downto 0);
    signal hundreds  : STD_LOGIC_VECTOR(3 downto 0);
    signal thousands : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: bin_to_bcd port map (
        bin_in    => bin_in,
        ones      => ones,
        tens      => tens,
        hundreds  => hundreds,
        thousands => thousands
    );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test 1: Score of 0
        bin_in <= std_logic_vector(to_unsigned(0, 14));
        wait for 20 ns;

        -- Test 2: Score of 99
        bin_in <= std_logic_vector(to_unsigned(99, 14));
        wait for 20 ns;

        -- Test 3: Score of 1234
        bin_in <= std_logic_vector(to_unsigned(1234, 14));
        wait for 20 ns;

        -- Test 4: Score of 9999
        bin_in <= std_logic_vector(to_unsigned(9999, 14));
        wait for 20 ns;

        wait;
    end process;

end Behavioral;