library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity fk is
  port (
  clk : in std_logic;
  reset : in std_logic;
  data_valid : in std_logic;
  a0 : in std_logic_vector(31 downto 0);
  a1 : in std_logic_vector(31 downto 0);
  a2 : in std_logic_vector(31 downto 0);

  busy : out std_logic;
  result_valid : out std_logic;
  e_x : out std_logic_vector(31 downto 0);
  e_y : out std_logic_vector(31 downto 0);
  );
end entity;

architecture behavioral of fk is
  type state is (idle, rotate0, trans0, rotate1, trans1, rotate2, trans2);
  signal current_s, next_s : state;
  signal vec, vec_c : std_logic_vector(95 downto 0);
  signal a0_i, a0_i_c, a1_i, a1_i_c, a2_i, a2_i_c : std_logic_vector(31 downto 0);
  signal outvec, outvec_c : std_logic_vector(95 downto 0);
begin
  clocked : process(clk, reset) is
    begin
      if (reset = '1') then
        vec <= (others => '0');
        outvec <= (others => '0');
        a0_i <= (others => '0');
        a1_i <= (others => '0');
        a2_i <= (others => '0');
        current_s <= idle;
      elsif (rising_edge(clk)) then
        vec <= vec_c;
        outvec <= outvec_c;
        a0_i <= a0_i_c;
        a1_i <= a1_i_c;
        a2_i <= a2_i_c;
        current_s <= next_s;
      end if;
  end process clocked;

  combinational : process(a0, a1, a2, data_valid, vec, current_s) is
    begin
    --Internal state signals
    vec_c <= vec;
    outvec_c <= outvec;
    next_s <= current_s;
    a0_i_c <= a0_i;
    a1_i_c <= a1_i;
    a2_i_c <= a2_i;
    --Output
    e_x <= outvec(95 downto 64);
    e_y <= outvec(63 downto 32);
    result_valid <= '0';
    busy <= '1';

    case (current_s) is
      when (idle) =>
        busy <= '0';
        result_valid <= '1';
      when (rotate0) =>
      when (trans0) =>
      when (rotate1) =>
      when (trans1) =>
      when (rotate2) =>
      when (trans2) =>
    end case;
  end process combinational;

end architecture;
