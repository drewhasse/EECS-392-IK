library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cross_product_tb is
end entity;

architecture behavioral of cross_product_tb is

  component cross_product
    port (
      a  : in  std_logic_vector(95 downto 0);
      b  : in  std_logic_vector(95 downto 0);
      cp : out std_logic_vector(95 downto 0)
    );
  end component cross_product;


  signal a_tb  : std_logic_vector(95 downto 0);
  signal b_tb  : std_logic_vector(95 downto 0);
  signal cp_tb : std_logic_vector(95 downto 0);
  signal cp_x  : std_logic_vector(31 downto 0);
  signal cp_y  : std_logic_vector(31 downto 0);
  signal cp_z  : std_logic_vector(31 downto 0);



begin
  dut : cross_product
    port map (
      a  => a_tb,
      b  => b_tb,
      cp => cp_tb
    );

  test : process is
    begin
      wait for 1 ns;
      a_tb(95 downto 64) <= std_logic_vector(to_signed(5,32));
      a_tb(63 downto 32) <= std_logic_vector(to_signed(4,32));
      a_tb(31 downto 0) <= std_logic_vector(to_signed(26,32));
      b_tb(95 downto 64) <= std_logic_vector(to_signed(14,32));
      b_tb(63 downto 32) <= std_logic_vector(to_signed(21,32));
      b_tb(31 downto 0) <= std_logic_vector(to_signed(30,32));
      wait for 1 ns;
      cp_x <= cp_tb(95 downto 64);
      cp_y <= cp_tb(63 downto 32);
      cp_z <= cp_tb(31 downto 0);
      wait;
    end process;

end architecture;
