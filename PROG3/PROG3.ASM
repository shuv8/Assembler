.model small
.stack 100h
.486
.data
	M	equ	3
	N	equ	4
	Len	equ	M*N
	mat	dw	4,7,1,3
		dw	3,32767,-127,0
		dw	127,-32768,65,1
.code
Start:
	mov	ax, @data
	mov	ds,	ax
	mov	es, ax
	mov	di,	offset mat
	mov	cx,	M
	xor	eax, eax
	xor ebx, ebx
MatLoop:
	push	cx
	mov	cx, N
RowLoop:
	sal	cx, 1
	mov si,	di
	add si, cx
	lea	bx, [si]	;bx = max index in row + 1
	sar	cx, 1
	mov	ax,	[di]		;ax = min (first element in row)
L1:
	sub	bx, 2			;moving along the row
	cmp	ax,	[bx]
	jl	L2				;if min <= [bx] element
	xchg	ax,	[bx]	;if min>[bx] -> swap
L2:
	cmp	bx, di
	jnz	L1				;if iteration didn't end
	stosw				;(mov [di], ax) di+=2 -- min element in row is the 1st
	loop	RowLoop
	pop	cx
	loop	MatLoop
	
	xor	eax, eax
	mov cx, Len
	mov	si, 0
Output:
	mov	ax, [mat + si]
	inc	si
	inc	si
	loop	Output
	
	mov	ax,	4c00h
	int 21h
end Start