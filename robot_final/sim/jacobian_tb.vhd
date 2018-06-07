library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ik_pack.all;

entity jacobian_tb is
end entity;

architecture arch of jacobian_tb is

  component jacobian_t
    port (
      e     : in  std_logic_vector(95 downto 0);
      p1    : in  std_logic_vector(95 downto 0);
      p2    : in  std_logic_vector(95 downto 0);
      j_out : out std_logic_vector(287 downto 0)
    );
  end component jacobian_t;

  signal e_tb     : std_logic_vector(95 downto 0);
  signal p1_tb    : std_logic_vector(95 downto 0);
  signal p2_tb    : std_logic_vector(95 downto 0);
  signal j_out_tb : std_logic_vector(287 downto 0);

begin
  dut : jacobian_t
    port map (
      e     => e_tb,
      p1    => p1_tb,
      p2    => p2_tb,
      j_out => j_out_tb
    );

test : process is begin
  wait for 1 ns;
  e_tb <= (0=>'1', 32=>'1', 64=>'1', others=>'0');
  p1_tb <= (1=>'1', 33=>'1', 65=>'1', others=>'0');
  p2_tb <= (2=>'1', 34=>'1', 66=>'1', others=>'0');
  wait;
end process;


end architecture;
