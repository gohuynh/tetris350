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
							 screenMode
							 );						 

	
input iRST_n;
input iVGA_CLK;
input [7:0] q_imgmem;
input [31:0] block1x, block1y, block2x, block2y, block3x, block3y, block4x, block4y;
input [31:0] score, blockType, screenMode;
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
//////////////////////////

wire[2:0] mode;
assign mode = screenMode[31:29];

wire[18:0] addr0, addr1, addr2, addr3;

assign addr_imgmem = mode == 3'd0 ? addr0 : 19'dz;
assign addr_imgmem = mode == 3'd1 ? addr1 : 19'dz;
assign addr_imgmem = mode == 3'd2 ? addr2 : 19'dz;
assign addr_imgmem = mode == 3'd3 ? addr3 : 19'dz;


wire [23:0] rgb_display;
wire [23:0] rgb_display0, rgb_display1, rgb_display2, rgb_display3;
assign rgb_display = mode == 3'd0 ? rgb_display0 : 24'dz;
assign rgb_display = mode == 3'd1 ? rgb_display1 : 24'dz;
assign rgb_display = mode == 3'd2 ? rgb_display2 : 24'dz;
assign rgb_display = mode == 3'd3 ? rgb_display3 : 24'dz;


//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
wire [7:0] index;
wire [23:0] bgr;
//assign addr_imgmem = ADDR;
assign index = q_imgmem;
//////Color table output
imgrom	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q (bgr)
	);	
	
////// SCREEN MODE 0 LOGIC

assign addr0 = ADDR;
assign rgb_display0 = bgr;
	
////// SCREEN MODE 1 LOGIC
vga_processor myGameProcessor(.curAddress(ADDR),
										.addrToRead(addr1),
										.colorIn(bgr),
										.colorOut(rgb_display1),
										.b1x(block1x),
										.b1y(block1y),
										.b2x(block2x),
										.b2y(block2y),
										.b3x(block3x),
										.b3y(block3y),
										.b4x(block4x),
										.b4y(block4y),
										.score(score),
										.blockType(blockType)
										);
																
										
////// SCREEN MODE 2 LOGIC

assign addr2 = ADDR;
assign rgb_display2 = bgr;

////// SCREEN MODE 3 LOGIC

assign addr3 = ADDR;
assign rgb_display3 = bgr;

//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= rgb_display;
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
 	
