library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_textio.all;
  use ieee.numeric_std.all;
  use std.textio.all;
  use work.ik_pack.all;
  use work.cordic.all;

entity ik_machine_tb is
end entity;

architecture behavioral of ik_machine_tb is

  signal hold : std_logic := '0';
  signal clk_tb : std_logic;
  signal reset_tb : std_logic;
  signal pulse_tb : std_logic;
  signal a0_tb  : std_logic_vector(31 downto 0);
  signal a1_tb  : std_logic_vector(31 downto 0);
  signal a2_tb  : std_logic_vector(31 downto 0);
  signal destx_tb : std_logic_vector(31 downto 0);
  signal desty_tb : std_logic_vector(31 downto 0);

begin


  ik_i : ik_machine
  port map (
    clk   => clk_tb,
    reset => reset_tb,
    pulse => pulse_tb,
    destx => destx_tb,
    desty => desty_tb,
    a0    => a0_tb,
    a1    => a1_tb,
    a2    => a2_tb
  );

  counter_i : counter
  port map (
    clk   => clk_tb,
    reset => reset_tb,
    hold  => hold,
    pulse => pulse_tb
  );

  clock_generate: process is
    begin
      clk_tb <= '0';
      wait for 10 ns;
      clk_tb <= not clk_tb;
      wait for 10 ns;
      if hold = '1' then
        wait;
      end if;
  end process clock_generate;

  stop_clk : process is
    begin
      reset_tb <= '1';
      wait for 2 ns;
      reset_tb <= '0';
      wait for 1000 ms;
      hold <= '1';
      wait;
  end process;

  process is
      variable my_line : line;
      file infile: text open read_mode is "ik_machine_input.in";
      variable inputa : std_logic_vector(31 downto 0);
      variable inputb : std_logic_vector(31 downto 0);
     begin
       while not (endfile(infile)) loop
         readline(infile, my_line);
         read(my_line, inputa);
         readline(infile, my_line);
         read(my_line, inputb);
         destx_tb <= inputa;
         desty_tb <= inputb;
         wait for 1 ms;
       end loop;
   end process;

end architecture;
