library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;

entity Project_Wrapper is
  port (
  clk : in std_logic;
  reset : in std_logic;
  hold : in std_logic;
  pulse : out std_logic_vector(5 downto 0)
  );
end entity;

architecture behavioral of Project_Wrapper is
begin
  PWM_TOP_i : PWM_TOP
  port map (
    clk   => clk,
    reset => reset,
    hold  => hold,
    a0    => std_logic_vector'("00000000000000011001001000011111"),
    a1    => std_logic_vector'("00000000000000011001001000011111"),
    a2    => std_logic_vector'("00000000000000011001001000011111"),
    a3    => std_logic_vector'("00000000000000011001001000011111"),
    a4    => std_logic_vector'("00000000000000011001001000011111"),
    a5    => std_logic_vector'("00000000000000011001001000011111"),
    pulse => pulse
  );

end architecture;
