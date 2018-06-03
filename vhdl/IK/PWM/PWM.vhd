library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PWM is
  port (
  clk : in std_logic;
  reset : in std_logic;
  hold : in std_logic;
  length : in std_logic_vector(31 downto 0);
  pulse : out std_logic
  );
end entity;

architecture behavioral of PWM is
type state is (increment, hold_s);
signal current_s, next_s : state;
signal count_width, count_width_c, count_pulse, count_pulse_c : std_logic_vector(31 downto 0);
signal pulse_gate, pulse_gate_c : std_logic;
signal pulse_length, pulse_length_c: std_logic_vector(31 downto 0);
signal pulseint,  pulseint_c : std_logic;
begin
  clocked : process(clk, reset) is
    begin
      if (reset = '1') then
        count_pulse <= (others => '0');
        count_width <= "00000000000011110100001001000000";
        pulse_length <= "00000000000000010010010011111000";
        pulse_gate <= '0';
        pulseint <= '0';
        current_s <= increment;
      elsif (rising_edge(clk)) then
        count_width <= count_width_c;
        count_pulse <= count_pulse_c;
        pulse_length <= pulse_length_c;
        pulse_gate <= pulse_gate_c;
        pulseint <= pulseint_c;
        current_s <= next_s;
      end if;
  end process clocked;

  combinational : process(count_width, count_pulse, pulseint, pulse_gate, current_s) is
    constant one : std_logic_vector(31 downto 0) := (0 => '1', others => '0');
    constant zero : std_logic_vector(31 downto 0) := (others => '0');
    begin
    --Internal state signals
    count_width_c <= count_width;
    count_pulse_c <= count_pulse;
    pulse_length_c <= pulse_length;
    pulse_gate_c <= pulse_gate;
    next_s <= current_s;
    pulseint_c <= pulseint;
    pulse_length_c <= length;
    --Output
    pulse <= pulseint;

    case (current_s) is
      when (increment) =>
        if (hold = '1') then
          next_s <= hold_s;
        else
          count_width_c <= std_logic_vector(unsigned(count_width) - unsigned(one));
          if (count_width = zero) then
            pulse_gate_c <= '1';
            pulseint_c <= '0';
            count_width_c <= "00000000000011110100001001000000";
          end if;

          if (pulse_gate = '1') then
            if (count_pulse = zero) then
              pulse_gate_c <= '0';
              pulseint_c <= '1';
              count_pulse_c <= pulse_length;
            else
              count_pulse_c <= std_logic_vector(unsigned(count_pulse) - unsigned(one));
            end if;
          end if;
        end if;

      when (hold_s) =>
        pulseint_c <= '0';
        if (hold = '0') then
          next_s <= increment;
        end if;
    end case;

  end process combinational;
end architecture;
