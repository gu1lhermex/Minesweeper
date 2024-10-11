.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
	save_context
move $s0,$a0 # board
addi $s1,$a1,-1 #linha-1,i
addi $s2,$a1,+1 #linha+1
addi $s3,$a2,-1 #coluna-1,j
addi $s4,$a2,1  #coluna+1
for_i:
	addi $s3,$s4,-2 # reseta o j
	bgt $s1,$s2,fim # i> row+1 oposto de i<=row+1
	for_j:
		bgt $s3,$s4,final_for_j # j> col+1 oposto de j<=col+1
		blt  $s1,$zero,skip_it # i<0 oposto de i<=0
 		bge $s1,TAMANHO,skip_it # i>=SIZE oposto de i<SIZE
		blt  $s3,$zero,skip_it # j<0 oposto de j<=0
		bge $s3,TAMANHO,skip_it # j>=SIZE oposto de j<SIZE
		sll $t6, $s1,5 #i*32
		sll $t7, $s3,2 #j*4
		add $t7,$t6,$t7 #i*32+j*4
		add $s5,$s0,$t7 # posição
		lw $t8,0($s5) # acessando board[i][j]
		bne $t8,-2,skip_it #board[posição] != -2 oposto de == -2
		move $a1,$s1 # passa i 
		move $a2,$s3 # passa j 
		move $a0,$s0 #passa o Board
		# parametros de count...
		jal countAdjacentBombs # vai ao jal e retorna o x no $v1
		move $t1,$v1 #recebe o count
		sw $t1,0($s5) # mover o count pra dentro do board[i][j]
		bnez $t1,skip_it #se (!x) reveal()
		move $a1,$s1 # passa o i da iteração
		move $a2,$s3 # passa o j da iteração
		move $a0,$s0 #passa o Board
		jal revealNeighboringCells
		skip_it:
		addi $s3,$s3,1 #j++
	j for_j
	final_for_j:
	addi $s1,$s1,1 #i++	
j for_i	

fim:
restore_context
jr $ra
