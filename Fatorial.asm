#Exercício 4
#Escreva um programa que calcule o fatorial de n. O valor de n deve ser lido da memória na posição 0x10010000 e o valor de n! deve
#ser escrito na posição seguinte na memória (0x10010004).

.data # declaracao de variaveis e seus tipos
	n: .word 2 #n recebe o valor inteiro
	res: .space 4 #reserva bytes

.text # onde declaramos as intrucoes
	lui $t0, 0x1001 #carregar os 16 bits mais significativos
	lw $t1, 0x0($t0) #load word: $t1 = n
	li $t3, 1 # carrega imediatamente 
	li $t2, 1 # i = 1
	
	beqz $t1, fim	# checa se é 0

	fatorialN:
	beq $t2,$t1,fim # se $t2 == $t1 pula pro fim
	addi $t2,$t2,1 #i = i+1
	mult $t3, $t2 # multiplicar $t3 com $t2
	mflo $t3 # move from lo para $t3
	j fatorialN #volta pro começo e repete a ação até o beq ser satisfeito

	fim:
	sw $t3, 0x4($t0) #armazenar na memória 0x10010004

