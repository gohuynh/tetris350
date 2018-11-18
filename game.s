# initialize registers that will be used for in game logic
addi  $19,   $0,   420
addi  $18,   $0,   440
addi  $17,   $0,   220

## top level loop, start here for each new block
newblock:
addi  $16,   $0,   20

addi  $20,   $0,   1
addi  $22,   $0,   300
addi  $23,   $0,   60
addi  $24,   $0,   300
addi  $25,   $0,   40
addi  $26,   $0,   320
addi  $27,   $0,   40
addi  $28,   $0,   320
addi  $29,   $0,   60


# main loop: check inputs and apply them, wait for timeout
main:
# call different methods of movement depending on current value of control register

addi $16, $16, -1
bne $16, $0, main

# timeout: try to move the block down. if the new y location is the same, save it


# down movement
down:
# check if it can move down
# check if it is at the lower bound
# check if any cell below the 4 cells is the dead color
# if it can move, move it
addi  $23,   $23,   20
addi  $25,   $25,   20
addi  $27,   $27,   20
addi  $29,   $29,   20

# right movement

# left movement

# rotate right

# save dead block
# save the 4 current block locations to the dead color
# check if any of the blocks are at y = 0, end the game if so
# if game is not over, jump to newblock

# end game
 