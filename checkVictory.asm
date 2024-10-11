.include "macros.asm"

.globl checkVictory

checkVictory:
	save_context
	move $s0, $a0
     li $t0, 0				#i = 0
     li $t1, 0				#j = 0
     li $s6, 0 				# count = 0
loop_i:
      	bge $t1, TAMANHO, fim_funcao
     	li $t2,0			#i = $t2, iniciando em 0
loop_j:
      bge $t2, TAMANHO, cont_i		#se i>= tamanho do tabuleiro, ir para cont_i
        sll $t0, $t1, 5 	
        sll $t4,$t2, 2
        add $t3,$t0,$t4
        add $t3, $t3, $s0		
      lw $t5,0($t3)			# carregando Board[i][j]
      bltz $t5, fim_j			# se menos que zero, pula.
      addi $s6, $s6, 1 			#$6 = count++
fim_j: 
       addi $t2,$t2,1
       j loop_j
cont_i:
       addi $t1,$t1,1
       j loop_i
fim_funcao:
     
      li $t6, TAMANHO		#Escreve o tamanho do tabuleiro em $t6 
      li $t7, BOMB_COUNT	#Escreve o número de bombas do tabuleiro em $t7 	
      mul $t6,$t6,TAMANHO	#multiplica o tamanho do tabuleiro por ele mesmo
      sub $t6,$t6,$t7 		#Tamanho - bombas, armazena no registrador que tinha tamanho
      seq $v0, $s6, $t6         # se "==" 1, "!=" 0
      restore_context
      jr $ra
      
