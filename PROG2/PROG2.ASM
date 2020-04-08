.model small
.stack 100h
.486
.data
	a	db	244
	b	db	61
.code
Start:
	mov	ax, @data
	mov	ds, ax
	mov	al, a
	mov	bl, b
Euklid:
	xor	ah, ah
	xchg	ax, bx
	xor	ah, ah
	xchg	ax, bx
	xor	edx, edx
	idiv	bx
	xor 	eax, eax
	mov	ax, bx
	mov	bx, dx
	cmp	bx, 0
	jne	Euklid

	mov	cx, 8
	xor	ebx, ebx
L:
	rcl	al, 1
	rcr	bl, 1	
	LOOP	L

	mov	ax, 4c00h
	int	21h
end Start

	