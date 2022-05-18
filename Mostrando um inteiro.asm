.data
	idade: .word 20 #Valor inteiro na memória
.text
	li $v0, 1 #comando
	lw $a0, idade
	syscall