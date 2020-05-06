.model medium
public	inputline,input,readfile,output,writefile,menu,algorithm,spaces,words
extrn	Start:far
.code
inputline	proc
locals @@
@@buffer	equ [bp+6]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov ah, 3fh
	xor bx, bx
	mov cx, 80
	mov dx, @@buffer
	int 21h
	jc @@ex
	cmp ax, 80
	jne @@m
	stc
	jmp short @@ex
@@m:
	mov di, @@buffer
	dec ax
	dec ax
	add di, ax
	xor al, al
	stosb
@@ex:
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp
input	proc
locals @@
@@buffer	equ [bp+6]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	xor bx, bx
	mov cx, 4095
	mov dx, @@buffer
@@m1:
	mov ah, 3fh
	int 21h
	jc @@ex
	cmp ax, 2
	je @@m2
	sub cx, ax
	jcxz @@m2
	add dx, ax
	jmp @@m1
@@m2:
	mov di, @@buffer
	add di, 4095
	sub di, cx
	xor al, al
	stosb
@@ex:
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp
output	proc
locals @@
@@buffer	equ [bp+6]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov di, @@buffer
	xor al, al
	mov cx, 0ffffh
	repne scasb
	neg cx
	dec cx
	dec cx
	jcxz @@ex
	cmp cx, 4095
	jbe @@m
	mov cx, 4095
@@m:
	mov ah, 40h
	xor bx, bx
	inc bx
	mov dx, @@buffer
	int 21h
@@ex:
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp
readfile	proc
locals @@
@@buffer	equ [bp+6]
@@filnam	equ [bp+8]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov ax, 3d00h
	mov dx, @@filnam
	int 21h
	jc @@ex
	mov bx, ax
	mov cx, 4095
	mov dx, @@buffer
@@m1:
	mov ah, 3fh
	int 21h
	jc @@er
	or ax, ax
	je @@m2
	sub cx, ax
	jcxz @@m2
	add dx, ax
	jmp @@m1
@@m2:
	mov di, @@buffer
	add di, 4095
	sub di, cx
	xor al, al
	stosb
	mov ah, 3eh
	int 21h
@@ex:
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
@@er:
	mov ah, 3eh
	int 21h
	stc
	jmp @@ex
endp
writefile proc
locals @@
@@filnam	equ [bp+8]
@@buffer	equ [bp+6]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov ah, 3ch
	xor cx, cx
	mov dx, @@filnam
	int 21h
	jc @@ex
	mov bx, ax
	mov di, @@buffer
	xor al, al
	mov cx, 0ffffh
	repne scasb
	neg cx
	dec cx
	dec cx
	jcxz @@ex1
	cmp cx, 4095
	jbe @@m
	mov cx, 4095
@@m:
	mov ah, 40h
	mov dx, @@buffer
	int 21h
	jc @@er
@@ex1:
	mov ah, 3eh
	int 21h
@@ex:
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
@@er:
	mov ah, 3eh
	int 21h
	stc
	jmp @@ex
endp
menu	proc
locals @@
@@ax		equ [bp-82]
@@buffer	equ [bp-80]
@@items	equ	[bp+6]
	push bp
	mov bp, sp
	sub sp, 80
	push ax
@@m:
	push @@items
	call output
	pop ax
	jc @@ex
	push ds
	push es
	push ss
	push ss
	pop ds
	pop es
	mov ax, bp
	sub ax, 80
	push ax
	call inputline
	pop ax
	pop es
	pop ds
	jc @@ex
	mov al, @@buffer
	cbw
	sub ax, '0'
	cmp ax, 0
	jl @@m
	cmp ax, @@ax
	jg @@m
	clc
@@ex:
	mov sp, bp
	pop bp
	ret
endp

algorithm	proc
locals @@
@@ibuf	equ [bp+6]
@@obuf	equ [bp+8]
@@del	equ	[bp+10]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push si
	push di
	
	xor	ax, ax
	xor	bx, bx
	xor	cx, cx
	cld
	mov	si, @@ibuf
	mov	di,	@@obuf
	mov	bx, di
	mov	di, @@del
	
TextLoop:
	push	bx
	mov	al, 10
	mov	cx, 65535
	mov	dx, si
	xchg	si, di
	repne	scasb		;start of the next string
	pop	ax
	push	di
	dec	di
	dec	di
	dec di
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
	mov	al, 13
	stosb
	mov	al, 10
	stosb
	mov	bx, di
	pop	di
	pop	si
	lodsb
	dec si
	cmp	al, 0h
	jnz	TextLoop
	mov di, bx
	xor	al, al
	stosb
	
	pop di
	pop si
	pop cx
	pop bx
	pop ax
	pop bp
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
	cmp al, 10
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
end Start
