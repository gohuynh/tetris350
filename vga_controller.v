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
							 blockType
							 );						 

	
input iRST_n;
input iVGA_CLK;
input [7:0] q_imgmem;
input [31:0] block1x, block1y, block2x, block2y, block3x, block3y, block4x, block4y;
input [31:0] score, blockType;
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
//reg [31:0] b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y;
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
//always@(posedge iVGA_CLK)
//begin
//	b1x <= block1x;
//   b1y <= block1y;
//   b2x <= block2x;
//   b2y <= block2y;
//   b3x <= block3x;
//   b3y <= block3y;
//   b4x <= block4x;
//   b4y <= block4y;
//end
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
//////INDEX addr.
wire [7:0] index;
wire [23:0] bgr_data_raw;
assign VGA_CLK_n = ~iVGA_CLK;
assign addr_imgmem = ADDR;
assign index = q_imgmem;
//////Color table output
imgrom	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////
wire [23:0] rgb_display;
vga_processor myProcessor(.address(ADDR),
								  .colorIn(bgr_data_raw),
								  .b1x(block1x),
								  .b1y(block1y),
								  .b2x(block2x),
								  .b2y(block2y),
								  .b3x(block3x),
								  .b3y(block3y),
								  .b4x(block4x),
								  .b4y(block4y),
								  .score(score),
								  .blockType(blockType),
								  .colorOut(rgb_display)
								  );
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
 	
