library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;

entity mat_4x1 is
  port (
  mat_4_l_in : in std_logic_vector(511 downto 0);
  vec_4_r_in : in std_logic_vector(127 downto 0);
  vec_4_out : out std_logic_vector(127 downto 0)
  );
end entity;

architecture behavioral of mat_4x1 is
  signal mat_4_l : mat_4;
  signal vec_4_r, vec_4_int : vec_4;
begin
  mat_4_l <= slv_to_mat_4(mat_4_l_in);
  vec_4_r <= slv_to_vec_4(vec_4_r_in);
  vec_4_int(0) <= std_logic_vector(resize(
                    ((signed(mat_4_l(0)(0))*signed(vec_4_r(0)))+
                     (signed(mat_4_l(0)(1))*signed(vec_4_r(1)))+
                     (signed(mat_4_l(0)(2))*signed(vec_4_r(2)))+
                     (signed(mat_4_l(0)(3))*signed(vec_4_r(3)))),32));
  vec_4_int(1) <= std_logic_vector(resize(
                    ((signed(mat_4_l(1)(0))*signed(vec_4_r(0)))+
                     (signed(mat_4_l(1)(1))*signed(vec_4_r(1)))+
                     (signed(mat_4_l(1)(2))*signed(vec_4_r(2)))+
                     (signed(mat_4_l(1)(3))*signed(vec_4_r(3)))),32));
  vec_4_int(2) <= std_logic_vector(resize(
                    ((signed(mat_4_l(2)(0))*signed(vec_4_r(0)))+
                     (signed(mat_4_l(2)(1))*signed(vec_4_r(1)))+
                     (signed(mat_4_l(2)(2))*signed(vec_4_r(2)))+
                     (signed(mat_4_l(2)(3))*signed(vec_4_r(3)))),32));
  vec_4_int(3) <= std_logic_vector(resize(
                    ((signed(mat_4_l(3)(0))*signed(vec_4_r(0)))+
                     (signed(mat_4_l(3)(1))*signed(vec_4_r(1)))+
                     (signed(mat_4_l(3)(2))*signed(vec_4_r(2)))+
                     (signed(mat_4_l(3)(3))*signed(vec_4_r(3)))),32));
  vec_4_out <= vec_4_to_slv(vec_4_int);
end architecture;
