library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ik_pack.all;
use work.cordic.all;

entity cordic_lib_tb is
end entity;

architecture behavioral of cordic_lib_tb is

  signal hold : std_logic := '0';
  signal clk_tb : std_logic;
  signal reset_tb : std_logic;
  signal Busy_tb, Result_valid_tb, Data_valid_tb : std_logic;
  signal sin_tb, cos_tb : signed(31 downto 0);


  begin
    sincos_sequential_i : sincos_pipelined
    generic map (
      SIZE               => 32,
      ITERATIONS         => 5,
      FRAC_BITS          => 16
    )
    port map (
      Clock        => clk_tb,
      Reset        => reset_tb,
      Angle        => rads_to_brads(std_logic_vector'("00000000000000011001001000011111")),
      Sin          => sin_tb,
      Cos          => cos_tb
    );

    clock_generate: process is
      begin
        clk_tb <= '0';
        wait for 1 ns;
        clk_tb <= not clk_tb;
        wait for 1 ns;
        if hold = '1' then
          wait;
        end if;
      end process clock_generate;

      stop_clk : process is
      begin
        wait for 1 ms;
        hold <= '1';
        wait;
      end process;


end architecture;
