library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;

entity fk_tb is
end entity;

architecture behavioral of fk_tb is

  signal hold : std_logic := '0';
  signal clk_tb : std_logic;
  signal reset_tb : std_logic;
  signal a0_tb  : std_logic_vector(31 downto 0);
  signal a1_tb  : std_logic_vector(31 downto 0);
  signal a2_tb  : std_logic_vector(31 downto 0);
  signal ex_tb  : std_logic_vector(31 downto 0);
  signal ey_tb  : std_logic_vector(31 downto 0);
  signal p1x_tb : std_logic_vector(31 downto 0);
  signal p1y_tb : std_logic_vector(31 downto 0);
  signal p2x_tb : std_logic_vector(31 downto 0);
  signal p2y_tb : std_logic_vector(31 downto 0);


begin

  reset_tb <= '0';
  a0_tb <= "00000000000000011001001000011111";
  a1_tb <= "00000000000000011001001000011111";
  a2_tb <= "00000000000000011001001000011111";

  fk_comb_i : fk_comb
  port map (
    clk => clk_tb,
    reset => reset_tb,
    a0 => a0_tb,
    a1 => a1_tb,
    a2 => a2_tb,
    ex => ex_tb,
    ey => ey_tb,
    p1x => p1x_tb,
    p1y => p1y_tb,
    p2x => p2x_tb,
    p2y => p2y_tb
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
