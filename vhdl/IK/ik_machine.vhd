library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.ik_pack.all;
  use work.cordic.all;

entity ik_machine is
  port (
    clk : in std_logic;
    reset : in std_logic;
    pulse : in std_logic;

    destx : in std_logic_vector(31 downto 0);
    desty : in std_logic_vector(31 downto 0);

    a0 : out std_logic_vector(31 downto 0);
    a1 : out std_logic_vector(31 downto 0);
    a2 : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavioral of ik_machine is
  type state is (idle, computeFK, computeJac, computeDTheta, computeAOut, updateAngle, waitOnPulseLow, waitforinput);
  signal current_s, next_s, previous_s, next_previous_s : state;
  signal a0_i, a0_i_c, a1_i, a1_i_c, a2_i, a2_i_c : std_logic_vector(31 downto 0);
  signal a0_o, a0_o_c, a1_o, a1_o_c, a2_o, a2_o_c : std_logic_vector(31 downto 0);
  signal a0_e, a0_e_c, a1_e, a1_e_c, a2_e, a2_e_c : std_logic_vector(31 downto 0);
  signal ei, ei_c, p1, p1_c, p2, p2_c : std_logic_vector(95 downto 0);
  signal e_j, e_j_c, p1_j, p1_j_c, p2_j, p2_j_c : std_logic_vector(95 downto 0);
  signal jac, jac_c, jac_mul, jac_mul_c : std_logic_vector(287 downto 0);
  signal delta_e_s, delta_e_s_c, delta_theta, delta_theta_c : std_logic_vector(95 downto 0);
  signal dest, dest_c : std_logic_vector(95 downto 0);
begin
  clocked_proc : process(clk, reset) is
    begin
      if (reset = '1') then
        current_s <= idle;
        previous_s <= idle;
        ei <= (others => '0');
        p1 <= (others => '0');
        p2 <= (others => '0');
        e_j <= (others => '0');
        p1_j <= (others => '0');
        p2_j <= (others => '0');
        jac <= (others => '0');
        jac_mul <= (others => '0');
        delta_e_s <= (others => '0');
        delta_theta <= (others => '0');
        a0_i <= "00000000000000011001001000011111";
        a1_i <= "00000000000000000000000000000000";
        a2_i <= "00000000000000000000000000000000";
        a0_o <= "00000000000000011001001000011111";
        a1_o <= "00000000000000000000000000000000";
        a2_o <= "00000000000000000000000000000000";
        a0_e <= "00000000000000011001001000011111";
        a1_e <= "00000000000000000000000000000000";
        a2_e <= "00000000000000000000000000000000";
        dest <= (others => '0');
      elsif (rising_edge(clk)) then
        current_s <= next_s;
        previous_s <= next_previous_s;
        ei <= ei_c;
        p1 <= p1_c;
        p2 <= p2_c;
        e_j <= e_j_c;
        p1_j <= p1_j_c;
        p2_j <= p2_j_c;
        jac <= jac_c;
        a0_i <= a0_i_c;
        a1_i <= a1_i_c;
        a2_i <= a2_i_c;
        jac_mul <= jac_mul_c;
        delta_e_s <= delta_e_s_c;
        delta_theta <= delta_theta_c;
        a0_o <= a0_o_c;
        a1_o <= a1_o_c;
        a2_o <= a2_o_c;
        a0_e <= a0_e_c;
        a1_e <= a1_e_c;
        a2_e <= a2_e_c;
        dest <= dest_c;
      end if;
  end process;

  comb_proc : process(current_s, pulse, destx, desty) is
    variable delta_e, alpha_theta, next_theta : std_logic_vector(95 downto 0);
    variable a, alpha_vec : vec_3;
  begin
    next_s <= current_s;
    next_previous_s <= previous_s;

    a0_i_c <= a0_i;
    a1_i_c <= a1_i;
    a2_i_c <= a2_i;
    --ei_c <= ei;
    --p1_c <= p1;
    --p2_c <= p2;

    e_j_c <= e_j;
    p1_j_c <= p1_j;
    p2_j_c <= p2_j;
    --jac_c <= jac;

    jac_mul_c <= jac_mul;
    delta_e_s_c <= delta_e_s;
    --delta_theta_c <= delta_theta;

    a0_o_c <= a0_o;
    a1_o_c <= a1_o;
    a2_o_c <= a2_o;

    a0_e_c <= a0_e;
    a1_e_c <= a1_e;
    a2_e_c <= a2_e;

    a0 <= a0_e;
    a1 <= a1_e;
    a2 <= a2_e;

    dest_c(95 downto 64) <= destx;
    dest_c(63 downto 32) <= desty;
    dest_c(31 downto 0) <= (others => '0');

    case(current_s) is
      when idle =>
        if (pulse = '0') then
          next_s <= idle;
        else
          case(previous_s) is
            when computeFK =>
              next_s <= computeJac;
            when computeJac =>
              next_s <= computeDTheta;
            when computeDTheta =>
              next_s <= computeAOut;
            when computeAOut =>
              next_s <= updateAngle;
            when updateAngle =>
              next_s <= computeFK;
            when others =>
              next_s <= computeFK;
          end case;
        end if;

      when computeFK =>
        next_previous_s <= computeFK;
        a0_i_c <= a0_o;
        a1_i_c <= a1_o;
        a2_i_c <= a2_o;
        next_s <= waitOnPulseLow;

      when computeJac =>
        next_previous_s <= computeJac;
        e_j_c <= ei;
        p1_j_c <= p1;
        p2_j_c <= p2;
        next_s <= waitOnPulseLow;

      when computeDTheta =>
        next_previous_s <= computeDTheta;
        delta_e := vec_3_to_slv(vec_3_sub(slv_to_vec_3(dest),slv_to_vec_3(ei)));
        delta_e_s_c <= delta_e;
        jac_mul_c <= jac;
        next_s <= waitOnPulseLow;

      when computeAOut =>
        next_previous_s <= computeAOut;
        alpha_vec(0) := ALPHA;
        alpha_vec(1) := ALPHA;
        alpha_vec(2) := ALPHA;
        alpha_theta := vec_3_to_slv(vec_3_mul(slv_to_vec_3(delta_theta),alpha_vec));
        a(0) := a0_i;
        a(1) := a1_i;
        a(2) := a2_i;
        next_theta := vec_3_to_slv(vec_3_add(slv_to_vec_3(alpha_theta), a));
        a0_o_c <= next_theta(95 downto 64);
        a1_o_c <= next_theta(63 downto 32);
        a2_o_c <= next_theta(31 downto 0);
        next_s <= waitOnPulseLow;

      when updateAngle =>
        next_previous_s <= updateAngle;
        next_s <= waitOnPulseLow;
        if (abs(signed(ei(95 downto 64)) - signed(destx)) < THRESH) then
          if (abs(signed(ei(63 downto 32)) - signed(desty)) < THRESH) then
            a0_e_c <= a0_o;
            a1_e_c <= a1_o;
            a2_e_c <= a2_o;
            next_s <= waitforinput;
          end if;
        end if;

      when waitOnPulseLow =>
        if (pulse = '0') then
          next_s <= idle;
        else
          next_s <= waitOnPulseLow;
        end if;

      when waitforinput =>
        if (dest(95 downto 64) /= destx or dest(63 downto 32) /= desty) then
          next_s <= idle;
        else
          next_s <= waitforinput;
        end if;

      when others =>
        next_s <= idle;
    end case;
  end process;

  fk_comb_i : fk_comb
  port map (
    clk => clk,
    reset => reset,
    a0  => a0_i,
    a1  => a1_i,
    a2  => a2_i,
    ex  => ei_c(95 downto 64),
    ey  => ei_c(63 downto 32),
    p1x => p1_c(95 downto 64),
    p1y => p1_c(63 downto 32),
    p2x => p2_c(95 downto 64),
    p2y => p2_c(63 downto 32)
  );
  ei_c(31 downto 0) <= (others => '0');
  p1_c(31 downto 0) <= (others => '0');
  p2_c(31 downto 0) <= (others => '0');

  jacobian_t_i : jacobian_t
  port map (
    e     => e_j,
    p1    => p1_j,
    p2    => p2_j,
    j_out => jac_c
  );

  mat_3x1_delta_theta : mat_3x1
  port map (
    mat_3_l_in => jac_mul,
    vec_3_r_in => delta_e_s,
    vec_3_out =>  delta_theta_c
  );
end architecture;
