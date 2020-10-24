
INCLUDE equs.h

codesg	segment public

	assume	cs:codesg,ds:datas1

bale_omada_ana	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATASC
	mov	cx,0
	mov	aromad[2],2
	mov	si,0
	mov	dx,0
epomeno_set:
pare_epomeno_oro:
	mov	al,es:arxasc[si]
	mov	ah,tipos_orou
	cmp	al,ah
	je	kalvs
	add	si,48
	cmp	si,arxascii
	jb	pare_epomeno_oro
	jmp	ejodos

kalvs:	xor	ax,ax
	mov	al,aromad[2]
	mov	es:arxasc[si+47],al
	mov	bl,10
	div	bl
	cmp	al,0
	jne	exei_prvto_chfio
	add	ah,30h
	mov	es:arxasc[si+45],ah
	mov	es:arxasc[si+46]," "
	jmp	kokoko

exei_prvto_chfio:
	add	al,30h
	mov	es:arxasc[si+45],al
deytero_chfio:
	add	ah,30h
	mov	es:arxasc[si+46],ah

kokoko:	inc	cx
	add	si,48
	cmp	si,arxascii
	jae	ejodos
	cmp	cx,word ptr aromad[0]
	jae	ayjhse_omada
	jmp	epomeno_set
ayjhse_omada:
	xor	cx,cx
	inc	aromad[2]
	cmp	aromad[2],35
	jbe	oreos
	mov	aromad[2],35
oreos:	jmp	epomeno_set
ejodos: @POP
	ret
bale_omada_ana	endp

;*************************************	sbisimo omadas
sbyse_omada	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATASC
	cmp	memory,0
	je	oxim1
	xor	ax,ax
	mov	al,aromad[0]
	cmp	al,1
	jbe	oxim
	mov	di,ax
	dec	di
	dec	di
	cmp	byte ptr es:klioma[di],0
	jne	oxim
oxim1:	mov	bx,0
allel:	mov	dl,es:arxasc[bx+47]
	cmp	dl,aromad[0]
	jne	msbyn
	jmp	sbyse
oxim:	@POP
	ret
msbyn:	cmp	dl,aromad[0]
	ja	telos
	add	bx,48
allo:	cmp	bx,arxascii
	jb	allel
telos:	mov	bx,0
allo1:	mov	dl,es:arxasc[bx]
	cmp	dl,99
	je	brika
	add	bx,48
	cmp	bx,arxascii
	jb	allo1
	jmp	tels
brika:	mov	si,bx
brika2:	mov	dl,es:arxasc[bx]
	cmp	dl,99
	jne	brika1
	add	bx,48
	cmp	bx,arxascii
	jb	brika2
	jmp	tels
brika1:	mov	cx,48
met:	mov	dl,es:arxasc[bx]
	mov	es:arxasc[si],dl
	mov	es:arxasc[bx],99
	inc	si
	inc	bx
	loop	met
	cmp	bx,arxascii
	jb	brika2
	jmp	tels
sbyse:	mov	cx,48
lop:	mov	byte ptr es:arxasc[bx],99
	inc	bx
	loop	lop
	jmp	allo
;
tels:	xor	ax,ax
	xor	dx,dx
	mov	al,aromad[0]
	mov	cx,6
	mul	cx
	mov	bx,ax
	mov	cx,pinak1[bx]
	cmp	cx,0
	jne	cxi
	@POP
	ret
cxi:	sub	arxascii,48
	loop	cxi
	mov	bx,arxascii
	push	bx
lapas:	mov	byte ptr es:arxasc[bx],0
	inc	bx
	cmp	bx,BUFASCII
	jb	lapas
	pop	bx
	mov	es:arxasc[bx+47],"c"
	mov	ax,arxascii
	xor	dx,dx
	mov	bx,48
	div	bx
	mov	bx,14
	div	bx
	mov	bl,dl
	mov	bselida,ax
	mov	al,bl
	mov	dl,4
	mul	dl
	add	ax,23
	mov	asthlh,al
	@POP
	ret
sbyse_omada	endp

;*************************************	allagi omadas
allage_omada	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATASC
	mov	bx,0
allh:	mov	dl,es:arxasc[bx+47]
	cmp	dl,aromad[0]
	je	allagh
	ja	telos1
allh1:	add	bx,48
	cmp	bx,arxascii
	jb	allh
telos1: xor	ax,ax
	mov	al,aromad[0]
	mov	dl,6
	mul	dl
	mov	bx,ax
	mov	ax,pinak1[bx]
	push	ax
	mov	ax,pinak1[bx+2]
	push	ax
	mov	ax,pinak1[bx+4]
	push	ax
	xor	ax,ax
	mov	al,aromad[1]
	mov	dl,6
	mul	dl
	mov	bx,ax
	pop	ax
	mov	pinak1[bx+4],ax
	pop	ax
	mov	pinak1[bx+2],ax
	pop	ax
	mov	pinak1[bx],ax
	cmp	bx,12
	jb	krios
	@POP
	ret
krios:	mov	pinak1[bx+4],0
	mov	pinak1[bx+2],0
	@POP
	ret

allagh: mov	dl,es:arxasc[bx]
	cmp	dl,"7"
	je	allh1
	cmp	aromad[1],0
	jne	nodl0
	jmp	dlis0
nodl0:	mov	dl,aromad[1]
	mov	es:arxasc[bx+47],dl
	xor	ax,ax
	mov	al,dl
	mov	grammh,al
	xor	dx,dx
	push	cx
	mov	cl,10
	div	cl
	pop	cx
	cmp	grammh,9
	ja	fy
	mov	al,ah
	mov	ah," "
	jmp	fy1
fy:	add	ah,30h
fy1:	mov	es:arxasc[bx+46],ah
	add	al,30h
	mov	es:arxasc[bx+45],al
	cmp	aromad[0],0
	je	midy
	jmp	allh1
dlis0:	mov	al,tipos_orou
	cmp	es:arxasc[bx],al
	jne	arxisnW
	mov	es:arxasc[bx],"0"
	mov	es:arxasc[bx+40]," "
	mov	es:arxasc[bx+41]," "
	mov	es:arxasc[bx+42]," "
	mov	es:arxasc[bx+43]," "
	mov	es:arxasc[bx+44]," "
	mov	es:arxasc[bx+45],"P"
	mov	es:arxasc[bx+46]," "
	mov	es:arxasc[bx+47],0
arxisnW: jmp	allh1

midy:	mov	al,tipos_orou
	mov	es:arxasc[bx],al
	mov	es:arxasc[bx+40],"0"
	mov	es:arxasc[bx+41]," "
	mov	es:arxasc[bx+42],"1"
	mov	es:arxasc[bx+43],"3"
	mov	es:arxasc[bx+44],"N"
	jmp	allh1
allage_omada	endp

;*************************************	allagi orivn basikvn omadas
all_or_basikvn	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATASC
	mov	bx,0
leo1:	mov	dl,es:arxasc[bx+47]
	cmp	dl,aromad[0]
	je	ocopi
	ja	ojape
oallhc: add	bx,48
	cmp	bx,arxascii
	jb	leo1
ojape:	@POP
	ret

ocopi:	mov	dl,es:arxasc[bx]
	mov	dh,tipos_orou
	cmp	dl,dh
	jne	oallhc
	xor	ax,ax
	mov	al,aromad[2]
	mov	grammh,al
	xor	dx,dx
	push	cx
	mov	cl,10
	div	cl
	pop	cx
	cmp	grammh,9
	ja	ofggg
	mov	al,ah
	mov	ah," "
	jmp	ofggg1
ofggg:	add	ah,30h
ofggg1: mov	es:arxasc[bx+41],ah
	add	al,30h
	mov	es:arxasc[bx+40],al
	xor	ax,ax
	mov	al,aromad[3]
	mov	grammh,al
	xor	dx,dx
	push	cx
	mov	cl,10
	div	cl
	pop	cx
	cmp	grammh,9
	ja	oft
	mov	al,ah
	mov	ah," "
	jmp	oft1
oft:	add	ah,30h
oft1:	mov	es:arxasc[bx+43],ah
	add	al,30h
	mov	es:arxasc[bx+42],al
	mov	dl,aromad[4]
	mov	es:arxasc[bx+44],dl
	jmp	oallhc
all_or_basikvn	endp

;*************************************	antigrafi omadas
copy_omada	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATASC
	mov	si,arxascii
	mov	bx,0
allhc:	mov	dl,es:arxasc[bx+47]
	cmp	dl,aromad[0]
	je	copia
	ja	telos2
	add	bx,48
allhc1: cmp	bx,arxascii
	jb	allhc
telos2: mov	bx,arxascii
	mov	es:arxasc[bx+47],"c"
	mov	ax,bx
	xor	dx,dx
	mov	bx,48
	div	bx
	mov	bx,14
	div	bx
	mov	bl,dl
	mov	bselida,ax
	mov	al,bl
iuyc:	mov	dl,4
	mul	dl
	add	ax,23
	mov	asthlh,al
	jmp	tels1

copia:	cmp	es:arxasc[bx],"7"
	jne	nopid
	jmp	pidaf

nopid:	cmp	aromad,0
	jne	oxiplr
	call	kopi_0
	call	kopi_1
	call	kopi_5
	jmp	pidaf1

oxiplr:	cmp	aromad[1],0
	jne	oxi2pl
	call	kopi_4
	call	kopi_1
	call	kopi_3
	jmp	pidaf

oxi2pl:	xchg    bx,si
	mov     cx,48
        mov     di,0
lop1:   mov     dl,es:arxasc[si]
        mov     es:arxasc[bx][di],dl
        inc     di
        inc     si
        loop    lop1
        xchg    bx,si
;*****
pidaf1:	mov	dl,aromad[1]
	mov	es:arxasc[si+47],dl
	xor	ax,ax
	mov	al,dl
	mov	grammh,al
	xor	dx,dx
	push	cx
	mov	cl,10
	div	cl
	pop	cx
	cmp	grammh,9
	ja	fgg
	mov	al,ah
	mov	ah," "
	jmp	fgg1
fgg:	add	ah,30h
fgg1:	mov	es:arxasc[si+46],ah
	add	al,30h
	mov	es:arxasc[si+45],al
;*****
pidaf:	add	arxascii,48
	cmp	arxascii,BUFASCII		;telos pinaka arxasc
	jb	krok
	jmp	telos2
krok:	add	si,48
	jmp	allhc1
;*****
tels1:	xor	ax,ax
	mov	al,aromad[0]
	mov	dl,6
	mul	dl
	mov	bx,ax
	mov	ax,pinak1[bx]
	push	ax
	mov	ax,pinak1[bx+2]
	push	ax
	mov	ax,pinak1[bx+4]
	push	ax
	xor	ax,ax
	mov	al,aromad[1]
	mov	dl,6
	mul	dl
	mov	bx,ax
	pop	ax
	mov	pinak1[bx+4],ax
	pop	ax
	mov	pinak1[bx+2],ax
	pop	ax
	mov	pinak1[bx],ax
	cmp	bx,6
	je	krios1
	@POP
	ret
krios1: mov	pinak1[bx+4],0
	mov	pinak1[bx+2],0
	@POP
	ret

kopi_0:	xchg	bx,si
	mov	dl,tipos_orou
	mov	es:arxasc[bx],dl
	inc	si
	xchg	bx,si
	ret

kopi_4:	xchg	bx,si
	mov	dl,"0"
	mov	es:arxasc[bx],dl
	inc	si
	xchg	bx,si
	ret

kopi_1:	xchg	bx,si
	xor	di,di
	mov	cx,13
lop10:	push	di
	push	cx
	xor	ax,ax
	mov	al,antistixia[di]
	cmp	al,0
	jne	lop13
	add	si,3
	jmp	lop14

lop13:	dec	al
	mov	di,ax
	add	di,ax
	add	di,ax
	inc	di

	mov	cx,3
lop11:	mov	dl,es:arxasc[si]
	mov	es:arxasc[bx][di],dl
	inc	si
	inc	di
	loop	lop11

lop14:	pop	cx
	pop	di
	inc	di
	loop	lop10
	xchg	bx,si
	ret

kopi_3:	xchg	bx,si
	mov	es:arxasc[bx][40]," "
	mov	es:arxasc[bx][41]," "
	mov	es:arxasc[bx][42]," "
	mov	es:arxasc[bx][43]," "
	mov	es:arxasc[bx][44]," "
	mov	es:arxasc[bx][45],"P"
	mov	es:arxasc[bx][46]," "
	mov	es:arxasc[bx][47],0
	xchg	bx,si
	ret

kopi_5:	xchg	bx,si
	mov	es:arxasc[bx][40],"1"
	mov	es:arxasc[bx][41]," "
	mov	es:arxasc[bx][42],"1"
	mov	es:arxasc[bx][43],"3"
	mov	es:arxasc[bx][44],"N"
	xchg	bx,si
	ret
copy_omada	endp

;*************************************	metatropi se basikes
mnimi2basikes	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATASC
	mov	si,arxascii
	cmp	si,BUFASCII-96
	jb	conio
	@POP
	ret

conio:	cmp	tipos_orou,"B"
	jne	noBBB
	jmp	forBBB

noBBB:	push	si
	inc	si
	xor	di,di
	xor	bx,bx
	xor	ax,ax
	mov	cx,13
bas:	mov	al,antistixia[di]
	cmp	al,0
	je	bas12
	dec	ax
	mov	bx,ax
	add	bx,ax
	add	bx,ax
	mov	dl,pinsthl[di]
	call	apocode
	mov	es:arxasc[si][bx],dl
	mov	es:arxasc[si][bx][1]," "
	mov	es:arxasc[si][bx][2]," "
bas12:	inc	di
	loop	bas
	pop	si

stand131:
	mov	al,tipos_orou
	mov	es:arxasc[si],al
	mov	es:arxasc[si+40],"0"
	mov	es:arxasc[si+41]," "
	mov	es:arxasc[si+42],"1"
	mov	es:arxasc[si+43],"3"
	mov	es:arxasc[si+44],"N"
	mov	es:arxasc[si+45],"3"
	mov	es:arxasc[si+46],"5"
	mov	es:arxasc[si+47],35
	add	arxascii,48
	mov	bx,arxascii
	mov	es:arxasc[bx+47],"c"
	mov	ax,bx
	xor	dx,dx
	mov	bx,48
	div	bx
	mov	bx,14
	div	bx
	mov	bl,dl
	mov	bselida,ax
	mov	al,bl
	mov	dl,4
	mul	dl
	add	ax,23
	mov	asthlh,al
i_ret:	@POP
	ret

forBBB:	push	si
	inc	si
	xor	di,di
	mov	cx,13
bas14:	mov	dl,pinsthl[di]
	call	apocode
	cmp	dl," "
	je	bas13
	mov	es:arxasc[si],dl
	mov	es:arxasc[si][1]," "
	mov	es:arxasc[si][2]," "
	inc	di
	add	si,3
	loop	bas14
bas13:	pop	si
	jmp	stand131
mnimi2basikes	endp

;*************************************	allagi simiou me allo
antikat_simio	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATASC
	mov	bx,0
ansleo1:
	mov	dl,es:arxasc[bx+47]
	cmp	dl,aromad[0]
	je	ansocopi
	ja	ansojape
ansoallhc:
	add	bx,48
	cmp	bx,arxascii
	jb	ansleo1
ansojape:
	@POP
	ret

ansocopi:
	mov	dl,es:arxasc[bx]
	mov	dh,tipos_orou
	cmp	dl,dh
	jne	ansoallhc
;****************************
	xor	ax,ax
	mov	al,aromad[2]
	mov	si,ax
	mov	al,es:arxasc[bx][si]
	cmp	al,aromad[3]
	jne	ansoallhc
	mov	al,es:arxasc[bx][si][1]
	cmp	al,aromad[4]
	jne	ansoallhc
	mov	al,es:arxasc[bx][si][2]
	cmp	al,aromad[5]
	jne	ansoallhc

	mov	al,aromad[6]
	mov	es:arxasc[bx][si],al
	mov	al,aromad[7]
	mov	es:arxasc[bx][si][1],al
	mov	al,aromad[8]
	mov	es:arxasc[bx][si][2],al
	jmp	ansoallhc
antikat_simio	endp

codesg	ends
	end
