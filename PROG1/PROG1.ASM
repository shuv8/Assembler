.model small
.stack 100h
.486
.data
	a	db	-127
	b	db	-127
	c	db	-1
	d	db	-127
	e	db	-1
.code
Start:
	mov	ax, @data
	mov	ds, ax
;------2(a+b)^3 / (c^2)d  +  a*(c-d)^2 / 2e--------
;------2(a+b)^3 / (c^2)d------
	movsx	ax, a
	movsx	bx, b
	add	ax, bx		;a+b
	mov	bx, ax
	imul	bx
	cwde
	ROL	eax, 16
	mov	ax, dx
	ROR	eax, 16
	imul	bx		;(a+b)^3
	SAL	eax, 1		;2(a+b)^3
	push	eax
	movsx	ax, c
	imul ax
	movsx	bx, d
	cwde
	ROL	eax, 16
	mov	ax, dx
	ROR	eax, 16	
	imul 	bx		;(c^2)d
	mov	ebx, eax
	pop	eax
	ROL	ebx, 16
	mov	bx, -0
	ROR	ebx, 16
	idiv	ebx		;2(a+b)^3 / (c^2)d
	push	edx
	push	eax
;-----a(c-d)^2 / 2e-------
	movsx	ax, c
	movsx	bx, d
	sub	ax, bx
	imul	ax
	cwde
	ROL	eax, 16
	mov	ax, dx
	ROR	eax, 16
	movsx	bx, a
	imul	bx		;a(c-d)^2
	mov	ebx, eax
	movsx	ax, e
	SAL	ax, 1
	cwde
	xchg	ebx, eax
	mov	edx, 0
	idiv	ebx		;a(c-d)^2 / 2e
	pop	ebx		;eax from stack
	add	eax, ebx	;sum of quotients
	pop	ebx		;edx from stack
	add	ebx, edx	;sum of rests
	mov	ax, 4c00h
	int	21h
end Start
	