mainmenu:
# Change screen and set up registers
add $15, $0, $0;
addi $1, $0, 55000;
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
addi $21, $0, 5678
sw $0, 0($0)

# top level loop, start here for each new block
newblock:

#set rotation status to 0 at memory address 0
sw $0, 0($0)

rtick $3

# if $1 < 20(or something) set type to 0
# else if $1 < 40 set type to 1
# so on and so forth
# you can change the addi amount to increase the range if you want



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

addi $24, $0, 160
addi $25, $0, 60

addi $26, $0, 140
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
addi $27, $0, 40

addi $28, $0, 140
addi $29, $0, 60


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

endcheck:
j newblock

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

lw $2, 0($0)
bne $2, $0, rtwosone

addi $27, $27, -20
addi $26, $26, 20
addi $25, $25, -40
addi $24, $24, 40
addi $23, $23, -60
addi $22, $22, 60

addi $2, $2, 1
sw $2, 0($0)
jr $31

rtwosone:

addi $27, $27, 20
addi $26, $26, -20
addi $25, $25, 40
addi $24, $24, -40
addi $23, $23, 60
addi $22, $22, -60

sw $0, 0($0)
jr $31

rthree:
addi $2, $0, 106
bne $20, $2, rfour

lw $2, 0($0)
bne $2, $0, rthreesone

addi $27, $27, 20
addi $26, $26, 20
addi $25, $25, 40
addi $24, $24, 40
addi $23, $23, 20
addi $22, $22, -20

addi $2, $2, 1
sw $2, 0($0)
jr $31

rthreesone:
addi $3, $0, 1
bne $2, $3, rthreestwo

addi $27, $27, 20
addi $26, $26, -20
addi $25, $25, 40
addi $24, $24, -40
addi $23, $23, -20
addi $22, $22, -20

addi $2, $1, 1
sw $2, 0($0)
jr $31

rthreestwo:
addi $3, $0, 2
bne $2, $3, rthreesthree

addi $27, $27, -20
addi $26, $26, -20
addi $25, $25, -40
addi $24, $24, -40
addi $23, $23, -20
addi $22, $22, 20

addi $2, $2, 1
sw $2, 0($0)
jr $31

rthreesthree:

addi $27, $27, -20
addi $26, $26, 20
addi $25, $25, -40
addi $24, $24, 40
addi $23, $23, 20
addi $22, $22, 20

sw $0, 0($0)
jr $31


rfour:
addi $2, $0, 35
bne $20, $2, rfive

lw $2, 0($0)
bne $2, $0, rfoursone

addi $27, $27, 20
addi $26, $26, 20
addi $25, $25, 40
addi $24, $24, 40
addi $23, $23, -20
addi $22, $22, 20

addi $2, $2, 1
sw $2, 0($0)
jr $31

rfoursone:
addi $3, $0, 1
bne $2, $3, rfourstwo

addi $27, $27, 20
addi $26, $26, -20
addi $25, $25, 40
addi $24, $24, -40
addi $23, $23, 20
addi $22, $22, 20

addi $2, $1, 1
sw $2, 0($0)
jr $31

rfourstwo:
addi $3, $0, 2
bne $2, $3, rfoursthree

addi $27, $27, -20
addi $26, $26, -20
addi $25, $25, -40
addi $24, $24, -40
addi $23, $23, 20
addi $22, $22, -20

addi $2, $2, 1
sw $2, 0($0)
jr $31

rfoursthree:

addi $27, $27, 20
addi $26, $26, -20
addi $25, $25, 40
addi $24, $24, -40
addi $23, $23, 60
addi $22, $22, -60

sw $0, 0($0)
jr $31

rfive:
addi $2, $0, 108
bne $20, $2, rsix

lw $2, 0($0)
bne $2, $0, rfivesone

addi $27, $27, 20
addi $26, $26, 20
addi $25, $25, -20
addi $24, $24, 20
addi $23, $23, 20
addi $22, $22, -20

addi $2, $2, 1
sw $2, 0($0)
jr $31

rfivesone:
addi $3, $0, 1
bne $2, $3, rfivestwo

addi $27, $27, 20
addi $26, $26, -20
addi $25, $25, 20
addi $24, $24, 20
addi $23, $23, -20
addi $22, $22, -20

addi $2, $1, 1
sw $2, 0($0)
jr $31

rfivestwo:
addi $3, $0, 2
bne $2, $3, rfivesthree

addi $27, $27, -20
addi $26, $26, -20
addi $25, $25, 20
addi $24, $24, -20
addi $23, $23, -20
addi $22, $22, 20

addi $2, $2, 1
sw $2, 0($0)
jr $31

rfivesthree:

addi $27, $27, -20
addi $26, $26, 20
addi $25, $25, -20
addi $24, $24, -20
addi $23, $23, 20
addi $22, $22, 20

sw $0, 0($0)
jr $31

rsix:
addi $2, $0, 113
bne $20, $2, rseven

lw $2, 0($0)
bne $2, $0, rsixsone

addi $29, $29, 20
addi $28, $28, -40
addi $26, $26, -20
addi $25, $25, 20
addi $22, $22, 20

addi $2, $2, 1
sw $2, 0($0)
jr $31

rsixsone:

addi $29, $29, -20
addi $28, $28, 40
addi $26, $26, 20
addi $25, $25, -20
addi $22, $22, -20

sw $0, 0($0)
jr $31
# t7
rseven:
addi $2, $0, 86
bne $20, $2, nml

lw $2, 0($0)
bne $2, $0, rsevensone

addi $29, $29, 40
addi $28, $28, -20
addi $27, $27, 20
addi $24, $24, -20
addi $23, $23, -20

addi $2, $2, 1
sw $2, 0($0)
jr $31

rsevensone:
addi $29, $29, -40
addi $28, $28, 20
addi $27, $27, -20
addi $24, $24, 20
addi $23, $23, 20

sw $0, 0($0)
jr $31

# end game




infinity:
j infinity