library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ik_pack.all;

entity PWM_TOP_tb is
end entity;

architecture behavioral of PWM_TOP_tb is
  signal clk_tb   : std_logic;
  signal reset_tb : std_logic;
  signal hold_tb  : std_logic;
  signal a0_tb    : std_logic_vector(31 downto 0);
  signal a1_tb    : std_logic_vector(31 downto 0);
  signal a2_tb    : std_logic_vector(31 downto 0);
  signal a3_tb    : std_logic_vector(31 downto 0);
  signal a4_tb    : std_logic_vector(31 downto 0);
  signal a5_tb    : std_logic_vector(31 downto 0);
  signal pulse_tb : std_logic_vector(5 downto 0);

  begin
    PWM_TOP_i : PWM_TOP
    port map (
      clk   => clk_tb,
      reset => reset_tb,
      hold  => hold_tb,
      a0    => a0_tb,
      a1    => a1_tb,
      a2    => a2_tb,
      a3    => a3_tb,
      a4    => a4_tb,
      a5    => a5_tb,
      pulse => pulse_tb
    );

    a0_tb <= std_logic_vector'("11111111111111100110110111100001");
    a1_tb <= std_logic_vector'("00000000000000000000000000000000");
    a2_tb <= std_logic_vector'("00000000000000011001001000011111");
    a3_tb <= std_logic_vector'("00000000000000001100100100001111");
    a4_tb <= std_logic_vector'("00000000000000110010010000111111");
    a5_tb <= std_logic_vector'("00000000000000000000000000000000");

    clock_generate: process is
      begin
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= not clk_tb;
        wait for 10 ns;
        if hold_tb = '1' then
          wait;
        end if;
    end process clock_generate;

    stop_clk : process is
      begin
        hold_tb <= '0';
        reset_tb <= '1';
        wait for 2 ns;
        reset_tb <= '0';
        wait for 100 ms;
        hold_tb <= '1';
        wait;
    end process;

end architecture;
