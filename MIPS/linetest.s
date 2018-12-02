mainmenu:
# Change screen and set up registers
add $15, $0, $0;
addi $1, $0, 2;#65000;
# sll $1, $1, 8;
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
# addi $4, $0, 8;
# bne $3, $4, 1;
# j mainmenu_select;
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