library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_test is
  port (
  clk : in std_logic;
  rst : in std_logic;
  rx : in std_logic;
  led : out std_logic
  );
end entity;

architecture structural of uart_test is
  component uart_interface
    port (
      clk_clk       : in  std_logic := '0';
      reset_reset_n : in  std_logic := '0';
      serial_rxd    : in  std_logic := '0';
      serial_txd    : out std_logic         --       .txd
    );
  end component uart_interface;


begin
  uart_i : uart_interface
    port map (
      clk_clk       => clk,
      reset_reset_n => rst,
      serial_rxd    => open,
      serial_txd    => led
    );


end architecture;
