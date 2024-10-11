.include "macros.asm"

.globl play

play:
	save_context
move $s0,$a0 # board
move $s1,$a1 # row
move $s2,$a2 # col
sll $t0, $s1,5
sll $t1, $s2,2
add $t2,$t0,$t1
add $s4,$s0,$t2 # posição
lw $s3,0($s4) # acessando board[posição]
li $v0, 1
if_bomb:
	li $t3,-1
	beq $s3,$t3,era_bomb
	li $t3,-2
	beq $s3,$t3,nao_era_bomb
	j continue
era_bomb: #retorna 0
	move $v0,$zero
	j fim
nao_era_bomb: #continua o play
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal countAdjacentBombs
	move $t3,$v1 #recebe o count 
	sw $t3,0($s4) # mover o count pra dentro do board[i][j]
	beqz $t3,reveal # se (!x) reveal()
	j fim
reveal: #chama a funcao que revela as adjacentes
	move $a1,$s1
	move $a2,$s2
	move $a0,$s0
	 jal revealNeighboringCells
	 j continue
fim:
restore_context	
jr $ra #volta ao main
continue:
	li  $v0,1 #retorna 1
	j fim
