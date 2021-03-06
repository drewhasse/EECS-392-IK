library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;
  use work.cordic.all;

entity fk_comb is
  port (
  clk : std_logic;
  reset : std_logic;

  a0 : in std_logic_vector(31 downto 0);
  a1 : in std_logic_vector(31 downto 0);
  a2 : in std_logic_vector(31 downto 0);

  ex : out std_logic_vector(31 downto 0);
  ey : out std_logic_vector(31 downto 0);

  p1x : out std_logic_vector(31 downto 0);
  p1y : out std_logic_vector(31 downto 0);

  p2x : out std_logic_vector(31 downto 0);
  p2y : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavioral of fk_comb is
  signal vec_origin, vec_t2xo, vec_r2xt2, vec_t1xr2, vec_r1xt1, vec_t0xr1, vec_r0xt0 : std_logic_vector(95 downto 0) := (others => '0');
  signal vec1_t0xo, vec1_r0xt0 : std_logic_vector(95 downto 0);
  signal vec2_t1xo, vec2_r1xt1, vec2_t0xr1, vec2_r0xt0 : std_logic_vector(95 downto 0);
  signal ex_i, ex_i_c, ey_i, ey_i_c, p1x_i, p1x_i_c, p1y_i, p1y_i_c, p2x_i, p2x_i_c, p2y_i, p2y_i_c : std_logic_vector(31 downto 0);
  signal sin_a0, cos_a0, sin_a1, cos_a1, sin_a2, cos_a2 : signed(31 downto 0);
  signal mat_r0, mat_t0, mat_r1, mat_t1, mat_r2, mat_t2 : mat_3;
begin
  clocked : process(clk, reset) is
    begin
      if (reset = '1') then
        ex_i <= (others => '0');
        ey_i <= (others => '0');
        p1x_i <= (others => '0');
        p1y_i <= (others => '0');
        p2x_i <= (others => '0');
        p2y_i <= (others => '0');
      elsif (rising_edge(clk)) then
        ex_i <= ex_i_c;
        ey_i <= ey_i_c;
        p1x_i <= p1x_i_c;
        p1y_i <= p1y_i_c;
        p2x_i <= p2x_i_c;
        p2y_i <= p2y_i_c;
      end if;
  end process clocked;
--- Init signals
vec_origin <= (16 => '1', others => '0');
--- Calculate sin and cos of input angles
  sincos_a0 : sincos_pipelined
  generic map (
    SIZE               => 32,
    ITERATIONS         => 25,
    FRAC_BITS          => 16
  )
  port map (
    Clock        => clk,
    Reset        => reset,
    Angle        => rads_to_brads(a0),
    Sin          => sin_a0,
    Cos          => cos_a0
  );

  sincos_a1 : sincos_pipelined
  generic map (
    SIZE               => 32,
    ITERATIONS         => 25,
    FRAC_BITS          => 16
  )
  port map (
    Clock        => clk,
    Reset        => reset,
    Angle        => rads_to_brads(a1),
    Sin          => sin_a1,
    Cos          => cos_a1
  );

  sincos_a2 : sincos_pipelined
  generic map (
    SIZE               => 32,
    ITERATIONS         => 25,
    FRAC_BITS          => 16
  )
  port map (
    Clock        => clk,
    Reset        => reset,
    Angle        => rads_to_brads(a2),
    Sin          => sin_a2,
    Cos          => cos_a2
  );
--- End sin/cos calculation
--- Begin matrix formation
mat_r0(0)(0) <= std_logic_vector(cos_a0);
mat_r0(0)(1) <= std_logic_vector((NOT signed(sin_a0))+1);
mat_r0(0)(2) <= (others => '0');
mat_r0(1)(0) <= std_logic_vector(sin_a0);
mat_r0(1)(1) <= std_logic_vector(cos_a0);
mat_r0(1)(2) <= (others => '0');
mat_r0(2)(0) <= (others => '0');
mat_r0(2)(1) <= (others => '0');
mat_r0(2)(2) <= (16 => '1', others => '0');

mat_t0(0)(0) <= (16 => '1', others => '0');
mat_t0(0)(1) <= (others => '0');
mat_t0(0)(2) <= L0;
mat_t0(1)(0) <= (others => '0');
mat_t0(1)(1) <= (16 => '1', others => '0');
mat_t0(1)(2) <= (others => '0');
mat_t0(2)(0) <= (others => '0');
mat_t0(2)(1) <= (others => '0');
mat_t0(2)(2) <= (16 => '1', others => '0');

mat_r1(0)(0) <= std_logic_vector(cos_a1);
mat_r1(0)(1) <= std_logic_vector((NOT signed(sin_a1))+1);
mat_r1(0)(2) <= (others => '0');
mat_r1(1)(0) <= std_logic_vector(sin_a1);
mat_r1(1)(1) <= std_logic_vector(cos_a1);
mat_r1(1)(2) <= (others => '0');
mat_r1(2)(0) <= (others => '0');
mat_r1(2)(1) <= (others => '0');
mat_r1(2)(2) <= (16 => '1', others => '0');

mat_t1(0)(0) <= (16 => '1', others => '0');
mat_t1(0)(1) <= (others => '0');
mat_t1(0)(2) <= L1;
mat_t1(1)(0) <= (others => '0');
mat_t1(1)(1) <= (16 => '1', others => '0');
mat_t1(1)(2) <= (others => '0');
mat_t1(2)(0) <= (others => '0');
mat_t1(2)(1) <= (others => '0');
mat_t1(2)(2) <= (16 => '1', others => '0');

mat_r2(0)(0) <= std_logic_vector(cos_a2);
mat_r2(0)(1) <= std_logic_vector((NOT signed(sin_a2))+1);
mat_r2(0)(2) <= (others => '0');
mat_r2(1)(0) <= std_logic_vector(sin_a2);
mat_r2(1)(1) <= std_logic_vector(cos_a2);
mat_r2(1)(2) <= (others => '0');
mat_r2(2)(0) <= (others => '0');
mat_r2(2)(1) <= (others => '0');
mat_r2(2)(2) <= (16 => '1', others => '0');

mat_t2(0)(0) <= (16 => '1', others => '0');
mat_t2(0)(1) <= (others => '0');
mat_t2(0)(2) <= L2;
mat_t2(1)(0) <= (others => '0');
mat_t2(1)(1) <= (16 => '1', others => '0');
mat_t2(1)(2) <= (others => '0');
mat_t2(2)(0) <= (others => '0');
mat_t2(2)(1) <= (others => '0');
mat_t2(2)(2) <= (16 => '1', others => '0');
--- End matrix formation
--- Begin matrix vector multiplication
--- Calculate E
mat_3x1_t2xo : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_t2),
  vec_3_r_in => vec_origin,
  vec_3_out => vec_t2xo
);
mat_3x1_r2xt2 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_r2),
  vec_3_r_in => vec_t2xo,
  vec_3_out => vec_r2xt2
);
mat_3x1_t1xr2 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_t1),
  vec_3_r_in => vec_r2xt2,
  vec_3_out => vec_t1xr2
);
mat_3x1_r1xt1 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_r1),
  vec_3_r_in => vec_t1xr2,
  vec_3_out => vec_r1xt1
);
mat_3x1_t0xr1 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_t0),
  vec_3_r_in => vec_r1xt1,
  vec_3_out => vec_t0xr1
);
mat_3x1_r0xt0 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_r0),
  vec_3_r_in => vec_t0xr1,
  vec_3_out => vec_r0xt0
);
--- Calculate P2
mat2_3x1_t1xr2 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_t1),
  vec_3_r_in => vec_origin,
  vec_3_out => vec2_t1xo
);
mat2_3x1_r1xt1 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_r1),
  vec_3_r_in => vec2_t1xo,
  vec_3_out => vec2_r1xt1
);
mat2_3x1_t0xr1 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_t0),
  vec_3_r_in => vec2_r1xt1,
  vec_3_out => vec2_t0xr1
);
mat2_3x1_r0xt0 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_r0),
  vec_3_r_in => vec2_t0xr1,
  vec_3_out => vec2_r0xt0
);
--- Calculate P1
mat1_3x1_t0xr1 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_t0),
  vec_3_r_in => vec_origin,
  vec_3_out => vec1_t0xo
);
mat1_3x1_r0xt0 : mat_3x1
port map (
  mat_3_l_in => mat_3_to_slv(mat_r0),
  vec_3_r_in => vec1_t0xo,
  vec_3_out => vec1_r0xt0
);
--- END MATRIX CALCULATION
ex_i_c <= vec_r0xt0(95 downto 64);
ey_i_c <= vec_r0xt0(63 downto 32);
ex <= ex_i;
ey <= ey_i;

p1x_i_c <= vec1_r0xt0(95 downto 64);
p1y_i_c <= vec1_r0xt0(63 downto 32);
p1x <= p1x_i;
p1y <= p1y_i;

p2x_i_c <= vec2_r0xt0(95 downto 64);
p2y_i_c <= vec2_r0xt0(63 downto 32);
p2x <= p2x_i;
p2y <= p2y_i;
--- End matrix vector multiplication
end architecture;
