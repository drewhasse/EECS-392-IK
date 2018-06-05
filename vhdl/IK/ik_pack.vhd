library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package ik_pack is
  constant TWO_PI : std_logic_vector(31 downto 0) := "00000000000001100100100001111110";
  constant L0 : std_logic_vector(31 downto 0) := "00000000000001101000110001100110";
  constant L1 : std_logic_vector(31 downto 0) := "00000000000001100010011011001100";
  constant L2 : std_logic_vector(31 downto 0) := "00000000000010101011011100110011";
  constant MAX_PULSE : std_logic_vector(35 downto 0) := "011110100001001000000000000000000000";
  constant MIN_PULSE : std_logic_vector(35 downto 0) := "000110000110101000000000000000000000";
  constant ALPHA : std_logic_vector(31 downto 0) := "00000000000000000000000000000001";
  constant THRESH : signed(31 downto 0) := "00000000000000010000000000000000";
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
  function vec_3_add (v1 : vec_3; v2 : vec_3)
                       return vec_3;
  function vec_3_mul (v1 : vec_3; v2 : vec_3)
                       return vec_3;
  function vec_3_srl (v1 : vec_3; x : integer)
                       return vec_3;
  function rads_to_brads (rads : std_logic_vector(31 downto 0))
                       return signed;
  function rads_to_pulse (rads : std_logic_vector(31 downto 0))
                       return std_logic_vector;

  component jacobian_t
  port (
    e     : in  std_logic_vector(95 downto 0);
    p1    : in  std_logic_vector(95 downto 0);
    p2    : in  std_logic_vector(95 downto 0);
    j_out : out std_logic_vector(287 downto 0)
  );
  end component jacobian_t;

  component UART_nByte
    generic (
      n            : natural := 4;
      CLKS_PER_BIT : natural := 434
    );
    port (
      clk        : in  std_logic;
      reset      : in  std_logic;
      RX         : in  std_logic;
      dout       : out std_logic_vector(n*8-1 downto 0);
      data_valid : out std_logic
    );
  end component UART_nByte;

  component UART_R
    generic (
      CLKS_PER_BIT : natural := 434
    );
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      RX      : in  std_logic;
      RX_DV   : out std_logic;
      RX_byte : out std_logic_vector(7 downto 0)
    );
  end component UART_R;



  component PWM_TOP is
    port (
    clk : in std_logic;
    reset : in std_logic;
    hold : in std_logic;
    a0 : in std_logic_vector(31 downto 0);
    a1 : in std_logic_vector(31 downto 0);
    a2 : in std_logic_vector(31 downto 0);
    a3 : in std_logic_vector(31 downto 0);
    a4 : in std_logic_vector(31 downto 0);
    a5 : in std_logic_vector(31 downto 0);
    pulse : out std_logic_vector(5 downto 0)
    );
  end component PWM_TOP;

  component PWM
  port (
    clk    : in  std_logic;
    reset  : in  std_logic;
    hold   : in  std_logic;
    length : in  std_logic_vector(31 downto 0);
    pulse  : out std_logic
  );
  end component PWM;

  component counter
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    hold  : in  std_logic;
    pulse : out std_logic
  );
  end component counter;

  component ik_machine
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    pulse : in  std_logic;
    destx : in  std_logic_vector(31 downto 0);
    desty : in  std_logic_vector(31 downto 0);
    a0    : out std_logic_vector(31 downto 0);
    a1    : out std_logic_vector(31 downto 0);
    a2    : out std_logic_vector(31 downto 0)
  );
  end component ik_machine;

  component ik
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    destx : in  std_logic_vector(31 downto 0);
    desty : in  std_logic_vector(31 downto 0);
    a0    : out std_logic_vector(31 downto 0);
    a1    : out std_logic_vector(31 downto 0);
    a2    : out std_logic_vector(31 downto 0)
  );
  end component ik;

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

function vec_3_add (v1 : vec_3; v2 : vec_3)
                     return vec_3 is
  variable vout : vec_3;
begin
  vout(0) := std_logic_vector(signed(v1(0))+signed(v2(0)));
  vout(1) := std_logic_vector(signed(v1(1))+signed(v2(1)));
  vout(2) := std_logic_vector(signed(v1(2))+signed(v2(2)));
  return vout;
end vec_3_add;

function vec_3_mul (v1 : vec_3; v2 : vec_3)
                     return vec_3 is
  variable vout : vec_3;
begin
  vout(0) := std_logic_vector(resize(unsigned((signed(v1(0))*signed(v2(0))) SRL 16), 32));
  vout(1) := std_logic_vector(resize(unsigned((signed(v1(1))*signed(v2(1))) SRL 16), 32));
  vout(2) := std_logic_vector(resize(unsigned((signed(v1(2))*signed(v2(2))) SRL 16), 32));
  return vout;
end vec_3_mul;

function vec_3_srl (v1 : vec_3; x : integer)
                     return vec_3 is
  variable vout : vec_3;
begin
  vout(0) := std_logic_vector(resize(signed(resize(unsigned(signed(v1(0)) SRL x),(32-x))),32));
  vout(1) := std_logic_vector(resize(signed(resize(unsigned(signed(v1(1)) SRL x),(32-x))),32));
  vout(2) := std_logic_vector(resize(signed(resize(unsigned(signed(v1(2)) SRL x),(32-x))),32));
  return vout;
end vec_3_srl;


function rads_to_brads (rads : std_logic_vector(31 downto 0))
                     return signed is
  variable to_brads : std_logic_vector(31 downto 0);
begin
  --if(signed(rads) < 0) then
  --  to_brads := std_logic_vector(signed(rads)+signed(TWO_PI));
  --else
    to_brads := rads;
  --end if;
  return signed( resize(unsigned(((resize(signed(to_brads),48) SLL 16) / signed(TWO_PI)) SLL 16),32));
end rads_to_brads;

function rads_to_pulse (rads : std_logic_vector(31 downto 0))
                     return std_logic_vector is
  variable pos : signed(31 downto 0);
  variable norm, scaled : unsigned(31 downto 0);
  variable max_min : unsigned(35 downto 0);
  variable tmp : std_logic_vector(31 downto 0);
begin
  pos := signed(rads) + signed'("00000000000000011001001000011111");
  if(pos > signed'("00000000000000110010010000111111")) then
    pos := signed'("00000000000000110010010000111111");
  elsif(pos < signed'(X"00000000")) then
    pos := (others => '0');
  end if;
  norm := resize((resize(unsigned(pos),48) SLL 16) / unsigned'("00000000000000110010010000111111"),32);
  max_min := unsigned(MAX_PULSE) - unsigned(MIN_PULSE);
  scaled := resize(((unsigned(norm)*unsigned(max_min)) SRL 34),32);
  tmp := std_logic_vector((scaled + resize((unsigned(MIN_PULSE) SRL 18),32)));
  return tmp;
end rads_to_pulse;

end package body ik_pack;
