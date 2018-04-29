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
                        return std_logic_vector(287 downto 0);
  function mat_4_to_slv (mat : mat_4)
                        return std_logic_vector(511 downto 0);
end package ik_pack;

package body ik_pack is
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
end package body ik_pack;
