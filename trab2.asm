.data
ask_str1: .asciiz "Multiplicando: "
ask_str2: .asciiz "Multiplicador: "
result_str: .asciiz ""
.align 2

.text
.globl tart

main: 

# $a1 -> multiplicando
# $a2 -> multiplicador
# $v1 -> multiplicar por -1
# $a2 -> end base do vetor que armazena os bits do multiplicando
# $a3 -> end base do vetor que armazena os bits do multiplicador

addi $v1, $zero, -1
add $a2, $zero, $zero

start:
# Ler o multiplicando
li $v0, 4
la $a0, ask_str1
syscall
li $v0, 5
syscall
move $a1, $v0

# Ler o multiplicador
li $v0, 4
la $a0, ask_str2
syscall
li $v0, 5
syscall
move $a2, $v0
#------------------------------------------------------------

slt $t5, $a1, $zero  # 1 -> multiplicando < 0
bne $t5, $zero, mult1
j continua

mult1:

mul $a1, $a1, $v1  # Multiplicamos o número por -1 (fica positivo)
j continua

continua:

slt $t5, $a2, $zero  # 1 -> multiplicador < 0
bne $t5, $zero, mult2
j conversor

mult2:

mul  $a2, $a2, $v1  # Multiplicamos o número por -1 (fica positivo)
j conversor

#--------------------------------------------------------------
conversor:

# Convertendo o multiplicando

add $t0, $zero, $a1 # put our input ($a1) into $t0
add $t1, $zero, $zero # Zero out $t1
addi $t3, $zero, 1 # load 1 as a mask
sll $t3, $t3, 31 # move the mask to appropriate position
addi $t4, $zero, 32 # loop counter

loop:

and $t1, $t0, $t3 # and the input with the mask
beq $t1, $zero, print # Branch to print if its 0

add $t1, $zero, $zero # Zero out $t1
addi $t1, $zero, 1 # Put a 1 in $t1

j print

print: 

li $v0, 1
move $a0, $t1
syscall

srl $t3, $t3, 1
addi $t4, $t4, -1
bne $t4, $zero, loop

#jr $ra

# New Line
li $v0, 11
li $a0, 10
syscall


# Convertendo o multiplicador

add $t0, $zero, $a2 # put our input ($a2) into $t0
add $t6, $zero, $zero # Zero out $t6
addi $t3, $zero, 1 # load 1 as a mask
sll $t3, $t3, 31 # move the mask to appropriate position
addi $t4, $zero, 32 # loop counter

loop1:

and $t6, $t0, $t3 # and the input with the mask
beq $t6, $zero, print1 # Branch to print if its 0

add $t6, $zero, $zero # Zero out $t6
addi $t6, $zero, 1 # Put a 1 in $t6
j print1

print1: li $v0, 1
move $a0, $t6
syscall

srl $t3, $t3, 1
addi $t4, $t4, -1
bne $t4, $zero, loop1

jr $ra










#li $v0, 1
#move $a0, $a1
#syscall

#li $v0, 11
#li $a0, 10
#syscall

#li $v0, 1
#move $a0, $a2
#syscall

#jal conversor

# New Line
#li $v0, 11
#li $a0, 10
#syscall

#j start
