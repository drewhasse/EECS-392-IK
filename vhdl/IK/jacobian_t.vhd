library IEEE;
use IEEE.std_logic_1164.all;
use numeric_std.all;
use work.ik_pack.all;

entity jacobian_t is
  port (
  e : in std_logic_vector(95 downto 0);
  p1 : in std_logic_vector(95 downto 0);
  p2 : in std_logic_vector(95 downto 0)
  j_t : out std_logic_vector(287 downto 0)
  );
end entity;

architecture dataflow of jacobian_t is

  signal e_v, p1_v, p2_v, vce_v : vec_3;
  signal emp1, emp2 : std_logic_vector(95 downto 0);
  signal j_mat : mat_3;
  signal vec001 : std_logic_vector(95 downto 0) := (0=>'1', others=>'0');
  signal v_cross_e : std_logic_vector(95 downto 0);

begin
  e_v <= slv_to_vec_3(e);
  p1_v <= slv_to_vec_3(p1);
  p2_v <= slv_to_vec_3(p2);
  vce_v <= slv_to_vec_3(v_cross_e);

  j_t <= mat_3_to_slv(j_mat);

  cross_e : cross_product
    port map(a=>e, b=>vec001, cp=>v_cross_e);


  j_mat(0)(0) <= vce_v(0);
  j_mat(0)(1) <= vce_v(1);
  j_mat(0)(2) <= vce_v(2);


end architecture;
