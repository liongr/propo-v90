
INCLUDE	equs.h

codesg	segment public

	assume	cs:codesg,ds:datas1

plhrakia	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

plr4_1:	jmp	plrmet

	mov	si,0
	mov	bx,axbp
	cmp	bx,0
	je	plrmet
	sub	bx,13
plr6:	xor	dh,dh
	mov	cx,13
plr3:	mov	dl,pinsthl[si]
	inc	dl
	cmp	dl,axbpin[bx][si]
	je	plr2

	inc	dh
	cmp	dh,1
	ja	plrmet
	mov	di,si

plr2:	inc	si
	loop	plr3
;**************************************** 1 SHMEIO DIAFORA=PROSUESI
	mov	dl,pinsthl[di]
	inc	dl
	add	axbpin[bx][di],dl
	@POP
	ret

plrmet:	mov	cx,13			;>1 SHMEIO DIAFORA = METAFORA
	mov	bx,axbp
	mov	si,0
plr1:	mov	dl,pinsthl[si]
	inc	dl
	mov	axbpin[bx][si],dl
	inc	si
	loop	plr1

	add	axbp,13
	cmp	axbp,BUFAXB_AB-26	;FULL BUFFER - 26byte
	jb	plrm1

plr4_2:	jmp	plrm2

	call	epejergasia

plrm1:	@POP
	ret

plrm2:	call	buffer_full
	@POP
	ret

Agonas14PrnPoint dw	0
Agonas14Prn db	0,0,0,0

plhrakia	endp

;********************************************************** EPEJERGASIA 1
epejergasia	proc	near		; 1H EPEJERGASIA
	@PUSH
	@CHANGESEGM	ds,DATAS1
arxh:	mov	plirup,1
	mov	bx,plirpoint
	xor	ah,ah
epe2:	mov	cx,12
	mov	di,12
epe1:	cmp	axbpin[bx][di],4
	jbe	synex
	mov	pliraki1,bx
	cmp	di,plirup
	jb	fyge
	sub	di,plirup
	mov	plirues,di
	jmp	elegxos
synex:	dec	di
	loop	epe1

	mov	di,12
	sub	di,plirup
	mov	pliraki1,bx
	mov	plirues,di
	jmp	elegxos
fyge:	add	bx,13
fyge9:	cmp	bx,axbp
	jb	epe2
	cmp	ah,1
	jne	koykoy
	inc	plirup
	cmp	plirup,13
	jb	arxh

koykoy: call	kauarisma

	cmp	axbp,BUFAXB_AB-2600
	jb	nopr

	call	telikh_epejergasia

nopr:	@POP
	ret
elegxos:
	mov	al,axbpin[bx][di]
	add	bx,13
	cmp	bx,axbp
	jb	ele1
	jmp	fyge2
ele1:	cmp	axbpin[bx],"*"
	je	ele9
ele3:	mov	pliraki2,bx
	cmp	al,axbpin[bx][di]
	jne	elegxos2
	jmp	fyge1
ele9:	add	bx,13
	cmp	bx,axbp
	jb	ele1
	jmp	fyge2

elegxos2:
	mov	cx,13
	mov	bx,pliraki2
	mov	si,pliraki1
	xor	dh,dh
ele2:	mov	dl,axbpin[bx]
	cmp	dl,axbpin[si]
	jne	brikae
gyrna:	inc	si
	inc	bx
	loop	ele2

	mov	di,plirues
	mov	bx,pliraki2
	mov	dl,axbpin[bx][di]
	mov	axbpin[bx],"*"
	mov	bx,pliraki1
	add	axbpin[bx][di],dl
	mov	ah,1
	mov	bx,pliraki2
	jmp	ele1

brikae: inc	dh
	cmp	dh,1
	ja	fyge2
	jmp	gyrna

fyge1:	cmp	plirues,1
	jbe	fyge2
	dec	plirues
	mov	bx,pliraki1
	mov	di,plirues
	mov	al,axbpin[bx][di]
	mov	bx,pliraki2
	jmp	ele3

fyge2:	mov	bx,pliraki1
	jmp	fyge

fyge3:	mov	bx,pliraki2
	jmp	ele9
epejergasia	endp

;********************************************************** EPEJERGASIA 2
telikh_epejergasia	proc	near	;TELIKH - SEIRIAKH - EPEJERGASIA
	@PUSH
	@CHANGESEGM	ds,DATAS1
arxht:	mov	bx,0
	xor	ax,ax
loop1:	cmp	axbpin[bx],"*"
	jne	seiriaka
allo:	add	bx,13
	cmp	bx,axbp
	jb	loop1
teloste:
	cmp	ah,1
	je	arxht

	mov	plirpoint,0
	call	kauarisma
	cmp	axbp,BUFAXB_AB-3900
	jb	teret
	call	buffer_full
teret:	@POP
	ret

;*********************************
seiriaka:
	mov	si,bx
	add	si,13
	cmp	si,axbp
	jae	teloste
loops:	cmp	axbpin[si],"*"
	jne	seiriaka1
allos:	add	si,13
	cmp	si,axbp
	jb	loops
	jmp	allo

seiriaka1:
	mov	cx,13
	xor	di,di
	xor	al,al
loops1: mov	dl,axbpin[bx][di]
	xchg	si,bx
	mov	dh,axbpin[bx][di]
	xchg	si,bx
	cmp	dl,dh
	jne	brikas
gyrbri: inc	di
	loop	loops1

	mov	di,plirues
	xchg	bx,si
	mov	dl,axbpin[bx][di]
	mov	axbpin[bx],"*"
	xchg	bx,si
	add	axbpin[bx][di],dl
	mov	ah,1
	jmp	allos
;
brikas: inc	al
	cmp	al,1
	ja	allos
	mov	plirues,di
	jmp	gyrbri
telikh_epejergasia	endp

;********************************************************** EPEJERGASIA 3
kauarisma proc	near				;BGALE STHLES ME ASTERAKIA
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	si,0
	mov	bx,plirpoint
loopk:	cmp	axbpin[bx],"*"
	je	astnai
	add	bx,13
	cmp	bx,axbp
	jb	loopk
	cmp	si,0
	je	kiuar
	jmp	telos

kiuar:	mov	plirpoint,bx
	@POP
	ret

astnai: mov	si,bx
	add	bx,13
	cmp	bx,axbp
	jae	telos
soyrtk: cmp	axbpin[bx],"*"
	jne	metafora
	add	bx,13
	cmp	bx,axbp
	jb	soyrtk
telos:	mov	axbp,si
	mov	plirpoint,si
	@POP
	ret
metafora:
	mov	cx,13
loopm1: mov	dl,axbpin[bx]
	mov	axbpin[si],dl
	inc	si
	inc	bx
	loop	loopm1
	mov	axbpin[bx-13],"*"
	cmp	bx,axbp
	jb	soyrtk
	jmp	telos
kauarisma endp

;*********************************************** H BUFFER GEMISE...TI KANOYME?
buffer_full	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	cmp	axbp,BUFAXB_AB-6500
	jae	plr12
	@POP
	ret

plr12:	cmp	axbp,0
	je	tere12
	cmp	dialogi,0
	je	pr_plr

	call	plirakia_dialogi
	jmp	short tere12

pr_plr:	call	plirakia_print

tere12:	@POP
	ret
buffer_full	endp


Agonas14	proc	near
	push	bx
	cmp	Agonas14_Anaposa,0
	jne	exei_anaposa
	mov	dl,Agonas14_Simio_Code[4]
	pop	bx
	ret
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
	pop	bx
	ret
Agonas14	endp

;*********************************************** PLIRAKIA 2 SCREEN
plirakia_print	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	mov	plhrqa,0
	mov	bx,0

arxhek:	@INCL	ar_deltiou

	mov	si,bx
	mov	sthlh,2

	mov	cx,4
	mov	cs:Agonas14PrnPoint,0
plrt9:	mov	grammh,2
	push	cx
proxor: push	si
	mov	si,plhrqa
	mov	plhrqpin[si],bx
	inc	plhrqa
	inc	plhrqa
	pop	si
;*****************************************
onlin3: cmp	shmeadel,0
	je	onlin2
	add	bx,13
	jmp	online1

onlin2: mov	cx,14
;------------------------------------- pida 14 simio
plrt1:	push	ax
	mov	ax,14
	sub	al,Agonas14_Thesi
	inc	ax
	cmp	cx,ax
	jne	n14ag1
	pop	ax
	
	
;******************************************************************** 14 AGONAS
	@PUSH
	call	Agonas14
	mov	bx,cs:Agonas14PrnPoint
	mov	cs:Agonas14Prn[bx],dl
	inc	cs:Agonas14PrnPoint
	call	plr_apcode
	@POP
	jmp	nx14o1
;********************************************************************

n14ag1:	pop	ax
	mov	dl,axbpin[bx]
	call	plr_apcode
	inc	bx

nx14o1:	inc	grammh
	loop	plrt1
online1:
	pop	cx
	cmp	bx,axbp
	jb	plrt8
	jmp	plrt0

plrt8:	add	sthlh,9
	loop	plrt9999
	jmp	plrt0
	
plrt9999:	jmp plrt9

plrt0:	cmp	plhrqa,0
	ja	ypolg
	jmp	japla

ypolg:	call	ypologismos_sthlvn
	@LCMPN	ar_deltiou,ardel
	jae	isbr1
	@JUMPONKEY	isbr1
	jmp	ardel9

isbr1:	cmp	protia_prn[0],0
	jne	liri2
	jmp	liri
liri2:	call	dimiourgia_deltiou_plr
	call	far ptr ektiposi_plirakia
	jc	liri
	@JUMPONKEY	liri
	@JUMPONKEY	liri

belxi:	jmp	ardel9

liri:	@SETWIND	wdelti
	@CLRPLBUF
	@WAITL
	@UPPERAX
	@DELWIND	wdelti
	cmp	al,"T"
	jne	noTTT
aspro:	mov	cx,BUFAXB_AB
	mov	bx,0
llrtc:	mov	axbpin[bx],0
	inc	bx
	loop	llrtc
	mov	axbp,0
	mov	plirpoint,0
	mov	sp,fatal_stack
	mov	fatal_stack,0
	@POP
	ret
noTTT:	cmp	al,"P"
	jne	noPPP
	mov	dx,0
	call	far ptr riumisi_ektip
	jmp	liri

noPPP:	cmp	al,"!"
	jne	noDok
	@ZEROBBUF	deltio2prn,200,1 	;14x4x3=168
	call	far ptr ektiposi_plirakia
	jmp	liri

noDok:	cmp	al,"Q"
	jne	noQQQ
	call	dimiourgia_deltiou_plr
	call	far ptr ektiposi_plirakia
	jmp	liri

noQQQ:	cmp	al,"A"
	jne	noAAA
	mov	protia_prn,0
	call	pane_deltio
	jmp	liri

noAAA:	cmp	al,"E"
	je	ardel9
	jmp	liri

ardel9:	@CLSWIND	wclr_pliraki
	cmp	plhrqa,0
	je	japla
	mov	plhrqa,0
;*****************************************
fygas:	cmp	bx,axbp
	jae	japla1
	jmp	arxhek
telosek:
	mov	cx,BUFAXB_AB
	mov	bx,0
plrtc:	mov	axbpin[bx],0
	inc	bx
	loop	plrtc
	mov	axbp,0
	mov	plirpoint,0
nbv1:	@POP
	ret

japla:	sub	ar_deltiou,1
	sbb	ar_deltiou[2],0

japla1:	cmp	plhrqa,15
	jne	lkji
	jmp	aspro

lkji:	jmp	telosek
plirakia_print	endp

plr_apcode	proc	near		;apokodikopoihsh plhrakia
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SELECTWIND	wdeltio_pliraki
	cmp	dl,2
	jb	error
	cmp	dl,9
	ja	error
	cmp	dl,8
	jne	plr_ap1

error:	call	fatal_error

plr_ap1:
	mov	dh,0
	dec	dl
	dec	dl
	shl	dl,1
	shl	dl,1
	mov	si,dx
	mov	ax,offset antistplr
	add	si,ax

ass:	@WPRINTSI	sthlh,grammh
	pop	ax
	@SELECTWI	al
	@POP
	ret
plr_apcode	endp

ypologismos_sthlvn	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SELECTWIND	wdeltio_pliraki
	mov	sthlh,2
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

plir139:
	jmp	plir13

plr49:	loop	plr4
	jmp	tel0

dpl:	@LMUL	stlplr[di][2],stlplr[di],0,2
	mov	stlplr[di],ax
	mov	stlplr[di][2],dx
qoqor:	inc	si
	loop	plir139

	pop	cx
	@LTOAN	stlplr[di],strbuf
	@USING	strbuf,7
	@WPRINT	sthlh,17,strbuf
	@LADDN	stlplr[16],stlplr[di]
	cmp	si,axbp
	jae	tel0
	add	di,4
	add	bx,2
	add	sthlh,8
	jmp	plr49

tel0:	@LADDN	mexri_tora,stlplr[16]
	@FILLSTR	strbuf," ",8
	@WPRINT	16,20,strbuf
	@LTOAN	stlplr[16],strbuf
	@WPRINT	16,20,strbuf

	@LTOAN	ar_deltiou,strbuf
	@WPRINT	16,19,strbuf

	@LTOAN	mexri_tora,strbuf
	@WPRINT	16,21,strbuf

	pop	ax
	@SELECTWI	al
	@POP
	ret
ypologismos_sthlvn	endp
;
dimiourgia_deltiou_plr	proc	near
	@PUSH
;**************************************************
IFDEF	@NORMAL
;**************************************************
	@CHANGESEGM	ds,DATAS1
	@ZEROBBUF	deltio2prn,200,0 	;14x4x3=168
	mov	cs:Agonas14PrnPoint,0
	mov	ax,plhrqa
	xor	dx,dx
	mov	cx,2
	div	cx
	mov	cx,ax

	xor	bx,bx
	mov	di,0

nxtplr:	push	cx
	push	di
	mov	si,plhrqpin[bx]

	add	si,12

	mov	cx,14
nxt:	
;------------------------------------- pida 14 simio
	push	ax
	xor	ax,ax
	mov	al,Agonas14_Thesi
;	inc	ax
	cmp	cx,ax
	jne	no14ag
	pop	ax
;******************************************************************** 14 AGONAS
	@PUSH
	mov	bx,cs:Agonas14PrnPoint
	mov	dl,cs:Agonas14Prn[bx]
	call	put_simia
	inc	cs:Agonas14PrnPoint
	@POP
;********************************************************************
	jmp	nxt14o

no14ag:	pop	ax
;-------------------------------------
	mov	dl,axbpin[si]
	call	put_simia
	dec	si
nxt14o:	inc	di
	loop	nxt

	pop	di
	pop	cx
	add	di,42	;3x14=42
	add	bx,2
	loop	nxtplr9
	@POP
	ret

nxtplr9:
	jmp	nxtplr

put_simia:
	cmp	dl,2
	jne	no_2
	mov	deltio2prn[di],1
	ret
no_2:	cmp	dl,3
	jne	no_3
	mov	deltio2prn[di+14],1
	ret
no_3:	cmp	dl,4
	jne	no_4
	mov	deltio2prn[di+28],1
	ret
no_4:	cmp	dl,5
	jne	no_5
	mov	deltio2prn[di],1
	mov	deltio2prn[di+14],1
	ret
no_5:	cmp	dl,6
	jne	no_6
	mov	deltio2prn[di],1
	mov	deltio2prn[di+28],1
	ret
no_6:	cmp	dl,7
	jne	no_7
	mov	deltio2prn[di+14],1
	mov	deltio2prn[di+28],1
	ret
no_7:	cmp	dl,9
	jne	no_9
	mov	deltio2prn[di],1
	mov	deltio2prn[di+14],1
	mov	deltio2prn[di+28],1
no_9:	ret
;**************************************************
ENDIF
;**************************************************
dimiourgia_deltiou_plr	endp


take_aples_stl	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	bx,0
	mov	si,0
epomno: mov	ax,0
	mov	di,0
qjanare:
	push	bx
	mov	cx,13
	mov	dx,0
qexeiarage:
	mov	dl,axbpin[bx]
	cmp	dl,8
	ja	pyros
	cmp	dl,5
	jb	qdenexei
	inc	dh
qdenexei:
	inc	bx
	loop	qexeiarage
	cmp	dh,2
	jb	qproxor

pyros:	pop	bx
	add	bx,13
	cmp	bx,axbp
	jb	qjanare
	jmp	thats

qproxor:
	pop	bx
	push	bx
	mov	cx,13
vbn:	mov	dl,axbpin[bx]
	call	plir2aplo
	inc	bx
	inc	di
	loop	vbn

	mov	exi_aples,1
	@WRITE_HANDLE	aples_handle,pinsthl1,13
	jnc	writ1

	call	fatal_error

writ1:	pop	bx
	mov	axbpin[bx],"*"
	add	bx,13

	cmp	ax,0
	je	writ2
	@WRITE_HANDLE	aples_handle,pinsthl2,13
	jnc	writ2

	call	fatal_error

writ2:	mov	ax,0
	cmp	bx,axbp
	jae	thats
	jmp	epomno

thats:	@POP
	ret
take_aples_stl	endp
;
plir2aplo	proc	near
	@PUSHAX
	@CHANGESEGM	ds,DATAS1
	cmp	dl,4
	ja	kke
	cmp	dl,1
	ja	kkeml

	call	fatal_error

kkeml:	dec	dl
	mov	pinsthl1[di],dl
	mov	pinsthl2[di],dl
	@POPAX
	ret

kke:	cmp	dl,5
	je	towtr
	cmp	dl,6
	je	frtow
	cmp	dl,7
	je	frtree

	call	fatal_error

towtr:	mov	pinsthl1[di],1
	mov	pinsthl2[di],2
	mov	ax,1
	@POPAX
	ret

frtow:	mov	pinsthl1[di],1
	mov	pinsthl2[di],3
	mov	ax,1
	@POPAX
	ret

frtree: mov	pinsthl1[di],2
	mov	pinsthl2[di],3
	mov	ax,1
	@POPAX
	ret
plir2aplo	endp

apla_deltia_from_file	proc	near
	@PUSH
	@OPEN_HANDLE	aples_file,I_READ
	
apli0:	mov	deltio,0
	xor	si,si

apli2:	@READ_HANDLE	aples_handle,gen_buf,13
	jnc	exiaples
	jmp	aples_telos
	
exiaples:
	xor	bx,bx
	mov	cx,13
apli1:	mov	dl,gen_buf[bx]
	mov	buf24[si],dl
	inc	bx
	inc	si
	loop	apli1
	inc	deltio
	cmp	si,143
	jb	apli2
	call	deltyp
	jmp	apli0

aples_telos:
	cmp	deltio,0
	je	apli3

	call	deltyp

apli3:	@CLOSE_HANDLE	aples_handle
	@POP
	ret
apla_deltia_from_file	endp

codesg	ends

codesg5	segment	public

	 assume	cs:codesg5,ds:datas1,es:datana

ektiposi_plirakia	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	mov	ax,offset lptnames
	mov	lpt_number,ax
	mov	protia_prn,1

	cmp	pcl_prn,5
	jb	isEPSON
	call	far ptr ektiposi_PCL
	jmp	koinon	

isEPSON:
	call	far ptr ektiposi_EPSON

koinon:	@WAIT	anamoni_plr
	@POP
	retf
ektiposi_plirakia	endp

ektiposi_PCL	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	cs:print_stack5,sp
	@LPRINT_START	lpt_number
	@LPRINTSTR	pcl_reset,lpt_number,cs:print_stack5
	@LPRINTSTR	pcl_10cpi,lpt_number,cs:print_stack5
	@LPRINTSTR	pcl_select_charset,lpt_number,cs:print_stack5
	@LPRINTSTR	pcl_set_height,lpt_number,cs:print_stack5
	mov	ax,riumisi_pano_plr
	mov	cs:__Y,ax
	mov	ax,riumisi_aris_plr
	mov	cs:__X,ax
	call	pcl_mov_Y
	call	pcl_mov_X
	
	cmp	tiposekt_plr,6
	je	ispcl_6
	jmp	nopcl_6
	
ispcl_6:
;	@LMULN	stlplr[16],draxmespropo
;	@LTOA	ax,dx,strbuf
;	call	far ptr div100
;	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
;	@LPRINTCHR	"-",lpt_number,cs:print_stack5
	@LTOAN	ar_deltiou,strbuf
	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
	@LPRINTCHR	"-",lpt_number,cs:print_stack5
	@LTOAN	stlplr[16],strbuf
	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
	@LPRINTCHR	"-",lpt_number,cs:print_stack5
	mov filename[8],0
	@LPRINTSTR	filename,lpt_number,cs:print_stack5
	
	mov	ax,riumisi_aris_plr
	mov	cs:__X,ax
	mov	ax,kena_info_plr
	add	cs:__Y,ax
	call	pcl_mov_Y
	call	pcl_mov_X

nopcl_6:
	mov	cx,12
	mov	si,0
pcl34:	push	cx
;----------------------------------------------------------------------------
	mov	ax,riumisi_aris_plr
	mov	cs:__X,ax
;----------------------------------------------------------------------------
	mov	cx,14
pcl13:	call	pcl_mov_X
	mov	dl,deltio2prn[si]
	cmp	dl,1
	je	pclone
	@LPRINTCHR	" ",lpt_number,cs:print_stack5
	jmp	pclken
pclone:
	@LPRINTCHR	prchar_plr,lpt_number,cs:print_stack5
pclken:
	mov	ax,kena_orizontia_plr
	add	cs:__X,ax
	inc	si
	loop	pcl13
	
	pop	cx

	mov	ax,kena_kaueta_plr
	add	cs:__Y,ax
	call	pcl_mov_Y
	loop	pcl34

	cmp	tiposekt_plr,6
	jne	ispcl_61
	jmp	nopcl_61

ispcl_61:
	mov	ax,riumisi_aris_plr
	mov	cs:__X,ax
	mov	ax,kena_info_plr
	add	cs:__Y,ax
	call	pcl_mov_Y
	call	pcl_mov_X

;	@LMULN	stlplr[16],draxmespropo
;	@LTOA	ax,dx,strbuf
;	call	far ptr div100
;	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
;	@LPRINTCHR	"-",lpt_number,cs:print_stack5
	@LTOAN	ar_deltiou,strbuf
	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
	@LPRINTCHR	"-",lpt_number,cs:print_stack5
	@LTOAN	stlplr[16],strbuf
	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
	@LPRINTCHR	"-",lpt_number,cs:print_stack5
	mov filename[8],0
	@LPRINTSTR	filename,lpt_number,cs:print_stack5

nopcl_61:
	@LPRINTSTR	pcl_formfeed,lpt_number,cs:print_stack5
	@LPRINT_STOP

	@POP
	retf
__X	dw	0
__Y	dw	0
ektiposi_PCL	endp

ektiposi_EPSON	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	cs:print_stack5,sp
;-------------------------------------------------> Start
	@LPRINT_START	lpt_number
;-------------------------------------------------------------> Reset
	@LPRINTSTR	prn_reset,lpt_number,cs:print_stack5
;-------------------------------------------------------------> Aristero periuorio
	mov	ax,riumisi_aris_plr
	call	far ptr do_left_mergin
;-------------------------------------------------------------> Arxiki proouisi
	mov	ax,riumisi_pano_plr
	call	far ptr do_proouisi
;-------------------------------------------------------------
	mov	ax,kena_kaueta_plr
	call	far ptr do_vertical_space
	mov	ax,kena_orizontia_plr
	call	far ptr do_horizontial_space
;-------------------------------------------------------------
	@LPRINTSTR	prn_expanded_on,lpt_number,cs:print_stack5
	@LPRINTSTR	prn_set_10cpi,lpt_number,cs:print_stack5

	call	far ptr epson_tipos

	@LPRINTSTR	prn_formfeed,lpt_number,cs:print_stack5

	@LPRINTSTR	prn_reset,lpt_number,cs:print_stack5
	@LPRINT_STOP

	@POP
	retf
_bx	dw	0
ektiposi_EPSON	endp

epson_tipos	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	cmp	tiposekt_plr,2
	jne	notipos_2
;	call	far ptr epson_T2
;	jmp	egine

notipos_2:
	cmp	tiposekt_plr,3
	jne	notipos_3
;	call	far ptr epson_T3
;	jmp	egine

notipos_3:
	cmp	tiposekt_plr,4
	jne	notipos_4
;	call	far ptr epson_T4
;	jmp	egine

notipos_4:
	cmp	tiposekt_plr,5
	jne	notipos_5
;	call	far ptr epson_T5
;	jmp	egine

notipos_5:
;	call	far ptr epson_T1
egine:	@POP
	retf
epson_tipos	endp

ekt_stand_riumisi	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@LPRINTSTR	prn_can_conden,lpt_number,cs:print_stack5
	@LPRINTSTR	prn_set_10cpi,lpt_number,cs:print_stack5
	mov	ax,kena_kaueta_plr
	call	far ptr do_vertical_space
	mov	ax,kena_orizontia_plr
	call	far ptr do_horizontial_space
	@POP
	retf
ekt_stand_riumisi	endp

ekt_plirof	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	ax,0
	call	far ptr do_horizontial_space
	@LPRINTSTR	prn_set_12cpi,lpt_number,cs:print_stack5
	@LPRINTSTR	prn_set_conden,lpt_number,cs:print_stack5
	@LTOAN	ar_deltiou,strbuf
	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
	@LPRINTCHR	"-",lpt_number,cs:print_stack5
	@LTOAN	stlplr[96],strbuf
	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
	@LPRINTCHR	"-",lpt_number,cs:print_stack5
	mov filename[8],0
	@LPRINTSTR	filename,lpt_number,cs:print_stack5
	@LPRINTSTR	prn_line_feed,lpt_number,cs:print_stack5
	@LPRINTSTR	prn_set_10cpi,lpt_number,cs:print_stack5
	@LPRINTSTR	prn_can_conden,lpt_number,cs:print_stack5
	mov	ax,kena_orizontia_plr
	call	far ptr do_horizontial_space
	@POP
	retf
ekt_plirof	endp

pcl_mov_Y	proc	near
	@PUSH
	@LPRINTSTR	pcl_mov_vert1,lpt_number,cs:print_stack5
	mov	ax,cs:__Y
	@LTOA	ax,0,strbuf
	call	do_using
	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
	@LPRINTSTR	pcl_mov_vert2,lpt_number,cs:print_stack5
	@POP
	clc
	ret
pcl_mov_Y	endp

pcl_mov_X	proc	near
	@PUSH
	@LPRINTSTR	pcl_mov_horiz1,lpt_number,cs:print_stack5
	mov	ax,cs:__X
	@LTOA	ax,0,strbuf
	call	do_using
	@LPRINTSTR	strbuf,lpt_number,cs:print_stack5
	@LPRINTSTR	pcl_mov_horiz2,lpt_number,cs:print_stack5
	@POP
	ret
pcl_mov_X	endp

do_using	proc	near
	@PUSH
	xor	bx,bx
nxtus:	mov	al,strbuf[bx]
	cmp	al,"0"
	jb	usend
	cmp	al,"9"
	ja	usend
	inc	bx
	jmp	nxtus
usend:	mov	strbuf[bx],0
	@POP
	ret
do_using	endp

make_orizontia_riumisi_printer proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	bx,cs:_bx
	xor	dx,dx
	mov	ax,cx
	mov	cx,endiam_oriz_plr
	div	cx
	cmp	dx,0
	je	is_or_endiameso
is_or_kirios:
	mov	bx,cs:_bx
	mov	ax,kena_orizontia_plr
	call	far ptr do_horizontial_space
	@POP
	retf
is_or_endiameso:
	mov	bx,cs:_bx
	mov	ax,kena_oriz_end_plr
	call	far ptr do_horizontial_space
	@POP
	retf
make_orizontia_riumisi_printer endp

make_kaueti_riumisi_printer proc near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	bx,cs:_bx
	xor	dx,dx
	mov	ax,cx
	mov	cx,endiam_kau_plr
	div	cx
	cmp	dx,0
	jne	is_ka_kirios
	jmp	is_ka_endiameso
is_ka_kirios:
	mov	bx,cs:_bx
	mov	ax,kena_kaueta_plr
	call	far ptr do_vertical_space
	@LPRINTSTR	prn_line_feed,lpt_number,cs:print_stack5
	@POP
	retf
is_ka_endiameso:
	mov	bx,cs:_bx
	mov	ax,kena_kaueta_end_plr
	call	far ptr do_vertical_space
	@LPRINTSTR	prn_line_feed,lpt_number,cs:print_stack5
	@POP
	retf
make_kaueti_riumisi_printer endp

do_proouisi	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	ax,0
	jne	isnt0
	jmp	is_miden
isnt0:	mov	cs:_temp,al
	cmp	ax,40
	ja	is_big
	jmp	is_nmiden
is_big:	xor	dx,dx
	mov	cx,40
	div	cx
	mov	cs:_temp,dl
	mov	cx,ax
	mov	ax,40
	call	far ptr do_vertical_space
nxtsm:
	@LPRINTSTR	prn_line_feed,lpt_number,cs:print_stack5
	loop	nxtsm
is_small:
	cmp	cs:_temp,0
	jne	is_nmiden
	jmp	is_miden
is_nmiden:
	mov	ah,0
	mov	al,cs:_temp
	call	far ptr do_vertical_space
	@LPRINTSTR	prn_line_feed,lpt_number,cs:print_stack5
is_miden:
	@POP
	retf
_temp	db	0
do_proouisi	endp

do_horizontial_space	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@LPRINTSTR	prn_hori_space,lpt_number,cs:print_stack5
	@LPRINTCHR	al,lpt_number,cs:print_stack5
	@POP
	retf
do_horizontial_space	endp

do_vertical_space	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@LPRINTSTR	prn_vert_space,lpt_number,cs:print_stack5
	@LPRINTCHR	al,lpt_number,cs:print_stack5
	@POP
	retf
do_vertical_space	endp

do_left_mergin	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@LPRINTSTR	prn_left_mergin,lpt_number,cs:print_stack5
	@LPRINTCHR	al,lpt_number,cs:print_stack5
	@POP
	retf
do_left_mergin	endp

codesg5	ends
	end
