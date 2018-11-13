module tetris(clock,
	 reset,
	 VGA_CLK,  														//	VGA Clock
	 VGA_HS,															//	VGA H_SYNC
	 VGA_VS,															//	VGA V_SYNC
	 VGA_BLANK,														//	VGA BLANK
	 VGA_SYNC,														//	VGA SYNC
	 VGA_R,   														//	VGA Red[9:0]
	 VGA_G,	 														//	VGA Green[9:0]
	 VGA_B															//	VGA Blue[9:0]
	 );
	
    input clock, reset;
	 output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC;
	 output [7:0] VGA_R, VGA_G, VGA_B;

    /** IMEM **/
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (~clock),                  // may need to invert the clock
        .data	    (data),    // data you want to write
        .wren	    (wren),      // write enable
        .q          (q_dmem)    // data from dmem
    );
	 
	 /** IMGMEM **/
    wire [18:0] addressA_imgmem, addressB_imgmem;
    wire [7:0] dataA_imgmem, dataB_imgmem;
    wire wrenA_imgmem, wrenB_imgmem, VGA_CLK;
    wire [7:0] qA_imgmem, qB_imgmem;
	 assign wrenB_imgmem = 1'b0;
	 assign dataB_imgmem = 8'd0;
    imgram my_imgmem(
        .address_a   (addressA_imgmem),       // address port for processor
		  .address_b	(addressB_imgmem), 			// address port for vga
        .clock_a     (~clock),                  // may need to invert the clock
		  .clock_b		(~VGA_CLK),
        .data_a	   (dataA_imgmem),    // data port for processor
		  .data_b		(dataB_imgmem),	// data port for vga
        .wren_a	   (wrenA_imgmem),      // write enable
		  .wren_b		(wrenB_imgmem),
        .q_a         (qA_imgmem),    // data from dmem
		  .q_b			(qB_imgmem)
    );

    /** REGFILE **/
    wire ctrl_writeEnable, ctrl_reset;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
        clock,
        ctrl_writeEnable,
        ctrl_reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
    );
	 
	 // VGA
	 wire DLY_RST, VGA_CTRL_CLK, AUD_CTRL_CLK;
	 Reset_Delay			r0	(.iCLK(clock),.oRESET(DLY_RST)	);
	 VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(clock),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
	 vga_controller vga_ins	(.iRST_n(DLY_RST),
									 .iVGA_CLK(VGA_CLK),
									 .oBLANK_n(VGA_BLANK),
									 .oHS(VGA_HS),
									 .oVS(VGA_VS),
								 	 .b_data(VGA_B),
									 .g_data(VGA_G),
									 .r_data(VGA_R),
									 .addr_imgmem(addressB_imgmem),
									 .q_imgmem(qB_imgmem)
									 );

    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        clock,                          // I: The master clock
        reset,                          // I: A reset signal

        // Imem
        address_imem,                   // O: The address of the data to get from imem
        q_imem,                         // I: The data from imem

        // Dmem
        address_dmem,                   // O: The address of the data to get or put from/to dmem
        data,                           // O: The data to write to dmem
        wren,                           // O: Write enable for dmem
        q_dmem,                         // I: The data from dmem
		  
		  // IMGmem
		  addressA_imgmem,						 // O: The address of the data to get or put from/to imgmem
		  dataA_imgmem,							 // O: The data to write to imgmem
		  wrenA_imgmem,							 // O: Write enable for imgmem
		  qA_imgmem,								 // I: The data from imgmem

        // Regfile
        ctrl_writeEnable,               // O: Write enable for regfile
        ctrl_writeReg,                  // O: Register to write to in regfile
        ctrl_readRegA,                  // O: Register to read from port A of regfile
        ctrl_readRegB,                  // O: Register to read from port B of regfile
        data_writeReg,                  // O: Data to write to for regfile
        data_readRegA,                  // I: Data from port A of regfile
        data_readRegB                   // I: Data from port B of regfile
		  
    );

endmodule
