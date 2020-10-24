
INCLUDE equs.h

codesg	segment public

	assume	cs:codesg,ds:datas1,es:datana

plhra	proc	near
do_poke: ret
	@PUSH
	mov	fatal_stack,sp
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATANA
	
	call	savetmp

	mov	ax,prog[16]
	mov	word ptr [cs:metr1],ax
	cmp	memory,1
	je	stload
	cmp	metraAscii,1
	je	asciiload
	jmp	pipi
;-------------------------------------------------------------- ASCII
asciiload:
	jmp	metrastlascii
;-------------------------------------------------------------- MEMORY
stload:	mov	cbyte,0
	mov	point,0
	mov	segm,0
	mov	point_bx[0],0
	mov	point_si[0],0
	mov	ax,mast1
	mov	point_bx[2],ax
	mov	point_si[2],ax
	lea	bx,antig
	mov	cx,13
more_1:	mov	byte ptr [bx],250
	inc	bx
	loop	more_1
	cmp	mema,0
	je	lkk
	jmp	ere
lkk:	cmp	exomnimi,0
	je	eret
	jmp	ere
eret:	mov	memory,0
	@POP
	ret
ere:	cmp	exomnimi,0
	je	pipi
	mov	poros,2
	mov	ax,es:word ptr arxdat[0]
	cmp	ax,0
	je	tipta
	xor	dx,dx
	mov	cx,44
	mul	cx
	add	poros,ax
	xor	ax,ax
	mov	ax,es:word ptr arxdat[0]
	sub	ypor,ax
tipta:	call	stil_up
 	cmp	mema,0
	jne	nr2
	@POP
	ret
nr2:	mov	bx,point_bx[0]
	mov	al,13
	call	ll4
	mov	al,13
	ror	al,1
	ror	al,1
k_ll:	call	ll4
	mov	al,0
	cmp	point,0
	jne	k_ll
	mov	cx,20
	mov	cbyte,0
_s_q1:	call	svse
	loop	_s_q1
	mov	exomnimi,1
	@POP
	ret
;------------------------------------------------------- GEN
pipi:	mov	ax,es:word ptr arxdat[0]
	cmp	ax,0
	je	piuan19
	jmp	ppl1
piuan19:
	@POP
	ret
;
ppl1:	mov	poros,2
	mov	cx,es:word ptr arxdat[0]
pjana:	push	cx
	mov	bx,poros
	dec	ypor
	add	poros,44
	add	bx,2
;
	mov	cx,13
	push	bx
	mov	si,0
ppl2:	push	si
	mov	dl,es:arxdat[bx+2]
	cmp	dl,0
	je	oxip1
	mov	pinplhr[si],dl
	inc	si
oxip1:	mov	dl,es:arxdat[bx+1]
	cmp	dl,0
	je	oxip2
	mov	pinplhr[si],dl
	inc	si
oxip2:	mov	dl,es:arxdat[bx]
	cmp	dl,0
	jne	oxip33
	mov	pinplhr[si],0
	jmp	oxip3
oxip33: mov	pinplhr[si],dl
oxip3:	pop	si
	add	bx,3
	add	si,3
	loop	ppl2
;
	pop	bx
	mov	cx,13
	mov	si,0
ppl6:	cmp	es:arxdat[bx+1],0
	jne	ppl3
	mov	dl,1
	jmp	ppl5
pjanaq: jmp	pjana
ppl3:	cmp	es:arxdat[bx+2],0
	jne	ppl4
	mov	dl,2
	jmp	ppl5
ppl4:	mov	dl,3
ppl5:	mov	pinsthl[si],dl
	inc	si
	add	bx,3
	loop	ppl6
	jmp	pokk
rpkk:	call	metrv
	pop	cx
	loop	pjanaq
 	cmp	mema,0
	jne	nr
	@POP
	ret
;-------------------------------------------------------
nr:	mov	bx,point_bx[0]
	mov	al,13
	call	ll4
	mov	al,13
	ror	al,1
	ror	al,1
k_l:	call	ll4
	mov	al,0
	cmp	point,0
	jne	k_l
	mov	cx,20
	mov	cbyte,0
_s_q:	call	svse
	loop	_s_q
	mov	exomnimi,1
	@POP
	ret
;
pokk:	lea	si,pinplhr[0]
	xor	ax,ax
	mov	al,pinsthl[0]
	add	si,ax
	mov	word ptr [cs:tt01+2],si
	lea	si,pinplhr[3]
	xor	ax,ax
	mov	al,pinsthl[1]
	add	si,ax
	mov	word ptr [cs:tt02+2],si
	lea	si,pinplhr[6]
	xor	ax,ax
	mov	al,pinsthl[2]
	add	si,ax
	mov	word ptr [cs:tt03+2],si
	lea	si,pinplhr[9]
	xor	ax,ax
	mov	al,pinsthl[3]
	add	si,ax
	mov	word ptr [cs:tt04+2],si
	lea	si,pinplhr[12]
	xor	ax,ax
	mov	al,pinsthl[4]
	add	si,ax
	mov	word ptr [cs:tt05+2],si
	lea	si,pinplhr[15]
	xor	ax,ax
	mov	al,pinsthl[5]
	add	si,ax
	mov	word ptr [cs:tt06+2],si
	lea	si,pinplhr[18]
	xor	ax,ax
	mov	al,pinsthl[6]
	add	si,ax
	mov	word ptr [cs:tt07+2],si
	lea	si,pinplhr[21]
	xor	ax,ax
	mov	al,pinsthl[7]
	add	si,ax
	mov	word ptr [cs:tt08+2],si
	lea	si,pinplhr[24]
	xor	ax,ax
	mov	al,pinsthl[8]
	add	si,ax
	mov	word ptr [cs:tt09+2],si
	lea	si,pinplhr[27]
	xor	ax,ax
	mov	al,pinsthl[9]
	add	si,ax
	mov	word ptr [cs:tt10+2],si
	lea	si,pinplhr[30]
	xor	ax,ax
	mov	al,pinsthl[10]
	add	si,ax
	mov	word ptr [cs:tt11+2],si
	lea	si,pinplhr[33]
	xor	ax,ax
	mov	al,pinsthl[11]
	add	si,ax
	mov	word ptr [cs:tt12+2],si
	lea	si,pinplhr[36]
	xor	ax,ax
	mov	al,pinsthl[12]
	add	si,ax
	mov	word ptr [cs:tt13+2],si
	call	set_poson
	jmp	rpkk
plhra	endp

set_poson	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	ax,1
	mov	cx,4
	mov	si,9
	xor	bx,bx
mul1:	mov	bl,pinsthl[si]
	mul	bx
	inc	si
	loop	mul1
	mov	poson,ax
	mov	poson[2],0
	@POP
	ret
set_poson	endp

init_code	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	ax,prog[16]
	mov	word ptr [cs:metr1],ax
	mov	ax,word ptr [cs:tcmp]
	mov	word ptr [cs:sthmnhm],ax
	mov	word ptr [cs:metbl1],ax
	mov	word ptr [cs:ayjhsh],ax
	mov	word ptr [cs:binlk],ax
	mov	word ptr [cs:aepib],ax
	mov	word ptr [cs:plhrak],ax
	mov	word ptr [cs:dialogh0],ax
	mov	word ptr [cs:dialogh1],ax
	mov	word ptr [cs:stl2prn],ax
	mov	word ptr [cs:ascii],ax
	mov	byte ptr [cs:pelex0],11000011b
	mov	byte ptr [cs:pelex1],11000011b
	mov	byte ptr [cs:pelex2],11000011b
	mov	byte ptr [cs:pelex3],11000011b
	mov	byte ptr [cs:pelexm],11000011b
	mov	byte ptr [cs:metrima_print],11000011b
	@POP
	ret
init_code	endp
;
metrv	proc	near
	mov	es_point,es
	mov	ds_point,ds
	push	ds
	pop	es
	cld
	mov	cx,4
	lea	di,pinsthl[9]
	mov	al,4
	rep	stosb
	lea	di,pinsthl


;***********************************
;*************     9 shmeia     ****
;***********************************	
	lea	si,pinplhr[0]
st1:	movsb
	push	si
	lea	si,pinplhr[3]
st2:	movsb
	push	si
	lea	si,pinplhr[6]
st3:	movsb
	push	si
	lea	si,pinplhr[9]
st4:	movsb
	push	si
	lea	si,pinplhr[12]
st5:	movsb
	push	si
	lea	si,pinplhr[15]
st6:	movsb
	push	si
	lea	si,pinplhr[18]
st7:	movsb
	push	si
	lea	si,pinplhr[21]
st8:	movsb
	push	si
	lea	si,pinplhr[24]
st9:	movsb
	mov	es,es_point
	push	di
	push	si
	call	perior
	jmp	short elenje_gia_escape
oxi_escape:
	pop	si
	pop	di
	mov	es,ds_point
	dec	di
tt09:	cmp	si,6565
	jb	st9
	pop	si
	dec	di
tt08:	cmp	si,6565
	jb	st8
	pop	si
	dec	di
tt07:	cmp	si,6565
	jb	st7
	pop	si
	dec	di
tt06:	cmp	si,6565
	jb	st6
	pop	si
	dec	di
tt05:	cmp	si,6565
	jb	st5
	pop	si
	dec	di
tt04:	cmp	si,6565
	jb	st4
	pop	si
	dec	di
tt03:	cmp	si,6565
	jb	st3
	pop	si
	dec	di
tt02:	cmp	si,6565
	jb	st2
	pop	si
	dec	di
tt01:	cmp	si,6565
	jae	trj
	jmp	st1
trj:	mov	es,es_point
	ret
elenje_gia_escape:
	@CPLRNS
	jnc	oxi_escape
	call	metrima_print
	cmp	al,@ESCAPE
	jne	nesc12
	call	diakopi

nesc12:	jmp	oxi_escape

tcmp:	xor	dl,dl

metrv1: mov	dx,word ptr [cs:tcmp]
	mov	word ptr [cs:metr1],dx
	mov	es,ds_point


;***********************************
;*************     4 shmeia     ****
;***********************************	
	lea	di,pinsthl[9]
	lea	si,pinplhr[27]
st10:	movsb
	push	si
	lea	si,pinplhr[30]
st11:	movsb
	push	si
	lea	si,pinplhr[33]
st12:	movsb
	push	si
	lea	si,pinplhr[36]
st13:	movsb
	mov	es,es_point
	push	di
	push	si
	call	perior
	pop	si
	pop	di
	mov	es,ds_point
	dec	di
tt13:	cmp	si,6565
	jb	st13
	pop	si
	dec	di
tt12:	cmp	si,6565
	jb	st12
	pop	si
	dec	di
tt11:	cmp	si,6565
	jb	st11
	pop	si
	dec	di
tt10:	cmp	si,6565
	jb	st10
	mov	dx,prog[16]
	mov	word ptr [cs:metr1],dx
	mov	cx,4
	lea	di,pinsthl[9]
	mov	al,4
	rep	stosb
	mov	es,es_point
	ret
metrv	endp



leles	proc	near
metrastlascii:
	mov	ax,word ptr [cs:tcmp]
	mov	word ptr [cs:metr1],ax
	mov	poros,2
	mov	ax,es:word ptr arxdat[0]
	cmp	ax,0
	je	tiptasc
	xor	dx,dx
	mov	cx,44
	mul	cx
	add	poros,ax
	xor	ax,ax
	mov	ax,es:word ptr arxdat[0]
	sub	ypor,ax
tiptasc:
	@CHANGESEGM	ds,DATAS1
	@OPEN_HANDLE	FileMetraAscii,I_READ
	mov	cs:handlef,ax
	@READ_HANDLE	cs:handlef,strbuf,16
	@MOVEFP		cs:handlef,0,0,I_BEG
	mov	cs:bite,13
	cmp	strbuf[13]," "
	ja	ascalo
	inc	cs:bite
	cmp	strbuf[14]," "
	ja	ascalo
	inc	cs:bite
	cmp	strbuf[15]," "
	ja	ascalo
	@POP
	ret	
ascalo:	@READ_HANDLE	cs:handlef,strbuf,cs:bite
	jc	telasc
	mov	cx,13
	xor	bx,bx
asc12:	mov	al,strbuf[bx]
	call	ascicode
	mov	pinsthl[bx],al
	inc	bx
	loop	asc12
	@PUSH
	call	perior
	@POP
	jmp	short ascii_escape
asciioxi_escape:
	jmp	ascalo
telasc:	@CLOSE_HANDLE	cs:handlef
	@POP
	ret

ascii_escape:
	@CPLRNS
	jnc	asciioxi_escape
	call	metrima_print
	cmp	al,@ESCAPE
	jne	ascnesc12
	push	bx
	mov	bx,cs:handlef
	call	diakopi
	pop	bx

ascnesc12:
	jmp	asciioxi_escape

bite	dw	0
handlef	dw	0
leles	endp

ascicode	proc	near
	cmp	al,3
	ja	noal3
	ret
noal3:	cmp	al,"1"
	jne	noal1
	mov	al,1
	ret
noal1:	cmp	al,"X"
	jne	noalx
	mov	al,2
	ret
noalx:	cmp	al,"2"
	jne	noal2
	mov	al,3
	ret
noal2:	mov	al,0
	ret
ascicode	endp

codesg	ends
	end
