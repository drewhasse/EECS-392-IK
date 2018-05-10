library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_test is
  port (
	clk : in std_logic;
	reset : in std_logic;
	LED : out std_logic;
	LED2 : out std_logic := '0';
	LIORX : inout std_logic;
	LIOTX : inout std_logic;
	memory_mem_a                     : out std_logic_vector(12 downto 0);
	memory_mem_ba                    : out std_logic_vector(2 downto 0);
	memory_mem_ck                    : out std_logic;
	memory_mem_ck_n                  : out std_logic;
	memory_mem_cke                   : out std_logic;
	memory_mem_cs_n                  : out std_logic;
	memory_mem_ras_n                 : out std_logic;
	memory_mem_cas_n                 : out std_logic;
	memory_mem_we_n                  : out std_logic;
	memory_mem_reset_n               : out std_logic;
	memory_mem_dq                    : inout std_logic_vector(7 downto 0);
	memory_mem_dqs                   : inout std_logic;
	memory_mem_dqs_n                 : inout std_logic;
	memory_mem_odt                   : out std_logic;
	memory_mem_dm                    : out std_logic;
	memory_oct_rzqin                 : in  std_logic
  );
end entity;

architecture arch of uart_test is
  component UART_R
    generic (
      CLKS_PER_BIT : natural := 868
      );
      port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        RX      : in  std_logic;
        RX_DV   : out std_logic;
        RX_byte : out std_logic_vector(7 downto 0)
      );
  end component UART_R;

  component uart_q
    port (
      clk_clk                          : in  std_logic                     := '0';
      hps_io_hps_io_gpio_inst_LOANIO49 : inout std_logic                     := '0';
      hps_io_hps_io_gpio_inst_LOANIO50 : inout std_logic                     := '0';
      loan_io_in                       : out std_logic_vector(66 downto 0);
      loan_io_out                      : in  std_logic_vector(66 downto 0) := (others => '0');
      loan_io_oe                       : in  std_logic_vector(66 downto 0) := (others => '0');
      memory_mem_a                     : out std_logic_vector(12 downto 0);
      memory_mem_ba                    : out std_logic_vector(2 downto 0);
      memory_mem_ck                    : out std_logic;
      memory_mem_ck_n                  : out std_logic;
      memory_mem_cke                   : out std_logic;
      memory_mem_cs_n                  : out std_logic;
      memory_mem_ras_n                 : out std_logic;
      memory_mem_cas_n                 : out std_logic;
      memory_mem_we_n                  : out std_logic;
      memory_mem_reset_n               : out std_logic;
      memory_mem_dq                    : inout std_logic_vector(7 downto 0)  := (others => '0');
      memory_mem_dqs                   : inout std_logic                     := '0';
      memory_mem_dqs_n                 : inout std_logic                     := '0';
      memory_mem_odt                   : out std_logic;
      memory_mem_dm                    : out std_logic;
      memory_oct_rzqin                 : in  std_logic                     := '0'              --        .oct_rzqin
    );
    end component uart_q;


signal not_reset : std_logic := '0';
signal output_en : std_logic_vector(66 downto 0) := (49=>'0', others=>'1');
signal loan_in : std_logic_vector(66 downto 0);
signal loan_out : std_logic_vector(66 downto 0);
signal RX_DV_s : std_logic;
signal RX_byte_s : std_logic_vector(7 downto 0);

begin

	not_reset <= not reset;

LED2 <= loan_in(49);
  -- compare : process(reset) is
  --   begin
  --     if (loan_in(49) = '0') then
  --       LED2 <= '1';
  --     end if;
  --   end process;



  UART_R_i : UART_R
    generic map (
      CLKS_PER_BIT => 868
    )
    port map (
      clk     => clk,
      reset   => reset,
      RX      => loan_in(49),
      RX_DV   => RX_DV_s,
      RX_byte => RX_byte_s
    );

	uart_q_i : uart_q
		port map (
		  clk_clk                          => clk,
		  hps_io_hps_io_gpio_inst_LOANIO49 => LIORX,
		  hps_io_hps_io_gpio_inst_LOANIO50 => LIOTX,
		  loan_io_in                       => loan_in,
		  loan_io_out                      => loan_out,
		  loan_io_oe                       => output_en,
		  memory_mem_a                     => memory_mem_a,
		  memory_mem_ba                    => memory_mem_ba,
		  memory_mem_ck                    => memory_mem_ck,
		  memory_mem_ck_n                  => memory_mem_ck_n,
		  memory_mem_cke                   => memory_mem_cke,
		  memory_mem_cs_n                  => memory_mem_cs_n,
		  memory_mem_ras_n                 => memory_mem_ras_n,
		  memory_mem_cas_n                 => memory_mem_cas_n,
		  memory_mem_we_n                  => memory_mem_we_n,
		  memory_mem_reset_n               => memory_mem_reset_n,
		  memory_mem_dq                    => memory_mem_dq,
		  memory_mem_dqs                   => memory_mem_dqs,
		  memory_mem_dqs_n                 => memory_mem_dqs_n,
		  memory_mem_odt                   => memory_mem_odt,
		  memory_mem_dm                    => memory_mem_dm,
		  memory_oct_rzqin                 => memory_oct_rzqin
		);

		--LED <= loan_in(49);
    LED <= '1';


end architecture;
