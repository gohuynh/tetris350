# addi $21, $0, 154;
# addi $1, $0, 4; # Screen Mode
# sll $1, $1, 3;
# addi $1, $1, 5; # result and type
# sll $15, $1, 26;
# j endgame;
# ======================================================================================================
# Loop for Main Menu Screen
# ======================================================================================================
mainmenu:
# Change screen and set up registers
add $15, $0, $0;
addi $1, $0, 40625;
sll $1, $1, 5;
add $2, $0, $0;
# Input loop:
mainmenu_input_loop:
addi $2, $2, 1;
bne $1, $2, 2;
jal mainmenu_handle_input;
add $2, $0, $0;
j mainmenu_input_loop;
# Handle Input
mainmenu_handle_input:
ri $3;
addi $4, $0, 4;
bne $3, $4, 1;
j mainmenu_toggle;
addi $4, $0, 8;
bne $3, $4, 1;
j mainmenu_select;
jr $31;
# Toggle through options
mainmenu_toggle:
addi $3, $0, 1;
sll $3, $3, 26;
add $15, $15, $3;
sra $3, $15, 26;
addi $4, $0, 7;
and $3, $3, $4;
addi $4, $0, 5;
blt $3, $4, 1;
add $15, $0, $0;
jr $31;
# Logic to transition to selected screen
mainmenu_select:
sra $3, $15, 26;
addi $4, $0, 7;
and $3, $3, $4;
addi $4, $0, 0;
bne $3, $4, 1;
j mainmenu_to_onep;
addi $4, $4, 1;
bne $3, $4, 1;
j mainmenu_to_end;
addi $4, $4, 1;
bne $3, $4, 1;
j mainmenu_to_twop;
addi $4, $4, 1;
bne $3, $4, 1;
j mainmenu_to_toponep;
j mainmenu_to_topend;
# Transition to 1P mode
mainmenu_to_onep:
addi $1, $0, 1;
sll $15, $1, 29;
j gameonep;
# Transition to Endless mode
mainmenu_to_end:
addi $1, $0, 1;
sll $15, $1, 29;
addi $15, $15, 1;
j gameonep;
# Transition to 2P mode
mainmenu_to_twop:
# Take out 2p mode***********************************************
j infinity;
# Transition to 1P Scores
mainmenu_to_toponep:
j toponep;
# Transition to Endless Scores
mainmenu_to_topend:
j topend;

# ======================================================================================================
# Loop for End Game Screen
# ======================================================================================================
endgame:
# Set up registers
addi $1, $0, 40625;
sll $1, $1, 5;
add $2, $0, $0;
# Get game results
sra $3, $15, 27;
addi $4, $0, 3;
and $3, $3, $4;
# Parse score if necessary
addi $4, $0, 1;
blt $3, $4, 1;
jal endgame_parse_score;
# Set up default highlighted option
addi $4, $0, 63;
sll $4, $4, 26;
and $15, $15, $4;
addi $4, $0, 2;
blt $3, $4, endgame_input_loop;
addi $5, $0, 2;
sll $5, $5, 23;
or $15, $15, $5;
# -------------------------------
# Input loop
# -------------------------------
endgame_input_loop:
addi $2, $2, 1;
bne $1, $2, 2;
jal endgame_handle_input;
add $2, $0, $0;
j endgame_input_loop;
# -------------------------------
# Parse the score
# -------------------------------
endgame_parse_score:
addi $11, $0, 2000
sw $21, 0($11);
sra $4, $15, 26;
addi $5, $0, 1;
and $4, $4, $5;
addi $5, $0, 10;# 10 for division
addi $6, $0, 0; # digit3
addi $7, $0, 0; # digit2
addi $8, $0, 0; # digit1
bne $4, $0, 1;
j endgame_parse_time;
# Parse score register into lines digits
addi $4, $0, 100; # decimal
# score / 100 and score % 100
endgame_parse_line_score_div_hundred:
blt $21, $4, 3;
addi $7, $7, 1;
sub $21, $21, $4;
j endgame_parse_line_score_div_hundred;
# (score / 100) / 10 and (score / 100) % 10
endgame_parse_line_thousands_div_ten:
blt $7, $5, 3;
addi $6, $6, 1;
sub $7, $7, $5;
j endgame_parse_line_thousands_div_ten;
# (score % 100) / 10 and (score % 100) % 10
endgame_parse_time_hundreds_div_ten:
blt $21, $5, 3;
addi $8, $8, 1;
sub $21, $21, $5;
j endgame_parse_time_hundreds_div_ten;
# sanity check
addi $4, $0, 15;
and $6, $6, $4;
and $7, $7, $4;
and $8, $8, $4;
and $21, $21, $4;
# Shift values and add together
sll $6, $6, 12;
sll $7, $7, 8;
sll $8, $8, 4;
add $21, $6, $21;
add $21, $7, $21;
add $21, $8, $21;
jr $31;
# Parse score register into time digits
endgame_parse_time:
addi $4, $0, 60; # seconds
# Score / 60 and score % 60
endgame_parse_time_score_div_sixty:
blt $21, $4, 3;
addi $7, $7, 1;
sub $21, $21, $4;
j endgame_parse_time_score_div_sixty;
# (score / 60) / 10 and (score / 60) % 10
endgame_parse_time_min_div_ten:
blt $7, $5, 3;
addi $6, $6, 1;
sub $7, $7, $5;
j endgame_parse_time_min_div_ten;
# (score % 60) / 10 and (score % 60) % 10
endgame_parse_time_sec_div_ten:
blt $21, $5, 3;
addi $8, $8, 1;
sub $21, $21, $5;
j endgame_parse_time_sec_div_ten;
# sanity check
addi $4, $0, 15;
and $6, $6, $4;
and $7, $7, $4;
and $8, $8, $4;
and $21, $21, $4;
# Shift values and add together
sll $6, $6, 12;
sll $7, $7, 8;
sll $8, $8, 4;
add $21, $6, $21;
add $21, $7, $21;
add $21, $8, $21;
jr $31;
# -------------------------------
# Handle Input
# -------------------------------
endgame_handle_input:
ri $4;
addi $5, $0, 1;
bne $4, $5, 1;
j endgame_left_input;
addi $5, $0, 2;
bne $4, $5, 1;
j endgame_right_input;
addi $5, $0, 4;
bne $4, $5, 1;
j endgame_down_input;
addi $5, $0, 8;
bne $4, $5, 1;
j endgame_rotate_input;
jr $31;
# -------------------------------
# Left input detected
# -------------------------------
endgame_left_input:
# Check if options 0 and 1 available
addi $4, $0, 2;
blt $3, $4, endgame_left_input_normal;
# Check if option 2 is already selected
sra $4, $15, 23;
addi $5, $0, 7;
and $4, $4, $5;
addi $5, $0, 2;
bne $4, $5, 1;
jr $31;
# Decrement selected option
addi $4, $0, 1;
sll $4, $4, 23;
sub $15, $15, $4;
jr $31;
# Set option to 0
endgame_left_input_normal:
addi $4, $0, -1;
addi $5, $0, 7;
sll $5, $5, 23;
sub $4, $4, $5;
and $15, $15, $4;
jr $31;
# -------------------------------
# Right input detected
# -------------------------------
endgame_right_input:
# Check if options 0 and 1 available
addi $4, $0, 2;
blt $3, $4, endgame_right_input_normal;
# Check if option 5 is already selected
sra $4, $15, 23;
addi $5, $0, 7;
and $4, $4, $5;
addi $5, $0, 5;
bne $4, $5, 1;
jr $31;
# Increment selected option
addi $4, $0, 1;
sll $4, $4, 23;
add $15, $15, $4;
jr $31;
# Set option to 1
endgame_right_input_normal:
addi $4, $0, -1;
addi $5, $0, 7;
sll $5, $5, 23;
sub $4, $4, $5;
and $15, $15, $4;
addi $4, $0, 1;
sll $4, $4, 23;
add $15, $15, $4;
jr $31;
# -------------------------------
# Down input detected
# -------------------------------
endgame_down_input:
# Check if normal options
addi $4, $0, 1;
blt $4, $3, 1;
jr $31;
# Check if option 5
sra $4, $15, 23;
addi $5, $0, 7;
and $4, $4, $5;
addi $5, $0, 5;
bne $4, $5, 1;
jr $31;
addi $5, $0, 2;
bne $4, $5, 1;
j endgame_down_chartwo;
addi $5, $0, 3;
bne $4, $5, 1;
j endgame_down_charone;
j endgame_down_charzero;
# Increment if needed chartwo
endgame_down_chartwo:
# Check if already at 'Z'
sra $4, $15, 12;
addi $5, $0, 63;
and $4, $4, $5;
addi $5, $0, 35;
bne $4, $5, 1;
jr $31;
# Increment char value
addi $15, $15, 4096;
jr $31;
# Increment if needed charone
endgame_down_charone:
# Check if already at 'Z'
sra $4, $15, 6;
addi $5, $0, 63;
and $4, $4, $5;
addi $5, $0, 35;
bne $4, $5, 1;
jr $31;
# Increment char value
addi $15, $15, 64;
jr $31;
# Increment if needed charzero
endgame_down_charzero:
# Check if already at 'Z'
addi $5, $0, 63;
and $4, $15, $5;
addi $5, $0, 35;
bne $4, $5, 1;
jr $31;
# Increment char value
addi $15, $15, 1;
jr $31;
# -------------------------------
# Rotate input detected
# -------------------------------
endgame_rotate_input:
sra $4, $15, 23;
addi $5, $0, 7;
and $4, $4, $5;
bne $4, $0, 1;
j endgame_to_mainmenu;
addi $5, $0, 1;
bne $4, $5, 1;
j endgame_to_restart;
addi $5, $0, 2;
bne $4, $5, 1;
j endgame_rotate_chartwo;
addi $5, $0, 3;
bne $4, $5, 1;
j endgame_rotate_charone;
addi $5, $0, 4;
bne $4, $5, 1;
j endgame_rotate_charzero;
j endgame_to_leaderboard;
# Decrement if needed chartwo
endgame_rotate_chartwo:
# Check if already at '0'
sra $4, $15, 12;
addi $5, $0, 63;
and $4, $4, $5;
bne $4, $0, 1;
jr $31;
# Decrement char value
addi $15, $15, -4096;
jr $31;
# Decrement if needed charone
endgame_rotate_charone:
# Check if already at '0'
sra $4, $15, 6;
addi $5, $0, 63;
and $4, $4, $5;
bne $4, $0, 1;
jr $31;
# Decrement char value
addi $15, $15, -64;
jr $31;
# Decrement if needed charzero
endgame_rotate_charzero:
# Check if already at '0'
addi $5, $0, 63;
and $4, $15, $5;
bne $4, $0, 1;
jr $31;
# Decrement char value
addi $15, $15, -1;
jr $31;
# -------------------------------
# Handle Screen Transitions
# -------------------------------
# Transition to main menu
endgame_to_mainmenu:
j mainmenu;
# Transition to new game:
endgame_to_restart:
# Check which game type
sra $4, $15, 26;
addi $5, $0, 1;
and $4, $4, $5;
bne $4, $0, 1;
j endgame_to_onep;
# Transition to Endless mode
addi $1, $0, 1;
sll $15, $1, 29;
addi $15, $15, 1;
j gameonep;
# Transition to 1P mode
endgame_to_onep:
addi $1, $0, 1;
sll $15, $1, 29;
j gameonep;
# Transition to leaderboards
endgame_to_leaderboard:
# Get unparsed score and associated name
addi $11, $0, 2000
lw $1, 0($11); # current score
addi $2, $0, 511;
sll $2, $2, 9;
addi $2, $2, 511;
and $2, $15, $2; # current name
# Check which leaderboard
sra $4, $15, 26;
addi $5, $0, 1;
and $4, $4, $5;
bne $4, $0, 1;
j endgame_to_toponep;
# Transition to Endless Scores
jal endgame_save_line;
j topend;
# Transition to 1P Scores
endgame_to_toponep:
jal endgame_save_time
j toponep;
# -------------------------------
# Store name and score
# -------------------------------
# Store new line record
endgame_save_line:
lw $3, 10($0); # 1 score
lw $4, 11($0); # 1 name
lw $5, 12($0); # 2 score
lw $6, 13($0); # 2 name
lw $7, 14($0); # 3 score
lw $8, 15($0); # 3 name
# Compare Cur and 1
blt $1, $3, 4;
sw $1, 10($0);
sw $2, 11($0);
add $1, $3, $0;
add $2, $4, $0;
# Compare Cur and 2
blt $1, $5, 4;
sw $1, 12($0);
sw $2, 13($0);
add $1, $5, $0;
add $2, $6, $0;
# Regardlesss, overwrite 3
sw $1, 14($0);
sw $2, 15($0);
jr $31;
# Store new time record
endgame_save_time:
lw $3, 0($0); # 1 score
lw $4, 1($0); # 1 name
lw $5, 2($0); # 2 score
lw $6, 3($0); # 2 name
lw $7, 4($0); # 3 score
lw $8, 5($0); # 3 name
# Compare Cur and 1
blt $3, $1, 4;
sw $1, 0($0);
sw $2, 1($0);
add $1, $3, $0;
add $2, $4, $0;
# Compare Cur and 2
blt $5, $1, 4;
sw $1, 2($0);
sw $2, 3($0);
add $1, $5, $0;
add $2, $6, $0;
# Regardlesss, overwrite 3
sw $1, 4($0);
sw $2, 5($0);
jr $31;

# ======================================================================================================
# Loop for 1P Leaderboard
# ======================================================================================================
toponep:
addi $1, $0, 5;
sll $15, $1, 29;
# Load Names
lw $22 1($0);
lw $24 3($0);
lw $26 5($0);
# Load Scores
lw $1 0($0);
jal toponep_parse_score;
add $23, $2, $0;
lw $1 2($0);
jal toponep_parse_score;
add $25, $2, $0;
lw $1 4($0);
jal toponep_parse_score;
add $27, $2, $0;
# Set up for input loop
addi $1, $0, 40625;
sll $1, $1, 5;
add $2, $0, $0;
toponep_input_loop:
addi $2, $2, 1;
bne $1, $2, 2;
jal toponep_handle_input;
add $2, $0, $0;
j toponep_input_loop;
# Check if input detected
toponep_handle_input:
ri $3;
bne $3, $0, 1;
jr $31;
# Input detected, return back to main
j mainmenu;
# Parse Scores
toponep_parse_score:
addi $2, $0, 60; # 60 seconds
addi $3, $0, 10;# 10 for division
addi $4, $0, 0; # digit3
addi $5, $0, 0; # digit2
addi $6, $0, 0; # digit1
addi $7, $1, 0; # digit0
# Score / 60 and score % 60
toponep_parse_time_score_div_sixty:
blt $7, $2, 3;
addi $5, $5, 1;
sub $7, $7, $2;
j toponep_parse_time_score_div_sixty;
# (score / 60) / 10 and (score / 60) % 10
toponep_parse_time_min_div_ten:
blt $5, $3, 3;
addi $4, $4, 1;
sub $5, $5, $3;
j toponep_parse_time_min_div_ten;
# (score % 60) / 10 and (score % 60) % 10
toponep_parse_time_sec_div_ten:
blt $7, $3, 3;
addi $6, $6, 1;
sub $7, $7, $3;
j toponep_parse_time_sec_div_ten;
# sanity check
addi $2, $0, 15;
and $4, $4, $2;
and $5, $5, $2;
and $6, $6, $2;
and $7, $7, $2;
# Shift values and add together
sll $4, $4, 12;
sll $5, $5, 8;
sll $6, $6, 4;
add $2, $4, $5;
add $2, $2, $6;
add $2, $2, $7;
jr $31;

# ======================================================================================================
# Loop for Endless Leaderboard
# ======================================================================================================
topend:
addi $1, $0, 6;
sll $15, $1, 29;
# Load Names
lw $22 11($0);
lw $24 13($0);
lw $26 15($0);
# Load Scores
lw $1 10($0);
jal topend_parse_score;
add $23, $2, $0;
lw $1 12($0);
jal topend_parse_score;
add $25, $2, $0;
lw $1 14($0);
jal topend_parse_score;
add $27, $2, $0;
# Set up for input loop
addi $1, $0, 40625;
sll $1, $1, 5;
add $2, $0, $0;
toponep_input_loop:
addi $2, $2, 1;
bne $1, $2, 2;
jal toponep_handle_input;
add $2, $0, $0;
j toponep_input_loop;
# Check if input detected
toponep_handle_input:
ri $3;
bne $3, $0, 1;
jr $31;
# Input detected, return back to main
j mainmenu;
# Parse Scores
topend_parse_score:
addi $2, $0, 100; # 100 for division
addi $3, $0, 10;# 10 for division
addi $4, $0, 0; # digit3
addi $5, $0, 0; # digit2
addi $6, $0, 0; # digit1
addi $7, $1, 0; # digit0
# Score / 60 and score % 60
topend_parse_line_score_div_hundred:
blt $7, $2, 3;
addi $5, $5, 1;
sub $7, $7, $2;
j topend_parse_line_score_div_hundred;
# (score / 60) / 10 and (score / 60) % 10
topend_parse_line_thousands_div_ten:
blt $5, $3, 3;
addi $4, $4, 1;
sub $5, $5, $3;
j topend_parse_line_thousands_div_ten;
# (score % 60) / 10 and (score % 60) % 10
topend_parse_line_hundreds_div_ten:
blt $7, $3, 3;
addi $6, $6, 1;
sub $7, $7, $3;
j topend_parse_line_hundreds_div_ten;
# sanity check
addi $2, $0, 15;
and $4, $4, $2;
and $5, $5, $2;
and $6, $6, $2;
and $7, $7, $2;
# Shift values and add together
sll $4, $4, 12;
sll $5, $5, 8;
sll $6, $6, 4;
add $2, $4, $5;
add $2, $2, $6;
add $2, $2, $7;
jr $31;

# ======================================================================================================
# Loop for 1P Game
# ======================================================================================================
gameonep:
# initialize registers that will be used for in game logic
addi  $19,   $0,   260
addi  $18,   $0,   410
addi  $17,   $0,   70
addi $16, $0, 640

addi $2, $0, 12900
# $1 has the color black
ilw $1, 0($2)

# rows left
addi $21, $0, 10
# top level loop, start here for each new block
newblock:

#set rotation status to 0 at memory address 1000
addi $2, $0, 1000
sw $0, 0($2)

# select random block
rtick $3
addi $2, $0, 127
and $3, $3, $2
addi $2, $0, 18
blt $3, $2, tOne
addi $2, $2, 18
blt $3, $2, tTwo
addi $2, $2, 18
blt $3, $2, tThree
addi $2, $2, 18
blt $3, $2, tFour
addi $2, $2, 18
blt $3, $2, tFive
addi $2, $2, 18
blt $3, $2, tSix
j tSeven

tOne:
addi $20, $0, 109

addi $22, $0, 140
addi $23, $0, 60

addi $24, $0, 160
addi $25, $0, 60

addi $26, $0, 160
addi $27, $0, 40

addi $28, $0, 140
addi $29, $0, 40
j startgameloop

tTwo:
addi $20, $0, 179

addi $22, $0, 140
addi $23, $0, 100

addi $24, $0, 140
addi $25, $0, 80

addi $26, $0, 140
addi $27, $0, 60

addi $28, $0, 140
addi $29, $0, 40
j startgameloop

tThree:
addi $20, $0, 106

addi $22, $0, 160
addi $23, $0, 80

addi $28, $0, 140
addi $29, $0, 80

addi $26, $0, 140
addi $27, $0, 60

addi $24, $0, 140
addi $25, $0, 40
j startgameloop

tFour:
addi $20, $0, 35

addi $22, $0, 140
addi $23, $0, 80

addi $28, $0, 160
addi $29, $0, 80

addi $26, $0, 160
addi $27, $0, 60

addi $24, $0, 160
addi $25, $0, 40
j startgameloop

tFive:
addi $20, $0, 108

addi $22, $0, 160
addi $23, $0, 60

addi $28, $0, 140
addi $29, $0, 60

addi $26, $0, 140
addi $27, $0, 40

addi $24, $0, 120
addi $25, $0, 60
j startgameloop

tSix:
addi $20, $0, 113

addi $22, $0, 140
addi $23, $0, 80

addi $24, $0, 140
addi $25, $0, 60

addi $26, $0, 160
addi $27, $0, 60

addi $28, $0, 160
addi $29, $0, 40
j startgameloop

tSeven:
addi $20, $0, 86

addi $22, $0, 160
addi $23, $0, 80

addi $24, $0, 160
addi $25, $0, 60

addi $26, $0, 140
addi $27, $0, 60

addi $28, $0, 140
addi $29, $0, 40


startgameloop:
#time til move down
addi $5, $0, 65335
sll $5, $5, 8
# time til button check
addi $6, $0, 65335
sll $6, $6, 4

innerloop:
addi $5, $5, -1
bne $0, $5, buttontimer
jal movedown
addi $5, $0, 65335
sll $5, $5, 8

buttontimer:
addi $6, $6, -1
bne $0, $6, innerloop

# check each combination of buttons
ri $12

addi $3, $0, 1
bne $12, $3, 1
jal moveleft

addi $3, $0, 2
bne $12, $3, 1
jal moveright

addi $3, $0, 4
bne $12, $3, 1
jal movedown

addi $3, $0, 5
bne $12, $3, 2
jal moveleft
jal movedown

addi $3, $0, 6
bne $12, $3, 2
jal moveright
jal movedown

addi $3, $0, 7
bne $12, $3, 1
jal movedown

addi $3, $0, 8
bne $12, $3, 1
jal rotate

addi $3, $0, 9
bne $12, $3, 2
jal moveleft
jal rotate

addi $3, $0, 10
bne $12, $3, 2
jal moveright
jal rotate

addi $3, $0, 11
bne $12, $3, 1
jal rotate

addi $3, $0, 12
bne $12, $3, 2
jal movedown
jal rotate

addi $3, $0, 13
bne $12, $3, 3
jal moveleft
jal movedown
jal rotate

addi $3, $0, 14
bne $12, $3, 3
jal moveright
jal movedown
jal rotate

addi $3, $0, 15
bne $12, $3, 2
jal movedown
jal rotate

addi $6, $0, 65335
sll $6, $6, 4
j innerloop
# END BUTTON CHECK

movedown:
# bounds checks: it can either move or be saved
# t1
blt $18, $23, saveit
blt $18, $25, saveit
blt $18, $27, saveit
blt $18, $29, saveit

# check the color of the pixel 23 pixels below of the top left corner
mul $2, $16, $23
add $2, $2, $22
addi $2, $2, 14721
ilw $3, 0($2)
# if it's black, check next space
# if it's not black, it can't be moved
bne $3, $1, saveit
mul $2, $16, $25
add $2, $2, $24
addi $2, $2, 14721
ilw $3, 0($2)
bne $3, $1, saveit
mul $2, $16, $27
add $2, $2, $26
addi $2, $2, 14721
ilw $3, 0($2)
bne $3, $1, saveit
mul $2, $16, $29
add $2, $2, $28
addi $2, $2, 14721
ilw $3, 0($2)
bne $3, $1, saveit

moveit:
addi $23, $23, 20
addi $25, $25, 20
addi $27, $27, 20
addi $29, $29, 20
jr $31

saveit:
# loop through each pixel in the block to save it
# use $13, $20,
# first cell

mul $13, $16, $23
add $13, $13, $22
# 20 pixels before next row
addi $2, $0, 20
addi $4, $0, 0

toploop:
addi $3, $0, 0

saveloop:
isw $20, 0($13)
addi $13, $13, 1
addi $3, $3, 1
blt $3, $2, saveloop
addi $13, $13, 620
addi $4, $4, 1
blt $4, $2, toploop

mul $13, $16, $25
add $13, $13, $24
# 20 pixels before next row
addi $2, $0, 20
addi $4, $0, 0

toplooptwo:
addi $3, $0, 0

savelooptwo:
isw $20, 0($13)
addi $13, $13, 1
addi $3, $3, 1
blt $3, $2, savelooptwo
addi $13, $13, 620
addi $4, $4, 1
blt $4, $2, toplooptwo

mul $13, $16, $27
add $13, $13, $26
# 20 pixels before next row
addi $2, $0, 20
addi $4, $0, 0

toploopthree:
addi $3, $0, 0

saveloopthree:
isw $20, 0($13)
addi $13, $13, 1
addi $3, $3, 1
blt $3, $2, saveloopthree
addi $13, $13, 620
addi $4, $4, 1
blt $4, $2, toploopthree

mul $13, $16, $29
add $13, $13, $28
# 20 pixels before next row
addi $2, $0, 20
addi $4, $0, 0

toploopfour:
addi $3, $0, 0

saveloopfour:
isw $20, 0($13)
addi $13, $13, 1
addi $3, $3, 1
blt $3, $2, saveloopfour
addi $13, $13, 620
addi $4, $4, 1
blt $4, $2, toploopfour


# save complete, now check if any line needs to be cleared
# $2, $3, $4, $7, $8, $9, $10, $11
# checking the row of cell1
addi $2, $0, 10
mul $3, $16, $29
addi $3, $3, 60
ccloopone:
# load in a pixel
ilw $4, 0($3)
# if it is black, don't clear this line
bne $4, $1, 1
j ccstarttwo
addi $3, $3, 20
addi $2, $2, -1
bne $0, $2, ccloopone
# if all pixels are not black in a row, clear the line
# clear a line by replacing a pixel with a pixel 20 pixels above it
# so you have to clear 10 cells
# quadruple loop in total to clear all rows above the current row

addi $3, $3, -200
addi $10, $3, 0
addi $11, $10, 0
addi $14, $0, 25600

clearloopfour:
addi $9, $0, 10

clearloopthree:
addi $8, $0, 20
addi $7, $3, -640
ilw $4, 0($7)
clearlooptwo:
addi $2, $0, 20

clearloopone:
isw $4, 0($3)
addi $3, $3, 1
 
addi $2, $2, -1
bne $0, $2, clearloopone
addi $3, $3, 620
addi $8, $8, -1
bne $0, $8, clearlooptwo
addi $3, $10, 20
addi $10, $10, 20
addi $9, $9, -1
bne $0, $9, clearloopthree
addi $10, $11, -12800
addi $11, $11, -12800
addi $3, $11, 0
blt $14, $11, clearloopfour

addi $21, $21, -1

ccstarttwo:
addi $2, $0, 10
mul $3, $16, $27
addi $3, $3, 60
cclooptwo:
# load in a pixel
ilw $4, 0($3)
# if it is black, don't clear this line
bne $4, $1, 1
j ccstartthree
addi $3, $3, 20
addi $2, $2, -1
bne $0, $2, cclooptwo

addi $3, $3, -200
addi $10, $3, 0
addi $11, $10, 0
addi $14, $0, 25600

clearloopfourb:
addi $9, $0, 10

clearloopthreeb:
addi $8, $0, 20
addi $7, $3, -640
ilw $4, 0($7)
clearlooptwob:
addi $2, $0, 20

clearlooponeb:
isw $4, 0($3)
addi $3, $3, 1
 
addi $2, $2, -1
bne $0, $2, clearlooponeb
addi $3, $3, 620
addi $8, $8, -1
bne $0, $8, clearlooptwob
addi $3, $10, 20
addi $10, $10, 20
addi $9, $9, -1
bne $0, $9, clearloopthreeb
addi $10, $11, -12800
addi $11, $11, -12800
addi $3, $11, 0
blt $14, $11, clearloopfourb

addi $21, $21, -1

ccstartthree:
addi $2, $0, 10
mul $3, $16, $25
addi $3, $3, 60
ccloopthree:
# load in a pixel
ilw $4, 0($3)
# if it is black, don't clear this line
bne $4, $1, 1
j ccstartfour
addi $3, $3, 20
addi $2, $2, -1
bne $0, $2, ccloopthree

addi $3, $3, -200
addi $10, $3, 0
addi $11, $10, 0
addi $14, $0, 25600

clearloopfourc:
addi $9, $0, 10

clearloopthreec:
addi $8, $0, 20
addi $7, $3, -640
ilw $4, 0($7)
clearlooptwoc:
addi $2, $0, 20

clearlooponec:
isw $4, 0($3)
addi $3, $3, 1
 
addi $2, $2, -1
bne $0, $2, clearlooponec
addi $3, $3, 620
addi $8, $8, -1
bne $0, $8, clearlooptwoc
addi $3, $10, 20
addi $10, $10, 20
addi $9, $9, -1
bne $0, $9, clearloopthreec
addi $10, $11, -12800
addi $11, $11, -12800
addi $3, $11, 0
blt $14, $11, clearloopfourc

addi $21, $21, -1

ccstartfour:
addi $2, $0, 10
mul $3, $16, $23
addi $3, $3, 60
ccloopfour:
# load in a pixel
ilw $4, 0($3)
# if it is black, don't clear this line
bne $4, $1, 1
j endcheck
addi $3, $3, 20
addi $2, $2, -1
bne $0, $2, ccloopfour

addi $3, $3, -200
addi $10, $3, 0
addi $11, $10, 0
addi $14, $0, 25600

clearloopfourd:
addi $9, $0, 10

clearloopthreed:
addi $8, $0, 20
addi $7, $3, -640
ilw $4, 0($7)
clearlooptwod:
addi $2, $0, 20

clearlooponed:
isw $4, 0($3)
addi $3, $3, 1
 
addi $2, $2, -1
bne $0, $2, clearlooponed
addi $3, $3, 620
addi $8, $8, -1
bne $0, $8, clearlooptwod
addi $3, $10, 20
addi $10, $10, 20
addi $9, $9, -1
bne $0, $9, clearloopthreed
addi $10, $11, -12800
addi $11, $11, -12800
addi $3, $11, 0
blt $14, $11, clearloopfourd

addi $21, $21, -1

endcheck:
# check if game was won
addi $14, $0, 1
blt $21, $14, gw

j newblock

# game is won
gw:
#1p
# get third place time
addi $3, $0, 2004
lw $2, 0($3)

j egl

#stuff that happens when the game is lost

#stuff that happens when the game ends
egl:
sra $1, $15, 25
addi $2, $0, 1
# don't do this for endless mode
and $1, $1, $2
bne $1, $2, 1
rsec $21
# turn the whole map black

j mainmenu

moveright:
# bounds checks
# t1
blt $19, $22, nml
blt $19, $24, nml
blt $19, $26, nml
blt $19, $28, nml

# check the color of the pixel 3 pixels to the right of the top left corner
mul $2, $16, $23
add $2, $2, $22
addi $2, $2, 22
ilw $3, 0($2)
# if it's black, check next space
# if it's not black, it can't be moved
bne $3, $1, nml
mul $2, $16, $25
add $2, $2, $24
addi $2, $2, 22
ilw $3, 0($2)
bne $3, $1, nml
mul $2, $16, $27
add $2, $2, $26
addi $2, $2, 22
ilw $3, 0($2)
bne $3, $1, nml
mul $2, $16, $29
add $2, $2, $28
addi $2, $2, 22
ilw $3, 0($2)
bne $3, $1, nml


# move it
addi $22, $22, 20
addi $24, $24, 20
addi $26, $26, 20
addi $28, $28, 20
jr $31

moveleft:
# bounds checks
# t1
blt $22, $17, nml
blt $24, $17, nml
blt $26, $17, nml
blt $28, $17, nml

mul $2, $16, $23
add $2, $2, $22
addi $2, $2, -1
ilw $3, 0($2)
# if it's black, check next space
# if it's not black, it can't be moved
bne $3, $1, nml
mul $2, $16, $25
add $2, $2, $24
addi $2, $2, -1
ilw $3, 0($2)
bne $3, $1, nml
mul $2, $16, $27
add $2, $2, $26
addi $2, $2, -1
ilw $3, 0($2)
bne $3, $1, nml
mul $2, $16, $29
add $2, $2, $28
addi $2, $2, -1
ilw $3, 0($2)
bne $3, $1, nml

# move it
addi $22, $22, -20
addi $24, $24, -20
addi $26, $26, -20
addi $28, $28, -20
nml:
jr $31

rotate:
#t2
addi $2, $0, 179
bne $20, $2, rthree
addi $14, $0, 1000
lw $2, 0($14)
bne $2, $0, rtwosone
# $3, $4, $7, $8, $9, $10, $11
addi $3, $29, 20
addi $4, $26, 20
addi $7, $25, -20
addi $8, $24, 40
addi $9, $23, -40
addi $10, $22, 60

addi $14, $0, 430
blt $14, $3, nml
addi $14, $0, 250
blt $14, $4, nml
blt $14, $8, nml
blt $14, $10, nml
addi $14, $0, 40
blt $7, $14, nml
blt $9, $14, nml

mul $11, $16, $3
add $11, $11, $28
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $27
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $29, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rtwosone:

addi $3, $29, -20
addi $4, $26, -20
addi $7, $25, 20
addi $8, $24, -40
addi $9, $23, 40
addi $10, $22, -60

addi $14, $0, 430
blt $14, $7, nml
blt $14, $9, nml
addi $14, $0, 60
blt $4, $14, nml
blt $8, $14, nml
blt $10, $14, nml
addi $14, $0, 40
blt $3, $14, nml

mul $11, $16, $3
add $11, $11, $28
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $27
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $29, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $14, $0, 1000
sw $0, 0($14)
jr $31

rthree:
addi $2, $0, 106
bne $20, $2, rfour

addi $14, $0, 1000
lw $2, 0($14)
bne $2, $0, rthreesone

addi $3, $27, 20
addi $4, $26, 20
addi $7, $25, 40
addi $8, $24, 40
addi $9, $23, 20
addi $10, $22, -20

addi $14, $0, 430
blt $14, $3, nml
blt $14, $7, nml
blt $14, $9, nml
addi $14, $0, 250
blt $14, $4, nml
blt $14, $8, nml
addi $14, $0, 60
blt $10, $14, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rthreesone:
addi $3, $0, 1
bne $2, $3, rthreestwo

addi $3, $27, 20
addi $4, $26, -20
addi $7, $25, 40
addi $8, $24, -40
addi $9, $23, -20
addi $10, $22, -20

addi $14, $0, 430
blt $14, $3, nml
blt $14, $7, nml
addi $14, $0, 60
blt $4, $14, nml
blt $8, $14, nml
blt $10, $14, nml
addi $14, $0, 40
blt $9, $14, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rthreestwo:
addi $3, $0, 2
bne $2, $3, rthreesthree

addi $3, $27, -20
addi $4, $26, -20
addi $7, $25, -40
addi $8, $24, -40
addi $9, $23, -20
addi $10, $22, 20

addi $14, $0, 250
blt $14, $10, nml
addi $14, $0, 60
blt $4, $14, nml
blt $8, $14, nml
addi $14, $0, 40
blt $3, $14, nml
blt $7, $14, nml
blt $9, $14, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rthreesthree:

addi $3, $27, -20
addi $4, $26, 20
addi $7, $25, -40
addi $8, $24, 40
addi $9, $23, 20
addi $10, $22, 20

addi $14, $0, 250
blt $14, $10, nml
blt $14, $8, nml
blt $14, $4, nml
addi $14, $0, 40
blt $3, $14, nml
blt $7, $14, nml
addi $14, $0, 430
blt $14, $9, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $14, $0, 1000
sw $0, 0($14)
jr $31


rfour:
addi $2, $0, 35
bne $20, $2, rfive

addi $14, $0, 1000
lw $2, 0($14)
bne $2, $0, rfoursone

addi $3, $27, 20
addi $4, $26, 20
addi $7, $25, 40
addi $8, $24, 40
addi $9, $23, -20
addi $10, $22, 20

addi $14, $0, 250
blt $14, $10, nml
blt $14, $8, nml
blt $14, $4, nml
addi $14, $0, 40
blt $9, $14, nml
addi $14, $0, 430
blt $14, $3, nml
blt $14, $7, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rfoursone:
addi $3, $0, 1
bne $2, $3, rfourstwo

addi $3, $27, 20
addi $4, $26, -20
addi $7, $25, 40
addi $8, $24, -40
addi $9, $23, 20
addi $10, $22, 20

addi $14, $0, 250
blt $14, $10, nml
addi $14, $0, 60
blt $4, $14, nml
blt $8, $14, nml
addi $14, $0, 430
blt $14, $3, nml
blt $14, $7, nml
blt $14, $9, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rfourstwo:
addi $3, $0, 2
bne $2, $3, rfoursthree

addi $3, $27, -20
addi $4, $26, -20
addi $7, $25, -40
addi $8, $24, -40
addi $9, $23, 20
addi $10, $22, -20

addi $14, $0, 40
blt $3, $14, nml
blt $7, $14, nml
addi $14, $0, 60
blt $10, $14, nml
blt $8, $14, nml
blt $4, $14, nml
addi $14, $0, 430
blt $14, $9, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31
 
rfoursthree:

addi $3, $27, -20
addi $4, $26, 20
addi $7, $25, -40
addi $8, $24, 40
addi $9, $23, -20
addi $10, $22, -20

addi $14, $0, 40
blt $3, $14, nml
blt $7, $14, nml
blt $9, $14, nml
addi $14, $0, 60
blt $10, $14, nml
addi $14, $0, 250
blt $14, $8, nml
blt $14, $4, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $14, $0, 1000
sw $0, 0($14)
jr $31

rfive:
addi $2, $0, 108
bne $20, $2, rsix

addi $14, $0, 1000
lw $2, 0($14)
bne $2, $0, rfivesone

addi $3, $27, 20
addi $4, $26, 20
addi $7, $25, -20
addi $8, $24, 20
addi $9, $23, 20
addi $10, $22, -20

addi $14, $0, 40
blt $7, $14, nml
addi $14, $0, 430
blt $14, $3, nml
blt $14, $9, nml
addi $14, $0, 60
blt $10, $14, nml
addi $14, $0, 250
blt $14, $8, nml
blt $14, $4, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rfivesone:
addi $3, $0, 1
bne $2, $3, rfivestwo

addi $3, $27, 20
addi $4, $26, -20
addi $7, $25, 20
addi $8, $24, 20
addi $9, $23, -20
addi $10, $22, -20

addi $14, $0, 40
blt $9, $14, nml
addi $14, $0, 430
blt $14, $3, nml
blt $14, $7, nml
addi $14, $0, 60
blt $10, $14, nml
blt $4, $14, nml
addi $14, $0, 250
blt $14, $8, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rfivestwo:
addi $3, $0, 2
bne $2, $3, rfivesthree

addi $3, $27, -20
addi $4, $26, -20
addi $7, $25, 20
addi $8, $24, -20
addi $9, $23, -20
addi $10, $22, 20

addi $14, $0, 40
blt $9, $14, nml
blt $3, $14, nml
addi $14, $0, 430
blt $14, $7, nml
addi $14, $0, 60
blt $8, $14, nml
blt $4, $14, nml
addi $14, $0, 250
blt $14, $10, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rfivesthree:

addi $3, $27, -20
addi $4, $26, 20
addi $7, $25, -20
addi $8, $24, -20
addi $9, $23, 20
addi $10, $22, 20

addi $14, $0, 40
blt $7, $14, nml
blt $3, $14, nml
addi $14, $0, 430
blt $14, $9, nml
addi $14, $0, 60
blt $8, $14, nml
addi $14, $0, 250
blt $14, $10, nml
blt $14, $4, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $10
ilw $11, 0($11)
bne $11, $1, nml

addi $27, $3, 0
addi $26, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $23, $9, 0
addi $22, $10, 0

addi $14, $0, 1000
sw $0, 0($14)
jr $31

rsix:
addi $2, $0, 113
bne $20, $2, rseven

addi $14, $0, 1000
lw $2, 0($14)
bne $2, $0, rsixsone

addi $3, $29, 20
addi $4, $28, -20
addi $7, $25, 20
addi $8, $24, 20
addi $9, $22, 40

addi $14, $0, 430
blt $14, $7, nml
blt $14, $3, nml
addi $14, $0, 60
blt $4, $14, nml
addi $14, $0, 250
blt $14, $8, nml
blt $14, $9, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $23
add $11, $11, $9
ilw $11, 0($11)
bne $11, $1, nml

addi $29, $3, 0
addi $28, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $22, $9, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rsixsone:

addi $3, $29, -20
addi $4, $28, 20
addi $7, $25, -20
addi $8, $24, -20
addi $9, $22, -40

addi $14, $0, 40
blt $7, $14, nml
blt $3, $14, nml
addi $14, $0, 60
blt $8, $14, nml
blt $9, $14, nml
addi $14, $0, 250
blt $14, $4, nml

mul $11, $16, $3
add $11, $11, $4
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $7
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $23
add $11, $11, $9
ilw $11, 0($11)
bne $11, $1, nml

addi $29, $3, 0
addi $28, $4, 0
addi $25, $7, 0
addi $24, $8, 0
addi $22, $9, 0

addi $14, $0, 1000
sw $0, 0($14)
jr $31
# t7
rseven:
addi $2, $0, 86
bne $20, $2, nml

addi $14, $0, 1000
lw $2, 0($14)
bne $2, $0, rsevensone

addi $3, $28, 40
addi $4, $27, -20
addi $7, $26, 20
addi $8, $22, -20
addi $9, $23, -20

addi $14, $0, 40
blt $4, $14, nml
blt $9, $14, nml
addi $14, $0, 60
blt $8, $14, nml
addi $14, $0, 250
blt $14, $3, nml
blt $14, $7, nml

mul $11, $16, $29
add $11, $11, $3
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $4
add $11, $11, $7
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

addi $28, $3, 0
addi $27, $4, 0
addi $26, $7, 0
addi $22, $8, 0
addi $23, $9, 0

addi $2, $2, 1
addi $14, $0, 1000
sw $2, 0($14)
jr $31

rsevensone:
addi $3, $28, -40
addi $4, $27, 20
addi $7, $26, -20
addi $8, $22, 20
addi $9, $23, 20

addi $14, $0, 60
blt $3, $14, nml
blt $7, $14, nml
addi $14, $0, 250
blt $14, $8, nml
addi $14, $0, 430
blt $14, $4, nml
blt $14, $9, nml

mul $11, $16, $29
add $11, $11, $3
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $4
add $11, $11, $7
ilw $11, 0($11)
bne $11, $1, nml

mul $11, $16, $9
add $11, $11, $8
ilw $11, 0($11)
bne $11, $1, nml

addi $28, $3, 0
addi $27, $4, 0
addi $26, $7, 0
addi $22, $8, 0
addi $23, $9, 0

addi $14, $0, 1000
sw $0, 0($14)
jr $31

infinity:
j infinity