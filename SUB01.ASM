
INCLUDE	equs.h

codesg	segment public

	assume	cs:codesg,ds:datas1


Agonas14_4Dialogi	proc	near
	push	bx
	cmp	Agonas14_Anaposa,0
	jne	exei_anaposa
	mov	dl,Agonas14_Simio_Code[4]
	jmp	Ag14tel
exei_anaposa:
	mov	bx,Agonas14_Simio_point
	inc	Agonas14_Metritis
	mov	ax,Agonas14_Metritis
	
	cmp	al,Agonas14_Anaposa
	jbe	min_allazis_simio
	
	inc	bx
	mov	Agonas14_Simio_point,bx
	mov	Agonas14_Metritis,1

min_allazis_simio:
	mov	dl,Agonas14_Simio_Code[bx]
	cmp	dl,0
	jne	Ag14tel
	mov	Agonas14_Simio_point,0
	xor	bx,bx
	jmp	min_allazis_simio

Ag14tel:
	mov	dh,Agonas14_Dialogi
	call	check
	jc	kisk

	inc	epitixies

kisk:	pop	bx
	ret
Agonas14_4Dialogi	endp


plirakia_dialogi	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	xor	bx,bx

arxhek:	@INCL	ar_deltiou
	mov	plhrqa,0

	mov	si,bx
	@ZEROBBUF	epig,4
	mov	cx,4
	
plrt9:	push	cx
	push	si
	mov	si,plhrqa
	mov	plhrqpin[si],bx
	inc	plhrqa
	inc	plhrqa
	pop	si

	push	bx
	push	si
	mov	si,bx
	xor	bx,bx
	mov	epitixies,0
	
	call	Agonas14_4dialogi
	
	mov	cx,13
plrt1:	mov	dl,axbpin[si][bx]
	mov	dh,pindial[bx]

	call	check
	jc	kiss

	inc	epitixies

kiss:	inc	bx
	loop	plrt1

	call	dial_pl1

	pop	si
	pop	bx
	add	bx,13
	pop	cx
	cmp	bx,axbp
	jae	plrt0
	loop	plrt9

plrt0:	cmp	plhrqa,0
	ja	ypolg
	jmp	japla

ypolg:	call	ypologismos_sthlvn
	call	dialogi_diax

	cmp	plhrqa,0
	je	japla
;*****************************************
fygas:	cmp	bx,axbp
	jae	telosek
	jmp	arxhek

telosek:
	mov	cx,BUFAXB_AB
	xor	bx,bx
plrtc:	mov	axbpin[bx],0
	inc	bx
	loop	plrtc
	mov	axbp,0
	mov	plirpoint,0
	@POP
	ret

japla:	sub	ar_deltiou,1
	sbb	ar_deltiou[2],0
	jmp	telosek
plirakia_dialogi	endp

ypologismos_sthlvn	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	cx,4
	xor	bx,bx
midenp:	mov	stlplr[bx],1
	mov	stlplr[bx+2],0
	add	bx,4
	loop	midenp

	mov	stlplr[16],0
	mov	stlplr[18],0

	xor	dx,dx
	mov	ax,plhrqa
	mov	cx,2
	div	cx
	mov	cx,ax

	mov	bx,0
	xor	di,di
plr4:	push	cx
	mov	cx,13
	mov	si,plhrqpin[bx]
plir13: mov	dl,axbpin[si]
	cmp	dl,8
	ja	trp
	cmp	dl,4
	ja	dpl
	jmp	qoqor
trp:	@LMUL	stlplr[di][2],stlplr[di],0,3
	mov	stlplr[di],ax
	mov	stlplr[di][2],dx
	jmp	qoqor

plir139: jmp	plir13

plr49:	loop	plr4
	jmp	tel0

dpl:	@LMUL	stlplr[di][2],stlplr[di],0,2
	mov	stlplr[di],ax
	mov	stlplr[di][2],dx
qoqor:	inc	si
	loop	plir139

	pop	cx
	@LADDN	stlplr[16],stlplr[di]
	cmp	si,axbp
	jae	tel0
	add	di,4
	add	bx,2
	add	sthlh,8
	jmp	plr49

tel0:	@LADDN	mexri_tora,stlplr[16]
	@POP
	ret
ypologismos_sthlvn	endp

dial_pl1	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	bx,14
	sub	bl,epitixies
	cmp	bx,3
	ja	fig
	inc	epig[bx]

fig:	@POP
	ret
dial_pl1	endp

check	proc	near
	cmp	dl,9
	je	krak9
	cmp	dl,4
	ja	krak1
	dec	dl
	cmp	dh,dl
	je	krak9
	stc
	ret
krak9:	clc
	ret
krak1:	cmp	dh,1
	jne	krak2
	cmp	dl,7
	jne	krak9
	stc
	ret
krak2:	cmp	dh,2
	jne	krak3
	cmp	dl,6
	jne	krak9
	stc
	ret
krak3:	cmp	dl,5
	jne	krak9
	stc
	ret
check	endp

codesg	ends
	end
