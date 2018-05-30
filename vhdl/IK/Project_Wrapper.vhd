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
  signal destx_s : std_logic_vector(31 downto 0);
  signal desty_s : std_logic_vector(31 downto 0);
  signal a0_s : std_logic_vector(31 downto 0);
  signal a1_s : std_logic_vector(31 downto 0);
  signal a2_s : std_logic_vector(31 downto 0);
  -- signal a3 : std_logic_vector(31 downto 0);
  -- signal a4 : std_logic_vector(31 downto 0);
begin
------------- Reorder bytes from UART ----------------
  -- base_angle(7 downto 0) <= dout_s(95 downto 88);
  -- base_angle(15 downto 8) <= dout_s(87 downto 80);
  -- base_angle(23 downto 15) <= dout_s(79 downto 72);
  -- base_angle(7 downto 0) <= dout_s(71 downto 64);
  -- destx_s(7 downto 0) <= dout_s(31 downto 24);
  -- destx_s(15 downto 8) <= dout_s(23 downto 16);
  -- destx_s(23 downto 16) <= dout_s(15 downto 8);
  -- destx_s(31 downto 24) <= dout_s(7 downto 0);
  -- desty_s(7 downto 0) <= dout_s(63 downto 56);
  -- desty_s(15 downto 8) <= dout_s(55 downto 48);
  -- desty_s(23 downto 16) <= dout_s(47 downto 40);
  -- desty_s(31 downto 24) <= dout_s(39 downto 32);
  dest_x_s <= dout_s(num_bytes*8-1 downto num_bytes*8-32);
  dest_y_s <= dout_s(num_bytes*8-33 downto num_bytes*8-64);
  base_angle <= dout_s(num_bytes*8-65 downto num_bytes*8-96);
--------------------------------------------------------
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
      destx => destx_s,
      desty => desty_s,
      a0    => a0_s,
      a1    => a1_s,
      a2    => a2_s
    );

  PWM_TOP_i : PWM_TOP
  port map (
    clk   => clk,
    reset => reset,
    hold  => hold,
    a0    => std_logic_vector(signed(base_angle)-signed'("00000000000000011001001000011111")),
    a1    => a0_s,
    a2    => a1_s,
    a3    => a2_s,
    a4    => std_logic_vector'("00000000000000011001001000011111"),
    a5    => std_logic_vector'("00000000000000011001001000011111"),
    pulse => pulse
  );

end architecture;
