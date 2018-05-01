library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ik_pack.all;

entity mat_3x3_tb is
end entity;

architecture behavioral of mat_3x3_tb is
  component mat_3x3
  port (
    mat_3_l_in : in  std_logic_vector(287 downto 0);
    mat_3_r_in : in  std_logic_vector(287 downto 0);
    mat_3_out  : out std_logic_vector(287 downto 0)
  );
  end component mat_3x3;
  signal mat_3_l_in_tb : std_logic_vector(287 downto 0);
  signal mat_3_r_in_tb : std_logic_vector(287 downto 0);
  signal mat_3_out_tb : std_logic_vector(287 downto 0);

  begin
    mat_3x3_i : mat_3x3
    port map (
      mat_3_l_in => mat_3_l_in_tb,
      mat_3_r_in => mat_3_r_in_tb,
      mat_3_out  => mat_3_out_tb
    );

  sim: process is
    variable temp_r, temp_l : mat_3;
    begin
      temp_r(0)(0) := (16=>'1', others => '0');
      temp_r(0)(1) := (16=>'1', others => '0');
      temp_r(0)(2) := (16=>'1', others => '0');
      temp_r(1)(0) := (16=>'1', others => '0');
      temp_r(1)(1) := (16=>'1', others => '0');
      temp_r(1)(2) := (16=>'1', others => '0');
      temp_r(2)(0) := (16=>'1', others => '0');
      temp_r(2)(1) := (16=>'1', others => '0');
      temp_r(2)(2) := (16=>'1', others => '0');

      temp_l(0)(0) := (16=>'1', others => '0');
      temp_l(0)(1) := (16=>'1', others => '0');
      temp_l(0)(2) := (16=>'1', others => '0');
      temp_l(1)(0) := (16=>'1', others => '0');
      temp_l(1)(1) := (16=>'1', others => '0');
      temp_l(1)(2) := (16=>'1', others => '0');
      temp_l(2)(0) := (16=>'1', others => '0');
      temp_l(2)(1) := (16=>'1', others => '0');
      temp_l(2)(2) := (16=>'1', others => '0');

      mat_3_l_in_tb <= mat_3_to_slv(temp_l);
      mat_3_r_in_tb <= mat_3_to_slv(temp_r);
      wait;
  end process sim;
end architecture;
