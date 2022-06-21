.data
contador: .space 40
menu: .asciiz " __________MENU__________\n|1 - Somar               |\n|2 - Subtrair            |\n|3 - Multiplicar         |\n|4 - Dividir             |\n|5 - Raiz Quadrada       |\n|6 - Fatorial            |\n|7 - Potência            |\n|8 - Último resultado    |\n|0 - SAIR                |\n>Insira sua opção: "
n1: 	.asciiz ">Digite o primeiro número: "
n2: 	.asciiz ">Digite o segundo número: "
raizQmsg: .asciiz ">Digite um número para saber sua raiz quadrada: "
raizQErro: .asciiz "Não é uma raiz quadrada perfeita, tente novamente!\n"
fatorialMsg: .asciiz ">Digite o número para saber seu fatorial: "
potenciaMsg: .asciiz ">Digite um número para saber sua potência: "
ultR: .asciiz "O último resultado da operação feita anteriormente foi: "
r: 	.asciiz "Resultado = "
pular: 	.asciiz "\n\n"
zero: .float 0.0 

.macro pula_linha	# Macro pula linha
	li $v0, 4
	la $a0, pular	# Carrega a string de pular em $a0
	li $v0, 4
	la $a0, pular
	syscall
.end_macro

.macro menu
	li $v0, 4	# Botar na tela nosso menu de escolhas
	la $a0, menu
	syscall

	li $v0, 5	# Prepara para ler um número inteiro
	syscall

	move $t0, $v0	# Salva o número digitado em $t0
.end_macro

.text			# Diretiva de dados
.globl principal	# Diretiva global

principal: 		# Função principal
	la $t7, contador
	
	menu		# Chama a macro menu
	
	beq $t0, 1, somar	# Condições / Se $t0 for digitado 1 vai para a função somar o mesmo pros restantes

	beq $t0, 2, subtrair    

	beq $t0, 3, multiplicar

	beq $t0, 4, dividir

	beq $t0, 5, raizQ

	beq $t0, 6, fatorial

	beq $t0, 7, potencia

	beq $t0, 8, historico

	beqz $t0, sair

somar:
	li $v0, 4	#Bota na tela o pedido pro usuário inserir o número 1
	la $a0, n1			
	syscall

	li $v0, 6	#Obtém o dado do usuário
	syscall
	
	add.s $f2, $f1, $f0
	

	li $v0, 4	#Pede o segundo número
	la $a0, n2
	syscall

	li $v0, 6
	syscall

	add.s $f12, $f0, $f2	# Armazena em $f12 a soma
	jal armazena1
	
	li $v0, 4
	la $a0, r		# Carrega r no registrador $a0
	syscall

	li $v0, 2		# Imprime o número
	syscall
	
	pula_linha		# Executa o macro
	j principal		# Pula pro principal

subtrair:			# Função subtrair
	li $v0, 4		# Imprime uma string
	la $a0, n1		# Carrega n1 no registrador a0
	syscall
	
	li $v0, 6		# Lê um número 
	syscall
	
	add.s $f3, $f1, $f0
	
	li $v0, 4		# Imprime uma string
	la $a0, n2		# Carrega n2 no registrador
	syscall
	
	li $v0, 6
	syscall
	
	
	sub.s $f12, $f3, $f0	# SUBTRAI: f12 = $f3 - $f0
	jal armazena1
	
	li $v0, 4		# Imprime uma string
	la $a0, r		# Carrega no registrador a0
	syscall
	
	li $v0, 2		# Imprime o número
	syscall
	pula_linha		# Executa o macro pula linha
	j principal		# Pula pro principal

multiplicar: 			#Função multiplicar
	li $v0, 4		# Imprime uma string
	la $a0, n1		# Carrega n1 no registrador a0
	syscall
	
	li $v0, 6		# Lê o número do usuário
	syscall
	
	add.s $f4, $f1, $f0
	
	li $v0, 4		# Imprime a string
	la $a0, n2
	syscall			# Carrega n2 no registrador

	li $v0, 6
	syscall
	
	mul.s $f12, $f4, $f0
	jal armazena1
	
	li $v0, 4		# Imprime uma string
	la $a0, r		# Carrega no registrador a0
	syscall
	
	li $v0, 2		# Imprime o resultado
	syscall
	
	pula_linha		
	
	j principal		# Pula pro principal

dividir:			# Função de dividir

	li $v0, 4		# Imprime uma string
	la $a0, n1		# Carrega n1 no registrador $a0
	syscall
	
	li $v0, 6		# Lê um número 
	syscall
	
	add.s $f5, $f1, $f0

	li $v0, 4		# Imprimi uma string
	la $a0, n2		# Carrega n2 no registrador $a0
	syscall
	
	li $v0, 6		# Le um número inteiro
	syscall
	
	div.s $f12, $f5, $f0
	jal armazena1
	
	li $v0, 4		# Imprime uma string
	la $a0, r		# Carrega no registrador a0
	syscall
	
	li $v0, 2		# Imprime o resultado
	syscall
	
	
	pula_linha
	
	j principal

raizQ:
	li $v0, 4			
	la $a0, raizQmsg	# Exibe a string		
	syscall

	li $v0, 5			
	syscall
				# Le o inteiro
	la 	$s0, ($v0)	# Guarda o valor lido
	li	$s1, 0

isqrt:
	mul $t0, $s1, 2		# Calculo da raiz
	add $t0, $t0, 1
	sub $s0, $s0, $t0
	add $s1, $s1, 1		# Incrementa o contador, que sera o resultado da raiz
	beq $s0, $zero, sucesso	# Se chegamos a zero a raiz é perfeita
	slt $t0, $s0, $zero	# Caso seja menor que zero, deu problema
	beq $t0, 1, erro	# Então mostramos mensagem de erro
	j isqrt					

erro:
	la $a0, raizQErro # Chama a mensagem de erro	
	la $v0, 4
	syscall
	j raizQ
	
sucesso:
	move $t3, $s1
	li $v0, 4
	la $a0, r			
	syscall		 # Chama a mensagem de resultado e bota na tela o resultado
	
	jal armazena2
	
	la $v0, 1
	la $a0, ($t3)
	syscall
	
	
	pula_linha		
	
	j principal

fatorial:
	li $v0, 4		# Exibe a string
	la $a0, fatorialMsg	
	syscall

	li $v0, 5		# Armazena o dado obtido pelo usuário
	syscall

	move $t1, $v0		# Move o dado do usuário pra $t1

	li $t3, 1 		# Carrega imediatamente 1
	li $t2, 1 		# i = 1
	
	beqz $t1, aux		# Checa se é 0

	fatorialN:
	beq $t2,$t1,aux 	# Se $t2 == $t1 pula pro fim
	addi $t2,$t2,1 		# i= i+1
	mult $t3, $t2 		# Multiplicar $t3 com $t2
	mflo $t3 		# Move from lo para $t3
	j fatorialN 		# Volta pro começo e repete a ação até o beq ser satisfeito
	
aux: 
	li $v0, 4		# Imprime uma string
	la $a0, r		# Carrega no registrador a0
	syscall
	
	jal armazena2
	
	li $v0, 1		# Imprime um número
	la $a0, ($t3)		# Carrega o inteiro 
	syscall
	
	pula_linha		
	
	j principal
	
potencia:
	li $v0, 4			
	la $a0, potenciaMsg	#Exibe a string	
	syscall

	li $v0, 5			
	syscall

	move $t2, $v0		# Move o valor de $v0 para $t2
	mul $t3, $t2, $t2	# Multiplica o valor de $t2 por ele mesmo e armazena no $t3
	jal armazena2
	
	li $v0, 4			
	la $a0, r			
	syscall
	
	li $v0, 1			
	la $a0, ($t3)		# Move do $t3 para ser exibido no $a0
	syscall
	
	pula_linha		
	
	j principal

historico:
	li $v0, 4
	la $a0, ultR		#Mostra para o usuário a mensagem do último
	syscall
	
	li $v0, 2
	la $t7, contador	# Mostra para o usuário o valor em float armazenado em $t7, no caso na memória
	syscall
	
	li $v0, 4		# Mostra para o usuário a mensagem do último resultado
	la $a0, pular
	syscall
	
	li $v0, 1		# Mostra para o usuário o valor em inteiro armazenado em $t7, no caso na memória
	la $t7, contador
	syscall
	
	li $v0, 4		# Quebra de página
	la $a0, pular
	syscall
	
	j principal

armazena1:
	s.s $f12, ($t7)		# Salva na memória
	addi $t7, $t7, 4	# Incrementa a próxima posição
	jr $ra
	
armazena2:
	sw $t3, ($t7)		# Salva na memória e incrementa
	addi $t7, $t7, 4
	jr $ra

sair:					
	li $v0, 10		# Fecha o programa
	syscall

