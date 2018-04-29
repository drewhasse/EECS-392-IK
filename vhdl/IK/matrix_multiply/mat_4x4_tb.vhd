library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ik_pack.all;

entity mat_4x4_tb is
end entity;

architecture behavioral of mat_4x4_tb is
  component mat_4x4
  port (
    mat_4_l_in : in  std_logic_vector(511 downto 0);
    mat_4_r_in : in  std_logic_vector(511 downto 0);
    mat_4_out  : out std_logic_vector(511 downto 0)
  );
end component mat_4x4;
  signal mat_4_l_in_tb : std_logic_vector(511 downto 0);
  signal mat_4_r_in_tb : std_logic_vector(511 downto 0);
  signal mat_4_out_tb : std_logic_vector(511 downto 0);

  begin
    mat_4x4_i : mat_4x4
    port map (
      mat_4_l_in => mat_4_l_in_tb,
      mat_4_r_in => mat_4_r_in_tb,
      mat_4_out  => mat_4_out_tb
    );

  sim: process is
    variable temp_r, temp_l : mat_4;
    begin
      temp_r(0)(0) := (0=>'1', others => '0');
      temp_r(0)(1) := (0=>'1', others => '0');
      temp_r(0)(2) := (0=>'1', others => '0');
      temp_r(0)(3) := (0=>'1', others => '0');
      temp_r(1)(0) := (0=>'1', others => '0');
      temp_r(1)(1) := (0=>'1', others => '0');
      temp_r(1)(2) := (0=>'1', others => '0');
      temp_r(1)(3) := (0=>'1', others => '0');
      temp_r(2)(0) := (0=>'1', others => '0');
      temp_r(2)(1) := (0=>'1', others => '0');
      temp_r(2)(2) := (0=>'1', others => '0');
      temp_r(2)(3) := (0=>'1', others => '0');
      temp_r(3)(0) := (0=>'1', others => '0');
      temp_r(3)(1) := (0=>'1', others => '0');
      temp_r(3)(2) := (0=>'1', others => '0');
      temp_r(3)(3) := (0=>'1', others => '0');

      temp_l(0)(0) := (0=>'1', others => '0');
      temp_l(0)(1) := (0=>'1', others => '0');
      temp_l(0)(2) := (0=>'1', others => '0');
      temp_l(0)(3) := (0=>'1', others => '0');
      temp_l(1)(0) := (0=>'1', others => '0');
      temp_l(1)(1) := (0=>'1', others => '0');
      temp_l(1)(2) := (0=>'1', others => '0');
      temp_l(1)(3) := (0=>'1', others => '0');
      temp_l(2)(0) := (0=>'1', others => '0');
      temp_l(2)(1) := (0=>'1', others => '0');
      temp_l(2)(2) := (0=>'1', others => '0');
      temp_l(2)(3) := (0=>'1', others => '0');
      temp_l(3)(0) := (0=>'1', others => '0');
      temp_l(3)(1) := (0=>'1', others => '0');
      temp_l(3)(2) := (0=>'1', others => '0');
      temp_l(3)(3) := (0=>'1', others => '0');

      mat_4_l_in_tb <= mat_4_to_slv(temp_l);
      mat_4_r_in_tb <= mat_4_to_slv(temp_r);
      wait;
  end process sim;
end architecture;
