
INCLUDE equs.h

codesg	segment public

	assume	cs:codesg

;******************************************
;***               A SHMIA              ***
;******************************************

axb:	@PUSH
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATANA
	push	dx
uu1:	mov	di,6
	lea	si,pinsthl[di]
uu2:	mov	cx,7
	mov	bx,axbp
	cmp	bx,0
	je	axbmet
	dec	bx
axb1:	mov	dl,[si]
	cmp	dl,axbpin[bx]
	jne	axbmet
	dec	si
	dec	bx
	loop	axb1
	jmp	axb40

axbmet: cmp	axbpb,0
	je	uu3
	jmp	bufel1
uu3:	mov	ax,8
	cmp	axbp,ax
	jb	axb93
	sub	axbp,ax
axb93:	cmp	axbl,255
	je	tasia

	cmp	axbl,1
	jne	axb8
	mov	axbl,0
	call	axbpr
axb8:	mov	bx,axbp
	mov	axbpin[bx],"*"
	inc	bx
uu4:	mov	cx,7
	lea	si,pinsthl
axb2:	mov	dl,[si]
	cmp	dl,0
	jne	ner12

	mov	ax,1001
	call	fatal_error

ner12:	mov	axbpin[bx],dl
	inc	si
	inc	bx
	loop	axb2
	mov	axbp,bx
	jmp	short axb40
;******************************************
tasia:	jmp	return1		;STO SC1 
;******************************************

;******************************************
;***              B SHMIA               ***
;******************************************

axb40:	mov	bx,axbpb
	cmp	bx,BUFAXB_A-20
	jbe	xb4j
	jmp	bufel1
xb4j:	mov	ax,axbp
	add	ax,bx
	cmp	ax,BUFAXB_AB-31
	jbe	axb4
	cmp	axbpb,0
	je	ss9
	mov	axbl,1
	jmp	bufel1
ss9:	call	axbpr
	jmp	axb8
axb4:	mov	cx,6
uu5:	mov	di,7
	lea	si,pinsthl[di]
axb41:	mov	dl,[si]
	cmp	dl,0
	jne	ner11

	mov	ax,1002
	call	fatal_error

ner11:	mov	es:axbbuf[bx],dl
	inc	bx
	inc	si
	loop	axb41
	mov	axbpb,bx
	pop	dx
	@POP
	ret

;******************************************
;***              METAFORA              ***
;******************************************

bufmet:	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATANA
	mov	ax,axbpb
	mov	bx,axbp
	mov	word ptr axbpin[bx],65534
	mov	axbpin[bx+2],ah
	mov	axbpin[bx+3],al
	add	axbp,4
	mov	cx,axbpb
	mov	si,0
	mov	bx,axbp
bufm1:	mov	dl,es:axbbuf[si]
	cmp	dl,0
	jne	ner10

	mov	ax,1003
	call	fatal_error

ner10:	mov	axbpin[bx],dl
	inc	axbp
	inc	bx
	inc	si
	loop	bufm1
	mov	cx,axbpb
	mov	bx,0
axbf:	mov	byte ptr es:axbbuf[bx],0
	inc	bx
	loop	axbf
	mov	axbpb,0
	jmp	axb93

;******************************************
;***               ELEGXOS              ***
;******************************************

bufel1: mov	ax,axbpb
	mov	cx,axbp
	mov	bx,0
buf2:	cmp	word ptr axbpin[bx],65534
	jne	buf1
	mov	dh,axbpin[bx+2]
	mov	dl,axbpin[bx+3]
	cmp	dx,ax
	je	belex
buf1:	inc	bx
buf3:	loop	buf2
	jmp	bufmet
belex:	inc	bx
	inc	bx
	inc	bx
	inc	bx
	push	bx
	push	cx
	mov	cx,axbpb
	mov	si,0
bel2:	mov	dl,axbpin[bx]
	cmp	dl,es:axbbuf[si]
	je	bel1
	pop	cx
	pop	bx
	jmp	buf3
bel1:	inc	si
	inc	bx
	loop	bel2
	mov	bx,axbp
	pop	cx
	pop	ax
	mov	word ptr axbpin[bx],65535
	mov	axbpin[bx+2],ah
	mov	axbpin[bx+3],al
	inc	axbp
	inc	axbp
	inc	axbp
	inc	axbp
	mov	cx,axbpb
	mov	bx,0
axbg:	mov	byte ptr es:axbbuf[bx],0
	inc	bx
	loop	axbg
	mov	axbpb,0
	jmp	axb93


;******************************************
;***             TYPOMA AXB             ***
;******************************************

axbpr	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	push	cx
	push	dx
	push	bx
	push	si
	mov	baxb,0
	mov	axbs,0
	mov	lola,0

	mov	cx,312
	mov	bx,0
rrr:	mov	byte ptr bufaxb[bx],0
	inc	bx
	loop	rrr

;****************************************** ELEGXOS
	mov	cx,axbp
	mov	bx,0
pr1:	mov	dl,axbpin[bx]
	cmp	dl,"*"
	jne	pr3
uu8:	mov	di,8			;shmeia a+1
	cmp	word ptr axbpin[bx][di],65534
	je	print
pr3:	inc	bx
	loop	pr1
	jmp	pr9

print:	push	cx
	mov	ah,axbpin[bx][di+2]
	mov	al,axbpin[bx][di+3]
	mov	axbs,ax
	inc	bx
uu7:	mov	ax,7			;shmeia a
	mov	cx,ax
	mov	si,baxb
prr1:	mov	dl,axbpin[bx]
	cmp	dl,0
	jne	ner14

	mov	ax,1004
	call	fatal_error

ner14:	mov	bufaxb[si],dl
	inc	bx
	inc	si
	loop	prr1
	mov	baxb,si
	add	bx,4
	push	bx
prr2:	cmp	word ptr axbpin[bx],65535
	je	elext
prr7:	inc	bx
	cmp	bx,axbp
	jb	prr2
	mov	si,baxb
	cmp	si,0
	je	llll
	pop	si
	push	si
	call	prinb
llll:	pop	bx
	pop	cx
	jmp	pr3

elext:	pop	di
	push	di
	mov	ah,axbpin[bx+2]
	mov	al,axbpin[bx+3]
	cmp	ax,di
	je	prina
	jmp	prr7

prina:	mov	ax,7			;shmeia a
	sub	bx,ax
	mov	cx,ax
	mov	si,baxb
prr5:	mov	dl,axbpin[bx]
	cmp	dl,0
	jne	ner13

	mov	ax,1005
	call	fatal_error

ner13:	mov	bufaxb[si],dl
	inc	bx
	inc	si
	loop	prr5
	mov	baxb,si
	inc	bx
	inc	bx

uu9:	mov	ax,77			;shmeia a x 11

	cmp	baxb,ax
	jae	werti
	jmp	prr7

werti:	pop	si
	push	si
	push	bx
	call	prinb
	pop	bx
	jmp	prr7

;******************************************
;***              TYPOMA A              ***
;******************************************
prinb:
	call	clr_buf24

	mov	bx,0
	mov	cx,baxb
	mov	di,0
	xor	ax,ax
uu31:	mov	ah,7			; a
lop1:	mov	dl,bufaxb[di]
	cmp	dl,0
	jne	ner15

	mov	ax,1006
	call	fatal_error

ner15:	mov	buf24[bx],dl
	inc	bx
	inc	di
	inc	al
	cmp	ah,al
	jne	lop2
uu34:	mov	dx,6			;shmeia b
	add	bx,dx
	xor	al,al
lop2:	loop	lop1

	push	bx
	cmp	lola,0
	je	cccc
;******************************************
;***              TYPOMA B              ***
;******************************************
	mov	cx,65500
	jmp	uu15

cccc:	mov	ch,axbpin[si-2]
	mov	cl,axbpin[si-1]
uu15:	mov	ax,60			;shmeia b x 10
	cmp	cx,ax
	jbe	uu36

	mov	cx,ax
	mov	lola,1

uu36:	mov	ax,7			; a
	pop	bx
	push	bx
	add	bx,ax
ert2:	xor	ax,ax
uu37:	mov	ah,6
prr3:	mov	dl,axbpin[si]
	cmp	dl,"*"
	je	ejod0
	cmp	dl,0
	je	ejod0
	mov	buf24[bx],dl
	inc	si
	inc	bx
	inc	al
	cmp	ah,al
	jne	prr71
	xor	al,al
uu35:	mov	dx,7			; a
	add	bx,dx
prr71:	loop	prr3
	jmp	ejodos

ejod0:	mov	lola,0

ejodos:	pop	ax
	push	ax
	push	bx

	push	cx
	push	dx

	sub	bx,ax
	xor	dx,dx
	mov	cx,13
	div	cx
	push	ax
	mov	ax,bx
	xor	dx,dx
	mov	cx,13
	div	cx
	xor	dx,dx
	pop	cx
	mov	axb_bm,ax
	mov	axb_am,cx
	mul	cx
	mov	deltio,ax
	pop	dx
	pop	cx
;****************************************************************
	cmp	ax,11
;****************************************************************
	ja	deltip
	jmp	delmet

deltip: pop	bx
	pop	ax
	call	deltyp

ejod2:	cmp	lola,0
	je	ejod1
	cmp	byte ptr axbpin[si],"*"
	je	ejod1
	cmp	byte ptr axbpin[si],0
	je	ejod1
	jmp	prinb

ejod1:	mov	baxb,0
	mov	lola,0
;****************************************************************
	mov	cx,312
;****************************************************************
	xor	bx,bx
rrr1:	mov	byte ptr bufaxb[bx],0
	mov	byte ptr buf24[bx],0
	inc	bx
	loop	rrr1
	ret

;****************************************
;***  		KANTO APLO            ***
;****************************************
delmet: pop	bx
	pop	ax
	mov	ax,axb_am
	mov	cx,13
	mul	cx
	mov	bx,ax
uu63:	mov	dx,7		; a
	add	bx,dx

	push	si
	mov	di,bp48
	mov	si,0
	mov	cx,axb_am
jkl:	push	cx
	push	bx
	mov	cx,axb_bm
fgh:	call	amet
	call	bmet
	add	bx,13
	loop	fgh
	pop	bx
	pop	cx
	add	si,13
	loop	jkl
	pop	si
;********************************* CHECK
	@PUSH	
	mov	ax,di
	sub	ax,bp48
	xor	dx,dx
	mov	cx,13
	div	cx
	cmp	dx,0
	jne	err19
	push	ax
	mov	ax,axb_am
	mov	cx,axb_bm
	mul	cx
	pop	cx
	cmp	ax,cx
	je	ner19

err19:	mov	ax,1007
	call	fatal_error

ner19:	@POP
;*********************************
	mov	bp48,di
;****************************************************************
	cmp	di,143		;312
;****************************************************************
	jae	pr24s
	jmp	ejod2
;****************************************************************
pr24s:	call	clr_buf24
	mov	cx,143		;312
;****************************************************************
	mov	bx,0
vcx:	mov	dl,buf48[bx]
	mov	buf24[bx],dl
	cmp	dl,0
	je	pvc
	inc	bx
	loop	vcx
pvc:
;********************************* CHECK
	mov	ax,bx
	xor	dx,dx
	mov	cx,13
	div	cx
	cmp	dx,0
	je	ok00

	mov	ax,1008
	call	fatal_error

ok00:
;*********************************
	mov	deltio,ax
	call	deltyp

;****************************************************************
sdh12:	mov	cx,143
;****************************************************************
	mov	bx,0
pp2:	mov	buf48[bx],0
	inc	bx
	loop	pp2
;****************************************************************
	mov	cx,143
;****************************************************************
	mov	bx,0
zxc:	mov	dl,buf48[bx][143]
	mov	buf48[bx],dl
	cmp	dl,0
	je	ejv
	inc	bx
	loop	zxc
ejv:
;********************************* CHECK
	mov	ax,bx
	mov	cx,13
	xor	dx,dx
	div	cx
	cmp	dx,0
	je	ner18

	mov	ax,1009
	call	fatal_error

ner18:
;*********************************
	mov	bp48,bx
;****************************************************************
	mov	cx,143			;312
;****************************************************************
	mov	bx,143
vbn:	mov	buf48[bx],0
	inc	bx
	loop	vbn
	jmp	ejod2

amet:	push	ax
	push	dx
	push	cx
	push	bx
	push	si
uu61:	mov	ax,7		; a
	mov	cx,ax
asd:	mov	dl,buf24[si]
	cmp	dl,0
	jne	ner17

	mov	ax,1010
	call	fatal_error

ner17:	mov	buf48[di],dl
	inc	si
	inc	di
	loop	asd
	pop	si
	pop	bx
	pop	cx
	pop	dx
	pop	ax
	ret
;
bmet:	push	ax
	push	dx
	push	cx
	push	bx
	push	si
uu62:	mov	ax,6		; b 
	mov	cx,ax
ads:	mov	dl,buf24[bx]
	cmp	dl,0
	jne	ner16

	mov	ax,1011
	call	fatal_error

ner16:	mov	buf48[di],dl
	inc	bx
	inc	di
	loop	ads
	pop	si
	pop	bx
	pop	cx
	pop	dx
	pop	ax
	ret
;******************************************
pr9:	mov	axbp,0
	mov	cx,BUFAXB_AB
	mov	bx,0
	xor	ax,ax
moyni:	mov	axbpin[bx],al
	inc	bx
	loop	moyni
	pop	si
	pop	bx
	pop	dx
	pop	cx
	@POP
	ret
axbpr	endp

codesg	ends
	end
