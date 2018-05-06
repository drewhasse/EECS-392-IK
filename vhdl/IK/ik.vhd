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
  rotx : in std_logic_vector(31 downto 0);
  roty : in std_logic_vector(31 downto 0);

  arot : out std_logic_vector(31 downto 0);
  a0 : out std_logic_vector(31 downto 0);
  a1 : out std_logic_vector(31 downto 0);
  a2 : out std_logic_vector(31 downto 0);
  );
end entity;

architecture behavioral of ik is
  type state is (calculate);
  signal current_s, next_s : state;
  signal arot_i, arot_i_c, a0_i, a0_i_c, a1_i, a1_i_c, a2_i, a2_i_c : std_logic_vector(31 downto 0);
  signal arot_step, arot_step_c, a0_step, a0_step_c, a1_step, a1_step_c, a2_step, a2_step_c : std_logic_vector(31 downto 0);
  signal e, p1, p2 : std_logic_vector(95 downto 0);
  signal j_out : std_logic_vector(287 downto 0);

  begin
    clocked : process(clk, reset) is
      begin
        if (reset = '1') then
          arot_i <= (others => '00000000000000110010010000111111');
          a0_i <= (others => '00000000000000110010010000111111');
          a1_i <= (others => '00000000000000110010010000111111');
          a2_i <= (others => '00000000000000110010010000111111');
          arot_step <= (others => '00000000000000110010010000111111');
          a0_step <= (others => '00000000000000110010010000111111');
          a1_step <= (others => '00000000000000110010010000111111');
          a2_step <= (others => '00000000000000110010010000111111');
          current_s <= calculate;
        elsif (rising_edge(clk)) then
          arot_i <= arot_i_c;
          a0_i <= a0_i_c;
          a1_i <= a1_i_c;
          a2_i <= a2_i_c;
          arot_step <= arot_step_c;
          a0_step <= a0_step_c;
          a1_step <= a1_step_c;
          a2_step <= a2_step_c;
          current_s <= next_s;
        end if;
    end process clocked;

    combinational : process(destx, desty, rotx, roty, current_s) is
      begin
      --Internal state signals
      next_s <= current_s;
      arot_i_c <= arot_i;
      a0_i_c <= a0_i;
      a1_i_c <= a1_i;
      a2_i_c <= a2_i;
      --- outputs
      arot_step_c <= arot_step;
      a0_step_c <= a0_step;
      a1_step_c <= a1_step;
      a2_step_c <= a2_step;
      -----------------------
      case (current_s) is
        when(calculate) =>

      end case;

    end process combinational;
    fk_comb_i : fk_comb
    port map (
      clk => clk,
      reset => reset,
      a0  => a0_i,
      a1  => a1_i,
      a2  => a2_i,
      ex  => e(95 downto 64),
      ey  => e(64 downto 32),
      p1x => p1(95 downto 64),
      p1y => p1(64 downto 32),
      p2x => p2(95 downto 64),
      p2y => p2(64 downto 32)
    );
    e(31 downto 0) <= (others => '0');
    p1(31 downto 0) <= (others => '0');
    p2(31 downto 0) <= (others => '0');

    jacobian_t_i : jacobian_t
    port map (
      e     => e,
      p1    => p1,
      p2    => p2,
      j_out => j_out
    );

end architecture;
