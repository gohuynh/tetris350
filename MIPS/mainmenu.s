mainmenu:
# Change screen and set up registers
add $15, $0, $0;
addi $1, $0, 65000;
sll $1, $1, 8;
add $2, $0, $0;
# Input loop:
mainmenu_input_loop:
addi $2, $2, 1;
bne $1, $2, 1;
jal mainmenu_handle_input:
j mainmenu_input_loop;
# Handle Input
mainmenu_handle_input:
ri $3;