library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cross_product is
  port (
    a : in std_logic_vector(95 downto 0);
    b : in std_logic_vector(95 downto 0);
    cp : out std_logic_vector(95 downto 0)
  );
end entity;

architecture behavioral of cross_product is

  --signal ax,ay,az,bx,by,bz : std_logic_vector(31 downto 0);

begin
  cp(95 downto 64) <= std_logic_vector(resize((signed(a(63 downto 32))*signed(b(31 downto 0)) SRL 16),32)-resize((signed(a(31 downto 0))*signed(b(63 downto 32)) SRL 16),32));
  cp(63 downto 32) <= std_logic_vector(resize((signed(a(31 downto 0))*signed(b(95 downto 64)) SRL 16),32)-resize((signed(a(95 downto 64))*signed(b(31 downto 0)) SRL 16),32));
  cp(31 downto 0) <= std_logic_vector(resize((signed(a(95 downto 64))*signed(b(63 downto 32)) SRL 16),32)-resize((signed(a(63 downto 32))*signed(b(95 downto 64)) SRL 16),32));
end architecture;
