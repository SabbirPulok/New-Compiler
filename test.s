#start
.text
.globl main
main:
addiu $t7, $sp, 480

#ld_int_value
li $a0, 10

#store
sw $a0, 0($t7)

#ld_int_value
li $a0, 20

#store
sw $a0, 16($t7)

#ld_int
li $a0, 40
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 0($t7)

#label
LABEL1:


#ld_var
lw $a0, 16($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#lt
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
slt $a0,$t1,$a0
addiu $sp, $sp, 16


#jmp_false
beq $a0, 0 , LABEL2

#ld_var
lw $a0, 16($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 35
sw $a0, 0($sp)
addiu $sp, $sp, 16


#eqn
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
seq $a0,$a0,$t1
addiu $sp, $sp, 16


#jmp_false
beq $a0, 0 , LABEL3

#write_int
lw $a0, 16($t7)
li $v0, 1
move $t0, $a0
syscall

#goto
j LABEL4


#label
LABEL3:


#write_int
lw $a0, 16($t7)
li $v0, 1
move $t0, $a0
syscall

#label
LABEL4:


#ld_var
lw $a0, 16($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 1
sw $a0, 0($sp)
addiu $sp, $sp, 16


#add
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
add $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 16($t7)

#goto
j LABEL1


#label
LABEL2:


#ld_int_value
li $a0, 0

#store
sw $a0, 0($t7)

#label
LABEL5:


#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 20
sw $a0, 0($sp)
addiu $sp, $sp, 16


#lt
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
slt $a0,$t1,$a0
addiu $sp, $sp, 16


#jmp_false
beq $a0, 0 , LABEL6

#write_int
lw $a0, 16($t7)
li $v0, 1
move $t0, $a0
syscall

#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 1
sw $a0, 0($sp)
addiu $sp, $sp, 16


#add
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
add $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 0($t7)

#goto
j LABEL5


#label
LABEL6:


#label
LABEL7:


#write_int
lw $a0, 16($t7)
li $v0, 1
move $t0, $a0
syscall

#ld_var
lw $a0, 16($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 1
sw $a0, 0($sp)
addiu $sp, $sp, 16


#add
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
add $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 16($t7)

#ld_var
lw $a0, 16($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 38
sw $a0, 0($sp)
addiu $sp, $sp, 16


#lten
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
sle $a0,$t1,$a0
addiu $sp, $sp, 16


#jmp_false
beq $a0, 0 , LABEL8

#goto
j LABEL7


#label
LABEL8:


#halt
li $v0, 10
syscall
