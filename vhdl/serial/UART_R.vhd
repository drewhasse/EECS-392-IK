library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART_R is
  generic (
--- Baud rate = 57,600
    CLKS_PER_BIT : natural := 868
  );
  port (
    clk : in std_logic;
    reset : in std_logic;
    RX : in std_logic;
    RX_DV : out std_logic;
    RX_byte : out std_logic_vector(7 downto 0)
  );
end entity;

architecture behavioral of UART_R is

  type state is (idle, start, data, stp, stp_hold);
  signal curr_state, next_state : state;
  signal byte : std_logic_vector(7 downto 0) := x"00";
  signal byte_c : std_logic_vector(7 downto 0) := x"00";
  signal stop_sig : std_logic := '0';
  signal stop_sig_c : std_logic := '0';
  signal RX_data : std_logic := '0';
  signal RX_data_i : std_logic := '0';

  signal clk_count : natural := 0;
  signal clk_count_c : natural := 0;
  signal index : natural := 7;
  signal index_c : natural := 7;

begin
  UART_clk_proc : process (clk, reset) is
    begin
      if (reset = '1') then
        curr_state <= idle;
        byte <= "00000000";
        stop_sig <= '0';
        RX_data <= '0';
        clk_count <= 0;
        index <= 7;
      elsif (rising_edge(clk)) then
    ----- double register to solve metastability issues---
        RX_data_i <= RX;
        RX_data <= RX_data_i;
    ------------------------------------------------------
        curr_state <= next_state;
        byte <= byte_c;
        stop_sig <= stop_sig_c;
        clk_count <= clk_count_c;
        index <= index_c;
      end if;
    end process;

  UART_comb_proc : process (byte, stop_sig, curr_state, RX_data, clk_count, index) is
    begin
      byte_c <= byte;
      stop_sig_c <= stop_sig;
      clk_count_c <= clk_count;
      next_state <= curr_state;
-----------OUTPUTS----------
      RX_byte <= byte;
      RX_DV <= stop_sig;
----------------------------
      case (curr_state) is
--- IDLE STATE
        when (idle) =>
          if (RX_data = '0') then
            next_state <= start;
            stop_sig_c <= '0';
            clk_count_c <= 0;
            index_c <= 7;
            byte_c <= x"00";
          else
            next_state <= idle;
          end if;

        when (start) =>
          if (clk_count = (CLKS_PER_BIT/2)) then
            if (RX_data = '0') then
              clk_count_c <= 0;
              next_state <= data;
            else
              next_state <= idle;
            end if;
          else
            clk_count_c <= clk_count + 1;
            next_state <= start;
          end if;
--- READ DATA STATE
        when (data) =>
          if (clk_count < CLKS_PER_BIT) then
            clk_count_c <= clk_count + 1;
            next_state <= data;
          else
            clk_count_c <= 0;
            byte_c(index) <= RX_data;
            if (index > 0) then
              index_c <= index - 1;
              next_state <= data;
            else
              index_c <= 0;
              next_state <= stp;
            end if;
          end if;
--- END OF DATA STATE
        when (stp) =>
          if (clk_count < CLKS_PER_BIT) then
            clk_count_c <= clk_count_c + 1;
            next_state <= stp;
          else
            stop_sig_c <= '1';
            clk_count_c <= 0;
            next_state <= stp_hold;
          end if;
--- HOLD STOP SIGNAL HIGH
        when (stp_hold) =>
          stop_sig_c <= '0';
          next_state <= idle;
      end case;
    end process;
end architecture;
