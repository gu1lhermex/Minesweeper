.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
	save_context
move $s0,$a0 # board
move $s5,$zero #count = 0 
addi $s1,$a1,-1 #row-1 ,i
addi $s2,$a1,+1 #row+1
addi $s3,$a2,-1 #col-1 ,j
addi $s4,$a2,1  #col+1
for_i:
	addi $s3,$s4,-2 #col-1 ,reseta o j
	bgt $s1,$s2,fim # i> row+1 oposto de i<=row+1
	for_j:
		bgt $s3,$s4,final_for_j # j> col+1 oposto de j<=col+1
		li  $t5,8
		blt  $s1,$zero,skip_it # i<0 oposto de i>=0
		bge $s1,$t5,skip_it # i>=SIZE oposto de i<SIZE
		blt  $s3,$zero,skip_it # j<0 oposto de j<=0
		bge $s3,$t5,skip_it # j>=SIZE oposto de j<SIZE
			sll $t6, $s1,5 #i*32
			sll $t7, $s3,2 #j*4
			add $t7,$t6,$t7 #i*32+j*4
			add $t7,$s0,$t7 # posição
			lw $t9,0($t7) # acessando board[i][j]
		li  $t5,-1
		bne $t9,$t5,skip_it #board[i][j] != -1 oposto de == -1
		addi $s5,$s5,1 #count++
		skip_it:
		addi $s3,$s3,1 #j++
		j for_j
		final_for_j:
		addi $s1,$s1,1 #i++	
	j for_i	
fim:
move $v1,$s5 #passa count como retorno da função
restore_context
jr $ra #volta 
