
INCLUDE	EQUS.H

codesg	segment public

	assume	cs:codesg,ds:datas1

apoustil proc near
	@PUSH
	mov	bx,point_bx[0]
	xor	dx,dx
	xor	si,si
	mov	cx,13
more_2: mov	al,pinsthl[si]
	cmp	antig[si],al
	jne	ejv
	inc	dx
	inc	si
	loop	more_2
	mov	memory,0
	call	sbmon
	
	mov	ax,1500
	call	fatal_error

more_3: mov	al,pinsthl[si]
ejv:	mov	antig[si],al
	inc	si
	loop	more_3
	mov	ax,dx
	call	ll4
	mov	ax,dx
	ror 	al,1
	ror 	al,1
	call	ll4
	xor	si,si
	mov	cx,13
	sub	cx,dx
	add	si,dx
more_4:	mov	al,antig[si]
	call	ll4
	inc	si
	loop	more_4
	mov	point_bx[0],bx
texx:	@POP
	jmp	aujis
apoustil endp

ll4	proc	near
	and	al,3
	or	cbyte,al
	inc	point
	cmp	point,4
	je	svse
	rol	byte ptr cbyte,1
	rol	byte ptr cbyte,1
	ret
ll4	endp

svse	proc	near
	push	ax
	cmp	exomnimi,1
	je	_klo
_kloe:	pop	ax
	mov	ah,cbyte
	push	ds
	push	point_bx[2]
	pop	ds
	mov	[bx],ah
	pop	ds
	mov	point,0
	mov	cbyte,0
	inc	bx
	cmp	bx,65498
	jae	exit0
	ret
_klo:	mov	ax,point_si[2]
	cmp	ax,point_bx[2]
	jne	_kloe
	mov	ax,point_si[0]
	cmp	ax,point_bx[0]
	jae	_kloe
	mov	memory,0

	mov	ax,1501
	call	fatal_error

exit0:	inc	segm
	mov	ax,point_bx[2]
	add	ax,4094
	cmp	ax,MAST6
	jb	_f
	call	sbmon
	mov	memory,0
	mov	point_bx[0],0
	xor	bx,bx
	ret

_f:	mov	point_bx[2],ax
	mov	point_bx[0],0
	xor	bx,bx
	ret
svse	endp
;
stil_up	proc	near
	mov	ax,word ptr [cs:tcmp]
	mov	word ptr [cs:metr1],ax
_arx:	xor	bx,bx
	push	ds
	push	point_si[2]
	pop	ds
	mov	dl,[bx]
	pop	ds
	mov	ubyte,dl
	mov	upoint,0
l00:	xor	dx,dx
	call	l01
	mov	dl,ah
	call	l01
	rol	ah,1
	rol	ah,1
	or	dl,ah
	cmp	dx,13
	jae	telos
	mov	cx,13
	sub	cx,dx
	mov	si,dx
more_01:
	call	l01
	mov	pinsthl[si],ah
	inc	si
	loop	more_01
	mov	point_si[0],bx
	@PUSH
;***************************************** ;METATROPI SE BASIKES
	cmp	metatropi_se_basikes,0
	je	tragouda
	cmp	metatropi_se_basikes,1
	je	makebasikes
	cmp	metatropi_se_basikes,2
	je	maketriades
	jmp	tragouda
maketriades:
	call	mnimi2triades
	@POP
	jmp	l00
makebasikes:
	call	mnimi2basikes
	@POP
	jmp	l00
;*****************************************
tcmp:	xor	al,al
telos:	ret

tragouda:
	@CPLRNS
	jnc	oxi_escape
	cmp	al,@ESCAPE
	jne	oxi_escape
	call	diakopi
oxi_escape:
	call	perior
	@POP
	jmp	l00
stil_up	endp
;
l01	proc	near
	mov	ah,ubyte
	rol	ah,1
	rol	ah,1
	mov	ubyte,ah
	and	ah,3
	inc	upoint
	cmp	upoint,4
	jae	l111
	ret
l111:	inc	bx
	cmp	bx,65498
	jb	_epik
	add	point_si[2],4094
	xor	bx,bx
_epik:	push	ds
	push	point_si[2]
	pop	ds
	mov	al,[bx]
	pop	ds
	mov	ubyte,al
	mov	upoint,0
	ret
l01	endp
;
codesg	ends
	end
