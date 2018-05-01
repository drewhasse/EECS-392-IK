library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;

entity mat_4x4 is
  port (
  mat_4_l_in : in std_logic_vector(511 downto 0);
  mat_4_r_in : in std_logic_vector(511 downto 0);
  mat_4_out : out std_logic_vector(511 downto 0)
  );
end entity;

architecture behavioral of mat_4x4 is
  signal mat_4_l, mat_4_r, mat_4_int : mat_4;
begin
  mat_4_l <= slv_to_mat_4(mat_4_l_in);
  mat_4_r <= slv_to_mat_4(mat_4_r_in);
  mat_4_int(0)(0) <= std_logic_vector(resize((
                    ((signed(mat_4_l(0)(0))*signed(mat_4_r(0)(0)))+
                     (signed(mat_4_l(0)(1))*signed(mat_4_r(1)(0)))+
                     (signed(mat_4_l(0)(2))*signed(mat_4_r(2)(0)))+
                     (signed(mat_4_l(0)(3))*signed(mat_4_r(3)(0)))) SRL 16), 32));
  mat_4_int(0)(1) <= std_logic_vector(resize((
                    ((signed(mat_4_l(0)(0))*signed(mat_4_r(0)(1)))+
                     (signed(mat_4_l(0)(1))*signed(mat_4_r(1)(1)))+
                     (signed(mat_4_l(0)(2))*signed(mat_4_r(2)(1)))+
                     (signed(mat_4_l(0)(3))*signed(mat_4_r(3)(1)))) SRL 16), 32));
  mat_4_int(0)(2) <= std_logic_vector(resize((
                    ((signed(mat_4_l(0)(0))*signed(mat_4_r(0)(2)))+
                     (signed(mat_4_l(0)(1))*signed(mat_4_r(1)(2)))+
                     (signed(mat_4_l(0)(2))*signed(mat_4_r(2)(2)))+
                     (signed(mat_4_l(0)(3))*signed(mat_4_r(3)(2)))) SRL 16), 32));
  mat_4_int(0)(3) <= std_logic_vector(resize((
                    ((signed(mat_4_l(0)(0))*signed(mat_4_r(0)(3)))+
                     (signed(mat_4_l(0)(1))*signed(mat_4_r(1)(3)))+
                     (signed(mat_4_l(0)(2))*signed(mat_4_r(2)(3)))+
                     (signed(mat_4_l(0)(3))*signed(mat_4_r(3)(3)))) SRL 16), 32));
  mat_4_int(1)(0) <= std_logic_vector(resize((
                    ((signed(mat_4_l(1)(0))*signed(mat_4_r(0)(0)))+
                     (signed(mat_4_l(1)(1))*signed(mat_4_r(1)(0)))+
                     (signed(mat_4_l(1)(2))*signed(mat_4_r(2)(0)))+
                     (signed(mat_4_l(1)(3))*signed(mat_4_r(3)(0)))) SRL 16), 32));
  mat_4_int(1)(1) <= std_logic_vector(resize((
                    ((signed(mat_4_l(1)(0))*signed(mat_4_r(0)(1)))+
                     (signed(mat_4_l(1)(1))*signed(mat_4_r(1)(1)))+
                     (signed(mat_4_l(1)(2))*signed(mat_4_r(2)(1)))+
                     (signed(mat_4_l(1)(3))*signed(mat_4_r(3)(1)))) SRL 16), 32));
  mat_4_int(1)(2) <= std_logic_vector(resize((
                    ((signed(mat_4_l(1)(0))*signed(mat_4_r(0)(2)))+
                     (signed(mat_4_l(1)(1))*signed(mat_4_r(1)(2)))+
                     (signed(mat_4_l(1)(2))*signed(mat_4_r(2)(2)))+
                     (signed(mat_4_l(1)(3))*signed(mat_4_r(3)(2)))) SRL 16), 32));
  mat_4_int(1)(3) <= std_logic_vector(resize((
                    ((signed(mat_4_l(1)(0))*signed(mat_4_r(0)(3)))+
                     (signed(mat_4_l(1)(1))*signed(mat_4_r(1)(3)))+
                     (signed(mat_4_l(1)(2))*signed(mat_4_r(2)(3)))+
                     (signed(mat_4_l(1)(3))*signed(mat_4_r(3)(3)))) SRL 16), 32));
  mat_4_int(2)(0) <= std_logic_vector(resize((
                    ((signed(mat_4_l(2)(0))*signed(mat_4_r(0)(0)))+
                     (signed(mat_4_l(2)(1))*signed(mat_4_r(1)(0)))+
                     (signed(mat_4_l(2)(2))*signed(mat_4_r(2)(0)))+
                     (signed(mat_4_l(2)(3))*signed(mat_4_r(3)(0)))) SRL 16), 32));
  mat_4_int(2)(1) <= std_logic_vector(resize((
                    ((signed(mat_4_l(2)(0))*signed(mat_4_r(0)(1)))+
                     (signed(mat_4_l(2)(1))*signed(mat_4_r(1)(1)))+
                     (signed(mat_4_l(2)(2))*signed(mat_4_r(2)(1)))+
                     (signed(mat_4_l(2)(3))*signed(mat_4_r(3)(1)))) SRL 16), 32));
  mat_4_int(2)(2) <= std_logic_vector(resize((
                    ((signed(mat_4_l(2)(0))*signed(mat_4_r(0)(2)))+
                     (signed(mat_4_l(2)(1))*signed(mat_4_r(1)(2)))+
                     (signed(mat_4_l(2)(2))*signed(mat_4_r(2)(2)))+
                     (signed(mat_4_l(2)(3))*signed(mat_4_r(3)(2)))) SRL 16), 32));
  mat_4_int(2)(3) <= std_logic_vector(resize((
                    ((signed(mat_4_l(2)(0))*signed(mat_4_r(0)(3)))+
                     (signed(mat_4_l(2)(1))*signed(mat_4_r(1)(3)))+
                     (signed(mat_4_l(2)(2))*signed(mat_4_r(2)(3)))+
                     (signed(mat_4_l(2)(3))*signed(mat_4_r(3)(3)))) SRL 16), 32));
  mat_4_int(3)(0) <= std_logic_vector(resize((
                    ((signed(mat_4_l(3)(0))*signed(mat_4_r(0)(0)))+
                     (signed(mat_4_l(3)(1))*signed(mat_4_r(1)(0)))+
                     (signed(mat_4_l(3)(2))*signed(mat_4_r(2)(0)))+
                     (signed(mat_4_l(3)(3))*signed(mat_4_r(3)(0)))) SRL 16), 32));
  mat_4_int(3)(1) <= std_logic_vector(resize((
                    ((signed(mat_4_l(3)(0))*signed(mat_4_r(0)(1)))+
                     (signed(mat_4_l(3)(1))*signed(mat_4_r(1)(1)))+
                     (signed(mat_4_l(3)(2))*signed(mat_4_r(2)(1)))+
                     (signed(mat_4_l(3)(3))*signed(mat_4_r(3)(1)))) SRL 16), 32));
  mat_4_int(3)(2) <= std_logic_vector(resize((
                    ((signed(mat_4_l(3)(0))*signed(mat_4_r(0)(2)))+
                     (signed(mat_4_l(3)(1))*signed(mat_4_r(1)(2)))+
                     (signed(mat_4_l(3)(2))*signed(mat_4_r(2)(2)))+
                     (signed(mat_4_l(3)(3))*signed(mat_4_r(3)(2)))) SRL 16), 32));
  mat_4_int(3)(3) <= std_logic_vector(resize((
                    ((signed(mat_4_l(3)(0))*signed(mat_4_r(0)(3)))+
                     (signed(mat_4_l(3)(1))*signed(mat_4_r(1)(3)))+
                     (signed(mat_4_l(3)(2))*signed(mat_4_r(2)(3)))+
                     (signed(mat_4_l(3)(3))*signed(mat_4_r(3)(3)))) SRL 16), 32));
  mat_4_out <= mat_4_to_slv(mat_4_int);
end architecture;
