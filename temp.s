addi $20, $0, 109
addi $21, $0, 5678
addi $22, $0, 20
addi $23, $0, 20
addi $24, $0, 40
addi $25, $0, 20
addi $26, $0, 40
addi $27, $0, 40
addi $28, $0, 60
addi $29, $0, 40
add $1, $0, $0
addi $5, $0, 65335
sll $5, $5, 10
outerloop: nop
addi $1, $1, 1
bne $1, $5, 1
j moveRight
j outerloop
moveRight: nop
addi $22, $22, 100
addi $24, $24, 100
addi $26, $26, 100
addi $28, $28, 100
infinity: nop
j infinity