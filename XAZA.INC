@XAZOMARES	macro
	LOCAL	xaza1,xaza2,xaza3,xaza4,xaza5,xaza6,xaza7,xaza8,xaza9,xaza0,xaza10,xaza11,xaza12
	push	ax
	push	dx
	push	bx
xaza0:	mov	ax,1
	dec	ax
	jnz	xaza1
	cmp	byte ptr cs:xaza9,4
	jne	xaza2
	inc	ax
xaza2:	pop	ax
	push	ax
xaza1:	cmp	ax,10
	ja	xaza3
	inc	ax
xaza3:	cmp	dx,12
	jae	xaza4
	inc	ax
xaza4:	jnz	xaza5
	inc	ax
xaza5:	dec	bx
	mov	al,byte ptr [bx][si]
	shl	ax,1
	jz	xaza6
xaza7:	inc	ax
	cmp	ax,1000
	jae	xaza6
	jmp	short xaza7
xaza6:	dec	bx
	mov	al,byte ptr [bx][si+1]
	shl	ax,1
	jz	xaza8
	inc	dx
xaza8:	xor	ax,ax
	xor	dx,dx
	xor	cx,cx
	jnz	xaza0
	pop	bx
	pop	dx
xaza9:	pop	ax
	cmp	ax,10
	jae	xaza10
	cmp	dx,2
	jbe	xaza11
	cmp	si,19
	je	xaza12
xaza10:	mov	byte ptr cs:xaza9,al
	inc	byte ptr cs:xaza8
xaza11:	mov	byte ptr cs:xaza9,dl
	inc	byte ptr cs:xaza7
xaza12:	mov	word ptr cs:xaza9,si
	inc	byte ptr cs:xaza6
	push	ax
	push	dx
	pop	ax
	mov	ax,24
	pop	ax
	endm
