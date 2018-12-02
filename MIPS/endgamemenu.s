# ===================================================
# Loop for End Game Screen
# ===================================================
endgame:
# Set up registers
addi $1, $0, 65000;
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
addi $4, $0, 2;
blt $3, $4, 1;
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
# TODO: put correct values************************************************************
addi $1, $0, 2;
j infinity;
# Transition to 1P mode
endgame_to_onep:
addi $1, $0, 1;
sll $15, $1, 29;
j gameonep;
# Transition to leaderboards
endgame_to_leaderboard:
jal endgame_save_score;
# Check which leaderboard
sra $4, $15, 26;
addi $5, $0, 1;
and $4, $4, $5;
bne $4, $0, 1;
j endgame_to_toponep;
# Transition to Endless Scores
# TODO: put correct values************************************************************
addi $1, $0, 6;
j infinity;
# Transition to 1P Scores
endgame_to_toponep:
# TODO: put correct values************************************************************
addi $1, $0, 5;
j infinity;
# -------------------------------
# Store name and score
# -------------------------------
endgame_save_score:
