	uart_2 u0 (
		.clk_clk            (<connected-to-clk_clk>),            //      clk.clk
		.hps_uart_cts       (<connected-to-hps_uart_cts>),       // hps_uart.cts
		.hps_uart_dsr       (<connected-to-hps_uart_dsr>),       //         .dsr
		.hps_uart_dcd       (<connected-to-hps_uart_dcd>),       //         .dcd
		.hps_uart_ri        (<connected-to-hps_uart_ri>),        //         .ri
		.hps_uart_dtr       (<connected-to-hps_uart_dtr>),       //         .dtr
		.hps_uart_rts       (<connected-to-hps_uart_rts>),       //         .rts
		.hps_uart_out1_n    (<connected-to-hps_uart_out1_n>),    //         .out1_n
		.hps_uart_out2_n    (<connected-to-hps_uart_out2_n>),    //         .out2_n
		.hps_uart_rxd       (<connected-to-hps_uart_rxd>),       //         .rxd
		.hps_uart_txd       (<connected-to-hps_uart_txd>),       //         .txd
		.memory_mem_a       (<connected-to-memory_mem_a>),       //   memory.mem_a
		.memory_mem_ba      (<connected-to-memory_mem_ba>),      //         .mem_ba
		.memory_mem_ck      (<connected-to-memory_mem_ck>),      //         .mem_ck
		.memory_mem_ck_n    (<connected-to-memory_mem_ck_n>),    //         .mem_ck_n
		.memory_mem_cke     (<connected-to-memory_mem_cke>),     //         .mem_cke
		.memory_mem_cs_n    (<connected-to-memory_mem_cs_n>),    //         .mem_cs_n
		.memory_mem_ras_n   (<connected-to-memory_mem_ras_n>),   //         .mem_ras_n
		.memory_mem_cas_n   (<connected-to-memory_mem_cas_n>),   //         .mem_cas_n
		.memory_mem_we_n    (<connected-to-memory_mem_we_n>),    //         .mem_we_n
		.memory_mem_reset_n (<connected-to-memory_mem_reset_n>), //         .mem_reset_n
		.memory_mem_dq      (<connected-to-memory_mem_dq>),      //         .mem_dq
		.memory_mem_dqs     (<connected-to-memory_mem_dqs>),     //         .mem_dqs
		.memory_mem_dqs_n   (<connected-to-memory_mem_dqs_n>),   //         .mem_dqs_n
		.memory_mem_odt     (<connected-to-memory_mem_odt>),     //         .mem_odt
		.memory_mem_dm      (<connected-to-memory_mem_dm>),      //         .mem_dm
		.memory_oct_rzqin   (<connected-to-memory_oct_rzqin>)    //         .oct_rzqin
	);

