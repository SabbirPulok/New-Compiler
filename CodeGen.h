enum code_ops {START,HALT, LD_INT_VALUE, STORE, WRITE_INT, LD_VAR, ADD, SUB, MUL, DIV, LD_INT, LTN,GTN,LTEN,GTEN, EQN, JMP_FALSE, GOTO, LABEL};

char *op_name[] = {"start", "halt", "ld_int_value", "store", "write_int", "ld_var", "add", "sub","mul","div","ld_int","lt","gtn","lten","gten","eqn","jmp_false","goto","label"};

struct instruction
{
    enum code_ops op;
    int arg;
};

struct instruction code[999];

int code_offset = 0;

void gen_code(enum code_ops op, int arg)
{
    code[code_offset].op = op;
    code[code_offset].arg = arg;
    
    code_offset++;
}

void print_code()
{
    int i = 0;

    for(i=0; i<code_offset; i++)
    {
        printf("%3d: %-15s  %4d\n", i, op_name[code[i].op], code[i].arg);

    }
}

void print_assembly()
{
    int i = 0;

    for(i=0; i<code_offset; i++)
    {
        printf("\n#%s\n", op_name[code[i].op]);

        switch(code[i].op)
        {
            case START:
                            printf(".text\n");
                            printf(".globl main\n");
                            printf("main:\n");
                            printf("addiu $t7, $sp, 480\n");
                            break;

            case HALT:
                            printf("li $v0, 10\n");
                            printf("syscall\n");
                            break;
            
            case LD_INT_VALUE:
                            printf("li $a0, %d\n", code[i].arg);
                            break;

            case STORE:
                            printf("sw $a0, %d($t7)\n", 16*code[i].arg);
                            break;

            case WRITE_INT:
                            printf("lw $a0, %d($t7)\n", 16*code[i].arg);
                            printf("li $v0, 1\n");
                            printf("move $t0, $a0\n");
                            printf("syscall\n");
                            break;
            
            case LD_VAR    : 
                            printf("lw $a0, %d($t7)\n", 16*code[i].arg);
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case LD_INT    :
                            printf("li $a0, %d\n", code[i].arg);
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case ADD       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("add $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case SUB       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sub $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case MUL       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("mul $a0, $t1, $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case DIV       :
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("div $t1, $t0\n");
                            printf("mflo $a0\n");
                            printf("sw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;   

            case LTN        :  
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("slt $a0,$t1,$a0\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case LTEN        :  
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sle $a0,$t1,$a0\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;
             case GTN       :  
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sgt $a0,$t1,$a0\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;

            case GTEN        :  
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("sge $a0,$t1,$a0\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;
            case EQN        :  
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $a0, 0($sp)\n");
                            printf("addiu $sp, $sp, -16\n");
                            printf("lw $t1, 0($sp)\n");
                            printf("seq $a0,$a0,$t1\n");
                            printf("addiu $sp, $sp, 16\n");
                            printf("\n");
                            break;   

            case JMP_FALSE :
                            printf("beq $a0, 0 , LABEL%d",code[i].arg);
                            printf("\n");
                            break;

            case GOTO      :
                            printf("j LABEL%d\n",code[i].arg);
                            printf("\n");
                            break;

            case LABEL     :
                            printf("LABEL%d:\n",code[i].arg);
                            printf("\n");
                            break;




            default:
                            break;
        }

    }
}