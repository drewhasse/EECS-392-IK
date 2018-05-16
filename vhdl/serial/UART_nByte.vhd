library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_nByte is
  generic (
    constant n : natural := 4;
    CLKS_PER_BIT : natural := 434
  );
  port (
  clk : in std_logic;
  reset : in std_logic;
  RX : in std_logic;
  dout : out std_logic_vector(n*8-1 downto 0);
  data_valid : out std_logic
  );
end entity;

architecture arch of UART_nByte is
  component UART_R
    generic (
      CLKS_PER_BIT : natural := 434
    );
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      RX      : in  std_logic;
      RX_DV   : out std_logic;
      RX_byte : out std_logic_vector(7 downto 0)
    );
  end component UART_R;

  type state is (idle, wait_for_byte, shift, done);
  signal curr_state, next_state : state := idle;
  signal bytes : std_logic_vector(n*8-1 downto 0) := (others => '0');
  signal bytes_c : std_logic_vector(n*8-1 downto 0) := (others => '0');
  signal valid : std_logic := '0';
  signal valid_c : std_logic := '0';
  signal count : natural := n;
  signal count_c : natural := n;
  signal RX_DV2 : std_logic := '0';
  signal RX_DV : std_logic := '0';
  signal RX_DV_c : std_logic := '0';
  signal RX_byte : std_logic_vector(7 downto 0);
  signal test_RXB : std_logic_vector(7 downto 0) := x"00";

begin
  clk_proc_nB : process(clk, reset) is
    begin
      if (reset = '1') then
        curr_state <= idle;
        bytes <= (others => '0');
        valid <= '0';
        count <= n;
      elsif (rising_edge(clk)) then
        curr_state <= next_state;
        bytes <= bytes_c;
        valid <= valid_c;
        count <= count_c;
      end if;
    end process;

  comb_proc_nB : process(bytes, valid, count, curr_state, RX_DV, RX_byte) is
    begin
      --Outputs--
      dout <= bytes;
      data_valid <= valid;
      ------------
      bytes_c <= bytes;
      valid_c <= valid;
      count_c <= count;
      next_state <= curr_state;
      case (curr_state) is
        when (idle) =>
          if (RX_DV = '1') then
            bytes_c(7 downto 0) <= RX_byte;
            count_c <= count - 1;
            valid_c <= '0';
            next_state <= shift;
          else
            next_state <= idle;
          end if;

        when (wait_for_byte) =>
          if (count > 0) then
            next_state <= wait_for_byte;
            if (RX_DV = '1') then
              bytes_c(7 downto 0) <= RX_byte;
              count_c <= count - 1;
              next_state <= shift;
            end if;
          else
            next_state <= done;
          end if;

        when (shift) =>
          if (count = 0) then
            next_state <= done;
          else
            bytes_c <= std_logic_vector(unsigned(bytes) sll 8);
            next_state <= wait_for_byte;
          end if;

        when (done) =>
          valid_c <= '1';
          count_c <= n;
          next_state <= idle;
        end case;
    end process;

    UART_R_i : UART_R
      generic map (
        CLKS_PER_BIT => CLKS_PER_BIT
      )
      port map (
        clk     => clk,
        reset   => reset,
        RX      => RX,
        RX_DV   => RX_DV,
        RX_byte => RX_byte
      );


end architecture;
