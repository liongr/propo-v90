
INCLUDE	equs.h
INCLUDE	globals.inc

CODESG  SEGMENT PUBLIC

	assume	cs:CODESG,ds:DATAS1

public	copyright,proc_crash,chk_crght,help,div100

copyright proc    near
	@PUSH
	@CLRCURS
        @SETWIND	wright
        @WAITL
        @DELWIND	wright
	@BIGCURS
	@POP
        ret
copyright endp
;
proc_crash proc    near
        @SETWIND	wright
	@SELECTWIND	wright
	@WPRINTCH	0,0,al
	@MBELL
	@EXIT
proc_crash endp

chk_crght proc	near
	ret
chk_crght endp

help    proc    near
	@PUSHAX
	@CLRCURS
	@SETWIND	whelp
	@WAITL
        @UPPERAX
	@DELWIND	whelp
	@BIGCURS
	cmp	al,27
	jne	okh
	mov	ax,32
okh:	@POPAX
	ret
help    endp

isidio	proc	near
	@PUSH
	@SETWIND	widio
	@MBELL
	@CPLR	"T"
	@DELWIND	widio
	@POP
	ret
isidio	endp

fatal_error	proc	near
	@PUSH
	@CHANGESEGM	ds,WINSEGM
	mov	cx,ax
	@TAKEWIND
	push	ax
	@SETWIND	wfatal
	@SELECTWIND	wfatal
	mov	ax,cx
	@ITOA	wstr
	@WPRINT	2,0,wstr
fat1:	@WPRINT	1,2,fatl
	@WPRINT	1,6,kenl
	@WAIT	5
	jnc	fat2
	@UPPERAX
	cmp	al,"T"
	je	fat4
fat2:	@MBELL
	@WPRINT	1,2,kenl
	@WPRINT	1,6,fatl
	@WAIT	5
	@MBELL
	jnc	fat1
	@UPPERAX
	cmp	al,"T"
	je	fat4
	jmp	fat1
fat4:	@DELWIND	wfatal
	pop	ax
	@SELECTWI	al
	@CHANGESEGM	ds,DATAS1
	mov	sp,fatal_stack
	mov	fatal_stack,0
	@POP
	ret
fatal_error	endp

diakopi	proc	near
	@PUSH
;------------------------------------
	push	bx	;handlef gia metraAscii=1
;------------------------------------
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SETWIND	wdiakop
	@SELECTWIND	wdiakop
	mov	cx,13
	xor	si,si
	xor	bx,bx
	mov	dl,7
diak1:	mov	bl,pinsthl[si]
	mov	al,antist[bx]
	@WPRINTCH	dl,4,al
	add	dl,2
	inc	si
	loop	diak1
	@LTOAN	cound,strbuf
	@USING	strbuf,7
	@WPRINT	26,6,strbuf
	@LTOAN	cound,strbuf
	@WNUMBER	4,8,strbuf
	@BELL
	@CLRPLBUF
	@WAITL
	@UPPERAX
	@DELWIND	wdiakop
	pop	dx
	@SELECTWI	dl
	pop	bx
	cmp	al,"T"
	je	diak2
	@POP
	ret
diak2:	@CLOSE_HANDLE	bx
	mov	sp,fatal_stack
	mov	fatal_stack,0
	@POP
	ret
diakopi	endp
;
toobig  proc    near	; den xoraei
	@PUSH
	@SETWIND	wtoobig
	@MBELL
	@CPLR	"T"
	@DELWIND	wtoobig
	@POP
        ret
toobig  endp
;
eidos_oroy	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SETWIND	widosor
	@SELECTWIND	widosor

eidor4:	mov	cx,13
	xor	bx,bx
	xor	ax,ax
	mov	dh,5
eidor1:	mov	al,antistixia[bx]
	@ITOA	strbuf,2
	@WPRINT	14,dh,strbuf
	inc	bx
	inc	dh
	loop	eidor1
	
	@WINPUT	18,1,tipos_orou
	pushf
	xor	ax,ax
	mov	al,tipos_orou
	@UPPERAX
	cmp	al,"W"
	je	eidor5
	cmp	al,"X"
	je	eidor5
	cmp	al,"Y"
	je	eidor5
	cmp	al,"B"
	je	eidor5
	mov	al,"W"
eidor5:	mov	tipos_orou,al
	@WPRINT	18,1,tipos_orou
	popf
	jnc	eidor3
	jmp	eidor9

eidor3:	mov	cx,13
	xor	bx,bx
	xor	ax,ax
	mov	dh,5
eidor2:	mov	al,antistixia[bx]
	@ITOA	strbuf,2
	@WINPUTNUMBER	14,dh,strbuf
	pushf
	@ATOI	strbuf
	cmp	al,13
	jbe	eidor6
	popf
	jmp	eidor2
eidor6:	mov	antistixia[bx],al
	popf
	jc	eidor9
	inc	bx
	inc	dh
	loop	eidor2
	jmp	eidor4
	
eidor9:	@DELWIND	widosor
	pop	ax
	@SELECTWI	al
	@POP
	ret
eidos_oroy	endp

metrima_print	proc	near
	nop			;ret
	nop
	nop
	nop
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SELECTWIND	wmetrima
	mov	cx,9
	xor	si,si
	xor	bx,bx
	mov	dl,16
metr11:	mov	bl,pinsthl[si]
	mov	al,antist[bx]
	@WPRINTCH	dl,3,al
	add	dl,2
	inc	si
	loop	metr11

	@LTOAN	pinbil,strbuf
	@USING	strbuf,7
	@WPRINT	26,4,strbuf

	@LTOAN	cound,strbuf
	@USING	strbuf,7
	@WPRINT	26,6,strbuf

	@LTOAN	cound,strbuf
	@WNUMBER	4,8,strbuf

;	@LMULN	cound,draxmespropo
;	@LTOA	ax,dx,strbuf
;	call 	far ptr div100
;	@WPRINTCH 20,16,"0"
;	@WPRINT	21,16,strbuf
	
	push	ax
	mov	ax,pinbil
	mov	cs:mettmp,ax
	mov	ax,pinbil[2]
	mov	cs:mettmp[2],ax
	mov	ax,cound
	sub	cs:mettmp,ax
	mov	ax,cound[2]
	sbb	cs:mettmp[2],ax
	pop	ax

	@POSOSTO	pinbil,cs:mettmp,strbuf
	@WPRINT	20,14,strbuf
	pop	dx
	@SELECTWI	dl
	@POP
	ret
mettmp	dw	0,0
metrima_print	endp

div100	proc	near
	@PUSH
	mov	cx,10
	mov	bx,0
dvx1:	cmp	strbuf[bx],0
	je	dvx2
	inc	bx
	loop	dvx1
	@POP
	retf
dvx2:	dec	bx
	mov	al,strbuf[bx]
	mov	strbuf[bx+1],al
	dec	bx
	mov	al,strbuf[bx]
	mov	strbuf[bx+1],al
	mov	strbuf[bx],"."
	mov	strbuf[bx+3],0
	@POP
	retf
div100	endp

set_sbise	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	arxascii,0
	jne	sbom0
	@POP
	ret
sbom0:	@TAKEWIND
	push	ax
	@SETWIND	wsbise
sbom1:	@SELECTWIND	wsbise
	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	27,2,strbuf
	jc	sbom9
	cmp	strbuf," "
	jne	sbom3
	cmp	strbuf[1]," "
	je	sbom9
sbom3:	@ATOI	strbuf
	cmp	ax,36
	ja	sbom1
	mov	aromad,al
	mov	strbuf,0
	@NAIOXI	34,12,strbuf,msbise,msigor
	jnc	sbom2
	cmp	ax,0
	je	sbom1
	jmp	sbom9
sbom2:	xor	ax,ax
	mov	al,aromad
	call	chk_klidoma
	jc	sbom9
	call	sbyse_omada
sbom9:	@DELWIND	wsbise
	pop	ax
	@SELECTWI	al
	@POP
	ret
set_sbise	endp

set_allagi	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	arxascii,0
	jne	alom0
	@POP
	ret
alom0:	@TAKEWIND
	push	ax
	@SETWIND	wallagi
alom1:	@SELECTWIND	wallagi
	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	27,2,strbuf
	jnc	alom6
	jmp	alom9
alom6:	cmp	strbuf," "
	jne	alom3
	cmp	strbuf[1]," "
	jne	alom3
	jmp	alom9
alom3:	@ATOI	strbuf
	cmp	ax,36
	ja	alom1
	mov	aromad,al

alom5:	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	27,3,strbuf
	jc	alom9
	cmp	strbuf," "
	jne	alom4
	cmp	strbuf[1]," "
	je	alom9
alom4:	@ATOI	strbuf
	cmp	ax,36
	ja	alom5
	cmp	aromad,al
	je	alom5
	mov	aromad[1],al

	mov	strbuf,0
	@NAIOXI	34,12,strbuf,mallage,msigor
	jnc	alom2
	cmp	ax,0
	jne	alom9
	jmp	alom1
alom2:	xor	ax,ax
	mov	al,aromad[1]
	call	chk_klidoma
	jc	alom9
	call	allage_omada
alom9:	@DELWIND	wallagi
	pop	ax
	@SELECTWI	al
	@POP
	ret
set_allagi	endp

set_oria	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	arxascii,0
	jne	alor0
	@POP
	ret
alor0:	@TAKEWIND
	push	ax
	@SETWIND	waloria
alor1:	@SELECTWIND	waloria
	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	19,4,strbuf
	jnc	alor6
	jmp	alor9
alor6:	cmp	strbuf," "
	jne	alor3
	cmp	strbuf[1]," "
	jne	alor3
	jmp	alor9
alor3:	@ATOI	strbuf
	cmp	ax,36
	ja	alor1
	mov	aromad,al

	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	19,5,strbuf
	jnc	alor11
	jmp	alor9
alor11:	cmp	strbuf," "
	jne	alor4
	cmp	strbuf[1]," "
	jne	alor4
	jmp	alor9
alor4:	@ATOI	strbuf
	mov	aromad[2],al

	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	19,6,strbuf
	jnc	alor91
	jmp	alor9
alor91:	cmp	strbuf," "
	jne	alor7
	cmp	strbuf[1]," "
	je	alor9
alor7:	@ATOI	strbuf
	mov	aromad[3],al

	@FILLSTR	strbuf,"N",1
	@WINPUT	19,7,strbuf
	jc	alor9
	xor	ax,ax
	mov	al,strbuf
	@UPPERAX
	cmp	al,"O"
	je	alor71
	mov	al,"N"
alor71:	mov	aromad[4],al

	mov	strbuf,0
	@NAIOXI	34,12,strbuf,maloria,msigor
	jnc	alor2
	cmp	ax,0
	jne	alor9
	jmp	alor1
alor2:	xor	ax,ax
	mov	al,aromad
	call	chk_klidoma
	jc	alor9
	call	all_or_basikvn
alor9:	@DELWIND	waloria
	pop	ax
	@SELECTWI	al
	@POP
	ret
set_oria	endp

set_antigrafi	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	arxascii,0
	jne	antom0
	@POP
	ret
antom0:	@TAKEWIND
	push	ax
	@SETWIND	wantigr
antom1:	@SELECTWIND	wantigr
	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	27,2,strbuf
	jnc	antom6
	jmp	antom9
antom6:	cmp	strbuf," "
	jne	antom3
	cmp	strbuf[1]," "
	jne	antom3
	jmp	antom9
antom3:	@ATOI	strbuf
	cmp	ax,36
	ja	antom1
	mov	aromad,al

antom5:	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	27,3,strbuf
	jc	antom9
	cmp	strbuf," "
	jne	antom4
	cmp	strbuf[1]," "
	je	antom9
antom4:	@ATOI	strbuf
	cmp	ax,36
	ja	antom5
	cmp	aromad,al
	je	antom5
	mov	aromad[1],al

	mov	strbuf,0
	@NAIOXI	34,12,strbuf,mantigr,msigor
	jnc	antom2
	cmp	ax,0
	jne	antom9
	jmp	antom1
antom2:	xor	ax,ax
	mov	al,aromad[1]
	call	chk_klidoma
	jc	antom9
	call	copy_omada
antom9:	@DELWIND	wantigr
	pop	ax
	@SELECTWI	al
	@POP
	ret
set_antigrafi	endp

chk_klidoma	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATASC
	cmp	al,2
	jb	oxim0
	mov	di,ax
	dec	di
	dec	di
	mov	dl,es:klioma[di]
	cmp	dl,0
	je	oxim0
	@POP
	stc
	ret
oxim0:	@POP
	clc
	ret
chk_klidoma	endp

protas	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SETWIND	wprotas
	@SELECTWIND	wprotas

prtnx2:	mov	cx,15
	mov	si,offset buf_protasi
	mov	dl,6
	mov	dh,3
prtnxt:	@WPRINTSI	dl,dh
	inc	dh
	add	si,40
	loop	prtnxt

	cmp	klidoma_prot,1
	jne	prot9

	@CPLR	@ESCAPE

	@DELWIND	wprotas
	pop	ax
	@SELECTWI	al
	@POP
	ret

prot9:	mov	cx,15
	mov	bx,offset buf_protasi
	mov	dl,6
	mov	dh,3
prtnx1:	@WINPUFGREEK	dl,dh,bx
	jc	prtojo
	cmp	byte ptr [bx]," "
	je	prtnx3
	call	chkprot
	jc	prtnx1
	inc	dh
	add	bx,40
	loop	prtnx1
	jmp	prtnx2

prtnx3:	jmp	prtnx5

prtojo:	call	chkprot
	jc	prtnx1
	@DELWIND	wprotas
	pop	ax
	@SELECTWI	al
	@POP
	ret

prtnx5:	@PUSH
	mov	dx,offset buf_protasi
	add	dx,640
	mov	si,bx
	add	si,40
prtnx7:	cmp	si,dx
	jae	prtnx6
	mov	al,[si]
	mov	[bx],al
	inc	si
	inc	bx
	jmp	prtnx7
prtnx6:	@POP
	jmp	prtnx2
protas	endp

dilono_elegxo	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SETWIND	wdilono
	@SELECTWIND	wdilono

	call	dilono_print

	cmp	klidoma_prot,1
	jne	dilono9
	@CPLR	@ESCAPE
	jmp	dilono8

dilono9:
	call	dilono_edit

dilono8:
	@DELWIND	wdilono
	pop	ax
	@SELECTWI	al
	@POP
	ret
dilono_elegxo	endp

dilono_print	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	mov	cx,15
	mov	dh,3
	mov	si,offset buf_protasi

dl_nxt:	push	si
	inc	si
	mov	al,[si]
	@WPRINTCH	9,dh,al
	inc	si
	mov	al,[si]
	cmp	al,">"
	je	dl_ok
	@WPRINTCH	10,dh,al
	inc	si
dl_ok:	inc	si
	mov	al,[si]
	@WPRINTCH	20,dh,al
	inc	si
	mov	al,[si]
	cmp	al," "
	je	dl_tl
	@WPRINTCH	21,dh,al
dl_tl:	pop	si
	add	si,40
	inc	dh
	loop	dl_nxt

	@POP
	ret
dilono_print	endp

dilono_edit	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1

	mov	cx,15
	mov	dh,3
	mov	si,offset buf_protasi

dle_nxt:	push	si
	inc	si
	mov	strbuf[0]," "
	mov	strbuf[1]," "
	mov	strbuf[2],0
	mov	al,[si]
	mov	strbuf[0],al
;;;	@WPRINT	9,dh,al
	inc	si
	mov	al,[si]
	cmp	al,">"
	je	dle_ok
	mov	strbuf[1],al
	inc	si
;;;	@WPRINTCH	10,dh,al
dle_ok:	@WINPUTNUMBER	9,dh,strbuf
	jnc	dle_enter1
	pop	si
	jmp	dle_fige
dle_enter1:
	mov	al,strbuf[0]
	mov	cs:dilos[0],al
	mov	al,strbuf[1]
	mov	cs:dilos[1],al

	mov	strbuf[0]," "
	mov	strbuf[1]," "
	mov	strbuf[2],0
	inc	si
	mov	al,[si]
	mov	strbuf[0],al
;;;	@WPRINTCH	20,dh,al
	inc	si
	mov	al,[si]
	cmp	al," "
	je	dle_tl
	mov	strbuf[1],al
;;;	@WPRINTCH	21,dh,al
dle_tl:	@WINPUTNUMBER	20,dh,strbuf
	jnc	dle_enter2
	pop	si
	jmp	dle_fige
dle_enter2:
	pop	si
	call	make_protas
	add	si,40
	inc	dh
	loop	dle_nxt00
dle_fige:
	@POP
	ret
dle_nxt00:
	jmp	dle_nxt
dilos	db	0,0
dilono_edit	endp

make_protas	proc	near
	@PUSH
	mov	byte ptr [si],"?"
	inc	si
	mov	al,cs:dilos[0]
	mov	byte ptr [si],al
	inc	si
	mov	al,cs:dilos[1]
	cmp	al," "
	je	mkp2
	mov	byte ptr [si],al
	inc	si
mkp2:	mov	byte ptr [si],">"
	inc	si
	mov	al,strbuf[0]
	mov	byte ptr [si],al
	inc	si
	mov	al,strbuf[1]
	cmp	al," "
	je	mkp3
	mov	byte ptr [si],al
	inc	si
mkp3:	mov	al," "
	mov	byte ptr [si],al
	mov	byte ptr [si+1],al
	mov	byte ptr [si+2],al
	@POP
	ret
make_protas	endp

chkprot	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	xor	ax,ax
	xor	dx,dx
	cmp	byte ptr [bx]," "
	je	chkp71
	cmp	byte ptr [bx],"/"
	je	chkp71
	cmp	byte ptr [bx],"?"
	jne	chkp1

	mov	cx,39
chkp7:	cmp	byte ptr [bx]," "
	jne	chkp6
	jmp	chkpS
chkp6:	cmp	byte ptr [bx],"?"
	je	chkpE
	cmp	byte ptr [bx],"+"
	je	chkpK
	cmp	byte ptr [bx],"-"
	je	chkpH
	cmp	byte ptr [bx],">"
	je	chkpT
	cmp	byte ptr [bx],"!"
	je	chkpO
	cmp	byte ptr [bx],"0"
	jb	chkp1
	cmp	byte ptr [bx],"9"
	ja	chkp1
	inc	dx

chkp4:	inc	bx
	loop	chkp7
	cmp	ax,101
	jne	chkp1
chkp71:	@POP
	clc
	ret

chkp1:	@MBELL
	@POP
	stc
	ret

chkpE:	inc	ax
	cmp	byte ptr [bx+1],"!"
	je	chkp4
	cmp	byte ptr [bx+1],"0"
	jb	chkp1
	cmp	byte ptr [bx+1],"9"
	ja	chkp1
	jmp	chkp4

chkpT:	add	ax,100
chkpK:
chkpH:	call	chk0_9
	jc	chkp1
	cmp	byte ptr [bx+1],"!"
	je	chkp4
	cmp	byte ptr [bx+1],"0"
	jb	chkp1
	cmp	byte ptr [bx+1],"9"
	ja	chkp1
	cmp	byte ptr [bx-1],"0"
	jb	chkp1
	cmp	byte ptr [bx-1],"9"
	ja	chkp1
	jmp	chkp4

chkpO:	cmp	byte ptr [bx+1],"0"
	jb	chkp11
	cmp	byte ptr [bx+1],"9"
	ja	chkp11
	cmp	byte ptr [bx-1],"+"
	je	chkp4
	cmp	byte ptr [bx-1],"-"
	je	chkp4
	cmp	byte ptr [bx-1],">"
	je	chkp4
	cmp	byte ptr [bx-1],"?"
	je	chkp5
chkp11:	jmp	chkp1

chkpS:	cmp	byte ptr [bx-1]," "
	je	chkp5
	cmp	byte ptr [bx-1],"0"
	jb	chkp9
	cmp	byte ptr [bx-1],"9"
	ja	chkp9
	call	chk0_9
	jc	chkp9
chkp5:	jmp	chkp4
chkp9:	jmp	chkp1

chk0_9:	cmp	dx,2
	ja	c0_90
	cmp	dx,1
	jb	c0_90
	jmp	c0_92
c0_90:	stc
	ret
c0_92:	push	ax
	mov	strbuf,"0"
	cmp	dx,1
	je	c0_93
	mov	dl,[bx-2]
	mov	strbuf,dl
c0_93:	mov	dl,[bx-1]
	mov	strbuf[1],dl
	mov	strbuf[2],0
	@ATOI	strbuf
	cmp	ax,36
	ja	c0_91
	cmp	ax,2
	jb	c0_91
	pop	ax
	xor	dx,dx
	clc
	ret

c0_91:	pop	ax
	stc
	ret
chkprot	endp

bale_omada	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	arxascii,0
	ja	exoroi
	@POP
	ret
exoroi:	@TAKEWIND
	push	ax
	@SETWIND	wbaleomad
	@SELECTWIND	wbaleomad
	mov	strbuf[0],"1"
	mov	strbuf[1]," "
	mov	strbuf[2]," "
	mov	strbuf[3],0
	@WINPUTNUMBER	30,2,strbuf
	jc	nobalo
	@ATOI	strbuf
	mov	word ptr aromad[0],ax
	cmp	ax,1
	jbe	nobalo
	call	bale_omada_ana
nobalo:	@DELWIND	wbaleomad
	pop	ax
	@SELECTWI	al
	@POP
	ret
bale_omada	endp

set_antikat_sim	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	arxascii,0
	jne	lsmor0
	@POP
	ret
lsmor0:	@TAKEWIND
	push	ax
	@SETWIND	wantiksim
lsmor1:	@SELECTWIND	wantiksim
	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	19,4,strbuf
	jnc	lsmor6
	jmp	lsmor9
lsmor6:	cmp	strbuf," "
	jne	lsmor3
	cmp	strbuf[1]," "
	jne	lsmor3
	jmp	lsmor9
lsmor3:	@ATOI	strbuf
	cmp	ax,36
	ja	lsmor1
	mov	aromad,al

	@FILLSTR	strbuf," ",2
	@WINPUTNUMBER	19,5,strbuf
	jnc	lsmor11
	jmp	lsmor9
lsmor11: cmp	strbuf," "
	jne	lsmor4
	cmp	strbuf[1]," "
	jne	lsmor4
	jmp	lsmor9
lsmor4:	@ATOI	strbuf
	dec	ax
	mov	cx,3
	mul	cx
	inc	ax
	mov	aromad[2],al

	@FILLSTR	strbuf," ",3
	mov	strbuf[3],0
lsm101:	mov	dl,19
	mov	dh,6
	call	inp12x
	pushf
	@WPRINT	19,6,strbuf
	popf
	jnc	lsm100
	jmp	lsm101
lsm100:	cmp	strbuf," "
	jne	lsm108
	jmp	lsmor9
lsm108:	mov	al,strbuf[0]
	mov	aromad[3],al
	mov	al,strbuf[1]
	mov	aromad[4],al
	mov	al,strbuf[2]
	mov	aromad[5],al

	@FILLSTR	strbuf," ",3
	mov	strbuf[3],0
lsm102:	mov	dl,19
	mov	dh,7
	call	inp12x
	pushf
	@WPRINT	19,7,strbuf
	popf
	jnc	lsm103
	jmp	lsm102
lsm103:	cmp	strbuf," "
	je	lsmor9
	mov	al,strbuf[0]
	mov	aromad[6],al
	mov	al,strbuf[1]
	mov	aromad[7],al
	mov	al,strbuf[2]
	mov	aromad[8],al

	mov	strbuf,0
	@NAIOXI	34,12,strbuf,mantiksim,msigor
	jnc	lsmor2
	cmp	ax,0
	jne	lsmor9
	jmp	lsmor1
lsmor2:	xor	ax,ax
	mov	al,aromad
	call	chk_klidoma
	jc	lsmor9
	call	antikat_simio
lsmor9:	@DELWIND	wantiksim
	pop	ax
	@SELECTWI	al
	@POP
	ret
set_antikat_sim	endp

inp12x	proc	near
	@CURSW	dl,dh
	cmp	al,13
	jne	inp0
	clc
	ret
inp0:	cmp	al,"1"
	jne	inp1
	mov	strbuf,"1"
	mov	strbuf[1]," "
	mov	strbuf[2]," "
	stc
	ret
inp1:	cmp	al,"2"
	jne	inp2
	mov	strbuf,"2"
	mov	strbuf[1]," "
	mov	strbuf[2]," "
	stc
	ret
inp2:	cmp	al,"3"
	jne	inp3
	mov	strbuf,"X"
	mov	strbuf[1]," "
	mov	strbuf[2]," "
	stc
	ret
inp3:	cmp	al,"4"
	jne	inp4
	mov	strbuf,"1"
	mov	strbuf[1],"2"
	mov	strbuf[2]," "
	stc
	ret
inp4:	cmp	al,"5"
	jne	inp5
	mov	strbuf,"X"
	mov	strbuf[1],"2"
	mov	strbuf[2]," "
	stc
	ret
inp5:	cmp	al,"6"
	jne	inp6
	mov	strbuf,"1"
	mov	strbuf[1],"X"
	mov	strbuf[2]," "
	stc
	ret
inp6:	cmp	al,"7"
	jne	inp7
	mov	strbuf,"1"
	mov	strbuf[1],"X"
	mov	strbuf[2],"2"
	stc
	ret
inp7:	mov	strbuf," "
	mov	strbuf[1]," "
	mov	strbuf[2]," "
	stc
	ret
inp12x	endp

CODESG  ends
        end
