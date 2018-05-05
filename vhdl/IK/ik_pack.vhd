library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package ik_pack is
  constant TWO_PI : std_logic_vector(31 downto 0) := "00000000000001100100100001111110";
  constant L0 : std_logic_vector(31 downto 0) := "00000000000000010000000000000000";
  constant L1 : std_logic_vector(31 downto 0) := "00000000000000010000000000000000";
  constant L2 : std_logic_vector(31 downto 0) := "00000000000000010000000000000000";
  type vec_3 is array(0 to 2) of std_logic_vector(31 downto 0);
  type vec_4 is array(0 to 3) of std_logic_vector(31 downto 0);
  type mat_3 is array(0 to 2) of vec_3;
  type mat_4 is array(0 to 3) of vec_4;
  function slv_to_vec_3 (slv : std_logic_vector(95 downto 0))
                        return vec_3;
  function slv_to_vec_4 (slv : std_logic_vector(127 downto 0))
                        return vec_4;
  function slv_to_mat_3 (slv : std_logic_vector(287 downto 0))
                        return mat_3;
  function slv_to_mat_4 (slv : std_logic_vector(511 downto 0))
                        return mat_4;
  function mat_3_to_slv (mat : mat_3)
                       return std_logic_vector;
  function mat_4_to_slv (mat : mat_4)
                       return std_logic_vector;
  function vec_3_to_slv (vec : vec_3)
                       return std_logic_vector;
  function vec_4_to_slv (vec : vec_4)
                       return std_logic_vector;
  function vec_3_sub (v1 : vec_3; v2 : vec_3)
                       return vec_3;
  function rads_to_brads (rads : std_logic_vector(31 downto 0))
                       return signed;
  component fk_comb
    port (
      clk : in std_logic;
      reset : in std_logic;
      a0 : in  std_logic_vector(31 downto 0);
      a1 : in  std_logic_vector(31 downto 0);
      a2 : in  std_logic_vector(31 downto 0);
      ex : out std_logic_vector(31 downto 0);
      ey : out std_logic_vector(31 downto 0);
      p1x : out std_logic_vector(31 downto 0);
      p1y : out std_logic_vector(31 downto 0);
      p2x : out std_logic_vector(31 downto 0);
      p2y : out std_logic_vector(31 downto 0)
    );
  end component fk_comb;

  component cross_product
    port (
      a  : in  std_logic_vector(95 downto 0);
      b  : in  std_logic_vector(95 downto 0);
      cp : out std_logic_vector(95 downto 0)
    );
  end component cross_product;

  component mat_4x1
  port (
    mat_4_l_in : in  std_logic_vector(511 downto 0);
    vec_4_r_in : in  std_logic_vector(127 downto 0);
    vec_4_out  : out std_logic_vector(127 downto 0)
  );
  end component mat_4x1;

  component mat_3x1
  port (
    mat_3_l_in : in  std_logic_vector(287 downto 0);
    vec_3_r_in : in  std_logic_vector(95 downto 0);
    vec_3_out  : out std_logic_vector(95 downto 0)
  );
  end component mat_3x1;

  component mat_4x4
  port (
    mat_4_l_in : in  std_logic_vector(511 downto 0);
    mat_4_r_in : in  std_logic_vector(511 downto 0);
    mat_4_out  : out std_logic_vector(511 downto 0)
  );
  end component mat_4x4;

  component mat_3x3
  port (
    mat_3_l_in : in  std_logic_vector(287 downto 0);
    mat_3_r_in : in  std_logic_vector(287 downto 0);
    mat_3_out  : out std_logic_vector(287 downto 0)
  );
  end component mat_3x3;

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

function slv_to_vec_4 (slv : std_logic_vector(127 downto 0))
                      return vec_4 is
  variable VEC : vec_4;
begin
  VEC(0) := slv(127 downto 96);
  VEC(1) := slv(95 downto 64);
  VEC(2) := slv(63 downto 32);
  VEC(3) := slv(31 downto 0);
  return VEC;
end slv_to_vec_4;

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

function vec_4_to_slv (vec : vec_4)
                     return std_logic_vector is
  variable slv : std_logic_vector(127 downto 0);
begin
  slv(127 downto 96) := vec(0);
  slv(95 downto 64) := vec(1);
  slv(63 downto 32) := vec(2);
  slv(31 downto 0) := vec(3);
  return slv;
end vec_4_to_slv;

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

function vec_3_sub (v1 : vec_3; v2 : vec_3)
                     return vec_3 is
  variable vout : vec_3;
begin
  vout(0) := std_logic_vector(signed(v1(0))-signed(v2(0)));
  vout(1) := std_logic_vector(signed(v1(1))-signed(v2(1)));
  vout(2) := std_logic_vector(signed(v1(2))-signed(v2(2)));
  return vout;
end vec_3_sub;

function rads_to_brads (rads : std_logic_vector(31 downto 0))
                     return signed is
begin
  return signed( resize((((resize(signed(rads),48) SLL 16) / signed(TWO_PI)) SLL 16),32));
end rads_to_brads;

end package body ik_pack;
