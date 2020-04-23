.model small
.stack 100h
.486
.data
	text	db	'I love assembly, really;', 0
			db	'1;2;3;4', 0
			db	'  A  B  C  D  ', 0
	del		db	' ', ',', ';', 0
	newtext	db	100 dup(?)
.code
Start:
	mov	ax, @data
	mov	ds, ax
	mov	es, ax
	xor	eax, eax
	xor	ebx, ebx
	xor	ecx, ecx
	cld
	lea	si, text
	lea	di,	newtext
	mov	ax, di
	lea	di, del
	
TextLoop:
	push	ax
	mov	al, 0
	mov	cx, 65535
	mov	dx, si
	xchg	si, di
	repne	scasb		;start of the next string
	pop	ax
	push	di
	dec	di
	dec	di
	xchg	si, di
	inc	si
StringLoop:
	dec	si
	call	spaces
	mov	bx, si
	inc	bx
	push	bx
	call	words
	pop	bx
	sub	bx, si
	mov	cx, bx
	mov	bx, di
	push	si
	mov	di, ax
	rep	movsb
	mov	ax, di
	mov	di, bx
	pop	si
	cmp	dx, si
	jz	M
	
	mov	di, ax
	mov	al, 20h
	stosb
	mov	ax, di
	mov	di, bx
	jmp	StringLoop
	
M:
	push	di
	mov	di, ax
	xchg	si, di		;space in the end check
	dec	si
	lodsb
	cmp	al, 20h
	jnz	M1
	dec	si
M1:
	xchg	si, di
	mov	al, 0
	stosb
	mov	ax, di
	pop	di
	pop	si
	cmp	si, di
	jnz	TextLoop
	
	mov	ax,	4c00h
	int	21h

	
spaces proc
	locals	@@
	push	ax
	push	cx
	push	di
	cld
	xor	al, al
	mov	cx, 65535
	repne	scasb
	neg	cx
	dec	cx
	push	cx
@@m1:
	pop	cx
	pop	di
	push	di
	push	cx
	std
	lodsb
	cld
	repne	scasb
	jcxz	@@m2
	jmp	@@m1
@@m2:
	inc	si
	add	sp, 2
	pop	di
	pop	cx
	pop	ax
	ret
endp

words proc
	locals	@@
	push	ax
	push	cx
	push	di
	cld
	xor	al, al
	mov	cx, 65535
	repne	scasb
	neg	cx
	dec	cx
	push	cx
@@m1:
	pop	cx
	pop	di
	push	di
	push	cx
	std
	lodsb
	cmp	al, 0
	jz	@@m2
	cld
	repne	scasb
	jcxz	@@m1
@@m2:
	cld
	inc	si
	inc	si
	add	sp, 2
	pop	di
	pop	cx
	pop	ax
	ret
endp
end Start

