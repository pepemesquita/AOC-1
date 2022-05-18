.data
	MSG: .asciiz "Olá mundo" #mensagem a ser exibida

.text
	li $v0, 4
	la $a0, MSG
	syscall