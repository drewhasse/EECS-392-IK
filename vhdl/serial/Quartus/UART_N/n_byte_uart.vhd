library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity n_byte_uart is
  generic (
    constant n : natural := 16;
    CLKS_PER_BIT : natural := 434 --57600, 434 = 115200
  );
  port (
  clk : in std_logic;
  reset : in std_logic;
  RX : in std_logic;
  LED_o : out std_logic;
  LED2 : out std_logic;
  data_valid : out std_logic;
  dout : out std_logic_vector(n*7-1 downto 0)
  );
end entity;

architecture arch of n_byte_uart is
  component UART_nByte
    generic (
      n            : natural;
      CLKS_PER_BIT : natural := 434
    );
    port (
      clk        : in  std_logic;
      reset      : in  std_logic;
      RX         : in  std_logic;
      dout       : out std_logic_vector(n*8-1 downto 0);
      data_valid : out std_logic
    );
  end component UART_nByte;

  component UART_R
    generic (
      CLKS_PER_BIT : natural := 434
    );
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      RX      : in  std_logic;
      RX_DV   : out std_logic;
      RX_byte : out std_logic_vector(7 downto 0)
    );
  end component UART_R;

  component leddcd
    port (
      data_in      : in  std_logic_vector(7 downto 0);
      segments_out : out std_logic_vector(6 downto 0)
    );
  end component leddcd;


  signal RX_sig : std_logic;
  signal not_reset : std_logic := '0';
  signal sev_seg : std_logic_vector(n*8-1 downto 0) := (others => '0');
  signal bytes : std_logic_vector(n*8-1 downto 0);
  signal valid : std_logic;

begin

  RX_sig <= RX;
  LED_o <= RX_sig;
  LED2 <= '1';
  not_reset <= not reset;
  data_valid <= valid;

  DFF : process(clk,valid,bytes) is
    begin
      if (rising_edge(clk)) then
        if (valid = '1') then
          sev_seg <= bytes;
        end if;
      end if;
    end process;

  UART_nByte_i : UART_nByte
    generic map (
      n            => n,
      CLKS_PER_BIT => CLKS_PER_BIT
    )
    port map (
      clk        => clk,
      reset      => not_reset,
      RX         => RX,
      dout       => bytes,
      data_valid => valid
    );

    LED_gen : for i in 0 to n-1 generate
        leddcd_i : leddcd
        port map (
          data_in      => sev_seg(i*8+7 downto i*8),
          segments_out => dout(i*7+6 downto i*7)
        );
      end generate;

    -- leddcd_i : leddcd
    --   port map (
    --     data_in      => sev_seg,
    --     segments_out => dout(6 downto 0)
    --   );


end architecture;
