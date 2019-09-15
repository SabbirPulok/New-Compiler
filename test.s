
#start
.text
.globl main
main:
addiu $t7, $sp, 160

#store
sw $a0, 0($t7)

#ld_int
li $a0, 2
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 0($t7)

#label
LABEL7:


#write_int
lw $a0, 0($t7)
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

#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 5
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
