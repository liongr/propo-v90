mcode1	segment	public
global	sigoura_no:proc
mcode1	ends

@NAIOXI	macro	x,y,d1,d2,d3
	push	di
	push	si
	push	bx
	mov	al,x
	mov	ah,y
IFB	<d3>
	xor	bx,bx
ELSE
	mov	bx,offset d3
ENDIF
IFB	<d2>
	xor	di,di
ELSE	
	mov	di,offset d2
ENDIF
IFB	<d1>
	xor	si,si
ELSE
	mov	si,offset d1
ENDIF
	call	far ptr sigoura_no
	pop	bx
	pop	si
	pop	di
	endm
