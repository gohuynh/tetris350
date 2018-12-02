module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 addr_imgmem,
							 q_imgmem,
							 block1x, block1y,
							 block2x, block2y,
							 block3x, block3y,
							 block4x, block4y,
							 score,
							 blockType,
							 screenMode,
							 sysTime
							 );						 

	
input iRST_n;
input iVGA_CLK;
input [7:0] q_imgmem;
input [31:0] block1x, block1y, block2x, block2y, block3x, block3y, block4x, block4y;
input [31:0] score, blockType, screenMode;
input [15:0] sysTime;
output [18:0] addr_imgmem;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+19'd1;
end

/////////////////////
reg [31:0] b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y, vga_score, vga_type;
	 
	 always @(posedge iVGA_CLK)
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
	 end
//////////////////////////

wire[2:0] mode;
wire[28:0] metadata;
assign mode = screenMode[31:29];
assign metadata = screenMode[28:0];

wire[18:0] addr0, addr1, addr2, addr3, addr4, addr5, addr6, addr7;

assign addr_imgmem = mode == 3'd0 ? addr0 : 19'dz;
assign addr_imgmem = mode == 3'd1 ? addr1 : 19'dz;
assign addr_imgmem = mode == 3'd2 ? addr2 : 19'dz;
assign addr_imgmem = mode == 3'd3 ? addr3 : 19'dz;
assign addr_imgmem = mode == 3'd4 ? addr4 : 19'dz;
assign addr_imgmem = mode == 3'd5 ? addr5 : 19'dz;
assign addr_imgmem = mode == 3'd6 ? addr6 : 19'dz;
assign addr_imgmem = mode == 3'd7 ? addr7 : 19'dz;

wire [7:0] index;
wire [7:0] index0, index1, index2, index3, index4, index5, index6, index7;
assign index = mode == 3'd0 ? index0 : 8'dz;
assign index = mode == 3'd1 ? index1 : 8'dz;
assign index = mode == 3'd2 ? index2 : 8'dz;
assign index = mode == 3'd3 ? index3 : 8'dz;
assign index = mode == 3'd4 ? index4 : 8'dz;
assign index = mode == 3'd5 ? index5 : 8'dz;
assign index = mode == 3'd6 ? index6 : 8'dz;
assign index = mode == 3'd7 ? index7 : 8'dz;

//wire [23:0] rgb_display;
//wire [23:0] rgb_display0, rgb_display1, rgb_display2, rgb_display3, rgb_display4, rgb_display5,
//				rgb_display6, rgb_display7;
//assign rgb_display = mode == 3'd0 ? rgb_display0 : 24'dz;
//assign rgb_display = mode == 3'd1 ? rgb_display1 : 24'dz;
//assign rgb_display = mode == 3'd2 ? rgb_display2 : 24'dz;
//assign rgb_display = mode == 3'd3 ? rgb_display3 : 24'dz;
//assign rgb_display = mode == 3'd4 ? rgb_display4 : 24'dz;
//assign rgb_display = mode == 3'd5 ? rgb_display5 : 24'dz;
//assign rgb_display = mode == 3'd6 ? rgb_display6 : 24'dz;
//assign rgb_display = mode == 3'd7 ? rgb_display7 : 24'dz;

//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
//wire [7:0] index;
wire [23:0] bgr;
//////Color table output
imgrom	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q (bgr)
	);	
	
////// SCREEN MODE 0 LOGIC

vga_mainmenu_processor main_menu(.curAddress(ADDR),
											.addrToRead(addr0),
											.indexIn(q_imgmem),
											.indexOut(index0),
											.metadata(metadata)
											);
	
////// SCREEN MODE 1 LOGIC
vga_processor myGameProcessor(.seconds(sysTime),
										.curAddress(ADDR),
										.addrToRead(addr1),
										.indexIn(q_imgmem),
										.indexOut(index1),
										.b1x(b1x),
										.b1y(b1y),
										.b2x(b2x),
										.b2y(b2y),
										.b3x(b3x),
										.b3y(b3y),
										.b4x(b4x),
										.b4y(b4y),
										.score(vga_score),
										.blockType(vga_type)
										);
																
										
////// SCREEN MODE 2 LOGIC

assign addr2 = ADDR;
assign index2 = q_imgmem;

////// SCREEN MODE 3 LOGIC

assign addr3 = ADDR;
assign index3 = q_imgmem;

////// SCREEN MODE 4 LOGIC

vga_endgame_processor endgame(.curAddress(ADDR),
									   .addrToRead(addr4),
									   .indexIn(q_imgmem),
									   .indexOut(index4),
									   .score(vga_score),
									   .metadata(metadata)
									   );

////// SCREEN MODE 5 LOGIC

assign addr5 = ADDR;
assign index5 = q_imgmem;

////// SCREEN MODE 6 LOGIC

assign addr6 = ADDR;
assign index6 = q_imgmem;

////// SCREEN MODE 7 LOGIC

assign addr7 = ADDR;
assign index7 = q_imgmem;

//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end


endmodule
 	
