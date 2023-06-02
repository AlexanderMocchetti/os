print_string:
	push %ebx
	push %edx
	movl %eax, %ebx
	movb $0x0E, %ah
	movl $0x0, %edx	
1:	cmpb $0x0, (%ebx, %edx)   
	je 1f
	movb (%ebx, %edx), %al
	int $0x10
	incl %edx	
	jmp 1b
1:	pop %edx
	pop %ebx
	ret
