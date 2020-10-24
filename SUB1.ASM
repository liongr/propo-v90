
INCLUDE	EQUS.H

codesg	segment public

	assume	cs:codesg,ds:datas1

prometr proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	bx,0
	mov	cx,34
pr13:	cmp	pinak2[bx],"P"
	jne	pr12
	mov	pinak2[bx],"*"
pr12:	inc	bx
	loop	pr13

	@ZEROBBUF	bufpik,200

	xor	si,si
	xor	bx,bx
	push	bx
pr41:	mov	dl,buf_protasi[si]
	cmp	dl,"*"
	jne	pr4
	add	si,40
	cmp	si,760
	jb	pr41
	jmp	pr6

pr4:	mov	dl,buf_protasi[si]
	cmp	dl," "
	je	pr5
	cmp	dl,"0"
	jb	pr3
	cmp	dl,"9"
	ja	pr3
	jmp	pr2

pr3:	mov	dh,0
	mov	dl,cs:met1
	cmp	dl,2
	jb	pr15
	cmp	dx,35
	ja	pr15
	pop	bx
	mov	bufpik[bx],dl
	inc	bx
	push	bx

pr15:	mov	cs:met1,0

pr5:	inc	si
	cmp	si,760
	jb	pr4
	jmp	pr6

pr2:	cmp	cs:met1,0
	je	pr221
	push	ax
	push	cx
	push	dx
	xor	ax,ax
	mov	al,cs:met1
	mov	cx,10
	mul	cx
	mov	cs:met1,al
	pop	dx
	pop	cx
	pop	ax
pr221:	sub	dl,"0"
	add	cs:met1,dl
	jmp	pr5

pr6:	pop	bx
	xor	bx,bx
	xor	si,si
pr8:	xor	dx,dx
	mov	dl,bufpik[bx]
	cmp	dl,2
	jb	pr7
	cmp	dl,35
	ja	pr7
	mov	si,dx
	sub	si,2
	mov	pinak2[si],"P"
pr7:	inc	bx
	cmp	bx,200
	jb	pr8
	@POP
	ret
met1	db	0
prometr endp

taj_metab	proc	near
	@PUSH
	mov	bx,arxascii
	sub	bx,48
kleo:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,"M"
	je	tajme
	mov	metabl,0
	mov	filtra,1
	mov	metablhths,13
	@POP
	ret
tajme:	mov	metabl,1
	mov	bin,0
	xor	ax,ax
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+40]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+41]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	mov	ax,bin
	cmp	ax,39
	ja	koko
	cmp	ax,1
	jb	koko
	jmp	nokoko
koko:	@CHANGESEGM	ds,DATASC
	mov	arxasc[bx+40],"0"
	mov	arxasc[bx+41]," "
	@CHANGESEGM	ds,DATAS1
	mov	ax,13
	jmp	nok13

nokoko: mov	cx,130
	mul	cx
nok13:	mov	filtra,ax
	mov	bin,0

	xor	ax,ax
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+42]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+43]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	mov	ax,bin
	cmp	ax,12
	ja	kiki
	cmp	ax,6
	jb	kiki
	jmp	nokiki
kiki:	@CHANGESEGM	ds,DATASC
	mov	arxasc[bx+42],"1"
	mov	arxasc[bx+43],"2"
	@CHANGESEGM	ds,DATAS1
	mov	al,12
nokiki: mov	ah,14
	sub	ah,al
	mov	metablhths,ah
	@CHANGESEGM	ds,DATASC
	mov	arxasc[bx+44]," "
	@CHANGESEGM	ds,DATAS1
	mov	cx,13
	mov	bx,arxascii
	sub	bx,47
	mov	di,0
kokobl1:
	mov	dh,0
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,"*"
	jne	kokobill
	mov	dh,1
kokobill:
	mov	pin_ues_met[di],dh
	add	bx,3
	inc	di
	loop	kokobl1
	@POP
	ret
taj_metab	endp

grmon	proc	near
	@PUSH
	@TAKEWIND
	push	ax
	@SELECTWI	0
	@WPRINTCH	1,19,"R"
	@WPRINTCH	1,20,"A"
	@WPRINTCH	1,21,"M"
	pop	ax
	@SELECTWI	al
	@POP
	ret
grmon	endp
;
grmdion	proc	near
	@PUSH
	@TAKEWIND
	push	ax
	@SELECTWI	0
	@WPRINTCH	1,19,"D"
	@WPRINTCH	1,20,"I"
	@WPRINTCH	1,21,"S"
	@WPRINTCH	1,22,"K"
	pop	ax
	@SELECTWI	al
	@POP
	ret
grmdion	endp
;
sbmon	proc	near
	@PUSH
	@TAKEWIND
	push	ax
	@SELECTWI	0
	@WPRINTCH	1,19," "
	@WPRINTCH	1,20," "
	@WPRINTCH	1,21," "
	@WPRINTCH	1,22,"Ä"
	@WPRINTCH	1,23," "
	pop	ax
	@SELECTWI	al
	@POP
	ret
sbmon	endp
;
klidvma proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	arxascii,0
	jne	tzoyj
	@POP
	ret
tzoyj:	mov	klidoma_prot,1
	mov	bx,0
kpali:	call	kleidi
	add	bx,48
	cmp	bx,arxascii
	jb	kpali
;-------------------------------
klouv:	mov	bx,12
	mov	cx,34
	mov	si,0
stoyp1: mov	ax,pinak1[bx]
	cmp	ax,0
	je	stoypi
	@CHANGESEGM	ds,DATASC
	mov	klioma[si],1
	@CHANGESEGM	ds,DATAS1
stoypi: add	bx,6
	inc	si
	loop	stoyp1
;-------------------------------
	mov	cx,34
	mov	bx,0
stop3:	mov	dl,pinak2[bx]
	cmp	dl,"*"
	je	stop2
	cmp	dl,"E"
	je	stop2
	sub	dl,65
	xor	dh,dh
	mov	si,dx
	@CHANGESEGM	ds,DATASC
	mov	kliype[si],1
	@CHANGESEGM	ds,DATAS1
stop2:	inc	bx
	loop	stop3
telos:	@POP
	ret
;-------------------------------
kleidi: @CHANGESEGM	ds,DATASC
	mov	ax,bx
	xor	dx,dx
	push	cx
	mov	cx,48
	div	cx
	pop	cx
	mov	si,ax
	mov	klioro[si],1
	@CHANGESEGM	ds,DATAS1
	ret
klidvma endp
;
klidvma_oxi	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	klidoma_prot,0
	@CHANGESEGM	ds,DATASC
	mov	bx,0
	mov	cx,1300
opali:	mov	klioro[bx],0
	inc	bx
	loop	opali
	mov	bx,0
	mov	cx,34
opali1:	mov	klioma[bx],0
	inc	bx
	loop	opali1
	mov	bx,0
	mov	cx,4
opali2:	mov	kliype[bx],0
	inc	bx
	loop	opali2
	@POP
	ret
klidvma_oxi	endp
;
kauarisma_metab proc	near		;metablhtvn
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	simio_super13[0],0
	mov	simio_super13[1],0
	mov	simio_super13[2],0
	mov	simio_super13[3],0
	mov	uesi_super13[0],0
	mov	uesi_super13[2],0
	mov	cound,0
	mov	cound[2],0
	lea	si,arxhm
	lea	di,telosm
	sub	di,si
	mov	cx,di
kart:	mov	byte ptr [si],0
	inc	si
	loop	kart

	@CHANGESEGM	ds,DATANA

	lea	si,datanarxh
	lea	di,datanend
	sub	di,si
	mov	cx,di
kart2:	mov	byte ptr [si],0
	inc	si
	loop	kart2
	@POP
	ret
kauarisma_metab endp
	
codesg	ends
	end
