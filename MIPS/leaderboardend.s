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