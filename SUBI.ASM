
INCLUDE	equs.h

print	macro	ch
	mov	al,ch
	mov	ah,0eh
	int	10h
	endm

biosprint macro	
	mov	al,dl		;routina bios
	mov	ah,0eh
	int	10h
	endm

codesg	segment public
public	screen,x21,apo_evs,naoxi,bbuf,prbuf,clr_scr,lprint
public	setcurs,plhktro,dispmhn,bin_dec,dosdisp
public	dec_bin,apou2,apou3,predit,bbuffer,capo,metrpr
public	tajinom,xarakt,asteri,edast,omades,metrima,edomad,putsthles
public	editq,editr,editomr,editot,sbyse,cersor,biosdisp
public	tend,editor,editor1,editor2,dioru,tselid,tchar,kauar
public	edtomr1,deltyp,eisagvgh_dialoghs,getkey,dosdisp

	ASSUME	CS:CODESG,DS:DATAS1,ES:DATANA
;
dosdisp proc	near
	push	ax
	biosprint
	pop	ax
	ret
dosdisp endp

;
biosdisp proc	near
	push	ax
	biosprint
	pop	ax
	ret
biosdisp endp

putsthles	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@SELECTWI	0
	@FILLSTR	strbuf," ",11
	@WPRINT	4,0,strbuf
	@LTOA	cound,cound[2],strbuf
	@USING	strbuf,8
	@WPRINT	6,0,strbuf
	@POP
	ret
putsthles	endp

tend	proc	near
	call	kauar
	cmp	shmea4,0
	je	blab
	mov	shmea4,0
	cmp	shmea5,1
	je	smea52
	ret
blab:	cmp	shmea5,1
	je	edvp
	mov	ax,bselida
	cmp	selida,ax
	je	edvp
	mov	selida,ax
	call	apou2
	call	prbuf
	call	apou3
edvp:	cmp	asthlh,77
	ja	sbyse1
	jmp	kouts
sbyse1: cmp	bselida,89
	jae	kouts
	call	sbyse
	inc	selida
	inc	bselida
kouts:	call	bbuf
	cmp	mastos,1
	je	cam1
	call	tselid
cam1:	mov	mastos,0
	ret
smea52: mov	shmea5,2
	ret
tend	endp
;
dioru	proc	near
	mov	dh,0
	mov	dl,23
koita:	call	setcurs
	push	dx
	mov	dl,219
	call	dosdisp
	mov	dl,8
	call	dosdisp
	call	getkey
	cmp	al,0
	jne	kolaraki
	cmp	ah,4dh
	je	koita1
	cmp	ah,4bh
	jne	kolaraki
	jmp	kratv2
kolaraki:
	cmp	al,"-"
	jne	kifa
	jmp	kratv2
kifa:	cmp	al,13
	je	koita2
	cmp	al,"]"
	je	koita1
	cmp	al,"+"
	je	koita1
	cmp	al,27
	jne	nokoit
	jmp	kissa
nokoit: pop	dx
	jmp	koita
koita1: mov	dl,32
	call	dosdisp
	pop	dx
	cmp	dl,74
	ja	maxim
	add	dl,4
	jmp	koita
koita2: pop	dx
	mov	sthlh,dl
	mov	stili,dl
	sub	dl,23
	xor	ax,ax
	mov	al,dl
	xor	dx,dx
	mov	cx,4
	div	cx
	mov	cx,48
	mul	cx
	push	ax
	mov	ax,selida
	mov	cx,672
	mul	cx
	pop	cx
	add	ax,cx
	xor	dx,dx
;------------------------------ klidoma
	push	ax
	mov	bx,48
	div	bx
	mov	bx,ax
	pop	ax
	@CHANGESEGM	ds,DATASC
	mov	dl,klioro[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	jne	tdk1
	mov	ax,65535
	jmp	tdk
tdk1:	call	bbuffer
	call	predit
tdk:	ret
maxim:	mov	dl,23
	jmp	koita
kissa:	pop	dx
	mov	sthlh,dl
	mov	stili,dl
	sub	dl,23
	xor	ax,ax
	mov	al,dl
	xor	dx,dx
	mov	cx,4
	div	cx
	mov	cx,48
	mul	cx
	push	ax
	mov	ax,selida
	mov	cx,672
	mul	cx
	pop	cx
	add	ax,cx
	xor	dx,dx
	mov	ax,65535
	ret
kratv2: mov	dl,32
	call	dosdisp
	pop	dx
	cmp	dl,23
	jbe	minim
	sub	dl,4
	jmp	koita
minim:	mov	dl,75
	jmp	koita
dioru	endp
;
tselid	proc	near
	mov	dl,asthlh
	mov	sthlh,dl
	mov	bx,0
	mov	dh,0
	mov	dl,sthlh
	inc	dl
	call	setcurs
	add	sthlh,3
	mov	dl,buffers[bx]
	call	tchar
	mov	grammh,2
	mov	cx,13
aqub:	push	cx
	dec	sthlh
	dec	sthlh
	dec	sthlh
	cmp	cx,10
	je	incr
	cmp	cx,7
	je	incr
	cmp	cx,4
	je	incr
	jmp	beba
incr:	inc	grammh
beba:	mov	cx,3
aqua:	push	cx
	mov	dh,grammh
	mov	dl,sthlh
	call	setcurs
	mov	dl,buffers[bx]
	call	tchar
	inc	sthlh
	pop	cx
	loop	aqua
	pop	cx
	inc	grammh
	loop	aqub
	inc	grammh
	dec	sthlh
	dec	sthlh
	dec	sthlh
	call	cersor
	mov	dl,buffers[bx]
	call	tchar
	mov	dl,buffers[bx]
	call	tchar
	inc	grammh
	call	cersor
	mov	dl,buffers[bx]
	call	tchar
	mov	dl,buffers[bx]
	call	tchar
	inc	grammh
	call	cersor
	mov	dl,buffers[bx]
	call	tchar
	inc	grammh
	inc	grammh
	call	cersor
	mov	dl,buffers[bx]
	call	tchar
	cmp	buffers[bx+1],2
	jb	pyr0
	mov	dl,buffers[bx]
	call	tchar
	jmp	pyr1
pyr0:	mov	dl," "
	call	tchar
pyr1:	mov	cx,48
	mov	bx,0
again:	mov	buffers[bx]," "
	inc	bx
	loop	again
	cmp	shmea5,1
	je	mvro
	add	asthlh,4
mvro:	ret
tselid	endp

sbyse	proc	near
	mov	sthlh,23
	mov	cx,14
babe:	push	cx
	mov	cx,0
baba:	cmp	cx,22
	je	decr
	cmp	cx,18
	je	decr
	cmp	cx,13
	je	decr
	cmp	cx,9
	je	decr
	cmp	cx,5
	je	decr
	cmp	cx,1
	je	decr
	jmp	edvm
decr:	inc	cx
edvm:	mov	dh,cl
	mov	dl,sthlh
	call	setcurs
	print	32
	print	32
	print	32
	inc	cx
	cmp	cx,24
	jl	baba
	add	sthlh,4
	pop	cx
	loop	babe
	mov	asthlh,23
	ret
sbyse	endp

cersor	proc	near
	push	dx
	push	ax
	push	bx
	mov	dh,grammh
	mov	dl,sthlh
	mov	ah,02
	mov	bh,00
	int	10h
	pop	bx
	pop	ax
	pop	dx
	ret
cersor	endp

tchar	proc	near
	biosprint
	inc	bx
	ret
tchar	endp

kauar	proc	near
	push	ax
	mov	al,shmeat
	mov	shmeat,0
	mov	shmea2,1
	call	editor1
	mov	shmea2,0
	mov	dl,18
	mov	dh,0
	call	setcurs
	print	32
	mov	dl,17
	mov	dh,19
	call	setcurs
	print	32
	print	32
	inc	dh
	call	setcurs
	print	32
	print	32
	inc	dh
	call	setcurs
	print	32
	inc	dh
	inc	dh
	call	setcurs
	print	32
	print	32
	mov	shmeat,al
	pop	ax
	ret
kauar	endp

editor	proc	near
	mov	shmea1,1
	mov	shmea3,0
	cmp	shmea8,1
	je	shm81
	mov	shmeat,0
shm81:	call	editor1
	call	editor2
	ret
editor	endp

editor2 proc	near
	cmp	shmeat,1
	jne	edit5
	ret
edit5:	call	posa_shmeia
	mov	sthlh,17
	mov	grammh,19
	mov	bx,40
	call	apo_evs
	cmp	shmea6,0
	je	edit3
	mov	shmea6,0
	jmp	edit4
edit3:	inc	grammh
	mov	bx,42
	call	apo_evs
	cmp	shmea6,0
	je	edit6
	mov	shmea6,0
	jmp	edit4
edit6:	call	naoxi
	cmp	shmea6,0
	je	edit7
	mov	shmea6,0
	jmp	edit4
edit7:	jmp	edit5
edit4:	cmp	buffers[44],32
	jne	pll41
	mov	buffers[44],78
pll41:	cmp	shmeat,1
	jne	tiptis
	cmp	buffers[45],32
	je	tipt1
	ret
tiptis: mov	grammh,23
	mov	bx,45
	call	apo_evs
	cmp	buffers[45],32
	jne	edit8
tipt1:	mov	buffers[45],49
	mov	buffers[46]," "
	mov	buffers[47],1
	mov	shmea6,0
	ret
edit8:	mov	shmea6,0
	mov	ax,bin
	cmp	al,0
	jne	deneinai0
	mov	al,1
	mov	buffers[45],49
deneinai0:
	cmp	al,35
	ja	tiptis
;------------------------------- klidoma
	mov	di,ax
	dec	di
	dec	di
	@CHANGESEGM	ds,DATASC
	mov	dl,klioma[di]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	je	tiptis
	mov	buffers[47],al
	ret
editor2 endp

editor1 proc	near
	cmp	shmeat,1
	jne	arxh
	ret
arxh:	mov	bx,1
	cmp	shmea8,0
	je	edll1
	mov	dl,19
	mov	bx,3
	jmp	edll2
edll1:	mov	dl,17
seb1:
edll2:	mov	dh,2
	call	x21

	jnc	seb2
	mov	bx,37
	jmp	short seb13
seb2:	mov	dh,3
	call	x21
	jc	seb1
seb3:	mov	dh,4
	call	x21
	jc	seb2
seb4:	mov	dh,6
	call	x21
	jc	seb3
seb5:	mov	dh,7
	call	x21
	jc	seb4
seb6:	mov	dh,8
	call	x21
	jc	seb5
seb7:	mov	dh,10
	call	x21
	jc	seb6
seb8:	mov	dh,11
	call	x21
	jc	seb7
seb9:	mov	dh,12
	call	x21
	jc	seb8
seb10:	mov	dh,14
	call	x21
	jc	seb9
seb11:	mov	dh,15
	call	x21
	jc	seb10
seb12:	mov	dh,16
	call	x21
	jc	seb11
seb13:	mov	dh,17
	call	x21
	jc	seb12
	cmp	shmea1,0
	je	reta
	cmp	shmea2,1
	je	reta
	jmp	arxh
reta:	ret
editor1 endp

x21	proc	near
	cmp	shmea2,0
	je	x21x
	mov	dl,17
	call	setcurs
	print	32
	print	32
	print	32
	ret
x21x:	cmp	shmea3,0
	je	poyli
	mov	shmea1,0
	ret
poyli:	call	setcurs
	call	getkey
	cmp	al,0
	jne	kokain
	cmp	ah,48h
	jne	kokais
_pan:	sub	bx,3
	stc
	ret
kokais: cmp	ah,50h
	je	remiza
kokain:	cmp	al,"+"
	je	_pan
	cmp	al,"."
	jne	gke
	mov	shmea1,1
	mov	shmea3,1
	inc	bx
	ret
gke:	cmp	al,"T"
	jne	pirou
_taf:	mov	shmea1,1
	mov	shmea3,1
	mov	shmeat,1
	inc	bx
	ret
remiza: jmp	return
pirou:	cmp	al,"/"
	je	_taf
	cmp	al,13
	je	return
	cmp	al,8
	je	_as
	cmp	al,"-"
	je	_as
	cmp	al,81
	jne	dttl
_as:	jmp	dlt
dttl:	cmp	shmea_diplh,1
	je	oxi_mona_shmeia
	cmp	al,"1"
	jz	q11
	cmp	al,32h
	jz	q22
	cmp	al,33h
	jz	qxx
	cmp	shmea8,1
	je	pll30
	cmp	shmea7,0
	jne	pll28
	cmp	shmea11,0
	jne	pll28
	cmp	al,"7"
	je	q12x
pll28:	cmp	shmea7,2
	je	pll30
oxi_mona_shmeia:
	cmp	al,"4"
	jz	q12
	cmp	al,"5"
	jz	q2x
	cmp	al,36h
	jnz	pll30
	jmp	q1x
pll30:	jmp	x21x
return: add	bx,3
	ret
dlt:	jmp	bdlt
q11:	print	31h
	jmp	b11
q22:	print	32h
	jmp	b22
qxx:	print	58h
	jmp	bxx
q12x:	print	31h
	print	58h
	print	32h
	jmp	b12x
q12:	print	31h
	print	32h
	jmp	b12
q2x:	print	58h
	print	32h
	jmp	b2x
q1x:	print	31h
	print	58h
	jmp	b1x
entera: print	32
enterb: print	32
entero: dec	bx
	dec	bx
	add	bx,3
	ret
	jmp	x21x
b12x:	mov	buffers[bx],31h
	inc	bx
	mov	buffers[bx],58h
	inc	bx
	mov	buffers[bx],32h
	jmp	entero
b1x:	mov	buffers[bx],31h
	inc	bx
	mov	buffers[bx],58h
	inc	bx
	mov	buffers[bx],32
	jmp	enterb
b12:	mov	buffers[bx],31h
	inc	bx
	mov	buffers[bx],32h
	inc	bx
	mov	buffers[bx],32
	jmp	enterb
b2x:	mov	buffers[bx],58h
	inc	bx
	mov	buffers[bx],32h
	inc	bx
	mov	buffers[bx],32
	jmp	enterb
b11:	mov	buffers[bx],31h
	cmp	shmea8,1
	jne	edll12
	jmp	x21x
edll12: inc	bx
	mov	buffers[bx],32
	inc	bx
	mov	buffers[bx],32
	jmp	entera
b22:	mov	buffers[bx],32h
	cmp	shmea8,1
	jne	edll4
	jmp	x21x
edll4:	cmp	shmea8,2
	jne	edll11
	jmp	x21x
edll11: inc	bx
	mov	buffers[bx],32
	inc	bx
	mov	buffers[bx],32
	jmp	entera
bxx:	mov	buffers[bx],58h
	cmp	shmea8,1
	jne	edll10
	jmp	x21x
edll10: inc	bx
	mov	buffers[bx],32
	inc	bx
	mov	buffers[bx],32
	jmp	entera
bdlt:	print	32
	cmp	shmea8,1
	je	pll100
	print	32
	print	32
	mov	buffers[bx],32
	inc	bx
	mov	buffers[bx],32
	inc	bx
	mov	buffers[bx],32

	jmp	entero
pll100: mov	buffers[bx],32
	jmp	x21x
x21	endp

apo_evs proc	near
	mov	al,buffers[bx]
	mov	chfioa,al
	inc	bx
	mov	al,buffers[bx]
	mov	chfiob,al
	mov	bin,0
pali1:	dec	bx
pali:	mov	dh,grammh
	mov	dl,sthlh
	call	setcurs
	call	plhktro
	cmp	al,13
	jne	_rita
	jmp	ejv
_rita:	cmp	al,46
	jne	rrter
	jmp	ejva1
rrter:	cmp	al,"T"
	jne	frot
_tafi:	mov	shmeat,1
	jmp	ejva1
frot:	cmp	al,"/"
	je	_tafi
	cmp	al,30h
	jb	pali
	cmp	al,39h
	ja	pali
	mov	buffers[bx],al
	mov	chfioa,al
	inc	bx
	mov	buffers[bx],32
	mov	chfiob,0
	mov	dl,al
	call	dosdisp
	print	32
	print	8
palia:	mov	dh,grammh
	mov	dl,sthlh
	inc	dl
	call	setcurs
	call	plhktro
	cmp	al,13
	je	ejv
	cmp	al,"T"
	jne	froto
_tafi1:	mov	shmeat,1
	jmp	ejva1
froto:	cmp	al,"/"
	je	_tafi1
	cmp	al,46
	je	ejva1
	cmp	al,30h
	jb	palia
	cmp	al,39h
	ja	palia
	mov	buffers[bx],al
	mov	chfiob,al
	mov	dl,al
	call	dosdisp
	jmp	pali1
ejva1:	mov	shmea6,1
ejv:	mov	al,chfioa
	call	dec_bin
	mov	al,chfiob
	call	dec_bin
	ret
apo_evs endp
;
naoxi	proc	near
	mov	bx,44
	mov	dh,21
	mov	dl,17
pll:	call	setcurs
	call	plhktro
	cmp	al,13
	je	rete
	cmp	al,46
	je	rete1
	cmp	al,"T"
	jne	frot2
_tafi2:	mov	shmeat,1
	jmp	rete1
frot2:	cmp	al,"/"
	je	_tafi2
	cmp	al,4fh
	je	oxi
	cmp	al,6fh
	je	oxi
	print	4eh
	mov	buffers[bx],78
	jmp	pll
oxi:	print	4fh
	mov	buffers[bx],79
	jmp	pll
rete1:	mov	shmea6,1
rete:	inc	bx
	ret
naoxi	endp

bbuf	proc	near
	mov	bx,0
	mov	si,arxascii
	cmp	si,BUFASCII
	jb	xese
	mov	dl,7
	call	dosdisp
	mov	asthlh,79
	mov	mastos,1
	ret
xese:	mov	cx,48
jump:	mov	dl,buffers[bx]
	@CHANGESEGM	ds,DATASC
	mov	arxasc[si],dl
	@CHANGESEGM	ds,DATAS1
	inc	si
	inc	bx
	loop	jump
	cmp	shmea5,1
	je	smea51
	add	arxascii,48
smea51: ret
bbuf	endp

prbuf	proc	near
	mov	ah,0
	mov	al,asthlh
	push	ax
	mov	asthlh,23
	mov	ax,selida
	mov	cx,672
	mul	cx
	mov	si,ax
	mov	cx,14
tira:	push	cx
	mov	bx,0
	mov	cx,48
tirb:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[si]
	@CHANGESEGM	ds,DATAS1
	mov	buffers[bx],dl
	inc	si
	inc	bx
	loop	tirb
	push	si
	call	tselid
	pop	si
	pop	cx
	loop	tira
	pop	dx
	mov	asthlh,dl
	ret
prbuf	endp

clr_scr proc	near
	@FILLSCR	" ",70h
	ret
clr_scr endp

setcurs proc	near		;routina toy bios
	push	bx
	push	ax
	mov	ah,02
	mov	bh,00
	int	10h
	pop	ax
	pop	bx
	ret
setcurs endp

plhktro proc	near
	@WAITL
	@UPPERAX
	ret
plhktro endp

dispmhn proc	near
	push	ax
	push	bx
	push	si
	xor	bx,bx
	mov	si,dx
mhn:	mov	dl,[si]
	cmp	dl,0
	je	endmhn
	biosprint
	inc	si
	jmp	mhn
endmhn: pop	si
	pop	bx
	pop	ax
	ret
dispmhn endp

bin_dec proc	near
	push	ax
	push	dx
	push	cx
	push	di
	sub	cx,cx
	xor	di,di
nextdig: push	cx
	mov	ax,dx
	xor	dx,dx
	mov	cx,10
	div	cx
	xchg	ax,dx
	add	al,30h
	mov	cs:ascbuf[di],al
	inc	di
	pop	cx
	inc	cx
	cmp	dx,0
	jnz	nextdig
emptbuf: dec	di
	mov	dl,cs:ascbuf[di]
	call	biosdisp
	mov	cs:ascbuf[di],0
	loop	emptbuf
	pop	di
	pop	cx
	pop	dx
	pop	ax
	ret
ascbuf	db	10 dup(0)
bin_dec endp

dec_bin proc	near
	push	ax
	push	dx
	push	cx
	push	bx
	sub	al,30h		;	 mov	al,chfioa
	jl	exit99		;	 call	dec_bin
	cmp	al,9		;	 mov	al,chfiob
	jg	exit99		;	 call	dec_bin
	cbw			;	 to apotelesma sthn [bin]
	xchg	ax,bin
	mov	cx,10
	mul	cx
	xchg	ax,bin
	add	bin,ax
exit99:
	pop	bx
	pop	cx
	pop	dx
	pop	ax
	ret
dec_bin endp

apou2	proc	near
	mov	cx,48
	mov	bx,0
edvc:	mov	dl,buffers[bx]
	mov	buffer[bx],dl
	inc	bx
	loop	edvc
	ret
apou2	endp

apou3	proc	near
	mov	cx,48
	mov	bx,0
edvd:	mov	dl,buffer[bx]
	mov	buffers[bx],dl
	inc	bx
	loop	edvd
	ret
apou3	endp

predit	proc	near
	push	ax
	mov	bx,ax
	mov	dh,0
	mov	dl,18
	call	setcurs
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	tchar
	inc	dh
	mov	cx,13
pred2:	push	cx
	inc	dh
	cmp	dh,5
	je	incr1
	cmp	dh,9
	je	incr1
	cmp	dh,13
	je	incr1
	mov	dl,17
	mov	cx,3
	jmp	pred1
incr1:	inc	dh
	mov	dl,17
	mov	cx,3
pred1:	call	setcurs
	push	dx
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	tchar
	pop	dx
	inc	dl
	loop	pred1
	pop	cx
	loop	pred2
	inc	dh
	inc	dh
	sub	dl,3
	call	setcurs
	inc	dl
	push	dx
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	tchar
	pop	dx
	call	setcurs
	inc	dh
	dec	dl
	push	dx
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	tchar
	pop	dx
	call	setcurs
	inc	dl
	push	dx
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	tchar
	pop	dx
	call	setcurs
	inc	dh
	dec	dl
	push	dx
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	tchar
	pop	dx
	call	setcurs
	inc	dh
	inc	dh
	push	dx
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	tchar
	pop	dx
	call	setcurs
	inc	dl
	push	dx
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	tchar
	pop	dx
	call	setcurs
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+1]
	@CHANGESEGM	ds,DATAS1
	cmp	al,1
	jne	b7
	mov	dl," "
	call	biosdisp
	jmp	b8
b7:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	tchar
b8:	pop	ax
	ret
predit	endp

bbuffer proc	near
	mov	si,ax
	mov	bx,0
	mov	cx,48
lopa:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[si]
	@CHANGESEGM	ds,DATAS1
	mov	buffers[bx],dl
	inc	bx
	inc	si
	loop	lopa
	ret
bbuffer endp

pintaj	proc	near
	@PUSH
	mov	bx,47
	xor	si,si
	mov	ah,0
pint2:	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	al,1
	jbe	pint3
	cmp	al,ah
	jne	pint1
pint3:	add	bx,48
	cmp	bx,arxascii
	jbe	pint2
	@POP
	ret

pint1:	xor	dx,dx
	mov	dl,al
	mov	di,dx
	dec	di
	dec	di
	cmp	pinak2[di],"*"
	jne	pint3
	mov	ah,al
	mov	elepin[si],al
	inc	si
	jmp	pint3
pintaj	endp

tajinom proc	near
	mov	ax,arxascii
	cmp	ax,49
	jb	yptaj
	xor	dx,dx
	mov	cx,48
	div	cx
	dec	ax
	mov	tajin,ax
taji1:	mov	bx,47
	mov	klitaj,0
	mov	cx,tajin
taji2:	@CHANGESEGM	ds,DATASC
	mov	ah,arxasc[bx]
	add	bx,48
	mov	al,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	al,ah
	jb	taji3
taji7:	inc	klitaj
	loop	taji2
	dec	tajin
	cmp	tajin,0
	jne	taji1
yptaj:	call	pintaj
	ret
;
taji3:	push	bx
	push	cx
	sub	bx,95
	mov	cx,48
	mov	si,0
taji4:	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	mov	buffers[si],al
	inc	bx
	inc	si
	loop	taji4
	mov	si,bx
	sub	bx,48
	@CHANGESEGM	ds,DATASC
	mov	cx,48
taji5:	mov	al,arxasc[si]
	mov	arxasc[bx],al
	inc	si
	inc	bx
	loop	taji5
	@CHANGESEGM	ds,DATAS1
	mov	si,0
	mov	cx,48
taji6:	mov	al,buffers[si]
	@CHANGESEGM	ds,DATASC
	mov	arxasc[bx],al
	@CHANGESEGM	ds,DATAS1
	inc	si
	inc	bx
	loop	taji6
	mov	bx,klitaj
	@CHANGESEGM	ds,DATASC
	mov	dl,klioro[bx]
	mov	dh,klioro[bx+1]
	mov	klioro[bx],dh
	mov	klioro[bx+1],dl
	@CHANGESEGM	ds,DATAS1
	pop	cx
	pop	bx
	jmp	taji7
tajinom endp

xarakt	proc	near
	mov	buffers[0],al
	mov	bx,0
xar1:	mov	dl,leonid[bx]
	cmp	dl,0
	je	xar99
	cmp	al,dl
	je	xar2
	add	bx,14
	jmp	xar1
xar99:	ret
xar2:	inc	bx
	mov	si,2
	mov	cx,13
	mov	dh,2
xar4:	mov	dl,18
	cmp	dh,5
	je	xari
	cmp	dh,9
	je	xari
	cmp	dh,13
	je	xari
	jmp	xar3
xari:	inc	dh
xar3:	call	setcurs
	mov	dl,leonid[bx]
	call	tchar
	mov	buffers[si],dl
	add	si,3
	inc	dh
	loop	xar4
	ret
xarakt	endp

asteri	proc	near
	mov	dh,2
	mov	dl,17
	mov	bx,1
	mov	cx,13
ast2:	call	setcurs
	print	42
	mov	buffers[bx],42
	add	bx,3
	inc	dh
	cmp	dh,5
	je	ast1
	cmp	dh,9
	je	ast1
	cmp	dh,13
	je	ast1
ast3:	loop	ast2
	ret
ast1:	inc	dh
	jmp	ast3
asteri	endp

edast	proc	near
	mov	bx,1
	mov	dh,2
	mov	dl,17
ast8:	call	setcurs
	call	getkey
	cmp	al,0
	jne	kerea
	cmp	ah,48h
	jne	kere1
_panc:	dec	dh
	cmp	bx,2
	jbe	notelec
	sub	bx,3
	jmp	telecame
notelec:
	mov	bx,37
	mov	dh,17
	jmp	telecame
kere1:	cmp	ah,50h
	je	ast6
kerea:	cmp	al,"+"
	je	_panc
	cmp	al,13
	je	ast6
	cmp	al,42
	je	ast7
	cmp	al,"/"
	je	_tafw
	cmp	al,"T"
	jne	krokd
_tafw:	mov	shmeat,1
	jmp	ast12
krokd:	cmp	al,8
	je	ast11
	cmp	al,81
	je	ast11
	cmp	al,"-"
	je	ast11
	cmp	al,46
	je	ast12
	jmp	ast8
ast6:	inc	dh
	add	bx,3
	cmp	dh,5
	je	ast9
	cmp	dh,9
	je	ast9
	cmp	dh,13
	je	ast9
	cmp	dh,18
	je	ast10
	jmp	ast8
ast9:	inc	dh
	jmp	ast8
ast10:	mov	dh,2
	mov	bx,1
	jmp	ast8
ast7:	print	42
	mov	buffers[bx],42
	jmp	ast8
ast11:	print	32
	mov	buffers[bx],32
	jmp	ast8
ast12:	ret
telecame:
	cmp	dh,5
	je	ast9w
	cmp	dh,9
	je	ast9w
	cmp	dh,13
	je	ast9w
	jmp	ast8
ast9w:	dec	dh
	jmp	ast8
edast	endp

capo	proc	near
	cmp	shmeat,1
	jne	shmt
	ret
shmt:	mov	bx,44
	mov	grammh,21
	mov	sthlh,17
	call	naoxi
	cmp	buffers[44],32
	jne	pll56
	mov	buffers[44],78
pll56:	mov	shmea6,0
	cmp	shmeat,1
	jne	capo4
	ret
capo4:	mov	bx,45
	mov	grammh,23
	call	apo_evs
	cmp	buffers[45],32
	jne	capo8
	mov	buffers[45],49
	mov	buffers[47],1
	mov	shmea6,0
	ret
capo8:	mov	shmea6,0
	mov	ax,bin
;-------------------------------- klidoma
	cmp	ax,0
	je	capo4
	cmp	al,35
	ja	capo4
	mov	di,ax
	dec	di
	dec	di
	@CHANGESEGM	ds,DATASC
	mov	dl,klioma[di]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	je	capo4
	mov	buffers[47],al
	ret
capo	endp

omades	proc	near
	call	clr_scr
	mov	bx,arxascii
	cmp	bx,0
	je	kratis
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx-48]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,"M"
	jne	kratis
	xor	dx,dx
	mov	dl,60
	call	setcurs
	lea	dx,mesfor12
	call	dispmhn
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx-6]
	mov	al,arxasc[bx-5]
	@CHANGESEGM	ds,DATAS1
	push	ax
	call	biosdisp
	pop	ax
	mov	dl,al
	call	biosdisp
kratis: xor	dx,dx
	call	setcurs
	lea	dx,omadea
	call	dispmhn
	mov	cx,80
	mov	dh,1
	mov	dl,0
	call	setcurs
omo2:	print	223
	loop	omo2
	mov	dh,2
	mov	dl,0
	call	setcurs
	lea	dx,mhnplhr
	call	dispmhn
	mov	cx,17
	mov	dh,3
omo1:	mov	dl,0
	push	dx
	call	setcurs
	lea	dx,omada
	call	dispmhn
	pop	dx
	inc	dh
	loop	omo1
	mov	dh,21
	mov	dl,0
	call	setcurs
	lea	dx,omadeb
	call	dispmhn
	mov	cx,80
	mov	dh,22
	mov	dl,0
	call	setcurs
omo3:	print	223
	loop	omo3
	mov	cx,4
	mov	bx,0
	mov	dh,23
	mov	dl,0
omo5:	push	dx
	call	setcurs
	lea	dx,omadb
	call	dispmhn
	pop	dx
	add	dl,8
	call	setcurs
	push	dx
	mov	dl,bl
	add	dl,65
	call	dosdisp
	inc	bx
	pop	dx
	add	dl,32
	cmp	dl,78
	ja	omo4
omo6:	loop	omo5
	jmp	omo7
omo4:	inc	dh
	mov	dl,0
	jmp	omo6
omo7:	ret
omades	endp

metrima proc	near
	mov	cx,36
	mov	bx,0
kolos:	mov	pinak1[bx],0
	add	bx,6
	loop	kolos
	mov	bx,arxascii
	@CHANGESEGM	ds,DATASC
	mov	arxasc[bx+47],99
	@CHANGESEGM	ds,DATAS1
	mov	bx,47
	mov	synor,0
metr5:	mov	ayjhse,0
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,99
	jne	metr11
	jmp	metr10
metr11: cmp	ayjhse,0
	jne	metr3
	mov	ayjhse,1
metr3:	add	bx,48
	@CHANGESEGM	ds,DATASC
	mov	dh,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	dh,dl
	jne	metr4
	inc	ayjhse
	jmp	metr3
metr4:	xor	ax,ax
	mov	al,dl
	mov	cx,6
	mul	cx
	mov	si,ax
	mov	dx,ayjhse
	add	synor,dx
	mov	pinak1[si],dx
	jmp	metr5
metr10: mov	cx,34
	mov	bx,12
mitr2:	mov	dx,pinak1[bx]
	cmp	dx,0
	je	mitr1
mitr3:	add	bx,6
	loop	mitr2
	ret
mitr1:	mov	pinak1[bx+2],0
	mov	pinak1[bx+4],0
	mov	ax,bx
	xor	dx,dx
	push	cx
	mov	cx,6
	div	cx
	pop	cx
	mov	si,ax
	sub	si,2
	mov	pinak2[si],42
	jmp	mitr3
metrima endp

edomad	proc	near
	mov	shmea13,0
edom34: mov	cx,34
	mov	bx,12
edom2:	mov	dx,pinak1[bx]
	cmp	dx,0
	jne	edom1
edom5:	add	bx,6
	loop	edom2
	cmp	shmea13,1
	je	trtr
	call	edtomr1
	call	plhktro
	ret
trtr:	jmp	edom34
;------------------------------- klidoma
edom1:	mov	ax,bx
	xor	dx,dx
	push	cx
	mov	cx,6
	div	cx
	pop	cx
	dec	ax
	dec	ax
	mov	si,ax
	@CHANGESEGM	ds,DATASC
	mov	al,klioma[si]
	@CHANGESEGM	ds,DATAS1
	cmp	al,1
	je	edom5
	mov	shmea13,1
	push	cx
	mov	ax,bx
	xor	dx,dx
	mov	pinak,ax
	mov	cx,6
	div	cx
	xor	dx,dx
	mov	cx,2
	div	cx
	cmp	dx,0
	jne	edom3
	mov	dh,al
	add	dh,2
	mov	dl,24
edom4:	mov	grammh,dh
	mov	sthlh,dl
	call	setcurs
	call	editq
	pop	cx
	cmp	shmea12,2
	je	edom33
	jmp	edom5
edom3:	mov	dl,64
	mov	dh,al
	add	dh,2
	jmp	edom4
edom33: mov	shmea12,0
	ret
edomad	endp

editq	proc	near
	push	bx
	mov	bx,0
	mov	si,pinak
	add	si,2
	mov	shmea9,0
	mov	dh,grammh
	mov	dl,sthlh
	push	dx
edq5:	call	cersor
edq13:	call	plhktro
	cmp	al,46
	jne	edq1
	call	edq8
	pop	dx
	pop	bx
	ret
edq1:	cmp	al,84
	jne	edq2
	call	edq8
	pop	dx
	pop	bx
	mov	shmea12,2
	ret
edq2:	cmp	al,13
	jne	edq4
	mov	bx,0
	call	edq8
edq7:	cmp	shmea9,0
	jne	edq3
	add	sthlh,8
	pop	dx
	mov	dl,sthlh
	push	dx
	add	si,2
	mov	shmea9,1
	jmp	edq5
edq3:	sub	sthlh,8
	pop	dx
	mov	dl,sthlh
	push	dx
	sub	si,2
	mov	shmea9,0
	jmp	edq5
edq4:	cmp	al,48
	jb	edq6
	cmp	al,57
	ja	edq6
	mov	shmea12,1
	mov	dl,al
	call	dosdisp
	mov	chfioc[bx],dl
	pop	dx
	inc	dl
	push	dx
	cmp	bx,0
	je	edq11
	cmp	bx,1
	je	edq12
edq9:	inc	bx
	cmp	bx,3
	jne	edq6
	mov	bx,0
	pop	dx
	mov	dl,sthlh
	push	dx
edq6:	call	setcurs
	jmp	edq13
edq11:	mov	chfioc[1],32
	print	32
edq12:	mov	chfioc[2],32
	print	32
	jmp	edq9
edq8:	cmp	shmea12,1
	jne	edq15
	mov	bin,0
	mov	al,chfioc[0]
	call	dec_bin
	mov	al,chfioc[1]
	call	dec_bin
	mov	al,chfioc[2]
	call	dec_bin
	mov	ax,bin
	mov	pinak1[si],ax
	mov	shmea12,0
edq15:	ret
editq	endp

editr	proc	near
	mov	shmea13,0
edtr42: mov	si,0
	mov	cx,34
	mov	bx,12
edtr21: cmp	pinak2[si],80
	je	edtr25
	mov	dx,pinak1[bx]
	cmp	dx,0
	jne	edtr22
edtr25: add	bx,6
	inc	si
	loop	edtr21
	cmp	shmea13,1
	je	rtrt
	ret
rtrt:	jmp	edtr42
;-------------------------------- klidoma
edtr22: @CHANGESEGM	ds,DATASC
	mov	dl,klioma[si]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	je	edtr25
stor1:	mov	shmea13,1
	push	cx
	mov	ax,bx
	xor	dx,dx
	mov	cx,6
	div	cx
	xor	dx,dx
	mov	cx,2
	div	cx
	cmp	dx,0
	jne	edtr23
	mov	dh,al
	add	dh,2
	mov	dl,0
	jmp	edtr28
edtr23: mov	dl,40
	mov	dh,al
	add	dh,2
edtr28: push	dx
edtr24: pop	dx
	call	setcurs
	push	dx
	call	plhktro
	cmp	al,81
	je	edtr2
	cmp	al,8
	je	edtr2
	cmp	al,13
	jne	edtr31
	pop	dx
	pop	cx
	jmp	edtr25
edtr31: cmp	al,46
	jne	edtr32
	pop	dx
	pop	cx
	jmp	edtr25
edtr32: cmp	al,84
	jne	edtr4
	pop	dx
	pop	cx
	ret
edtr4:	cmp	al,65
	jb	edtr1
	cmp	al,69
	ja	edtr1
	push	ax
	xor	ah,ah
	sub	ax,65
	mov	di,ax
	pop	ax
	@CHANGESEGM	ds,DATASC
	mov	dl,kliype[di]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	je	edtr24
	mov	dl,al
	call	dosdisp
	mov	pinak2[si],al
edtr1:	jmp	edtr24
edtr2:	print	42
	mov	pinak2[si],42
	jmp	edtr24
editr	endp

editomr proc	near
	mov	shmea13,0
	mov	dh,65
edtm3:	mov	ayjhse,0
	mov	cx,34
	mov	bx,0
edtm2:	mov	dl,pinak2[bx]
	cmp	dl,80
	je	edtm4
	cmp	dl,dh
	jne	edtm4
	inc	ayjhse
edtm4:	inc	bx
	loop	edtm2
	push	dx
	sub	dh,65
	mov	al,dh
	mov	dl,3
	mul	dl
	mov	ah,0
	mov	si,ax
	mov	dx,ayjhse
	mov	pinak3[si],dl
	pop	dx
	inc	dh
	cmp	dh,69
	jb	edtm3
	jmp	edtm5
edtm5:	mov	cx,4
	mov	bx,0
edrmt:	cmp	pinak3[bx],0
	je	edtrm
edtmr:	add	bx,3
	loop	edrmt
	ret
edtrm:	mov	pinak3[bx+1],0
	mov	pinak3[bx+2],0
	jmp	edtmr
editomr endp

edtomr1 proc	near
	mov	shmea13,0
	mov	cx,12
	mov	dh,23
	mov	dl,17
	mov	bx,0
edtm51: call	setcurs
	push	dx
	cmp	dl,40
	jb	edtm59
	sub	dl,40
edtm59: cmp	dl,17
	jne	edtm52
	pop	dx
	dec	dl
	push	dx
edtm52: mov	dl,pinak3[bx]
	mov	dh,0
	call	bin_dec
	mov	dl,32
	call	dosdisp
	inc	bx
	pop	dx
	add	dl,8
	cmp	dl,32
	ja	edtm61
	jmp	edtm62
edtm61: cmp	dl,41
	jb	edtm54
edtm62: cmp	dl,72
	ja	edtm55
edtm53: loop	edtm51
	ret
edtm54: mov	dl,57
	jmp	edtm53
edtm55: mov	dl,17
	mov	dh,24
	jmp	edtm53
edtomr1 endp

editot	proc	near
	mov	cx,4
	mov	bx,0
eddtd:	cmp	pinak3[bx],0
	jne	eddtt
eddtdr: add	bx,3
	loop	eddtd
	ret
;------------------------------ klidoma
eddtt:	mov	ax,bx
	xor	dx,dx
	push	cx
	mov	cx,3
	div	cx
	pop	cx
	mov	si,ax
	@CHANGESEGM	ds,DATASC
	mov	dl,kliype[si]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	je	eddtdr
	mov	shmea13,0
edttq:	@CHANGESEGM	ds,DATASC
	mov	dl,kliype[0]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	je	dl1
	mov	dh,23
	mov	dl,24
	mov	bx,1
	call	edtti
	cmp	shmea13,1
	je	tois
dl1:	@CHANGESEGM	ds,DATASC
	mov	dl,kliype[1]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	je	dl2
	mov	dh,23
	mov	dl,64
	mov	bx,4
	call	edtti
	cmp	shmea13,1
	je	tois
dl2:	@CHANGESEGM	ds,DATASC
	mov	dl,kliype[2]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	je	dl3
	mov	dh,24
	mov	dl,24
	mov	bx,7
	call	edtti
	cmp	shmea13,1
	je	tois
dl3:	@CHANGESEGM	ds,DATASC
	mov	dl,kliype[3]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	je	dl4
	mov	dh,24
	mov	dl,64
	mov	bx,10
	call	edtti
	cmp	shmea13,1
	je	tois
	jmp	edttq
dl4:
tois:	mov	shmea13,0
	ret
edtti:	mov	si,0
	call	setcurs
	push	dx
edtt1:	call	plhktro
	cmp	al,84
	jne	edtt3
	pop	dx
	mov	shmea13,1
	call	edttk
	ret
edtt3:	cmp	al,13
	je	edtt4
	cmp	al,46
	je	edtt5
	cmp	al,48
	jb	edtt1
	cmp	al,57
	ja	edtt1
	mov	shmea12,1
	mov	dl,al
	call	dosdisp
	cmp	si,0
	je	edtt6
	cmp	si,1
	je	edtt7
edtt6:	print	32
	print	8
	mov	chfioc[0],dl
	mov	chfioc[1],32
	inc	si
	jmp	edtt1
edtt7:	mov	chfioc[1],dl
	dec	si
	print	8
	print	8
	jmp	edtt1
edtt5:	pop	dx
	call	edttk
	ret
edtt4:	pop	dx
	call	edttk
	cmp	dl,40
	ja	edtt8
	cmp	dl,24
	je	edtt9
	mov	dl,24
	dec	bx
	jmp	edtti
edtt9:	mov	dl,32
	inc	bx
	jmp	edtti
edtt8:	cmp	dl,64
	je	edtt10
	mov	dl,64
	dec	bx
	jmp	edtti
edtt10: mov	dl,72
	inc	bx
	jmp	edtti
edttk:	cmp	shmea12,1
	je	edtt11
	ret
edtt11: push	dx
	push	bx
	mov	bin,0
	mov	al,chfioc[0]
	call	dec_bin
	mov	al,chfioc[1]
	call	dec_bin
	mov	dx,bin
	pop	bx
	mov	pinak3[bx],dl
	pop	dx
	mov	shmea12,0
	ret
editot	endp

getkey	proc	near
	@WAITL
	@UPPERAX
	ret
getkey	endp

metrpr	proc	near
metr6:	mov	dh,0
	mov	dl,13
	call	setcurs
	mov	dx,synor
	mov	ax,pinak1
	sub	dx,ax
	call	bin_dec
	mov	dh,2
	mov	dl,16
	call	setcurs
	mov	dx,pinak1[0]
	cmp	dx,0
	je	metr15
	call	bin_dec
metr15: mov	dh,2
	mov	dl,56
	call	setcurs
	mov	dx,pinak1[6]
	cmp	dx,0
	je	metr14
	call	bin_dec
	mov	dh,2
	mov	dl,48
	call	setcurs
	print	49
metr14: mov	cx,34
	mov	bx,2
	mov	dh,3
	mov	dl,16
metr8:	call	setcurs
	push	dx
	mov	al,bl
	mov	ah,0
	mov	dl,6
	mul	dl
	mov	si,ax
	mov	dx,pinak1[si]
	cmp	dx,0
	je	metr13
	call	bin_dec
	pop	dx
	push	dx
	add	dl,8
	call	setcurs
	mov	dx,pinak1[si+2]
	call	bin_dec
	pop	dx
	push	dx
	add	dl,16
	call	setcurs
	mov	dx,pinak1[si+4]
	call	bin_dec
	pop	dx
	push	dx
	sub	dl,8
	call	setcurs
	mov	dl,bl
	mov	dh,0
	call	bin_dec
	pop	dx
	push	dx
	sub	dl,16
	call	setcurs
	mov	dl,pinak2[bx-2]
	push	ax
	call	dosdisp
	pop	ax
metr13: pop	dx
	add	dl,40
	cmp	dl,80
	ja	metr7
metr9:	inc	bx
	loop	metr8
	jmp	metr10
metr7:	mov	dl,16
	inc	dh
	jmp	metr9
metrpr	endp
;
dialogi_deltiou	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@ZEROBBUF	epig,13
	@ZEROBBUF	epitixies,22
;;;;;;;;;;;;;;;;	mov	exosuper13,0
	cmp	deltio,0
	je	dildqw
	@LADDN	mexri_tora,deltio
	@INCL	ar_deltiou

	cmp	deltio,11
	jbe	dild1
	call	dialogi_axb
	jmp	dild2

dild1:	call	dialogi_aplo

dild2:
;*****************************************
	cmp	epig[0],0
	je	sup13no
	mov	al,dialsuper13
	cmp	al,simio_super13
	jne	sup13no
;;;;;;;;;;;;;;;;;;;;	mov	exosuper13,1
sup13no:
;*****************************************

	call	dialogi_diax
dildqw:	call	clr_buf24
	@POP
	ret
dialogi_deltiou	endp
;
dialogi_diax	proc	near
	@PUSH
	mov	cx,3
	mov	bx,0
dild7:	cmp	epig[bx],0
	jne	dild8
	inc	bx
	loop	dild7
	call	dialogi_geniki
	call	dialogi_ekt_alla
	jmp	dild9

dild8:	cmp	dial_xarti,0
	je	isouon
;;	call	dialogi2xarti
	jmp	isxart
isouon:	call	dialogi_ekt_deltia
isxart:	call	dialogi_geniki
	call	dialogi_ekt_alla

dild9:	@POP
	ret
dialogi_diax	endp
;
dialogi_geniki	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	cx,14
	xor	bx,bx
	xor	si,si
dilge1: xor	dx,dx
	mov	dl,epig[bx]
	add	sepig[si],dx
	inc	bx
	add	si,2
	loop	dilge1
	@POP
	ret
dialogi_geniki	endp
;
dialogi_ekt_deltia	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	cmp	clr_win,0
	je	dilek2
	@CLSWIND	wclr_dial
	mov	clr_win,0

dilek2:	@SELECTWIND	wdial1
	@LTOAN	ar_deltiou,strbuf
	@WPRINT	4,grammh,strbuf

	xor	ax,ax
	mov	al,epig[0]
	@ITOA	strbuf,4
	@WPRINT	14,grammh,strbuf
	cmp	ax,0
	je	supida
;********************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;	cmp	exosuper13,1
;	jne	supida
;	@WPRINTCH	12,grammh,"S"
;********************************************
supida:	xor	ax,ax
	mov	al,epig[1]
	@ITOA	strbuf,4
	@WPRINT	21,grammh,strbuf

	xor	ax,ax
	mov	al,epig[2]
	@ITOA	strbuf,4
	@WPRINT	28,grammh,strbuf
	cmp	epig[0],0
	je	no13ari
	@INVERSE	1,grammh,34
	call	mysound
no13ari:
	inc	grammh
	cmp	grammh,16
	jb	dilek3
	@WPRINT	8,17,mpatapl
	
	@WAITL
	mov	grammh,3
	mov	clr_win,1
	@FILLSTR	strbuf," ",34
	@WPRINT	1,17,strbuf
	@WPRINT	11,17,mypolog

dilek3:	@POP
	ret
dialogi_ekt_deltia	endp
;
mysound	proc	near
	@PUSH
	mov	cx,10
sond1:	push	cx
	mov	cx,400
	mov	ax,cx
sond:	@SOUND	3,ax
	dec	ax
	loop	sond
	pop	cx
	loop	sond1
sond3:	@POP
	ret
mysound	endp
;
dialogi_ekt_alla	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@SELECTWIND	wdial2
	@LTOAN	ar_deltiou,strbuf
	@WPRINT	14,2,strbuf
	@LTOAN	mexri_tora,strbuf
	@WPRINT	14,3,strbuf
	mov	ax,sepig[0]
	@ITOA	strbuf
	@WPRINT	14,7,strbuf
	mov	ax,sepig[2]
	@ITOA	strbuf
	@WPRINT	14,8,strbuf
	mov	ax,sepig[4]
	@ITOA	strbuf
	@WPRINT	14,9,strbuf
	mov	ax,sepig[6]
	@ITOA	strbuf
	@WPRINT	14,10,strbuf
	mov	ax,sepig[8]
	@ITOA	strbuf
	@WPRINT	14,11,strbuf
	mov	ax,sepig[10]
	@ITOA	strbuf
	@WPRINT	14,12,strbuf
	mov	ax,sepig[12]
	@ITOA	strbuf
	@WPRINT	14,13,strbuf
	mov	ax,sepig[14]
	@ITOA	strbuf
	@WPRINT	14,14,strbuf
	mov	ax,sepig[16]
	@ITOA	strbuf
	@WPRINT	14,15,strbuf
;********************************************
;;;;;;;;;;;;;;;;;;;;;;	cmp	exosuper13,1
;	jne	supida1
;	@WPRINTCH	2,7,"S"
;	@WPRINTCH	2,8,"U"
;	@WPRINTCH	2,9,"P"
;	@WPRINTCH	2,10,"E"
;	@WPRINTCH	2,11,"R"
;	@WPRINTCH	2,12,"1"
;	@WPRINTCH	2,13,"3"
;********************************************
supida1:
	@POP
	ret
dialogi_ekt_alla	endp
;
dialogi_aplo	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	xor	si,si
	xor	di,di

	mov	cx,11
dilap3:	push	cx
	xor	bx,bx
	mov	cx,13
dilap2:	mov	al,buf24[si][bx]
	cmp	al,0
	je	dilap1
	cmp	al," "
	je	dilap1
	cmp	pindial[bx],0
	je	dilap0
	cmp	pindial[bx],al
	jne	dilap1
dilap0:	inc	epitixies[di]
dilap1:	inc	bx
	loop	dilap2
	pop	cx
	add	si,13
	inc	di
	loop	dilap3
	mov	cx,11
	xor	si,si
dilap4:	cmp	epitixies[si],5
	jb	dilap5
	xor	dx,dx
	mov	dl,epitixies[si]
	mov	bx,13
	sub	bx,dx
	inc	epig[bx]
dilap5:	inc	si
	loop	dilap4
	@POP
	ret
dialogi_aplo	endp
;
dialogi_axb	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	mov	cx,axb_am
	xor	di,di
	xor	si,si
dilab3:	push	cx
	xor	bx,bx
	xor	cx,cx
	mov	cl,axbuesi
dilab2:	mov	al,buf24[si][bx]
	cmp	pindial[bx],0
	je	incit
	cmp	pindial[bx],al
	jne	dilab1
incit:	inc	epitixies[di]
dilab1:	inc	bx
	loop	dilab2
	pop	cx
	add	si,13
	inc	di
	loop	dilab3

	mov	ax,axb_am
	mov	cx,13
	mul	cx
	mov	si,ax

	mov	cx,axb_bm
	mov	di,12
	xor	bx,bx
	mov	bl,axbuesi

dilab8:	push	cx
	push	bx
	mov	cx,13
	sub	cx,bx

dilab6:	mov	al,buf24[si][bx]
	cmp	pindial[bx],0
	je	incit1
	cmp	pindial[bx],al
	jne	dilab5
incit1:	inc	epitixies[di]
dilab5:	inc	bx
	loop	dilab6

	pop	bx
	pop	cx
	add	si,13
	inc	di
	loop	dilab8

	mov	si,12
	mov	cx,axb_bm
dlab13:	push	cx
	xor	di,di
	mov	cx,axb_am
dlab12:	xor	ax,ax
	mov	al,epitixies[di]
	add	al,epitixies[si]
	cmp	ax,5
	jb	dlab11
	cmp	ax,13
	jbe	dlab14

	mov	ax,1200
	call	fatal_error

dlab14:	mov	bx,13
	sub	bx,ax
	inc	epig[bx]
dlab11:	inc	di
	loop	dlab12
	pop	cx
	inc	si
	loop	dlab13
	@POP
	ret
dialogi_axb	endp
;
eisagvgh_dialoghs	 proc	near
	mov	cx,13
	mov	bx,3
bobi:	mov	buffers[bx],0
	add	bx,3
	loop	bobi
	mov	dh,1
	mov	dl,19
	mov	cx,13
	mov	bx,0
epred2: inc	dh
	cmp	dh,5
	je	eincr1
	cmp	dh,9
	je	eincr1
	cmp	dh,13
	je	eincr1
	jmp	epred1
eincr1: inc	dh
epred1: call	setcurs
	push	dx
	mov	dl,pindial[bx]
	call	apokod1
	call	biosdisp
	pop	dx
	inc	bx
	loop	epred2
	mov	shmea1,1
	mov	shmea3,0
	mov	shmea8,1
	call	editor1
	mov	shmea8,0
	mov	cx,13
	mov	bx,3
	mov	di,0
edvpera:
	mov	dl,buffers[bx]
	cmp	dl,0
	je	moyz
	call	apokod
	mov	pindial[di],dl
moyz:	add	bx,3
	inc	di
	loop	edvpera
	call	kauar
	mov	cx,48
	mov	bx,0
agg:	mov	buffers[bx],32
	inc	bx
	loop	agg
	ret
apokod: cmp	dl,"1"
	je	ena
	cmp	dl,"2"
	je	diplo
	cmp	dl,"X"
	je	xire
	mov	dl,0
	ret
ena:	mov	dl,1
	ret
diplo:	mov	dl,3
	ret
xire:	mov	dl,2
	ret
apokod1:
	cmp	dl,1
	je	aena
	cmp	dl,2
	je	axi
	cmp	dl,3
	je	adio
	mov	dl," "
	ret
aena:	mov	dl,"1"
	ret
adio:	mov	dl,"2"
	ret
axi:	mov	dl,"X"
	ret
eisagvgh_dialoghs	 endp
;
posa_shmeia	proc	near
	cmp	buffers[40]," "
	jne	p_ret
	cmp	buffers[42]," "
	jne	p_ret
	jmp	p_ok
p_ret:	ret
p_ok:	cmp	buffers[0],"W"
	je	p_1
	cmp	buffers[0],"X"
	je	p_1
	cmp	buffers[0],"Y"
	je	p_1
	jmp	p_allo
p_1:	push	ax
	push	bx
	push	cx
	mov	cx,13
	mov	bx,1
	xor	ax,ax
p_next:	cmp	buffers[bx]," "
	je	p_oxi
	inc	ax
p_oxi:	add	bx,3
	loop	p_next
p_ekt:	mov	buffers[40],"0"
	mov	buffers[41]," "
	mov	sthlh,17
	mov	grammh,19
	call	cersor
	mov	dl,"0"
	call	biosdisp
	mov	dl," "
	call	biosdisp
	mov	cl,10
	div	cl
	cmp	al,0
	jne	exei_prvto
	add	ah,30h
	mov	buffers[42],ah
	mov	buffers[43]," "
	jmp	kokoko
exei_prvto:
	add	al,30h
	mov	buffers[42],al
	add	ah,30h
	mov	buffers[43],ah
kokoko:	inc	grammh
	call	cersor
	mov	dl,buffers[42]
	call	biosdisp
	mov	dl,buffers[43]
	call	biosdisp
	pop	cx
	pop	bx
	pop	ax
	ret
p_allo:	ret
	push	ax
	push	bx
	push	cx
	cmp	buffers[0],"Q"
	jne	p_2
	mov	ax,6
	jmp	p_ekt
p_2:	cmp	buffers[0],"P"
	je	p_3
	cmp	buffers[0],"H"
	je	p_3
	cmp	buffers[0],"B"
	je	p_3
	cmp	buffers[0],"I"
	je	p_3
	jmp	p_4
p_3:	mov	ax,12
	jmp	p_ekt
p_4:	cmp	buffers[0],"A"
	je	p_5
	cmp	buffers[0],"S"
	je	p_5
	cmp	buffers[0],"D"
	je	p_5
	jmp	p_6
p_5:	mov	ax,26
	jmp	p_ekt
p_6:	cmp	buffers[0],"R"
	je	p_7
	cmp	buffers[0],"O"
	je	p_7
	cmp	buffers[0],"U"
	je	p_7
	cmp	buffers[0],"4"
	je	p_7
	jmp	p_8
p_7:	mov	ax,7
	jmp	p_ekt
p_8:	pop	cx
	pop	bx
	pop	ax
	ret	
posa_shmeia	endp
;
screen	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@SELECTWI	0
	@FILLSCR	" ",07h

	mov	ax,1
	mov	cx,13
	mov	dh,2
	mov	bx,0
tsonta:	cmp	bx,3
	jb	okep
	cmp	cx,3
	jb	okep
	mov	bx,0
	inc	dh
okep:	@ITOA	strbuf,2
	@WPRINT	13,dh,strbuf
	inc	dh
	inc	ax
	inc	bx
	loop	tsonta

	@WPRINT	7,19,mhnhm
	@WPRINT	7,20,mhnhm[4]
	@WPRINT	7,21,mhnhm[8]
	@WPRINT	5,23,mhnhm[12]

	call	putsthles

	mov	cx,78	;grammes
	mov	dx,0

edv:	@WPRINTCH	dl,1,205
	cmp	dl,13
	jb	p198
	@WPRINTCH	dl,5,196
	@WPRINTCH	dl,9,196
	@WPRINTCH	dl,13,196
p198:	@WPRINTCH	dl,18,196
	@WPRINTCH	dl,22,196
	inc	dl
	loop	edv

	mov	cx,24	;sthles
	mov	dh,0
edva:	@WPRINTCH	3,dh,179
	@WPRINTCH	15,dh,179
	@WPRINTCH	21,dh,219
	inc	dh
	loop	edva

	mov	sthlh,26
	mov	cx,13
papara: push	cx
	mov	cx,24
papari: mov	dh,cl
	dec	dh
	@WPRINTCH	sthlh,dh,179
	loop	papari
	add	sthlh,4
	pop	cx
	loop	papara

	@WPRINTCH	12,1,209
	mov	cx,16
	mov	dh,2
	mov	dl,1
	mov	bx,0
p179:	push	dx
	@WPRINTCH	1,dh,cprgt0[bx]
	@WPRINTCH	5,dh,cprgt1[bx]
	@WPRINTCH	9,dh,prakt_name[bx]
	@WPRINTCH	12,dh,179
	pop	dx
	inc	dh
	inc	bx
	loop	p179

	@WPRINTCH	12,dh,193
	cmp	memory,1
	jne	lina
	call	grmon
	@POP
	ret
lina:	call	sbmon
	cmp	metraAscii,1
	je	lina01
	@POP
	ret
lina01:	call	grAscii
	@POP
	ret
screen	endp

grAscii	proc	near
	@PUSH
	@TAKEWIND
	push	ax
	@SELECTWI	0
	@WPRINTCH	1,19,"S"
	@WPRINTCH	1,20,"T"
	@WPRINTCH	1,21,"L"
	pop	ax
	@SELECTWI	al
	@POP
	ret
grAscii	endp

stl2ouoni	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	fatal_stack,0
	jne	stou4
	@POP
	ret
stou4:	xor	si,si
	xor	bx,bx
	mov	dl,2
	mov	cx,24
stou2:	push	cx
	mov	dh,4
	mov	cx,13
stou1:	mov	bl,buf24[si]
	cmp	bl,4
	jb	kakala

	mov	ax,1201
	call	fatal_error

kakala:	mov	al,antist[bx]
	@WPRINTCH	dl,dh,al
	inc	dh
	inc	si
	loop	stou1
	pop	cx
	inc	dl
	loop	stou2
	xor	dx,dx
	mov	ax,pointp
	mov	cx,13
	div	cx
	add	cound,ax
	adc	cound,0
	@LTOAN	cound,strbuf
	@WPRINT	2,0,strbuf
	@PLHKTRO
	@UPPERAX
	cmp	al,"T"
	jne	stou3
	mov	sp,fatal_stack
	mov	fatal_stack,0
stou3:	@POP
	ret
stl2ouoni	endp

deltyp	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	deltio,0
	je	isadio
	cmp	dialogi,0
	je	isekti
	call	dialogi_deltiou
isadio:	@POP
	ret

isekti:	@SELECTWIND	wdeltio_axb
	call	clr_standar

	@INCL	ar_deltiou
	@LTOAN	ar_deltiou,strbuf
	@WPRINT	16,17,strbuf

	mov	ax,deltio		;stl deltioy
	@ITOA	strbuf,3
	@WPRINT	16,18,strbuf

	@LADDN	mexri_tora,deltio
	@LTOAN	mexri_tora,strbuf
	@WPRINT	16,19,strbuf
	@LCMPN	ar_deltiou,ardel
	jae	isbr1

	@JUMPONKEY	isbr1
 
 	call	clr_buf24
	@POP
	ret
;**************************************************
isbr1:	mov	grammh,3
	mov	sthlh,4
	mov	bx,0
	mov	cx,13
typ2:	push	cx
	push	bx
	mov	cx,21
typ1:	cmp	buf24[bx],0
	jne	delt91
	add	bx,13
	loop	typ1
	jmp	delt9

delt91: mov	dl,buf24[bx]

delt5:	cmp	buf24[bx],0
	je	delt4
	cmp	dl,buf24[bx]
	jne	delt9
	add	bx,13
	loop	delt5

delt4:	mov	sthlh,2
	pop	bx
	push	bx
	mov	stand[bx],dl
	call	apocode
	mov	al,dl
	@WPRINTCH	sthlh,grammh,al
	jmp	delt7

typ99:	jmp	typ2

delt9:	pop	bx
	push	bx
	mov	cx,21
delt6:	mov	dl,buf24[bx]
	call	apocode
	mov	al,dl
	@WPRINTCH	sthlh,grammh,al
	inc	sthlh
	add	bx,13
	loop	delt6

delt7:	pop	bx
	pop	cx
	inc	bx
	mov	sthlh,4
	inc	grammh
delt21: loop	typ99

	cmp	aytomato_axb,1
	jne	liri
	cmp	protia_prn[0],0
	jne	liri2
	jmp	liri
liri2:	call	dimiourgia_deltiou_axb
;	call	far ptr ektiposi_axb
	jc	liri
	@JUMPONKEY	liri
	@JUMPONKEY	liri

belxi:	jmp	ardel4

liri:	@SETWIND	wdelti
	@CLRPLBUF
	@WAITL
	@UPPERAX
	@DELWIND	wdelti
	cmp	al,"Q"
	jne	noQQQ
	call	dimiourgia_deltiou_axb
;	call	far ptr ektiposi_axb
	jmp	liri

noQQQ:	cmp	al,"P"
	jne	noPPP
	mov	dx,1
	call	far ptr riumisi_ektip
	jmp	liri

noPPP:	cmp	al,"!"
	jne	noDok
	@ZEROBBUF	deltio2prn,500,1 	;41x12=492
	mov	cx,11
	mov	di,450
zdel1:	mov	deltio2prn[di],0
	sub 	di,41
	loop	zdel1
	mov	cx,9
	mov	di,490
zdel2:	mov	deltio2prn[di],0
	sub 	di,41
	loop	zdel2
;	call	far ptr ektiposi_axb
	jmp	liri

noDok:	cmp	al,"A"
	jne	noAAA
	call	pane_deltio
	jmp	liri

noAAA:	cmp	al,"T"
	jne	pri99
	call	clr_buf24
	mov	sp,fatal_stack
	mov	fatal_stack,0
	@POP
	ret
pri99:	cmp	al,"E"
	je	ardel4
	jmp	liri
ardel4:	call	clr_buf24
	@CLSWIND	wclr_axb
	@DELWIND	wdelti
	@POP
	ret
deltyp	endp

dimiourgia_deltiou_axb	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@ZEROBBUF	deltio2prn,500,0 	;12x41
;------------------------------------------------------>ektaktos
	cmp	ektaktos,0
	je	is_no_ektaktos
	mov	deltio2prn[491],1
is_no_ektaktos:
;------------------------------------------------------>super13
	mov	dl,simio_super13
	cmp	dl,"1"
	jne	no_s1
	mov	bx,39
	jmp	vrika
no_s1:	cmp	dl,"X"
	jne	no_s2
	mov	bx,80
	jmp	vrika
no_s2:	cmp	dl,"2"
	jne	no_sX
	mov	bx,121
	jmp	vrika
no_sX:	jmp	no_super
vrika:	mov	deltio2prn[bx],1
no_super:
;----------------------------------------------------------->standard
	mov	cx,13
	xor	si,si
	xor	bx,bx
	xor	di,di
alstan:	mov	bl,stand[si]
	cmp	bl,0
	je	is_zer1
	dec	bx
	mov	deltio2prn[di][bx],1
is_zer1:
	add	di,3
	inc	si
	loop	alstan
;-----------------------------------------------------------
	xor	si,si
	xor	bx,bx
	mov	di,41
	mov	cx,13

alstil:	cmp	stand[si],0
	je	no_standar
	jmp	it_is_standar

no_standar:
	mov	ax,13
	sub	ax,cx
	cmp	al,axbuesi
	jb	is_ameros
	cmp	buf24[si],0
	jne	is_ameros

is_bmeros:
	@PUSH
b_alo:	cmp	buf24[si],0
	jne	is_b_brika
	add	si,13
	cmp	si,273
	jb	b_alo
	@EXIT

is_b_brika:
	add	di,41
	xor	bx,bx
	mov	cx,10
b_alsim:
	mov	bl,buf24[si]
	cmp	bl,0
	je	b_is_zer
	dec	bx
	mov	deltio2prn[di][bx],1
b_is_zer:
	add	si,13
	add	di,41
	loop	b_alsim
	@POP
	jmp	it_is_standar

is_ameros:
	@PUSH
	xor	bx,bx
	mov	cx,11
a_alsim:
	mov	bl,buf24[si]
	cmp	bl,0
	je	a_is_zer
	dec	bx
	mov	deltio2prn[di][bx],1
a_is_zer:
	add	si,13
	add	di,41
	loop	a_alsim
	@POP

it_is_standar:
	inc	si
	add	di,3
	loop	alstil99
	@POP
	ret
alstil99: jmp	alstil
dimiourgia_deltiou_axb	endp


clr_buf24	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	xor	bx,bx
	mov	cx,312
clrb24:	mov	buf24[bx],0
	inc	bx
	loop	clrb24
	@POP
	ret
clr_buf24	endp

clr_standar	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	cx,13
	mov	bx,0
std1:	mov	stand[bx],0
	inc	bx
	loop	std1
	@POP
	ret
clr_standar	endp

apocode	proc	near
	push	bx
	cmp	dl,4
	jbe	apc45

	mov	ax,1202
	call	fatal_error

apc45:	xor	bx,bx
	mov	bl,dl
	mov	dl,antist[bx]
	pop	bx
	ret
apocode	endp

riumisi_ektip	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SETWIND	wektip
	@SELECTWIND	wektip

	mov	bx,offset ektip_plr
	mov	di,bx
	call	riumisi1_ektip

	mov	ax,[bx][4]	;anamoni
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,3,strbuf
	@ATOI	strbuf
	mov	[bx][4],ax
	call	riumisi1_ektip
;---------------------------------------------------

	mov	ax,[bx][6]	;pano
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,4,strbuf
	@ATOI	strbuf
	mov	[bx][6],ax

	call	riumisi1_ektip

	mov	ax,[bx][12]	;aristero
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,5,strbuf
	@ATOI	strbuf
	mov	[bx][12],ax

	call	riumisi1_ektip

	mov	ax,[bx][18]	;kaueto
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,7,strbuf
	@ATOI	strbuf
	mov	[bx][18],ax

	call	riumisi1_ektip

	mov	ax,[bx][24]	;kaueto end
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,8,strbuf
	@ATOI	strbuf
	mov	[bx][24],ax

	call	riumisi1_ektip

	mov	ax,[bx][66]	;ana posa kaueta
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,9,strbuf
	@ATOI	strbuf
	mov	[bx][66],ax

	call	riumisi1_ektip


	mov	ax,[bx][30]	;orizon
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,11,strbuf
	@ATOI	strbuf
	mov	[bx][30],ax

	call	riumisi1_ektip

	mov	ax,[bx][36]	;orizon end
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,12,strbuf
	@ATOI	strbuf
	mov	[bx][36],ax

	call	riumisi1_ektip

	mov	ax,[bx][72]	;ana posa orizon
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,13,strbuf
	@ATOI	strbuf
	mov	[bx][72],ax

	call	riumisi1_ektip

	mov	ax,[bx][54]	;character
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,15,strbuf
	@ATOI	strbuf
	mov	[bx][54],ax
	call	riumisi1_ektip

	mov	ax,[bx][60]	;tipos ektip
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,16,strbuf
	@ATOI	strbuf
	mov	[bx][60],ax
	call	riumisi1_ektip


	mov	ax,[bx][78]	;1
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,17,strbuf
	@ATOI	strbuf
	mov	[bx][78],ax
	call	riumisi1_ektip

	mov	ax,pcl_prn	;ektipotis
	@ITOA	strbuf,4
	@WINPUTNUMBER	23,19,strbuf
	@ATOI	strbuf
	mov	pcl_prn[0],ax

	call	riumisi1_ektip

	call	save_inf
	@DELWIND	wektip
	pop	ax
	@SELECTWI	al
	@POP
	retf
riumisi_ektip	endp

riumisi1_ektip	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	push	di
	mov	cx,6
nstrui:	cmp	word ptr [di][66],0	; endiamesa oxi 0
	jne	nxtriu
	mov	word ptr [di][66],1
nxtriu:	add	di,2
	loop	nstrui
	pop	di

	mov	ax,[di][4]	;anamoni
	@ITOA	strbuf,4
	@WPRINT	23,3,strbuf

;---------------------------------------------------
	mov	ax,[di][6]	;peri8orio pano
	@ITOA	strbuf,4
	@WPRINT	23,4,strbuf

	mov	ax,[di][12]     ;peri8orio aristero
	@ITOA	strbuf,4
	@WPRINT	23,5,strbuf

	mov	ax,[di][18]     ;kena ka8eta
	@ITOA	strbuf,4
	@WPRINT	23,7,strbuf

	mov	ax,[di][24]     ;kena kaueta endiamesa
	@ITOA	strbuf,4
	@WPRINT	23,8,strbuf

	mov	ax,[di][30]     ;kena orizontia
	@ITOA	strbuf,4
	@WPRINT	23,11,strbuf

	mov	ax,[di][36]     ;kena orizontia endiamesa
	@ITOA	strbuf,4
	@WPRINT	23,12,strbuf

	mov	ax,[di][54]	;character 1
	@ITOA	strbuf,4
	@WPRINT	23,15,strbuf

	mov	ax,[di][60]	;tipos ektip 1
	@ITOA	strbuf,4
	@WPRINT	23,16,strbuf

	mov	ax,[di][66]	;endiamesa kaueta
	@ITOA	strbuf,4
	@WPRINT	23,9,strbuf

	mov	ax,[di][72]	;endiamesa orizontia
	@ITOA	strbuf,4
	@WPRINT	23,13,strbuf

	mov	ax,[di][78]	;kena apo plirofories
	@ITOA	strbuf,4
	@WPRINT	23,17,strbuf

	mov	ax,pcl_prn[0] 	;tipos ektipoti
	@ITOA	strbuf,4
	@WPRINT	23,19,strbuf

	@POP
	ret
_yy	db	0
riumisi1_ektip	endp

nai_oxi	proc	near
	cmp	ax,0
	je	foxi
	mov	strbuf[0],"N"
	mov	strbuf[1],"A"
	mov	strbuf[2],"I"
	mov	strbuf[3],0
	ret
foxi:	mov	strbuf[0],"O"
	mov	strbuf[1],"X"
	mov	strbuf[2],"I"
	mov	strbuf[3],0
	ret
nai_oxi	endp

lprint	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@LPRINTCHR	dl,lpt_number,cs:print_stack
	@POP
	ret
lprint	endp

pane_deltio	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SETWIND	wpane
	@SELECTWIND	wpane
	@FILLSTR	strbuf," ",10
	@WINPUTNUMBER	16,2,strbuf
	@ATOL	strbuf
	mov	ardel,ax
	mov	ardel[2],dx
	@DELWIND	wpane
	pop	ax
	@SELECTWI	al
	@POP
	ret
pane_deltio	endp

codesg	ends
	end
