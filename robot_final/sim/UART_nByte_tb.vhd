library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity UART_nByte_tb is
end entity;

architecture behavioral of UART_nByte_tb is
  constant NUM_BYTES : natural := 4;
  component UART_R
    generic (
      CLKS_PER_BIT : natural := 868
    );
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      RX      : in  std_logic;
      RX_DV   : out std_logic;
      RX_byte : out std_logic_vector(7 downto 0)
    );
  end component UART_R;
  component UART_nByte
    generic (
      n : natural;
      CLKS_PER_BIT : natural
    );
    port (
      clk        : in  std_logic;
      reset      : in  std_logic;
      RX         : in std_logic;
      dout       : out std_logic_vector(n*8-1 downto 0);
      data_valid : out std_logic
    );
  end component UART_nByte;

  signal hold          : std_logic := '0';
  signal clk_tb        : std_logic;
  signal reset_tb      : std_logic;
  signal RX_tb         : std_logic;
  signal data_valid_tb : std_logic;
  signal dout_tb    : std_logic_vector(NUM_BYTES*8-1 downto 0);


begin
  reset_tb <= '0';
  UART_nByte_i : UART_nByte
    generic map (
      n            => NUM_BYTES,
      CLKS_PER_BIT => 868
    )
    port map (
      clk        => clk_tb,
      reset      => reset_tb,
      RX         => RX_tb,
      dout       => dout_tb,
      data_valid => data_valid_tb
  );


  clock_generate: process is
  begin
    clk_tb <= '0';
    wait for 10 ns;
    clk_tb <= not clk_tb;
    wait for 10 ns;
    if hold = '1' then
      wait;
    end if;
  end process clock_generate;

  read_proc: process is
    variable my_line : line;
    file infile: text open read_mode is "RX_NB.in";
    variable byte_int : integer;
    variable byte_slv : std_logic_vector(9 downto 0);
    begin
      while not (endfile(infile)) loop
        readline(infile,my_line);
        read(my_line, byte_int);
        byte_slv := std_logic_vector(to_signed(byte_int,10));
        for i in 9 downto 0 loop
          RX_tb <= byte_slv(i);
          wait for 17361 ns;
        end loop;
        wait for 20 ns;
      end loop;
      wait for 100 us;
      hold <= '1';
      wait;
  end process;

end architecture;
