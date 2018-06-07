library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;

entity Project_Wrapper_tb is
end entity;

architecture behavioral of Project_Wrapper_tb is
  component Project_Wrapper
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    hold  : in  std_logic;
    pulse : out std_logic_vector(5 downto 0)
  );
  end component Project_Wrapper;
  signal clk_tb   : std_logic;
  signal reset_tb : std_logic;
  signal hold_tb  : std_logic;
  signal pulse_tb : std_logic_vector(5 downto 0);

begin

  Project_Wrapper_i : Project_Wrapper
  port map (
    clk   => clk_tb,
    reset => reset_tb,
    hold  => hold_tb,
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
