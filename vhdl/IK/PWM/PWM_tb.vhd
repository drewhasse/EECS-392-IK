library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ik_pack.all;

entity PWM_tb is
end entity;

architecture behavioral of PWM_tb is
signal clk_tb   : std_logic;
signal reset_tb : std_logic;
signal hold_tb  : std_logic;
signal sig_tb   : std_logic;
signal pulse_tb : std_logic;

  begin
    PWM_i : PWM
    port map (
      clk   => clk_tb,
      reset => reset_tb,
      hold  => hold_tb,
      length   => rads_to_pulse(std_logic_vector'("00000000000000011001001000011111")),
      pulse => pulse_tb
    );

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
