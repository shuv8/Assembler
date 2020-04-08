.model small
.stack 100h
.data
	a	db	3
	b	db	4
	c	db	5
.code
	Start:
	mov	ax, @data
	mov	ds, ax
	mov	al, a
	cbw
	mov	bx, ax
	mov	al, b
	cbw
	add	ax, bx
	idiv	c
	mov	ax, 4c00h
	int	21h
end Start