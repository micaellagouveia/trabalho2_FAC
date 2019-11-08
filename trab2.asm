.data
ask_str1: .asciiz "Multiplicando: "
ask_str2: .asciiz "Multiplicador: "
ask_str3: .asciiz "Hi: "
ask_str4: .asciiz "Lo: "

.text 

main:

# ------------- TRABALHO 2 - FAC - 2/2019 ---------------------
#             Micaella Gouveia - 17/0111288
#             Sofia Patrocínio - 17/0114333


# Variáveis
# $s0 -> multiplicando
# $s1 -> multiplicador
# $s2 -> n = 32
# $s3 -> HI
# $s4 -> LO
# $a1 -> Hi definitivo
# $a2 -> Lo definitivo
# $t0 -> Hi temporário
# $t1 -> Lo temporário
# $t2 -> i
# $t3 -> Bit extra
# $t4 -> último bit do Lo
# $t5 -> verificar se deve fazer a operação
# $t6 -> Hi +- Multiplicando
# $t7 -> último bit de Hi

add $t3, $zero, $zero  # bit extra = 0
add $t2, $zero, $zero  # i = 0
addi $s2, $zero, 32  # n = 32

# Ler o multiplicando
li $v0, 4
la $a0, ask_str1
syscall

li $v0, 5
syscall
move $s0, $v0  # $s0 = Multiplicando

# Ler o multiplicador
li $v0, 4
la $a0, ask_str2
syscall

li $v0, 5
syscall
move $s1, $v0  # $s1 = Multiplicador

jal Multifac
j exit

Multifac:

add $t0, $zero, $zero  # Zerar Hi

add $t1, $zero, $s1  # Multiplicador em Lo

loop:

beq $t2, $s2, exit      # Condição de Parada

andi $t4, $t1, 1        #   1 -> multiplicador terminar com 1
                        #   0 -> multiplicador terminar com 0


xor $t5, $t4, $t3    # $t5 = ultimo bit de lo XOR bit extra

bne $t5, $zero, operacao  # Se o último bit de Lo e o bit extra forem diferentes, ir para a operação 
j shift                   # Se foram iguais, nada a fazer, então vamos para o shift lógico

operacao:

beq $t3, $zero, subtrair  # Se o bit extra é 0, então temos "10" -> subtraímos
add $t0, $t0, $s0  # Se não, Hi = Hi + Multiplicando
j shift

subtrair:
sub $t0, $t0, $s0  # Hi = Hi - Multiplicando
j shift

shift:

# Shift Hi
andi $t7, $t0, 1  # $t7 = último bit do Hi
sra $t0, $t0, 1   # shift aritmético no Hi

# Shift Lo
add $t3, $t4, $zero  # Passa o último bit de Lo para o Bit Extra
srl $t1, $t1, 1      # shift no Lo

sll $t7, $t7, 31     # Ultimo bit de Hi
add $t1, $t1, $t7    # Passar ultimo bit de Hi para o primeiro de Lo

addi $t2, $t2, 1  # i++
j loop

jr $ra

exit:

mthi $t0
mtlo $t1

mfhi $s3
mflo $s4

# Printar o Hi
li $v0, 4
la $a0, ask_str3
syscall

li $v0, 1
move $a0, $s3
syscall

# New Line
li $v0, 11
li $a0, 10
syscall

# Printar o Lo
li $v0, 4
la $a0, ask_str4
syscall

li $v0, 1
move $a0, $s4
syscall