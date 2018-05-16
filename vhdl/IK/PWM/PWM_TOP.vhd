library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ik_pack.all;

entity PWM_TOP is
  port (
  clk : in std_logic;
  reset : in std_logic;
  hold : in std_logic;
  a0 : in std_logic_vector(31 downto 0);
  a1 : in std_logic_vector(31 downto 0);
  a2 : in std_logic_vector(31 downto 0);
  a3 : in std_logic_vector(31 downto 0);
  a4 : in std_logic_vector(31 downto 0);
  a5 : in std_logic_vector(31 downto 0);
  pulse : out std_logic_vector(5 downto 0);
  );
end entity;

architecture behavioral of PWM_TOP is
  begin
    PWM_0 : PWM
    port map (
      clk    => clk,
      reset  => reset,
      hold   => hold,
      length => rads_to_pulse(a0),
      pulse  => pulse(0)
    );
    PWM_1 : PWM
    port map (
      clk    => clk,
      reset  => reset,
      hold   => hold,
      length => rads_to_pulse(a1),
      pulse  => pulse(1)
    );
    PWM_2 : PWM
    port map (
      clk    => clk,
      reset  => reset,
      hold   => hold,
      length => rads_to_pulse(a2),
      pulse  => pulse(2)
    );
    PWM_3 : PWM
    port map (
      clk    => clk,
      reset  => reset,
      hold   => hold,
      length => rads_to_pulse(a3),
      pulse  => pulse(3)
    );
    PWM_4 : PWM
    port map (
      clk    => clk,
      reset  => reset,
      hold   => hold,
      length => rads_to_pulse(a4),
      pulse  => pulse(4)
    );
    PWM_5 : PWM
    port map (
      clk    => clk,
      reset  => reset,
      hold   => hold,
      length => rads_to_pulse(a5),
      pulse  => pulse(5)
    );


end architecture;
