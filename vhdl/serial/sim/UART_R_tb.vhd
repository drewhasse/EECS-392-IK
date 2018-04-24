library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity UART_R_tb is
end entity;

architecture behavioral of UART_R_tb is

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
  signal hold       : std_logic := '0';
  signal clk_tb     : std_logic;
  signal reset_tb   : std_logic;
  signal RX_tb      : std_logic;
  signal RX_DV_tb   : std_logic;
  signal RX_byte_tb : std_logic_vector(7 downto 0);


begin
  reset_tb <= '0';
  dut : UART_R
  generic map (
    CLKS_PER_BIT => 868
  )
  port map (
    clk     => clk_tb,
    reset   => reset_tb,
    RX      => RX_tb,
    RX_DV   => RX_DV_tb,
    RX_byte => RX_byte_tb
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
    file infile: text open read_mode is "RX.in";
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
      end loop;
      hold <= '1';
      wait;
  end process;

end architecture;
