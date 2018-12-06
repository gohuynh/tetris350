module DE2_Audio_Example (
// Inputs
CLOCK_50,
KEY,
screenMode,
sfx_play,
sfx_freq,

AUD_ADCDAT,

// Bidirectionals
AUD_BCLK,
AUD_ADCLRCK,
AUD_DACLRCK,

I2C_SDAT,

// Outputs
AUD_XCK,
AUD_DACDAT,

I2C_SCLK
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input CLOCK_50;
input [3:0] KEY;

input AUD_ADCDAT;
input [31:0] screenMode;
input sfx_play;
input [31:0] sfx_freq;

// Bidirectionals
inout AUD_BCLK;
inout AUD_ADCLRCK;
inout AUD_DACLRCK;

inout I2C_SDAT;

// Outputs
output AUD_XCK;
output AUD_DACDAT;

output I2C_SCLK;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire audio_in_available;
wire [31:0] left_channel_audio_in;
wire [31:0] right_channel_audio_in;
wire read_audio_in;

wire audio_out_allowed;
wire [31:0] left_channel_audio_out;
wire [31:0] right_channel_audio_out;
wire write_audio_out;

// Internal Registers

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/
 
 /*****************************************************************************
 *                         LAB 6 SOUNDS GO HERE                               *
 *****************************************************************************/
 
 reg [31:0] audio, beatCounter, freqCounter, beatMax, freqMax, nextBeatMax, nextFreqMax;
 
 reg[31:0] beatIndex, nextBeatIndex;
 
// reg[31:0] sfxTimer, sfxCounter, sfxFrequency, sfx, sfxFreq;
 
 reg add, play;//, sfxAdd, sfxPlay;
 
 wire [31:0] clockFreq;
 
 assign halfClockFreq = 32'd25000000;
 
 initial
 begin
	audio <= 32'd0;
	beatCounter <= 32'd0;
	freqCounter <= 32'd0;
	beatMax <= 32'd25000000;
	freqMax <= 32'd37878;
	nextBeatMax <= 32'd12500000;
	nextFreqMax <= 32'd50000;
	beatIndex <= 32'd0;
	nextBeatIndex <= 32'd1;
	add <= 1'b1;
//	sfx <= 32'd0;
//	sfxTimer <= 32'd0;
//	sfxCounter <= 32'd0;
//	sfxFrequency <= 32'd0;
//	sfxAdd <= 1'd1;
//	sfxPlay <= 1'd0;
//	sfxFreq <= 32'd0;
 end
 
// always @(posedge CLOCK_50)
// begin
//	sfxPlay <= sfx_play;
//	sfxFreq <= sfx_freq;
//	if (sfxPlay)
//	begin
//		sfxTimer <= 32'd0;
//		sfxCounter <= 32'd0;
//		sfxFrequency <= 32'd25000000 / sfxFreq;
//		sfxAdd <= 1'd1;
//	end
//	if (sfxTimer < 32'd12500000)
//	begin
//		sfxTimer <= sfxTimer + 32'd1;
//		if (sfxCounter >= sfxFrequency)
//		begin
//			sfxAdd <= ~sfxAdd;
//			sfxCounter <= 32'd0;
//		end
//		else
//		begin
//			sfxCounter <= sfxCounter + 32'd1;
//			if (sfxAdd)
//				sfx <= 32'd100000000;
//			else
//				sfx <= 32'd0 - 32'd100000000;				
//		end
//	end
//	else
//		sfx <= 32'd0;
// end
 
 always
 begin
	case(beatIndex)
	32'd0:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd50000;			//b'
				nextBeatIndex <= 32'd1;
			end
	32'd1:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd2;
			end
	32'd2:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd43103;			//d''
				nextBeatIndex <= 32'd3;
			end
	32'd3:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd4;
			end
	32'd4:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd50000;			//b'
				nextBeatIndex <= 32'd5;
			end
	32'd5:begin
				nextBeatMax <= 32'd37500000;
				nextFreqMax <= 32'd56818;			//a'
				nextBeatIndex <= 32'd6;
			end
	32'd6:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd7;
			end
	32'd7:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd37878;			//e''
				nextBeatIndex <= 32'd8;
			end
	32'd8:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd43103;			//d''
				nextBeatIndex <= 32'd9;
			end
	32'd9:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd10;
			end
	32'd10:begin
				nextBeatMax <= 32'd37500000;
				nextFreqMax <= 32'd50000;			//b'
				nextBeatIndex <= 32'd11;
			end
	32'd11:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd12;
			end
	32'd12:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd43103;			//d''
				nextBeatIndex <= 32'd13;
			end
	32'd13:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd37878;			//e''
				nextBeatIndex <= 32'd14;
			end
	32'd14:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd15;
			end
	32'd15:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd56818;			//a'
				nextBeatIndex <= 32'd16;
			end
	32'd16:begin
				nextBeatMax <= 32'd37500000;
				nextFreqMax <= 32'd0;				//rest
				nextBeatIndex <= 32'd17;
			end
	32'd17:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd43103;			//d''
				nextBeatIndex <= 32'd18;
			end
	32'd18:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd35714;			//f''
				nextBeatIndex <= 32'd19;
			end
	32'd19:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd28409;			//a''
				nextBeatIndex <= 32'd20;
			end
	32'd20:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd32051;			//g''
				nextBeatIndex <= 32'd21;
			end
	32'd21:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd35714;			//f''
				nextBeatIndex <= 32'd22;
			end
	32'd22:begin
				nextBeatMax <= 32'd37500000;
				nextFreqMax <= 32'd37878;			//e''
				nextBeatIndex <= 32'd23;
			end
	32'd23:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd24;
			end
	32'd24:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd37878;			//e''
				nextBeatIndex <= 32'd25;
			end
	32'd25:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd43103;			//d''
				nextBeatIndex <= 32'd26;
			end
	32'd26:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd27;
			end
	32'd27:begin
				nextBeatMax <= 32'd37500000;
				nextFreqMax <= 32'd50000;			//b'
				nextBeatIndex <= 32'd28;
			end
	32'd28:begin
				nextBeatMax <= 32'd12500000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd29;
			end
	32'd29:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd43103;			//d''
				nextBeatIndex <= 32'd30;
			end
	32'd30:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd37878;			//e''
				nextBeatIndex <= 32'd31;
			end
	32'd31:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd48076;			//c''
				nextBeatIndex <= 32'd32;
			end
	32'd32:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd56818;			//a'
				nextBeatIndex <= 32'd33;
			end
	32'd33:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd0;			//rest
				nextBeatIndex <= 32'd34;
			end
	32'd34:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd75757;			//e'
				nextBeatIndex <= 32'd35;
			end
	32'd35:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd96153;			//c'
				nextBeatIndex <= 32'd36;
			end
	32'd36:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd86206;			//d'
				nextBeatIndex <= 32'd37;
			end
	32'd37:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd100000;			//b
				nextBeatIndex <= 32'd38;
			end
	32'd38:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd96153;			//c'
				nextBeatIndex <= 32'd39;
			end
	32'd39:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd113636;			//a
				nextBeatIndex <= 32'd40;
			end
	32'd40:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd120772;			//gsharp
				nextBeatIndex <= 32'd41;
			end
	32'd41:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd100000;			//b
				nextBeatIndex <= 32'd42;
			end
	32'd42:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd75757;			//e'
				nextBeatIndex <= 32'd43;
			end
	32'd43:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd96153;			//c'
				nextBeatIndex <= 32'd44;
			end
	32'd44:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd86206;			//d'
				nextBeatIndex <= 32'd45;
			end
	32'd45:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd100000;			//b
				nextBeatIndex <= 32'd46;
			end
	32'd46:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd96153;			//c'
				nextBeatIndex <= 32'd47;
			end
	32'd47:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd75757;			//e'
				nextBeatIndex <= 32'd48;
			end
	32'd48:begin
				nextBeatMax <= 32'd50000000;
				nextFreqMax <= 32'd56818;			//a'
				nextBeatIndex <= 32'd49;
			end
	32'd49:begin
				nextBeatMax <= 32'd100000000;
				nextFreqMax <= 32'd60240;			//gsharp'
				nextBeatIndex <= 32'd50;
			end
	32'd50:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd37878;			//e''
				nextBeatIndex <= 32'd0;
			end
	default:begin
				nextBeatMax <= 32'd25000000;
				nextFreqMax <= 32'd37878;
				nextBeatIndex <= 32'd0;
			end
	endcase
 end
 
 always @(posedge CLOCK_50)
 begin
	if (screenMode[31:29] == 3'd1)
	begin
		if (beatCounter >= beatMax)
		begin
			beatCounter <= 32'd0;
			freqCounter <= 32'd0;
			beatMax <= nextBeatMax;
			freqMax <= nextFreqMax;
			beatIndex <= nextBeatIndex;
		end
		else
		begin
			beatCounter <= beatCounter + 32'd1;
			if (freqCounter >= freqMax)
			begin
				add <= ~add;
				freqCounter <= 32'd0;
			end
			else
			begin
				freqCounter <= freqCounter + 32'd1;
				if (add)
					audio <= 32'd100000000;
				else
					audio <= 32'd0 - 32'd100000000;
			end
		end
	end
	else
	begin
		beatCounter <= 32'd0;
		freqCounter <= 32'd0;
		beatMax <= 32'd25000000;
		freqMax <= 32'd37878;
		beatIndex <= 32'd50;
		add <= 1'b1;
	end
 end
 
// wire [31:0] toAdd;
// assign toAdd = screenMode[31:29] == 3'd1 ? audio : 32'd0;
 
 
 /*****************************************************************************
 *                         LAB 6 SOUNDS END HERE                              *
 *****************************************************************************/


assign read_audio_in = audio_in_available & audio_out_allowed;

wire [31:0] left_in, right_in, left_out, right_out;
assign left_in = left_channel_audio_in;
assign right_in = right_channel_audio_in;


assign left_channel_audio_out = left_out + audio;// + sfx;
assign right_channel_audio_out = right_out + audio;// + sfx;
assign write_audio_out = audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Audio_Controller Audio_Controller (
// Inputs
.CLOCK_50 (CLOCK_50),
.reset (~KEY[0]),

.clear_audio_in_memory (),
.read_audio_in (read_audio_in),
.clear_audio_out_memory (),
.left_channel_audio_out (left_channel_audio_out),
.right_channel_audio_out (right_channel_audio_out),
.write_audio_out (write_audio_out),

.AUD_ADCDAT (AUD_ADCDAT),

// Bidirectionals
.AUD_BCLK (AUD_BCLK),
.AUD_ADCLRCK (AUD_ADCLRCK),
.AUD_DACLRCK (AUD_DACLRCK),


// Outputs
.audio_in_available (audio_in_available),
.left_channel_audio_in (left_channel_audio_in),
.right_channel_audio_in (right_channel_audio_in),

.audio_out_allowed (audio_out_allowed),

.AUD_XCK (AUD_XCK),
.AUD_DACDAT (AUD_DACDAT),

);

avconf #(.USE_MIC_INPUT(1)) avc (
.I2C_SCLK (I2C_SCLK),
.I2C_SDAT (I2C_SDAT),
.CLOCK_50 (CLOCK_50),
.reset (~KEY[0]),
.key1 (KEY[1]),
.key2 (KEY[2])
);

endmodule