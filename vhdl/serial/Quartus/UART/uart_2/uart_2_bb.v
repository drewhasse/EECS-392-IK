
module uart_2 (
	clk_clk,
	hps_uart_cts,
	hps_uart_dsr,
	hps_uart_dcd,
	hps_uart_ri,
	hps_uart_dtr,
	hps_uart_rts,
	hps_uart_out1_n,
	hps_uart_out2_n,
	hps_uart_rxd,
	hps_uart_txd,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin);	

	input		clk_clk;
	input		hps_uart_cts;
	input		hps_uart_dsr;
	input		hps_uart_dcd;
	input		hps_uart_ri;
	output		hps_uart_dtr;
	output		hps_uart_rts;
	output		hps_uart_out1_n;
	output		hps_uart_out2_n;
	input		hps_uart_rxd;
	output		hps_uart_txd;
	output	[12:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[7:0]	memory_mem_dq;
	inout		memory_mem_dqs;
	inout		memory_mem_dqs_n;
	output		memory_mem_odt;
	output		memory_mem_dm;
	input		memory_oct_rzqin;
endmodule
