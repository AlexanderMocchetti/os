.code16
.org 0
.text
.global _start

_start:
	movl HELLO_MSG, %eax      
	call print_string
	movl GOODBYE_MSG, %eax 
	call print_string
	jmp .
.include "src/print_string.s" 
HELLO_MSG:
	.string "Hello, World!"
GOODBYE_MSG:
	.string "Goodbye!"
.fill 510-(.-_start), 1, 0
.word 0xaa55 
