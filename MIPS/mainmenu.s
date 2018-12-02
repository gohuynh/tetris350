mainmenu:
# Change screen and set up registers
add $15, $0, $0;
addi $1, $0, 65000;
sll $1, $1, 8;
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
and $3, $3, $4;
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
# TODO: put correct values
addi $1, $0, 2;
j infinity;
# Transition to 2P mode
mainmenu_to_twop:
# TODO: put correct values
addi $1, $0, 3;
j infinity;
# Transition to 1P Scores
mainmenu_to_toponep:
# TODO: put correct values
addi $1, $0, 5;
j infinity;
# Transition to Endless Scores
mainmenu_to_topend:
# TODO: put correct values
addi $1, $0, 6;
j infinity;