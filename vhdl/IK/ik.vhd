library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;

entity ik is
  port (
  clk : in std_logic;
  reset : in std_logic;

  destx : in std_logic_vector(31 downto 0);
  desty : in std_logic_vector(31 downto 0);

  a0 : out std_logic_vector(31 downto 0);
  a1 : out std_logic_vector(31 downto 0);
  a2 : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavioral of ik is
  type state is (calculate);
  signal current_s, next_s : state;
  signal a0_i, a0_i_c, a1_i, a1_i_c, a2_i, a2_i_c : std_logic_vector(31 downto 0);
  signal a0_step, a0_step_c, a1_step, a1_step_c, a2_step, a2_step_c : std_logic_vector(31 downto 0);
  signal dest : std_logic_vector(95 downto 0);
  signal ei, ei_c, p1, p2 : std_logic_vector(95 downto 0);
  signal delta_e, delta_theta, alpha_theta, next_theta : std_logic_vector(95 downto 0);
  signal alpha_vec, a : vec_3;
  signal j_out : std_logic_vector(287 downto 0);

  begin
    clocked : process(clk, reset) is
      begin
        if (reset = '1') then
          ei <= (others => '0');
          a0_i <= "00000000000000110010010000111111";
          a1_i <= "00000000000000000000000000000000";
          a2_i <= "00000000000000000000000000000000";
          a0_step <= "00000000000000110010010000111111";
          a1_step <= "00000000000000000000000000000000";
          a2_step <= "00000000000000000000000000000000";
          current_s <= calculate;
        elsif (rising_edge(clk)) then
          ei <= ei_c;
          a0_i <= a0_i_c;
          a1_i <= a1_i_c;
          a2_i <= a2_i_c;
          a0_step <= a0_step_c;
          a1_step <= a1_step_c;
          a2_step <= a2_step_c;
          current_s <= next_s;
        end if;
    end process clocked;

    combinational : process(destx, desty, current_s) is
      begin
      --Internal state signals
      next_s <= current_s;
      a0_step_c <= a0_step;
      a1_step_c <= a1_step;
      a2_step_c <= a2_step;
      --- outputs
      a0 <= a0_step;
      a1 <= a1_step;
      a2 <= a2_step;
      -----------------------
      case (current_s) is
        when(calculate) =>
          if (signed(signed(ei(95 downto 64)) - signed(destx)) < THRESH) then
            if (signed(signed(ei(63 downto 32)) - signed(desty)) < THRESH) then
              a0_step_c <= a0_i;
              a1_step_c <= a0_i;
              a2_step_c <= a0_i;
            end if;
          end if;
      end case;

    end process combinational;
    fk_comb_i : fk_comb
    port map (
      clk => clk,
      reset => reset,
      a0  => a0_i,
      a1  => a1_i,
      a2  => a2_i,
      ex  => ei_c(95 downto 64),
      ey  => ei_c(63 downto 32),
      p1x => p1(95 downto 64),
      p1y => p1(63 downto 32),
      p2x => p2(95 downto 64),
      p2y => p2(63 downto 32)
    );
    ei_c(31 downto 0) <= (others => '0');
    p1(31 downto 0) <= (others => '0');
    p2(31 downto 0) <= (others => '0');

    jacobian_t_i : jacobian_t
    port map (
      e     => ei_c,
      p1    => p1,
      p2    => p2,
      j_out => j_out
    );

    dest(95 downto 64) <= destx;
    dest(63 downto 32) <= desty;
    dest(31 downto 0) <= (others => '0');

    delta_e <= vec_3_to_slv(vec_3_sub(slv_to_vec_3(dest),slv_to_vec_3(ei)));

    mat_3x1_delta_theta : mat_3x1
    port map (
      mat_3_l_in => j_out,
      vec_3_r_in => delta_e,
      vec_3_out => delta_theta
    );

    alpha_vec(0)<=ALPHA;
    alpha_vec(1)<=ALPHA;
    alpha_vec(2)<=ALPHA;

    alpha_theta <= vec_3_to_slv(vec_3_mul(slv_to_vec_3(delta_theta),alpha_vec));

    a(0) <= a0_i;
    a(1) <= a1_i;
    a(2) <= a2_i;

    next_theta <= vec_3_to_slv(vec_3_add(slv_to_vec_3(alpha_theta), a));

    a0_i_c <= next_theta(95 downto 64);
    a1_i_c <= next_theta(63 downto 32);
    a2_i_c <= next_theta(31 downto 0);


end architecture;
