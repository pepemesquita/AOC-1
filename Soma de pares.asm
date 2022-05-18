#Exercício 12
# Crie um programa para calcular a soma S de todos os números pares dentre os N
#números informados pelo usuário. Inicialmente, o número N deverá ser lido pelo
#teclado e, logo depois, serão lidos os N valores. Os N valores lidos devem ser
#armazenados na memória. O resultado S da soma de pares deverá ser apresentado na
#tela, assim como a quantidade Q de valores pares.
#Você deve criar uma sub-rotina para a leitura dos valores e uma sub-rotina para
#encontrar e somar os pares.

.data 	
	res: .space 56
	msg: .asciiz "Informe a quantidade de números a serem lidos (até 15): "
	msg1: .asciiz "Insira o número: "
	msgQ: .asciiz "A quantidade de pares é: "
	msgS: .asciiz "\nA a soma desses pares é: "
	
.text
main:	#interação com o usuário
	li $v0, 4
	la $a0, msg
	syscall #chama a msg para informar a quantidade de números
	
	li $v0, 5 
	syscall #obtém a quantidade do usuário
	
	move $t1, $v0 #move o número recebido de $v0 para $t1
	bgt $t1, 15, fim #se for maior que 15 que é o número max estipulado, encerra o programa
	beqz $t1, fim # e se for igual a 0 encerra também
	
	la $t2, res

recursao:	
	beq $t4, $t1, fim #se o contador chegar na quantidade de números digitadas pelo user pula pro fim
	jal leitura #vai pra função de leitura e retorna posteriormente	
	jal verificar #vai pra função de calculos dos pares e retorna posteriormente
	j recursao #repete até satisfazer o beq 

leitura:
	lw $t3, 0 ($t2) #armazenando o $t3 na memória

	li $v0, 4
	la $a0, msg1 #exibe a mensagem para o usuário botar o número desejado
	syscall

	li $v0, 5 #recebe o número do usuário
	syscall

	move $t3, $v0 #move de $v0 para $t3
	sw $t3, ($t2) #armazena na memória
	add $t4, $t4, 1 #contador das ações +1

	addi $t2, $t2, 4 #escreve no próximo endereço da memória

	jr $ra#retorna de onde foi chamado

verificar: #Verifica se é par
	li $t0, 2 #carrega imediatamente 2 em $t0
	div $t3, $t0 #divide $t0 por $t3
	mfhi $t7 #move o resto do hi para $t7
	beq $t7, 1, recursao #se o resto for 1 pula pra recursao
	
	add $t5, $t3, $t5 #soma os pares
	addi $t6, $t6, 1 #par +1
	
	jr $ra #retorna de onde foi chamado

fim:
	li $v0, 4
	la $a0, msgQ 
	syscall
			#mostra a quantidade de números pares
	li $v0, 1
	move $a0, $t6
	syscall
	
	li $v0, 4
	la $a0, msgS
	syscall
			#mostra a soma total deles
	li $v0, 1
	move $a0, $t5
	syscall
			#encerra o programa
	li $v0, 10
	syscall
	
