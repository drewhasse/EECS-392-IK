library IEEE;
use IEEE.std_logic_1164.all;
use work.ik_pack.all;

entity cross_product is
  port (
    a : in std_logic_vector(95 downto 0);
    b : in std_logic_vector(95 downto 0);
    cp : out std_logic_vector(95 downto 0);
  );
end entity;

architecture behavioral of cross_product is

  signal ax,ay,az,bx,by,bz : std_logic_vector(31 downto 0);

begin
  cp(95 downto 64) <= to_signed(a(63 downto 32))*to_signed(b(31 downto 0))-to_signed(a(31 downto 0))*to_signed(b(63 downto 32));
  cp(63 downto 32) <= to_signed(a(31 downto 0))*to_signed(b(95 downto 64))-to_signed(a(95 downto 64))*to_signed(b(31 downto 0));
  cp(31 downto 0) <= to_signed(a(95 downto 64))*to_signed(b(64 downto 32))-to_signed(a(64 downto 32))*to_signed(b(95 downto 64));
end architecture;
