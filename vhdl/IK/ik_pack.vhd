library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package ik_pack is
  type vec_3 is array(0 to 2) of std_logic_vector(31 downto 0);
  type vec_4 is array(0 to 3) of std_logic_vector(31 downto 0);
  type mat_3 is array(0 to 3) of vec_3;
  type mat_4 is array(0 to 4) of vec_4;
  function slv_to_mat_3 (slv : std_logic_vector(287 downto 0))
                        return mat_3;
  function slv_to_mat_4 (slv : std_logic_vector(511 downto 0))
                        return mat_4;
  function mat_3_to_slv (mat : mat_3)
                       return std_logic_vector;
  function mat_4_to_slv (mat : mat_4)
                       return std_logic_vector;
  component cross_product
    port (
      a  : in  std_logic_vector(95 downto 0);
      b  : in  std_logic_vector(95 downto 0);
      cp : out std_logic_vector(95 downto 0)
    );
  end component cross_product;

end package ik_pack;

package body ik_pack is

function slv_to_vec_3 (slv : std_logic_vector(95 downto 0))
                      return vec_3 is
  variable VEC : vec_3;
begin
  VEC(0) := slv(95 downto 64);
  VEC(1) := slv(63 downto 32);
  VEC(2) := slv(31 downto 0);
  return VEC;
end slv_to_vec_3;

function slv_to_mat_3 (slv : std_logic_vector(287 downto 0))
                      return mat_3 is
  variable MAT : mat_3;
begin
  MAT(0)(0) := slv(287 downto 256);
  MAT(0)(1) := slv(255 downto 224);
  MAT(0)(2) := slv(223 downto 192);
  MAT(1)(0) := slv(191 downto 160);
  MAT(1)(1) := slv(159 downto 128);
  MAT(1)(2) := slv(127 downto 96);
  MAT(2)(0) := slv(95 downto 64);
  MAT(2)(1) := slv(63 downto 32);
  MAT(2)(2) := slv(31 downto 0);
  return MAT;
end slv_to_mat_3;

function slv_to_mat_4 (slv : std_logic_vector(511 downto 0))
                      return mat_4 is
  variable MAT : mat_4;
begin
  MAT(0)(0) := slv(511 downto 480);
  MAT(0)(1) := slv(479 downto 448);
  MAT(0)(2) := slv(447 downto 416);
  MAT(0)(3) := slv(415 downto 384);
  MAT(1)(0) := slv(383 downto 352);
  MAT(1)(1) := slv(351 downto 320);
  MAT(1)(2) := slv(319 downto 288);
  MAT(1)(3) := slv(287 downto 256);
  MAT(2)(0) := slv(255 downto 224);
  MAT(2)(1) := slv(223 downto 192);
  MAT(2)(2) := slv(191 downto 160);
  MAT(2)(3) := slv(159 downto 128);
  MAT(3)(0) := slv(127 downto 96);
  MAT(3)(1) := slv(95 downto 64);
  MAT(3)(2) := slv(63 downto 32);
  MAT(3)(3) := slv(31 downto 0);
  return MAT;
end slv_to_mat_4;

function vec_3_to_slv (vec : vec_3)
                     return std_logic_vector is
  variable slv : std_logic_vector(95 downto 0);
begin
  slv(95 downto 64) := vec(0);
  slv(63 downto 32) := vec(1);
  slv(31 downto 0) := vec(2);
  return slv;
end vec_3_to_slv;

function mat_3_to_slv (mat : mat_3)
                     return std_logic_vector is
  variable slv : std_logic_vector(287 downto 0);
begin
  slv(287 downto 256) := mat(0)(0);
  slv(255 downto 224) := mat(0)(1);
  slv(223 downto 192) := mat(0)(2);
  slv(191 downto 160) := mat(1)(0);
  slv(159 downto 128) := mat(1)(1);
  slv(127 downto 96) := mat(1)(2);
  slv(95 downto 64) := mat(2)(0);
  slv(63 downto 32) := mat(2)(1);
  slv(31 downto 0) := mat(2)(2);
  return slv;
end mat_3_to_slv;

function mat_4_to_slv (mat : mat_4)
                     return std_logic_vector is
  variable slv : std_logic_vector(511 downto 0);
begin
  slv(511 downto 480) := mat(0)(0);
  slv(479 downto 448) := mat(0)(1);
  slv(447 downto 416) := mat(0)(2);
  slv(415 downto 384) := mat(0)(3);
  slv(383 downto 352) := mat(1)(0);
  slv(351 downto 320) := mat(1)(1);
  slv(319 downto 288) := mat(1)(2);
  slv(287 downto 256) := mat(1)(3);
  slv(255 downto 224) := mat(2)(0);
  slv(223 downto 192) := mat(2)(1);
  slv(191 downto 160) := mat(2)(2);
  slv(159 downto 128) := mat(2)(3);
  slv(127 downto 96) := mat(3)(0);
  slv(95 downto 64) := mat(3)(1);
  slv(63 downto 32) := mat(3)(2);
  slv(31 downto 0) := mat(3)(3);
  return slv;
end mat_4_to_slv;
end package body ik_pack;
