addi $1, $0, 440;
sfx $1;
addi $2, $0, 48828;
sll $2, $2, 10;
addi $3, $0, 0;
loop:
addi $3, $3, 1;
bne $2, $3, 1;
j 10;
j loop;
addi $1, $0, 800;
sfx $1;








infinity:
j infinity;