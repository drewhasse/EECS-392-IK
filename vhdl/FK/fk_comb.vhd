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
  );
end entity;

architecture behavioral of fk_comb is
  signal vec_r0, vec_t0, vec_r1, vec_t1, vec_r2, vec_t2 : std_logic_vector(95 downto 0);
  signal ex_i, ex_i_c, ey_i, ey_i_c : std_logic_vector(31 downto 0);
  signal sin_a0, cos_a0, sin_a0, cos_a0, sin_a0, cos_a0 : std_logic_vector(31 downto 0);
  signal mat_r0, mat_t0, mat_r1, mat_t1, mat_r2, mat_t2 : mat_3;
begin
  clocked : process(clk, reset) is
    begin
      if (reset = '1') then
        ex_i <= (others => '0');
        ey_i <= (others => '0');
      elsif (rising_edge(clk)) then
        ex_i <= ex_i_c;
        ey_i <= ey_i_c;
      end if;
  end process clocked;
--- Calculate sin and cos of input angles
  sincos_a0 : sincos_pipelined
  generic map (
    SIZE               => 32,
    ITERATIONS         => 5,
    FRAC_BITS          => 16
  )
  port map (
    Clock        => clk,
    Reset        => reset,
    Angle        => signed(rads_to_brads(a0),
    Sin          => sin_a0,
    Cos          => cos_a0
  );

  sincos_a1 : sincos_pipelined
  generic map (
    SIZE               => 32,
    ITERATIONS         => 5,
    FRAC_BITS          => 16
  )
  port map (
    Clock        => clk,
    Reset        => reset,
    Angle        => signed(rads_to_brads(a1),
    Sin          => sin_a1,
    Cos          => cos_a1
  );

  sincos_a2 : sincos_pipelined
  generic map (
    SIZE               => 32,
    ITERATIONS         => 5,
    FRAC_BITS          => 16
  )
  port map (
    Clock        => clk,
    Reset        => reset,
    Angle        => signed(rads_to_brads(a2),
    Sin          => sin_a2,
    Cos          => cos_a2
  );
--- End sin/cos calculation

mat_r0(0)(0) <= cos_a0;
mat_r0(0)(1) <= std_logic_vector((NOT signed(sin_a0))+1);
mat_r0(0)(2) <= (others => '0');
mat_r0(1)(0) <= sin_a0;
mat_r0(1)(1) <= cos_a0;
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

mat_r1(0)(0) <= cos_a1;
mat_r1(0)(1) <= std_logic_vector((NOT signed(sin_a1))+1);
mat_r1(0)(2) <= (others => '0');
mat_r1(1)(0) <= sin_a1;
mat_r1(1)(1) <= cos_a1;
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

mat_r2(0)(0) <= cos_a2;
mat_r2(0)(1) <= std_logic_vector((NOT signed(sin_a2))+1);
mat_r2(0)(2) <= (others => '0');
mat_r2(1)(0) <= sin_a2;
mat_r2(1)(1) <= cos_a2;
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

end architecture;
