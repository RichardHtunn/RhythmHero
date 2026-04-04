library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port ( 
        clk       : in  STD_LOGIC;                      
        btn_ext   : in  STD_LOGIC_VECTOR(3 downto 0);   
        btnC      : in  STD_LOGIC; 
        btnU      : in  STD_LOGIC; 
        rx_line   : in  STD_LOGIC;
        tx_line   : out STD_LOGIC;
        
        led       : out STD_LOGIC_VECTOR(15 downto 0);  
        seg       : out STD_LOGIC_VECTOR(6 downto 0);
        an        : out STD_LOGIC_VECTOR(3 downto 0);
        vgaRed    : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue   : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen  : out STD_LOGIC_VECTOR(3 downto 0);
        Hsync     : out STD_LOGIC;
        Vsync     : out STD_LOGIC
    );
end top;

architecture Behavioral of top is

    signal clk_25        : STD_LOGIC := '0';
    signal clk_div_cnt   : integer range 0 to 1 := 0;
    signal frame_counter : integer range 0 to 1666666 := 0; 
    signal frame_tick    : STD_LOGIC := '0';

    signal w_video_on   : STD_LOGIC;
    signal w_pixel_x, w_pixel_y : STD_LOGIC_VECTOR(9 downto 0);

    signal uart_data    : STD_LOGIC_VECTOR(7 downto 0);
    signal uart_valid   : STD_LOGIC;
    signal spawn_vec    : STD_LOGIC_VECTOR(3 downto 0) := "0000";

    signal clean_btn, pulse_btn : STD_LOGIC_VECTOR(3 downto 0);
    signal clean_start, pulse_start, clean_miss : STD_LOGIC;

    signal w_game_state : STD_LOGIC_VECTOR(1 downto 0);
    signal w_score      : unsigned(15 downto 0);
    
    signal w_any_perfect, w_any_good, w_any_fatal : STD_LOGIC;
    signal w_clear_lanes : STD_LOGIC_VECTOR(3 downto 0);
    signal v0, v1, v2, v3 : STD_LOGIC_VECTOR(3 downto 0);
    signal y0, y1, y2, y3 : STD_LOGIC_VECTOR(39 downto 0);
    
    signal w_reset_game  : STD_LOGIC;
    signal w_end_trigger : STD_LOGIC;
    signal w_uart_char   : STD_LOGIC_VECTOR(7 downto 0);

begin
    w_reset_game <= '1' when w_game_state = "00" else '0';
    
    w_end_trigger <= w_any_fatal or clean_miss;
    
    w_uart_char <= x"58" when w_any_fatal = '1' else x"53"; 

    process(clk)
    begin
        if rising_edge(clk) then
            if clk_div_cnt = 1 then clk_25 <= not clk_25; clk_div_cnt <= 0;
            else clk_div_cnt <= clk_div_cnt + 1; end if;

            if frame_counter = 1666666 then frame_counter <= 0; frame_tick <= '1';
            else frame_counter <= frame_counter + 1; frame_tick <= '0'; end if;
            
            if uart_valid = '1' then spawn_vec <= uart_data(3 downto 0);
            else spawn_vec <= "0000"; end if;
        end if;
    end process;

    DEB_0: entity work.debouncer port map(clk=>clk, btn_in=>btn_ext(0), btn_out=>clean_btn(0));
    DEB_1: entity work.debouncer port map(clk=>clk, btn_in=>btn_ext(1), btn_out=>clean_btn(1));
    DEB_2: entity work.debouncer port map(clk=>clk, btn_in=>btn_ext(2), btn_out=>clean_btn(2));
    DEB_3: entity work.debouncer port map(clk=>clk, btn_in=>btn_ext(3), btn_out=>clean_btn(3));
    DEB_ST: entity work.debouncer port map(clk=>clk, btn_in=>btnC, btn_out=>clean_start);
    DEB_M:  entity work.debouncer port map(clk=>clk, btn_in=>btnU, btn_out=>clean_miss);

    PULS_0: entity work.single_pulser port map(clk=>clk, btn_in=>clean_btn(0), pulse_out=>pulse_btn(0));
    PULS_1: entity work.single_pulser port map(clk=>clk, btn_in=>clean_btn(1), pulse_out=>pulse_btn(1));
    PULS_2: entity work.single_pulser port map(clk=>clk, btn_in=>clean_btn(2), pulse_out=>pulse_btn(2));
    PULS_3: entity work.single_pulser port map(clk=>clk, btn_in=>clean_btn(3), pulse_out=>pulse_btn(3));
    PULS_ST: entity work.single_pulser port map(clk=>clk, btn_in=>clean_start, pulse_out=>pulse_start);
    UART_RX_INST: entity work.uart_rx port map (clk=>clk, reset=>'0', rx_line=>rx_line, data_out=>uart_data, new_byte=>uart_valid);
    
    UART_TX_INST: entity work.uart_tx port map (
        clk=>clk, reset=>'0', send_trigger=>w_end_trigger, data_in=>w_uart_char, tx_line=>tx_line, busy=>open
    );

    FSM_INST: entity work.game_fsm port map (
        clk=>clk, reset=>'0', btn_start=>pulse_start, fatal_miss_in=>w_end_trigger, game_state=>w_game_state
    );

    LANES_INST: entity work.four_lane_manager port map (
        clk=>clk, reset=>w_reset_game, frame_tick=>frame_tick, spawn_lanes=>spawn_vec, clear_lanes=>w_clear_lanes,
        v_0=>v0, v_1=>v1, v_2=>v2, v_3=>v3, y_0=>y0, y_1=>y1, y_2=>y2, y_3=>y3
    );

    JUDGES_INST: entity work.four_judge_manager port map (
        clk=>clk, reset=>w_reset_game, v_0=>v0, v_1=>v1, v_2=>v2, v_3=>v3, y_0=>y0, y_1=>y1, y_2=>y2, y_3=>y3,
        btn_pulse=>pulse_btn, any_perfect=>w_any_perfect, any_good=>w_any_good, any_fatal_miss=>w_any_fatal, clear_lanes=>w_clear_lanes
    );

    SCORE_INST: entity work.score_tracker port map (
        clk=>clk, reset=>w_reset_game, perfect_hit=>w_any_perfect, good_hit=>w_any_good, total_score=>w_score
    );
    
    VGA_SYNC_INST: entity work.vga_sync port map (clk_25mhz=>clk_25, rst=>'0', hsync=>Hsync, vsync=>Vsync, video_on=>w_video_on, pixel_x=>w_pixel_x, pixel_y=>w_pixel_y);
    VGA_RENDER_INST: entity work.vga_render port map (video_on=>w_video_on, pixel_x=>w_pixel_x, pixel_y=>w_pixel_y, game_state=>w_game_state, v_0=>v0, v_1=>v1, v_2=>v2, v_3=>v3, y_0=>y0, y_1=>y1, y_2=>y2, y_3=>y3, vga_red=>vgaRed, vga_green=>vgaGreen, vga_blue=>vgaBlue);

    SEG_INST: entity work.seven_segment_display port map (clk=>clk, reset=>'0', score=>w_score, seg=>seg, an=>an);
    
    LED_FB_INST: entity work.led_hit_feedback port map (clk=>clk, reset=>'0', perfect_in=>w_any_perfect, good_in=>w_any_good, led_perfect=>led(15), led_good=>led(14));

    led(3 downto 0) <= clean_btn;

end Behavioral;