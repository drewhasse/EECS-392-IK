library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;
  use work.cordic.all;

entity ik_tb is
end entity;

architecture behavioral of ik_tb is

  signal hold : std_logic := '0';
  signal clk_tb : std_logic;
  signal reset_tb : std_logic;
  signal a0_tb  : std_logic_vector(31 downto 0);
  signal a1_tb  : std_logic_vector(31 downto 0);
  signal a2_tb  : std_logic_vector(31 downto 0);
  signal destx_tb : std_logic_vector(31 downto 0);
  signal desty_tb : std_logic_vector(31 downto 0);

begin

  destx_tb <= "00000000000000010000000000000000";
  desty_tb <= "00000000000000010000000000000000";

  ik_i : ik
  port map (
    clk   => clk_tb,
    reset => reset_tb,
    destx => destx_tb,
    desty => desty_tb,
    a0    => a0_tb,
    a1    => a1_tb,
    a2    => a2_tb
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
      reset_tb <= '1';
      wait for 2 ns;
      reset_tb <= '0';
      wait for 1 ms;
      hold <= '1';
      wait;
  end process;

end architecture;
