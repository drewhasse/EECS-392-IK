library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ik_pack.all;

entity mat_3x1_tb is
end entity;

architecture behavioral of mat_3x1_tb is
  component mat_3x1
  port (
    mat_3_l_in : in  std_logic_vector(287 downto 0);
    vec_3_r_in : in std_logic_vector(95 downto 0);
    vec_3_out : out std_logic_vector(95 downto 0)
  );
end component mat_3x1;
  signal mat_3_l_in_tb : std_logic_vector(287 downto 0);
  signal vec_3_r_in_tb : std_logic_vector(95 downto 0);
  signal vec_3_out_tb : std_logic_vector(95 downto 0);

  begin
    mat_3x1_i : mat_3x1
    port map (
      mat_3_l_in => mat_3_l_in_tb,
      vec_3_r_in => vec_3_r_in_tb,
      vec_3_out  => vec_3_out_tb
    );


  sim: process is
    variable temp_l : mat_3;
    variable temp_r : vec_3;
    begin
      temp_l(0)(0) := x"ffff0000";
      temp_l(0)(1) := x"ffff0000";
      temp_l(0)(2) := x"ffff0000";
      temp_l(1)(0) := x"ffff0000";
      temp_l(1)(1) := x"ffff0000";
      temp_l(1)(2) := x"ffff0000";
      temp_l(2)(0) := x"ffff0000";
      temp_l(2)(1) := x"ffff0000";
      temp_l(2)(2) := x"ffff0000";

      temp_r(0) := x"00010000";
      temp_r(1) := x"00010000";
      temp_r(2) := x"00010000";

      mat_3_l_in_tb <= mat_3_to_slv(temp_l);
      vec_3_r_in_tb <= vec_3_to_slv(temp_r);
      wait;
  end process sim;
end architecture;
