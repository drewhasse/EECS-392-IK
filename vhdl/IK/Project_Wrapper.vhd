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
  signal pulse_int : std_logic;
  signal a0, a1, a2 : std_logic_vector(31 downto 0);
begin
  counter_i : counter
  port map (
    clk   => clk,
    reset => reset,
    hold  => hold,
    pulse => pulse_int
  );


  ik_machine_i : ik_machine
  port map (
    clk   => clk,
    reset => reset,
    pulse => pulse_int,
    destx => std_logic_vector'("00000000100101100000000000000000"),
    desty => std_logic_vector'("00000000100101100000000000000000"),
    a0    => a0,
    a1    => a1,
    a2    => a2
  );


  PWM_TOP_i : PWM_TOP
  port map (
    clk   => clk,
    reset => reset,
    hold  => hold,
    a0    => std_logic_vector(signed(a0)-signed'("00000000000000011001001000011111")),
    a1    => a1,
    a2    => a2,
    a3    => std_logic_vector'("00000000000000011001001000011111"),
    a4    => std_logic_vector'("00000000000000011001001000011111"),
    a5    => std_logic_vector'("00000000000000011001001000011111"),
    pulse => pulse
  );


end architecture;
