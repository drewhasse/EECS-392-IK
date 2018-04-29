library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ik_pack.all;

entity jacobian_t is
  port (
  e : in std_logic_vector(95 downto 0);
  p1 : in std_logic_vector(95 downto 0);
  p2 : in std_logic_vector(95 downto 0);
  j_out : out std_logic_vector(287 downto 0)
  );
end entity;

architecture dataflow of jacobian_t is

  signal e_v, p1_v, p2_v, vce_v, vcemp1_v, vcemp2_v, emp1, emp2 : vec_3;
  signal j_mat : mat_3;
  signal vec001 : std_logic_vector(95 downto 0) := (0=>'1', others=>'0');
  signal v_cross_e, v_cross_emp1, v_cross_emp2 : std_logic_vector(95 downto 0);

begin
  e_v <= slv_to_vec_3(e);
  p1_v <= slv_to_vec_3(p1);
  p2_v <= slv_to_vec_3(p2);

  emp1 <= vec_3_sub(e_v,p1_v);
  emp2 <= vec_3_sub(e_v,p2_v);

  vce_v <= slv_to_vec_3(v_cross_e);
  vcemp1_v <= slv_to_vec_3(v_cross_emp1);
  vcemp2_v <= slv_to_vec_3(v_cross_emp2);

  cross_e : cross_product
    port map(a=>vec001, b=>e, cp=>v_cross_e);
  cross_emp1 : cross_product
    port map(a=>vec001, b=>vec_3_to_slv(emp1), cp=>v_cross_emp1);
  cross_emp2 : cross_product
    port map(a=>vec001, b=>vec_3_to_slv(emp2), cp=>v_cross_emp2);

  j_mat(0)(0) <= vce_v(0);
  j_mat(0)(1) <= vce_v(1);
  j_mat(0)(2) <= vce_v(2);

  j_mat(1)(0) <= vcemp1_v(0);
  j_mat(1)(1) <= vcemp1_v(1);
  j_mat(1)(2) <= vcemp1_v(2);

  j_mat(2)(0) <= vcemp2_v(0);
  j_mat(2)(1) <= vcemp2_v(1);
  j_mat(2)(2) <= vcemp2_v(2);

  j_out <= mat_3_to_slv(j_mat);
end architecture;
