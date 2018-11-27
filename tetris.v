module tetris(clock,
	 reset,
	 VGA_CLK,  														//	VGA Clock
	 VGA_HS,															//	VGA H_SYNC
	 VGA_VS,															//	VGA V_SYNC
	 VGA_BLANK,														//	VGA BLANK
//	 VGA_SYNC,														//	VGA SYNC
	 VGA_R,   														//	VGA Red[9:0]
	 VGA_G,	 														//	VGA Green[9:0]
	 VGA_B,															//	VGA Blue[9:0]
	 IO_left,
	 IO_right,
	 IO_down,
	 IO_rotate_cw,
	 IO_left_LED,
	 IO_right_LED,
	 IO_down_LED,
	 IO_rotate_cw_LED,
	 DEBUG_gamemode,
	 DEBUG_mode
//	 outy
//	 dataToReg
	 );
	 
//	 output [31:0] dataToReg;
//	output [31:0] outy;
	input [15:0] DEBUG_gamemode;
	input DEBUG_mode;
	 
	 input IO_left, IO_right, IO_down, IO_rotate_cw;
    input clock, reset;
	 output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK;//, VGA_SYNC;
	 output [7:0] VGA_R, VGA_G, VGA_B;
	 output IO_left_LED, IO_right_LED, IO_down_LED, IO_rotate_cw_LED;
	 
	 wire left, right, down, rotate_cw;
	 assign left = ~IO_left;
	 assign right = ~IO_right;
	 assign down = ~IO_down;
	 assign rotate_cw = ~IO_rotate_cw;
	 
	 assign IO_left_LED = left;
	 assign IO_right_LED = right;
	 assign IO_down_LED = down;
	 assign IO_rotate_cw_LED = rotate_cw;
	 
	 
	 
	 
	 wire [31:0] DEBUG_screenMode, tempScreenMode, screenMode;
	 assign DEBUG_screenMode[31:16] = DEBUG_gamemode;
	 assign DEBUG_screenMode[15:0] = 16'd0;
	 assign tempScreenMode = DEBUG_mode ? DEBUG_screenMode : screenMode;
	 
	 /** In Game Timer **/
	 reg changeReset;
	 reg[25:0] counter;
	 reg[15:0] seconds;
	 initial
	 begin
		counter <= 26'd0;
		seconds <= 16'd0;
		changeReset <= 1'b0;
	 end
	 
	 always @(tempScreenMode[31:29])
	 begin
		if (tempScreenMode[31:29] == 3'b001)
			changeReset <= 1'b0;
		else
			changeReset <= 1'b1;
	 end
		
	 always @(posedge clock or posedge reset or posedge changeReset)
	 begin
		if (reset || changeReset)
		begin
			counter <= 26'd0;
			seconds <= 26'd0;
		end
		else if (counter > 26'd50000000)
		begin
			counter <= 26'd0;
			seconds <= seconds + 16'd1;
		end
		else
			counter <= counter + 26'd1;
	 end
	 
	 
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
	 wire [31:0] block1x, block1y, block2x, block2y, block3x, block3y, block4x, block4y;
	 wire [31:0] score, blockType;
    regfile my_regfile(
        .clock(clock),
        .ctrl_writeEnable(ctrl_writeEnable),
        .ctrl_reset(ctrl_reset),
        .ctrl_writeReg(ctrl_writeReg),
        .ctrl_readRegA(ctrl_readRegA),
        .ctrl_readRegB(ctrl_readRegB),
        .data_writeReg(data_writeReg),
        .data_readRegA(data_readRegA),
        .data_readRegB(data_readRegB),
		  .block1x(block1x),
		  .block1y(block1y),
		  .block2x(block2x),
		  .block2y(block2y),
		  .block3x(block3x),
		  .block3y(block3y),
		  .block4x(block4x),
		  .block4y(block4y),
		  .score(score),
		  .blockType(blockType),
		  .screenMode(screenMode)
    );
	 
	 reg [31:0] b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y, vga_score, vga_type, vga_mode;
	 
	 always @(posedge clock)
	 begin
		b1x <= block1x;
		b1y <= block1y;
		b2x <= block2x;
		b2y <= block2y;
		b3x <= block3x;
		b3y <= block3y;
		b4x <= block4x;
		b4y <= block4y;
		vga_score <= score;
		vga_type <= blockType;
		vga_mode <= screenMode;
	 end
	 
	 // VGA
	 wire DLY_RST, VGA_CTRL_CLK, AUD_CTRL_CLK;
	 
	 Reset_Delay			r0	(.iCLK(clock),.oRESET(DLY_RST)	);
	 VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(clock),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
//	 testpll					p1 (.areset(~DLY_RST), .inclk0(clock), .c0(VGA_CLK));
	 vga_controller vga_ins	(.iRST_n(DLY_RST),
									 .iVGA_CLK(VGA_CLK),
									 .oBLANK_n(VGA_BLANK),
									 .oHS(VGA_HS),
									 .oVS(VGA_VS),
								 	 .b_data(VGA_B),
									 .g_data(VGA_G),
									 .r_data(VGA_R),
									 .addr_imgmem(addressB_imgmem),
									 .q_imgmem(qB_imgmem),
									 .block1x(b1x),
									 .block1y(b1y),
									 .block2x(b2x),
									 .block2y(b2y),
									 .block3x(b3x),
									 .block3y(b3y),
									 .block4x(b4x),
									 .block4y(b4y),
									 .score(vga_score),
									 .blockType(vga_type),
									 .screenMode(tempScreenMode),
									 .sysTime(seconds)
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
        data_readRegB,                   // I: Data from port B of regfile
		  
		  // Controller Inputs
		  left,
		  right,
		  down,
		  rotate_cw,
		  
		  // In Game Timing
		  counter,
		  seconds
		  
    );
	 
//	 assign dataToReg = data_writeReg;
//	assign outy = block1y;

endmodule
