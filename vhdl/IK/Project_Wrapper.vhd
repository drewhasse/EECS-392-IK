library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;

entity Project_Wrapper is
  port (
  clk : in std_logic;
  reset : in std_logic;
  hold : in std_logic;
  RX : in std_logic;
  pulse : out std_logic_vector(5 downto 0)
  );
end entity;

architecture behavioral of Project_Wrapper is
  constant num_bytes : natural := 16;
  constant CLKS_PER_BIT : natural := 434;

  signal dout_s : std_logic_vector(num_bytes*8-1 downto 0);
  signal pulse_s : std_logic;
  signal base_angle : std_logic_vector(31 downto 0);
  signal a0_s : std_logic_vector(31 downto 0);
  signal a1_s : std_logic_vector(31 downto 0);
  signal a2_s : std_logic_vector(31 downto 0);
  -- signal a3 : std_logic_vector(31 downto 0);
  -- signal a4 : std_logic_vector(31 downto 0);
begin

  UART_nByte_i : UART_nByte
    generic map (
      n            => num_bytes,
      CLKS_PER_BIT => CLKS_PER_BIT
    )
    port map (
      clk        => clk,
      reset      => reset,
      RX         => RX,
      dout       => dout_s,
      data_valid => open
      );

  counter_i : counter
    port map (
      clk   => clk,
      reset => reset,
      hold  => hold,
      pulse => pulse_s
    );


  ik_machine_i : ik_machine
    port map (
      clk   => clk,
      reset => reset,
      pulse => pulse_s,
      destx => dout_s(31 downto 0),
      desty => dout_s(63 downto 32),
      a0    => a0_s,
      a1    => a1_s,
      a2    => a2_s
    );

  PWM_TOP_i : PWM_TOP
  port map (
    clk   => clk,
    reset => reset,
    hold  => hold,
    a0    => std_logic_vector(signed(dout_s(95 downto 64))-signed'("00000000000000011001001000011111")),
    a1    => a0_s,
    a2    => a1_s,
    a3    => a2_s,
    a4    => std_logic_vector'("00000000000000011001001000011111"),
    a5    => std_logic_vector'("00000000000000011001001000011111"),
    pulse => pulse
  );

end architecture;
