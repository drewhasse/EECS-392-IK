library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;

entity mat_3x1 is
  port (
  mat_3_l_in : in std_logic_vector(287 downto 0);
  vec_3_r_in : in std_logic_vector(95 downto 0);
  vec_3_out : out std_logic_vector(95 downto 0)
  );
end entity;

architecture behavioral of mat_3x1 is
  signal mat_3_l : mat_3;
  signal vec_3_r, vec_3_int : vec_3;
begin
  mat_3_l <= slv_to_mat_3(mat_3_l_in);
  vec_3_r <= slv_to_vec_3(vec_3_r_in);
  vec_3_int(0) <= std_logic_vector(resize((
                    ((signed(mat_3_l(0)(0))*signed(vec_3_r(0)))+
                     (signed(mat_3_l(0)(1))*signed(vec_3_r(1)))+
                     (signed(mat_3_l(0)(2))*signed(vec_3_r(2)))) SRL 16), 32));
  vec_3_int(1) <= std_logic_vector(resize((
                    ((signed(mat_3_l(1)(0))*signed(vec_3_r(0)))+
                     (signed(mat_3_l(1)(1))*signed(vec_3_r(1)))+
                     (signed(mat_3_l(1)(2))*signed(vec_3_r(2)))) SRL 16), 32));
  vec_3_int(2) <= std_logic_vector(resize((
                    ((signed(mat_3_l(2)(0))*signed(vec_3_r(0)))+
                     (signed(mat_3_l(2)(1))*signed(vec_3_r(1)))+
                     (signed(mat_3_l(2)(2))*signed(vec_3_r(2)))) SRL 16), 32));
  vec_3_out <= vec_3_to_slv(vec_3_int);
end architecture;
