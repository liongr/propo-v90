
INCLUDE equs.h

datas1	segment public
extrn	servieta:byte
extrn	pdata:word,pinak2:byte,es_point:word,ds_point:word
extrn	arxascii:word,pinak1:word,pinak3:byte,bufpik:byte
extrn	bin:word,mestil:byte,pplhr:word,komad:byte,komad1:word
extrn	mapo:byte,pinsthl:byte,poros:word,sthlh:byte
extrn	pointp:word,grammh:byte,comast:word,ypomadt:byte
extrn	pinsthl1:byte,pinsthl2:byte,stacc:word,prog:word,periodos:byte
extrn	comom:byte,pinprot:byte,sofi:byte,buf48:byte,bp48:word,ardel:word
extrn	poipro:word,callpro:word,callipr:word,gen_buf:byte,omadt:byte
extrn	porel:word,g_emf:word
extrn	prott:byte,ypor:word,pror:byte,asor:word,omor:byte
extrn	plr:word,ypor1:word,oryp:byte,msg4:byte,binels:byte
extrn	axbp:word,axbpb:word,bufaxb:byte,pokmetbl:word,metabex:byte
extrn	axbpin:byte,buf24:byte
extrn	epig:byte,sepig:word,pindial:byte,metabl:byte,filtra:word,memory:byte
extrn	metablhths:byte,metp:word,pinmet:byte,pin_ues_met:byte,dialogh:byte
datas1	ends

CODESG	segment public
extrn	dec_bin:near,plhktro:near,bin_dec:near,clr_scr:near,cersor:near
extrn	midenm:near,dispmhn:near,mettyp:near,metrv1:near,axb:near,dosdisp:near
extrn	plhrakia:near,setcurs:near,taj_metab:near,interrupt:near
extrn	biosdisp:near,apoustil:near,sbmon:near,init_code:near

public	tajasc,perior,ayjhsh,elegxpr,pelex0,pelex1,pelex2,pelex3,pelexm
public	metr1,aepib,plhrak,dialogh0,dialogh1,metbl1
public	sthmnhm,aujis,binlk,binpr,ascii

	ASSUME	CS:CODESG,DS:DATAS1,ES:DATANA

tajasc	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
tcmp:	xor	al,al
	call	init_code
	cmp	arxascii,0
	jne	t100
	@POP
	clc
	ret
t100:	@CHANGESEGM	ES,DATANA
	mov	metabl,0
	mov	ax,word ptr [cs:tcmp]
	mov	word ptr [cs:metbl1],ax
	call	taj_metab
	cmp	metabl,0
	je	oxi_metabl
	mov	ax,pokmetbl
	mov	word ptr [cs:metbl1],ax
oxi_metabl:
	mov	komad1,0
	mov	bx,0
lena2:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,"0"
	jne	lena1
	jmp	q_l
	cmp	memory,0
	je	q_l
	push	cx
	@CHANGESEGM	ds,DATASC
	mov	di,1
	mov	cx,13
enfas:	cmp	arxasc[bx][di]," "
	je	kronos
	add	di,3
	loop	enfas
	@CHANGESEGM	ds,DATAS1
	pop	cx
	jmp	q_l
kronos:	@CHANGESEGM	ds,DATAS1
	pop	cx
	mov	memory,0
	call	sbmon
q_l:	inc	komad1
	add	bx,48
	jmp	lena2
lena1:	mov	dx,komad1
	mov	es:word ptr arxdat[0],dx
	mov	pdata,2
	mov	pplhr,0
	mov	komad,0
	mov	ax,word ptr [cs:t02]
	mov	prog[20],ax
	mov	byte ptr [cs:telex+2],"P"
tarxh:	mov	bx,pplhr
t99:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+47]
	@CHANGESEGM	ds,DATAS1
trlrl:	cmp	dl,99
	jne	trl
	cmp	pplhr,0
	je	trl1
	jmp	qtelos
trl1:	cmp	byte ptr [cs:t02],10010000b
	je	trl2
	mov	pplhr,bx
	mov	si,pdata
	mov	es:arxdat[si],255
	inc	pdata
trl2:	jmp	qtelos
trl:	cmp	dl,2
	jb	t97
t02:	jmp	short allagh		; nop - nop
epistr: mov	dh,0
	mov	si,dx
	mov	dl,pinak2[si-2]
telex:	cmp	dl,"P"		; p - * - a - b - c - d
	je	trr
rtel:	jmp	ttel
;
allagh: mov	pplhr,bx
	mov	word ptr [cs:t02],1001000010010000b
	mov	si,pdata
	mov	es:arxdat[si],255
	inc	pdata
	jmp	tarxh
;
trr:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+47]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,komad
	je	t97
	mov	komad,dl
	call	omapes
;
t97:	cmp	pdata,BUFDATA-100
	jbe	konta
	@POP
	stc
	ret

konta:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1

	cmp	dl,"0"			;0-plhrh
	jne	t1
	mov	ax,offset cs:bastri
	jmp	qbastt
t1:	cmp	dl,"P"			;p-enallages
	jne	t2
	mov	ax,offset cs:enalag
	jmp	qxvris
t2:	cmp	dl,"O"			;o-omades 1,2,x
	jne	t3
	jmp	qom_1_2_x
t3:	cmp	dl,"R"			;r-genika paragvga
	jne	t4
	mov	ax,offset cs:basmon
	jmp	gen_par
t4:	cmp	dl,"5"			;5-genika synexomena
	jne	t5
	mov	ax,offset cs:synmon
	jmp	gen_par
t5:	cmp	dl,"S"			;s-baros
	jne	t6
	mov	ax,offset cs:baros
	jmp	qxvris
t6:	cmp	dl,"W"			;w-basikes mones,diples,triples
	jne	t7
	jmp	qbasth
t7:	cmp	dl,"Y"			;y-omades synexomenvn
	jne	t8
	mov	ax,offset cs:omsyn
	jmp	qbastm
t8:	cmp	dl,"I"			;i-parastaseis staueres me orous
	jne	t9
	mov	ax,offset cs:parsmo
	jmp	qparst
t9:	cmp	dl,"J"			;j-	-.-	 -.-	xvris -.-
	jne	t10
	mov	ax,offset cs:parsxo
	jmp	qparst
t10:	cmp	dl,"H"			;h-	-.-	eleuyeres me -.-
	jne	t11
	mov	ax,offset cs:paremo
	jmp	qparst
t11:	cmp	dl,"K"			;k-	-.-	 -.-	xvris -.-
	jne	t12
	mov	ax,offset cs:parexo
	jmp	qparst
t12:	cmp	dl,"L"			;l-paragvga
	jne	t13
	mov	ax,offset cs:parago
	jmp	qpar
t13:	cmp	dl,"Z"			;z-mona-zyga
	jne	t14
	jmp	qmonz
t14:	cmp	dl,"X"			;x-synexomena monhs,diplhs bas.sthlhs
	jne	t15
	jmp	qsynex
t15:	cmp	dl,"B"			;b-triples parastaseis
	jne	t16
	jmp	qpard
t16:	cmp	dl,"Q"			;q-symmetrika
	jne	t17
	mov	ax,offset cs:symetr
	jmp	qxvris
t17:	cmp	dl,"D"			;d-baros ana uesh
	jne	t18
	mov	ax,offset cs:barana
	jmp	qpar
t18:	cmp	dl,"\"			;\-omades 1x2
	jne	t19
	mov	ax,offset cs:synomad
	jmp	qxvris
t19:	cmp	dl,"1"			;1-ajones 1x2
	jne	t20
	mov	ax,offset cs:ajones
	jmp	qxvris
t20:	cmp	dl,"4"			;4-diades synexomenes
	jne	t21
	mov	ax,offset cs:dyades_syn
	jmp	qxvris
t21:	cmp	dl,"7"			;7-periodikothta
	jne	t22
	mov	ax,offset cs:periodo
	mov	servieta,1
	jmp	qxvris
t22:	cmp	dl,"A"			;a-baros2
	jne	t23
	mov	ax,offset cs:baros_2
	jmp	qxvris
t23:	cmp	dl,"U"			;u-omades 1x, x2, 12
	jne	t24
	jmp	omades_shmeivn
t24:	cmp	dl,"3"			;3-sinexomena simetrika
	jne	t25
	mov	ax,offset cs:symetr_synex
	jmp	qxvris
t25:	cmp	dl,"2"			;2-omades enallagvn
	jne	t26
	mov	ax,offset cs:enalag_omad
	jmp	qxvris
t26:	cmp	dl,"6"			;6-emfaniseis orvn
	jne	t27
	mov	ax,offset cs:emfgen
	jmp	qxvris
t27:	cmp	dl,"{"			;{-triades sinexomened
	jne	t28
	mov	ax,offset cs:triades_syn
	jmp	qxvris
t28:	cmp	dl,"}"			;}-enallages ana uesi
	jne	t29
	mov	ax,offset cs:enalanauesi
	jmp	qpar
t29:	cmp	dl,"%"			;%-enallages sinexomenes
	jne	t30
	mov	ax,offset cs:enalsinexom
	jmp	qpar
t30:	cmp	dl,"&"			;&-emfaniseis orvn x N
	jne	t31
	jmp	emfXn
t31:	cmp	dl,"V"			;V-auristikoi pinakes
	jne	t32
	mov	ax,offset cs:aurist_pinak
	jmp	qxvris
t32:	cmp	dl,"@"			;@-monades 1x2
	jne	t33
	mov	ax,offset cs:monasimia
	jmp	qxvris
t33:	cmp	dl,"("			;(-diades
	jne	t34
	mov	ax,offset cs:dyades
	jmp	qpar
t34:	cmp	dl,")"			;)-triades
	jne	t35
	mov	ax,offset cs:triades
	jmp	qpar
t35:	cmp	dl,"!"			;!-ajones shmeivn
	jne	t36
	mov	ax,offset cs:ajones_s
	jmp	qsimio_ae
t36:	cmp	dl,"$"			;$-monades simion
	jne	t37
	mov	ax,offset cs:monades_s
	jmp	qsimio_ae
t37:	cmp	dl,"<"			;<-statistiko paketo
	jne	t38
	mov	ax,offset cs:stat_paketo
	jmp	qxvris
t38:	cmp	dl,"#"			;#-TRIADES ME SEIRA
	jne	t39
	jmp	qtriad_l

t39:

;*******************************************
t999:	@POP
	stc
	ret

ttel:	add	bx,48
	jmp	t99
qtelos: inc	byte ptr [cs:telex+2]
	mov	dl,byte ptr [cs:telex+2]
	cmp	dl,81			;"P" +1
	je	qaaa
	cmp	dl,43			;"*" +1
	je	qppp
	cmp	dl,68			;"D" +1
	ja	qtel
qtelq:	mov	si,pdata
	mov	es:arxdat[si],255
	inc	pdata
	cmp	byte ptr [cs:telex+2],42
	je	qtel1
	call	omomad
qtel1:	jmp	tarxh
qaaa:	mov	byte ptr [cs:telex+2],"*"
	jmp	qtelq
qppp:	mov	byte ptr [cs:telex+2],"A"
	jmp	qtelq
;***************************************************** telos
qtel:	mov	si,pdata
	mov	es:arxdat[si],255
	mov	es:arxdat[si+1],255
	add	pdata,2
	mov	ax,prog[20]
	mov	word ptr [cs:t02],ax
;***************************************************** 
	mov	ypor,0
	mov	bx,0
www3:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+47]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,1
	ja	www2
	inc	ypor
	add	bx,48
	jmp	www3
www2:	mov	cx,word ptr es:arxdat[0]
	mov	ax,ypor
	sub	ax,cx
	mov	ypor1,ax
;***************************************************** 
	mov	bx,0
www21:	cmp	es:arxdat[bx],255
	je	www1
www22:	inc	bx
	jmp	www21
www1:	mov	dx,bx
	inc	bx
www5:	cmp	es:arxdat[bx],255
	je	www6
	inc	bx
	jmp	www5
www6:	push	bx
	sub	bx,dx
	cmp	bx,3
	jb	www7
	mov	pror,1
	jmp	www8
www7:	mov	pror,0
www8:	pop	bx
;***************************************************** 
	mov	dx,bx
	inc	bx
www9:	cmp	es:arxdat[bx],255
	je	www10
	inc	bx
	jmp	www9
www10:	push	bx
	sub	bx,dx
	cmp	bx,3
	jb	www11
	mov	asor,1
	jmp	www12
www11:	mov	asor,0
www12:	pop	bx
;***************************************************** 
	mov	dx,bx
	inc	bx
	mov	si,1
	mov	omor[0],0
www13:	cmp	es:arxdat[bx],255
	je	www14
	inc	bx
	jmp	www13
www14:	push	bx
	sub	bx,dx
	cmp	bx,6
	jb	www15
	mov	omor[si],1
	mov	omor[0],1
	jmp	www16
www15:	mov	omor[si],0
www16:	pop	bx
;***************************************************** 
	mov	dx,bx
	inc	bx
	inc	si
	cmp	si,5
	jb	www13
;***************************************************** 
tprot1: cmp	asor,0
	je	tprot
	mov	asor,0
	mov	cx,34
	mov	bx,12
trp2:	cmp	pinak1[bx],0
	jne	trp1
trp4:	add	bx,6
	loop	trp2
	jmp	tprot
trp1:	push	cx
	mov	ax,bx
	xor	dx,dx
	mov	cx,6
	div	cx
	pop	cx
	sub	ax,2
	mov	si,ax
	cmp	pinak2[si],"*"
	je	trp3
	jmp	trp4
trp3:	inc	asor
	jmp	trp4
;********************************************************** protaseis
tprot:
;******************************* midenismos pinprot & callipr
;	xor	bx,bx
;	xor	di,di
;	mov	cx,400
;	xor	ax,ax
;pinn:	mov	byte ptr pinprot[bx],al
;	mov	word ptr callipr[di],ax
;	inc	di
;	inc	di
;	inc	bx
;	loop	pinn
;******************************* kodikopiisi pinprot
	mov	bx,0
	mov	di,0
	mov	si,1
ismhn:	mov	dl,buf_protasi[bx][di]
	cmp	dl," "
	je	isnhn11
	cmp	dl,"/"	  ;*
	je	ismhn6
	cmp	dl,"-"    ;H
	je	ismhn1
	cmp	dl,"+"    ;K
	je	ismhn2
	cmp	dl,"!"    ;O
	je	isoxi
	cmp	dl,">"    ;T
	je	ismhn3
leon1:	inc	bx
	jmp	ismhn

ismhn6: add	di,40
	xor	bx,bx

isnhn:	cmp	di,600		;*********
	jb	ismhn
	mov	pinprot[si],"$"
	jmp	cale

isoxi:	mov	ax,offset cs:skoxi
	dec	si
	mov	pinprot[si],"O"
	inc	si
	jmp	ismhn8

isnhn11:add	di,40
	xor	bx,bx
	mov	pinprot[si],3
	inc	si
	inc	si
	jmp	isnhn

ismhn1: cmp	buf_protasi[bx+1],"O"
	je	ismhn4
	mov	ax,offset cs:hdiaz
	jmp	ismhn8

ismhn4: mov	ax,offset cs:hdoxi
	inc	bx
	dec	di
	jmp	ismhn8

ismhn2: cmp	buf_protasi[bx+1],"O"
	je	ismhn5
	mov	ax,offset cs:kaii
	jmp	ismhn8

ismhn5: mov	ax,offset cs:kaoxi
	inc	bx
	dec	di
	jmp	ismhn8

ismhn3: mov	ah,"T"
	mov	al,0
ismhn8: mov	pinprot[si],ah
	inc	si
	mov	pinprot[si],al
	inc	si
	inc	si
	jmp	leon1
;*********************************** pointer omadvn protasevn
cale:	mov	bx,0
	mov	di,0
islo1:	mov	dl,bufpik[bx]		;oi omades tvn protasevn dyadika
	cmp	dl,0			;kai se seira
	je	isret

	mov	si,0
	xor	dh,dh
islop:	cmp	callpro[si],dx		;ta offset tvn omadvn prots
	je	isedv
	add	si,4
	cmp	si,800
	jb	islop
	mov	di,0
	jmp	isret

isedv:	mov	ax,callpro[si+2]
	mov	callipr[di],ax
	add	di,2
	inc	bx
	jmp	islo1

isret:	mov	ax,0
	mov	callipr[di],ax
	add	di,2
;*********************************** afairesh telos pointer omadon
	mov	bx,0
	mov	cx,0
isi1:	cmp	es:arxdat[bx],255
	je	isil
	inc	bx
	jmp	isi1

isil:	inc	cx
	push	bx
	inc	bx
	cmp	cx,2
	jne	isi1
	pop	ax
	pop	ax
	dec	bx
	cmp	ax,bx
	jne	isil1
	mov	callipr[0],0
	mov	di,2
isil1:	mov	callipr[di],bx
	mov	callipr[398],bx
;***********************************
	@POP
	clc
	ret
;*********************************** ;ektyposi tajinomhshs gia elegxoys
ektyp:	mov	bx,0
	call	clr_scr
	mov	dh,0
	mov	dl,0
	call	setcurs
t98:	mov	dl,es:arxdat[bx]
	mov	dh,0
	push	bx
	call	bin_dec
	mov	dl,32
	mov	ah,02h
	int	21h
	pop	bx
	inc	bx
	cmp	bx,300
	jb	t98
	mov	dl,13
	mov	ah,02h
	int	21h
	mov	cx,100
	mov	bx,0
rtrtr:	mov	dl,pinprot[bx]
	call	biosdisp
	inc	bx
	loop	rtrtr
	mov	dl,13
	mov	ah,02h
	int	21h
	mov	cx,10
	mov	bx,0
laert:	mov	dx,callipr[bx]
	call	bin_dec
	mov	dl,32
	mov	ah,02h
	int	21h
	add	bx,2
	loop	laert
	call	plhktro
	@POP
	clc
	ret
;*****************************************************
gen_par:
	push	bx
	call	omega
	pop	bx
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+4]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	si,pdata
	mov	cx,13
_klooun:
	mov	es:arxdat[si],dl
	inc	si
	loop	_klooun
	mov	pdata,si
	call	apoevs
	jmp	ttel
;***************************************************** 
qsimio_ae:
	push	bx
	call	omega
	pop	bx
	mov	si,pdata
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+4]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	inc	pdata
	call	apoevs
	jmp	ttel
;***************************************************** 
qom_1_2_x:
	mov	ax,offset cs:omassvn
	push	bx
	call	omega
	pop	bx
	mov	si,pdata
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+4]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	inc	pdata
	call	apoevs
	jmp	ttel
;***************************************************** 
emfXn:	mov	ax,offset cs:emfgenXn
	push	bx
	call	omega
	pop	bx
	mov	si,pdata
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+4]
	@CHANGESEGM	ds,DATAS1
	sub	dl,"0"
	mov	es:arxdat[si],dl
	inc	pdata
	call	apoevs
	jmp	ttel
;***************************************************** 
omades_shmeivn:
	mov	ax,offset cs:asso_xi
	push	bx
	call	omega
	pop	bx
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+4]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,"1"
	jne	_1_
	jmp	gia_asso
_1_:	cmp	dl,"X"
	jne	_X_
	jmp	gia_xi
omitel:	mov	si,pdata
	mov	es:arxdat[si],dl
	inc	pdata
	call	apoevs
_X_:	jmp	ttel

gia_asso:
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+5]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,"2"		;12
	jne	omd_1_1
	mov	dl,2
	jmp	omitel
omd_1_1: mov	dl,3		;1x
	jmp	omitel
gia_xi:	mov	dl,1		;x2
	jmp	omitel
;***************************************************** 
qxvris: push	bx
	call	omega
	pop	bx
	call	apoevs
	jmp	ttel
;
qpard:	push	bx
	add	bx,2
	mov	cx,13
qpard1: @CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	dl," "
	jne	qpard2
	add	bx,3
	loop	qpard1
	mov	ax,offset cs:parmon
	pop	bx
	jmp	qparmo
qpard2: pop	bx
	push	bx
	add	bx,3
	mov	cx,13
qpatr1: @CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	dl," "
	jne	qpatr2
	add	bx,3
	loop	qpatr1
	mov	ax,offset cs:pardip
	pop	bx
	jmp	qpardi
qpatr2: mov	ax,offset cs:partri
	pop	bx
	jmp	qpartr
;
qparmo: push	bx
	call	omega
	mov	cx,12
	mov	si,pdata
	inc	bx
qparm1: @CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	inc	si
	add	bx,3
	loop	qparm1
	mov	es:arxdat[si],0
	inc	si
	mov	pdata,si
	pop	bx
	call	apoevs
	jmp	ttel
;
qpardi: push	bx
	call	omega
	mov	cx,13
	mov	si,pdata
	push	si
	inc	bx
qpari1: @CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	inc	si
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+1]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	inc	si
	add	bx,3
	loop	qpari1
	mov	pdata,si
	pop	si
	mov	es:arxdat[si+24],0
	mov	es:arxdat[si+25],0
	pop	bx
	call	apoevs
	jmp	ttel
;
qpartr: push	bx
	call	omega
	mov	cx,39
	mov	si,pdata
	push	si
	inc	bx
qpart0: @CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	inc	si
	inc	bx
	loop	qpart0
	mov	pdata,si
	pop	si
	mov	es:arxdat[si+38],0
	mov	es:arxdat[si+39],0
	mov	es:arxdat[si+40],0
	pop	bx
	call	apoevs
	jmp	ttel
;
qparst: push	bx
	call	omega
	mov	si,pdata
	inc	bx
	mov	cx,13
qpsm1:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+2]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si+13],dl
	add	bx,3
	inc	si
	loop	qpsm1
	mov	es:arxdat[si+12],0
	add	si,13
	mov	pdata,si
	pop	bx
	call	apoevs
	jmp	ttel
;
qpar:	push	bx
	call	omega
	mov	si,pdata
	inc	bx
	mov	cx,13
qpar1:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	add	bx,3
	inc	si
	loop	qpar1
	mov	pdata,si
	pop	bx
	call	apoevs
	jmp	ttel
;
qmonz:	push	bx
	mov	ax,offset cs:monazy
	call	omega
	mov	cx,13
	inc	bx
qmn2:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	inc	si
	add	bx,3
	loop	qmn2
	mov	pdata,si
	pop	bx
	mov	bin,0
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+40]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+41]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	mov	dx,bin
	rcr	dl,1
	jnc	qbar1
	mov	dl,1		;zyga
	jmp	qbar2
qbar1:	mov	dl,0		;mona
qbar2:	mov	si,pdata
	mov	es:arxdat[si],dl
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+44]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,"O"
	je	qbar3
	mov	dl,0
	jmp	qbar4
qbar3:	mov	dl,1
qbar4:	mov	es:arxdat[si+1],dl
	add	pdata,2
	jmp	ttel
;
qtriad_l:
	mov	ax,offset cs:triades_kata_seira
	jmp	qbastm

;
qsynex: mov	si,bx
	add	si,2
	mov	cx,13
qsyn1:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[si]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,32
	jne	qsyn2
	add	si,3
	loop	qsyn1
	mov	ax,offset cs:synmon
	jmp	qbastm
qsyn2:	mov	ax,offset cs:syndon
	jmp	qbastd
;
qbasth: mov	si,bx
	add	si,3
	mov	cx,13
qbas1:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[si]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,32
	jne	qbas2
	add	si,3
	loop	qbas1
	mov	cx,13
	mov	si,bx
	add	si,2
qbas3:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[si]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,32
	jne	qbas4
	add	si,3
	loop	qbas3
	mov	ax,offset cs:basmon
	jmp	qbastm
qbas2:	mov	ax,offset cs:bastri
	jmp	qbastt
qbas4:	mov	ax,offset cs:basdip
	jmp	qbastd
;
qbastm: push	bx
	call	omega
	mov	si,pdata
	inc	bx
	mov	cx,13
qb2:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	inc	si
	add	bx,3
	loop	qb2
	mov	pdata,si
	pop	bx
	call	apoevs
	jmp	ttel
;
qbastd: push	bx
	call	omega
	mov	si,pdata
	inc	bx
	mov	cx,13
qb3:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si],dl
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+1]
	@CHANGESEGM	ds,DATAS1
	call	elina
	mov	es:arxdat[si+1],dl
	add	bx,3
	add	si,2
	loop	qb3
	mov	pdata,si
	pop	bx
	call	apoevs
	jmp	ttel
;
qbastt: push	bx
	call	omega
	inc	bx
	mov	si,pdata
	mov	cx,39
t58:	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	call	elina
t59:	mov	es:arxdat[si],dl
	inc	bx
	inc	si
	loop	t58
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx]
	@CHANGESEGM	ds,DATAS1
	cmp	dl," "				;ean to apo einai " "
	je	qplhr				;tote einai plhres
	mov	pdata,si
	pop	bx
	call	apoevs
	jmp	ttel
qplhr:	mov	es:arxdat[si],13		;apo evs gia plhres
	inc	si
	mov	es:arxdat[si],14
	inc	si
	mov	es:arxdat[si],1
	inc	si
	mov	pdata,si
	pop	bx
	jmp	ttel
;
elina:	cmp	dl,"1"
	jne	el1
	mov	dl,1
	ret
el1:	cmp	dl,"2"
	jne	el2
	mov	dl,3
	ret
el2:	cmp	dl,"X"
	jne	el3
	mov	dl,2
	ret
el3:	cmp	dl,"*"
	jne	el4
	mov	dl,1
	ret
el4:	mov	dl,0
	ret
;
apoevs: mov	si,pdata
	mov	bin,0
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+40]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+41]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	mov	dx,bin
	mov	es:arxdat[si],dl
	inc	si
	mov	bin,0
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+42]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+43]
	@CHANGESEGM	ds,DATAS1
	call	dec_bin
	mov	dx,bin
	inc	dl
	mov	es:arxdat[si],dl
	inc	si
	@CHANGESEGM	ds,DATASC
	mov	dl,arxasc[bx+44]
	@CHANGESEGM	ds,DATAS1
	cmp	dl,"O"
	je	qoxi
	mov	dl,0
	jmp	qnai
qoxi:	mov	dl,1
qnai:	mov	es:arxdat[si],dl
	inc	si
	mov	pdata,si
	clc
	ret
;
omega:	mov	si,pdata
	mov	es:arxdat[si],ah
	inc	si
	mov	es:arxdat[si],al
	inc	si
	mov	pdata,si
	clc
	ret

;	
omapes: push	bx
;**************************************** OMADES GIA TIS PROTASEIS
	cmp	byte ptr [cs:telex+2],"P"
	jne	omap1
	mov	si,poipro
	xor	dh,dh
	mov	callpro[si],dx
	mov	di,pdata
	mov	callpro[si+2],di
	add	poipro,4
;****************************************
;
omap1:	@CHANGESEGM	ds,DATASC
	mov	al,arxasc[bx+47]
	@CHANGESEGM	ds,DATAS1
	mov	si,pdata
	mov	es:arxdat[si],al
	mov	ah,0
	mov	dl,6
	mul	dl
	mov	bx,ax
	mov	dx,pinak1[bx]
	mov	es:arxdat[si+1],dh
	mov	es:arxdat[si+2],dl
	mov	dx,pinak1[bx+2]
	mov	es:arxdat[si+3],dh
	mov	es:arxdat[si+4],dl
	mov	dx,pinak1[bx+4]
	mov	es:arxdat[si+5],dh
	mov	es:arxdat[si+6],dl
	add	pdata,7
	pop	bx
	ret
;
omomad: push	bx
	mov	al,byte ptr [cs:telex+2]
	sub	al,65
	mov	ah,0
	mov	dl,3
	mul	dl
	mov	ah,0
	mov	bx,ax
	mov	dl,pinak3[bx]
	mov	si,pdata
	mov	es:arxdat[si],dl
	mov	dl,pinak3[bx+1]
	mov	es:arxdat[si+1],dl
	mov	dl,pinak3[bx+2]
	mov	es:arxdat[si+2],dl
	add	pdata,3
	pop	bx
	ret
tajasc	endp

;*************************************************
;**	routines poy elegxoun mia sthlh me	**
;**	tous orous.				**
;*************************************************
triades_kata_seira  proc	near
	mov	mapo,0
	cmp	pinsthl[12],4
	jne	trikat_1
	@LMOVN	triades_pollapl,triades_poll_apo
	add	bx,14
	ret
trikat_1:
	push	bx
	mov	cx,13
	xor	ah,ah
	lea	si,pinsthl
trkop2:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	trkpo
	cmp	al,[si]
	je	trkpo
	jmp	tr_ejo
trkpo:	inc	si
	inc	bx
	loop	trkop2
	cmp	triades_pollapl[2],0
	jne	tttrr1
	cmp	triades_pollapl[0],0
	jne	tttrr1
	mov	triades_pollapl[0],1
tttrr1:	
	xor	ax,ax
	xor	dx,dx
	mov	al,es:arxdat[bx]
	mov	cx,triades_pollapl[2]
	mov	bx,triades_pollapl[0]
	call	far ptr longmul
	mov	triades_pollapl,ax
	mov	triades_pollapl[2],dx
tr_ejo:	pop	bx
	add	bx,14
	ret
triades_kata_seira	endp

stat_paketo proc	near			;statistiko paketo
	push	bx
	mov	mapo,0
	cmp	pinsthl[12],4
	je	stat_p1
	
	pop	bx
	inc	bx
	ret

stat_p1:
	pop	bx
	inc	bx
	cmp	es:arxdat[bx+1],1
	je	stat_p2
	ret
stat_p2:
	mov	mapo,1
	ret
stat_pin dw	offset	cs:basmon
	db	1,1
	dw	offset	cs:basmon
	db	1,3
	dw	offset	cs:basmon
	db	1,2
	dw	offset	cs:symetr,0
	dw	offset	cs:enalag,0
	dw	offset	cs:ajones,0
	dw	offset	cs:baros,0
	dw	offset	cs:omassvn
	db	0,1
	dw	offset	cs:omassvn
	db	0,3
	dw	offset	cs:omassvn
	db	0,2
	dw	offset	cs:dyades_syn,0
	dw	offset	cs:synmon
	db	1,1
	dw	offset	cs:synmon
	db	1,3
	dw	offset	cs:synmon
	db	1,2
	dw	offset	cs:symetr_synex,0
	dw	offset	cs:enalag_omad,0
	dw	offset	cs:synomad,0
	dw	offset	cs:baros_2,0
	dw	offset	cs:asso_xi
	db	0,3
	dw	offset	cs:asso_xi
	db	0,2
	dw	offset	cs:asso_xi
	db	0,1
	dw	offset	cs:triades_syn,0
stat_paketo endp

aurist_pinak proc	near			;auristikoi pinakes
	push	bx
	mov	mapo,0
	cmp	pinsthl[12],4
	je	auris_p1
	xor	ax,ax	
	mov	al,es:arxdat[bx]
	cmp	ax,0
	jbe	auris_p1
	cmp	ax,9
	ja	auris_p1
	dec	ax
	mov	cx,84
	mul	cx
	add	ax,2
	mov	di,ax

	mov	cx,13
	lea	si,pinsthl
	xor	ax,ax

auris_p7:
	xor	bx,bx
	mov	bl,[si]
	cmp	bx,0
	je	auris_p6
	dec	bx
	shl	bx,1
	add	ax,auristikos[di][bx]
auris_p6:
	add	di,6
	inc	si
	loop	auris_p7
	cmp	ax,auristikos[di]
	jb	auris_p9
	cmp	ax,auristikos[di+2]
	ja	auris_p9
	pop	bx
	inc	bx
	ret
auris_p9:
	mov	mapo,1
	pop	bx
	inc	bx
	ret
auris_p1:
	pop	bx
	inc	bx
	cmp	es:arxdat[bx+1],1
	je	auris_p2
	ret
auris_p2:
	mov	mapo,1
	ret
aurist_pinak	endp

dyades_syn proc	near
	mov	mapo,0
	cmp	pinsthl[12],4
	je	dys1
	xor	ax,ax
	mov	cx,12
	lea	si,pinsthl
dys_epom:
	mov	al,[si]
	cmp	al,[si+1]
	jne	dys_n
	inc	ah
dys_n:	inc	si
	loop	dys_epom
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	dys_n1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	dys_n2
	ret
dys_n1:	inc	bx
dys_n2:	mov	mapo,1
	ret
dys1:	inc	bx
	cmp	es:arxdat[bx+1],1
	je	dys_n2
	ret
dyades_syn endp
;
triades_syn proc	near
	mov	mapo,0
	cmp	pinsthl[12],4
	je	tris1
	xor	ax,ax
	mov	cx,11
	lea	si,pinsthl
tris_epom:
	mov	al,[si]
	cmp	al,[si+1]
	jne	tris_n
	cmp	al,[si+2]
	jne	tris_n
	inc	ah
tris_n:	inc	si
	loop	tris_epom
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	tris_n1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	tris_n2
	ret
tris_n1: inc	bx
tris_n2: mov	mapo,1
	ret
tris1:	inc	bx
	cmp	es:arxdat[bx+1],1
	je	tris_n2
	ret
triades_syn endp
;
symetr_synex proc	near			;synexomena symetrika
	mov	mapo,0
	cmp	pinsthl[12],4
	je	sym_syn1
	lea	si,pinsthl
	lea	di,pinsthl+12
	xor	dx,dx
	xor	ax,ax
	mov	cx,6
sym_syn2:
	mov	al,[si]
	cmp	al,[di]
	jne	sym_syn_ch
	inc	ah
sym_s_epi:
	inc	si
	dec	di
	loop	sym_syn2
	cmp	dh,ah
	jae	sym_sq
	mov	dh,ah
sym_sq:	mov	al,dh
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	sla1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	sla
	ret
sym_syn_ch:
	mov	dl,ah
	xor	ax,ax
	cmp	dh,dl
	jae	sym_s_epi
	mov	dh,dl
	jmp	sym_s_epi
sla1:	inc	bx
sla:	mov	mapo,1
	ret
sym_syn1:
	inc	bx
	cmp	es:arxdat[bx+1],1
	je	sla
	ret
symetr_synex	endp
;
enalag_omad proc near			;omades enallagvn
	mov	mapo,0
	cmp	pinsthl[12],4
	je	enal_o1
	mov	cx,12
	xor	dx,dx
	xor	ax,ax
	lea	si,pinsthl
	mov	ah,[si]
	inc	si
olft:	cmp	ah,[si]
	je	olfb
	inc	al
	mov	ah,[si]
en_ome:
	inc	si
	loop	olft
	cmp	al,0
	je	en_ome1
	inc	dh
en_ome1:
	mov	al,dh
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	eli1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	eli
	ret
olfb:	mov	dl,al
	mov	al,0
	cmp	dl,0
	je	en_ome
	inc	dh
	jmp	en_ome
eli1:	inc	bx
eli:	mov	mapo,1
	ret
;
enal_o1:
	inc	bx
	cmp	es:arxdat[bx+1],1
	je	enalo2
	ret
enalo2:	mov	mapo,1
	ret
enalag_omad endp
;
ajones	proc	near			;ajones 1x2
	mov	mapo,0
	cmp	pinsthl[12],4
	je	aj0
	mov	cx,11
	xor	ax,ax
	lea	si,pinsthl
aj_epom:
	mov	al,[si]
	cmp	al,[si+2]
	jne	aj_oxi
	inc	ah
aj_oxi:	inc	si
	loop	aj_epom
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	aj_n1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	aj_n2
	ret
aj_n1:	inc	bx
aj_n2:	mov	mapo,1
	ret
;
aj0:	inc	bx
	cmp	es:arxdat[bx+1],1
	je	aj_n2
	ret
ajones	endp
;
ajones_s	proc	near			;ajones
	mov	mapo,0
	cmp	pinsthl[12],4
	je	ajs0
	mov	cx,11
	xor	ax,ax
	lea	si,pinsthl
ajs_epom:
	mov	al,[si+1]
	cmp	al,es:arxdat[bx]
	jne	ajs_oxi
	mov	al,[si]
	cmp	al,[si+2]
	jne	ajs_oxi
	inc	ah
ajs_oxi:
	inc	si
	loop	ajs_epom
	inc	bx
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	ajs_n1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	ajs_n2
	ret
ajs_n1:	inc	bx
ajs_n2:	mov	mapo,1
	ret
;
ajs0:	inc	bx
	inc	bx
	cmp	es:arxdat[bx+1],1
	je	ajs_n2
	ret
ajones_s	endp
;
monasimia	proc	near			;mona simia
	mov	mapo,0
	cmp	pinsthl[12],4
	je	monsim0

	mov	cx,11
	xor	ax,ax
	lea	si,pinsthl
	mov	al,[si]
	cmp	al,[si+1]
	je	mons01
	inc	ah
mons01:	mov	al,[si+12]
	cmp	al,[si+11]
	je	mons02
	inc	ah
mons02:
monsim_epom:
	mov	al,[si+1]
	cmp	al,[si]
	je	monsim1
	cmp	al,[si+2]
	je	monsim1
	inc	ah
monsim1:
	inc	si
	loop	monsim_epom
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	mons_n1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	mons_n2
	ret
mons_n1:	inc	bx
mons_n2:	mov	mapo,1
	ret
;
monsim0:
	inc	bx
	cmp	es:arxdat[bx+1],1
	je	mons_n2
	ret
monasimia	endp

monades_s	proc	near			;mona simia
	mov	mapo,0
	cmp	pinsthl[12],4
	je	monasim0

	mov	cx,11
	xor	ax,ax
	lea	si,pinsthl
	mov	al,[si]
	cmp	al,es:arxdat[bx]
	jne	monas01
	cmp	al,[si+1]
	je	monas01
	inc	ah
monas01:
	mov	al,[si+12]
	cmp	al,es:arxdat[bx]
	jne	monas02
	cmp	al,[si+11]
	je	monas02
	inc	ah
monas02:
monasim_epom:
	mov	al,[si+1]
	cmp	al,es:arxdat[bx]
	jne	monasim1
	cmp	al,[si]
	je	monasim1
	cmp	al,[si+2]
	je	monasim1
	inc	ah
monasim1:
	inc	si
	loop	monasim_epom
	inc	bx
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	monas_n1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	monas_n2
	ret
monas_n1:
	inc	bx
monas_n2:
	mov	mapo,1
	ret
;
monasim0:
	inc	bx
	inc	bx
	cmp	es:arxdat[bx+1],1
	je	monas_n2
	ret
monades_s	endp

dyades	proc	near
	mov	mapo,0
	cmp	pinsthl[12],4
	jne	eidia1
	add	bx,14
	cmp	es:arxdat[bx+1],1
	jne	eidia2
	mov	mapo,1
eidia2:	ret
eidia1:
	mov	cx,13
	xor	di,di
	xor	si,si
	mov	cs:posaster,0
doup1:	cmp	es:arxdat[bx],0
	je	doupla
	mov	al,pinsthl[di]
	mov	cs:stldyad[si],al
	inc	si
	inc	cs:posaster
doupla:	inc	di
	inc	bx
	loop	doup1

	cmp	cs:posaster,2
	jae	oket1
	mov	cs:posaster,2

oket1:	push	bx
	mov	di,offset cs:dyad
	mov	cx,9
sso:	mov	byte ptr cs:[di],0
	add	di,3
	loop	sso

	xor	bx,bx
	xor	dx,dx
	xor	di,di
	mov	cx,cs:posaster
	dec	cx
pane:	mov	al,cs:stldyad[bx]
	inc	bx
	mov	ah,cs:stldyad[bx]
	
	mov	di,offset cs:dyad
	push	cx
	mov	cx,9
paner:	cmp	byte ptr cs:[di],0
	jne	oxiii0
	inc	di
	cmp	al,cs:[di]
	jne	oxiii
	inc	di
	cmp	ah,cs:[di]
	jne	oxiii1
	inc	dx

	dec	di
	dec	di
	mov	byte ptr cs:[di],1
	inc	di
	inc	di

	pop	cx
	loop	pane
	jmp	telgg

oxiii0:	inc	di
oxiii:	inc	di
oxiii1:	inc	di
	loop	paner
	pop	cx
	loop	pane

telgg:	pop	bx
	cmp	dl,es:arxdat[bx]
	jb	kopsn
	inc	bx
	cmp	dl,es:arxdat[bx]
	jae	kopsn1
	ret

kopsn:	inc	bx
kopsn1:	mov	mapo,1
	ret

stldyad	db	13 dup(0)
posaster dw	0
dyad	db	0,1,1
	db	0,1,2
	db	0,2,1
	db	0,2,2
	db	0,2,3
	db	0,3,2
	db	0,3,3
	db	0,1,3
	db	0,3,1
dyades	endp

triades	proc	near
	mov	mapo,0
	cmp	pinsthl[12],4
	jne	eitia1
	add	bx,14
	cmp	es:arxdat[bx+1],1
	jne	eitia2
	mov	mapo,1
eitia2:	ret
eitia1:
	mov	cx,13
	xor	di,di
	xor	si,si
	mov	cs:posaster,0
toup1:	cmp	es:arxdat[bx],0
	je	toupla
	mov	al,pinsthl[di]
	mov	cs:stldyad[si],al
	inc	si
	inc	cs:posaster
toupla:	inc	di
	inc	bx
	loop	toup1

	cmp	cs:posaster,3
	jae	oket2
	mov	cs:posaster,3

oket2:	push	bx
	mov	di,offset cs:triad

	mov	cx,27
tsso:	mov	byte ptr cs:[di],0
	add	di,4
	loop	tsso

	xor	bx,bx
	xor	dx,dx
	xor	di,di
	mov	cx,cs:posaster
	dec	cx
	dec	cx
tpane:	push	bx
	mov	al,cs:stldyad[bx]
	inc	bx
	mov	ah,cs:stldyad[bx]
	inc	bx
	mov	dh,cs:stldyad[bx]
	
	mov	di,offset cs:triad
	push	cx
	mov	cx,27
tpaner:	cmp	byte ptr cs:[di],0
	jne	toxiii0
	inc	di
	cmp	al,cs:[di]
	jne	toxiii
	inc	di
	cmp	ah,cs:[di]
	jne	toxiii1
	inc	di
	cmp	dh,cs:[di]
	jne	toxiii2
	inc	dl

	dec	di
	dec	di
	dec	di
	mov	byte ptr cs:[di],1
	inc	di
	inc	di
	inc	di

	pop	cx
	pop	bx
	inc	bx
	loop	tpane
	jmp	ttelgg

toxiii0: inc	di
toxiii:	 inc	di
toxiii1: inc	di
toxiii2: inc	di
	loop	tpaner
	pop	cx
	pop	bx
	inc	bx
	loop	tpane

ttelgg:	pop	bx
	cmp	dl,es:arxdat[bx]
	jb	tkopsn
	inc	bx
	cmp	dl,es:arxdat[bx]
	jae	tkopsn1
	ret

tkopsn:	inc	bx
tkopsn1: mov	mapo,1
	ret

triad	db	0,1,1,1
	db	0,1,2,1
	db	0,2,1,1
	db	0,2,2,1
	db	0,2,3,1
	db	0,3,2,1
	db	0,3,3,1
	db	0,1,3,1
	db	0,3,1,1
	db	0,1,1,2
	db	0,1,2,2
	db	0,2,1,2
	db	0,2,2,2
	db	0,2,3,2
	db	0,3,2,2
	db	0,3,3,2
	db	0,1,3,2
	db	0,3,1,2
	db	0,1,1,3
	db	0,1,2,3
	db	0,2,1,3
	db	0,2,2,3
	db	0,2,3,3
	db	0,3,2,3
	db	0,3,3,3
	db	0,1,3,3
	db	0,3,1,3
triades	endp

omassvn proc	near		;omades 1,x,2
	cmp	pinsthl[12],4
	je	omas1
	mov	mapo,0
	xor	ax,ax
	mov	dl,es:arxdat[bx]
	inc	bx
	mov	cx,13
	lea	si,pinsthl
aa:	mov	al,[si]
	cmp	al,dl
	je	ass
bb:	inc	si
	loop	aa
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	oloba1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	oloba
	ret
ass:	dec	si
	cmp	al,[si]
	jne	gg
	inc	si
	jmp	bb
gg:	inc	ah
	inc	si
	jmp	bb
oloba1: inc	bx
oloba:	mov	mapo,1
	ret
;
omas1:	mov	mapo,0
	xor	ax,ax
	mov	cx,9
	lea	si,pinsthl
	mov	dl,es:arxdat[bx]
	inc	bx
aaq:	mov	al,[si]
	cmp	al,dl
	je	assq
bbq:	inc	si
	loop	aaq
	mov	al,ah
	add	al,2
	cmp	es:arxdat[bx+2],1
	je	omaoxi
	cmp	al,es:arxdat[bx]
	jb	omret
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	olobaq
	ret
omaoxi: cmp	ah,es:arxdat[bx]
	jb	omret
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	olobaq
	ret
assq:	dec	si
	cmp	al,[si]
	jne	ggq
	inc	si
	jmp	bbq
ggq:	inc	ah
	inc	si
	jmp	bbq
omret:	inc	bx
olobaq: mov	mapo,1
	ret
omassvn endp
;
asso_xi	proc	near			;omades diplvn shmeivn
	cmp	pinsthl[12],4
	je	asso_x1
	mov	mapo,0
	xor	ax,ax
	xor	dx,dx
	mov	cx,13
	lea	si,pinsthl
	mov	al,es:arxdat[bx]
	inc	bx
ass_xi_epom:
	cmp	[si],al
	je	ass_xi_dio
	inc	dl
	jmp	ass_xi_no
ass_xi_dio:
	cmp	dl,1
	jbe	ass_xi_no_
	inc	ah
ass_xi_no_:
	xor	dx,dx
ass_xi_no:
	inc	si
	loop	ass_xi_epom
	cmp	dl,1
	jbe	ass_xi_oxi
	inc	ah
ass_xi_oxi:
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	ass_xi_fige1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	ass_xi_fige2
	ret
ass_xi_fige1:
	inc	bx
ass_xi_fige2:
	mov	mapo,1
	ret
;
asso_x1:
	mov	mapo,0
	xor	ax,ax
	xor	dx,dx
	mov	cx,9
	lea	si,pinsthl
	mov	al,es:arxdat[bx]
	inc	bx
ass_xi_epom1:
	cmp	[si],al
	je	ass_xi_dio1
	inc	dl
	jmp	ass_xi_no1
ass_xi_dio1:
	cmp	dl,1
	jbe	ass_xi_no1_
	inc	ah
ass_xi_no1_:
	xor	dx,dx
ass_xi_no1:
	inc	si
	loop	ass_xi_epom1
	cmp	dl,1
	jbe	ass_xi_oxi1
	inc	ah
ass_xi_oxi1:
	mov	al,ah
	add	al,2
	cmp	es:arxdat[bx+2],1
	je	ass_xi_ck
	cmp	al,es:arxdat[bx]
	jb	ass_xi_ret
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	ass_xi_fige3
	ret
ass_xi_ck:
	cmp	ah,es:arxdat[bx]
	jb	ass_xi_ret
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	ass_xi_fige3
	ret
ass_xi_fige3:
	mov	mapo,1
	ret
ass_xi_ret:
	mov	mapo,1
	inc	bx
	ret
asso_xi	endp
;
enalanauesi	proc	near
	cmp	pinsthl[12],4
	je	enlue1
	mov	mapo,0
	mov	cx,13
	xor	ax,ax
	xor	dx,dx
	lea	si,pinsthl
enlue4:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	enlue5
	cmp	ah,0
	jne	enlue6
	mov	ah,[si]
	jmp	enlue5
enlue6:	cmp	ah,[si]
	je	enlue5
	inc	dx
	mov	ah,[si]
enlue5:	inc	bx
	inc	si
	loop	enlue4
	mov	al,dl
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	enlue7
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	enlue8
	ret
enlue7:	inc	bx
enlue8:	mov	mapo,1
	ret

enlue1: cmp	es:arxdat[bx+15],1
	je	enlue2
	mov	mapo,0
	add	bx,14
	ret
enlue2: add	bx,14
	mov	mapo,1
	ret
enalanauesi	endp

enalsinexom	proc	near
	cmp	pinsthl[12],4
	je	enlsi1
	mov	mapo,0
	mov	cx,13
	xor	ax,ax
	xor	dx,dx
	lea	si,pinsthl
enlsi4:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	enlsi5
	cmp	ah,0
	jne	enlsi6
	mov	ah,[si]
	jmp	enlsi5
enlsi6:	cmp	ah,[si]
	jne	enlsi10
	cmp	dl,dh
	jb	enlsi11
	mov	dh,0
	jmp	enlsi5
enlsi11: mov	dl,dh
	 mov	dh,0
	 jmp	enlsi5
enlsi10: inc	dh
	mov	ah,[si]
enlsi5:	inc	bx
	inc	si
	loop	enlsi4
	cmp	dl,dh
	jae	enlsi12
	mov	dl,dh
enlsi12:
	mov	al,dl
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	enlsi7
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	enlsi8
	ret
enlsi7:	inc	bx
enlsi8:	mov	mapo,1
	ret

enlsi1: cmp	es:arxdat[bx+15],1
	je	enlsi2
	mov	mapo,0
	add	bx,14
	ret
enlsi2: add	bx,14
	mov	mapo,1
	ret
enalsinexom	endp

enalag	proc	near		;enallages
	cmp	pinsthl[12],4
	je	enal1
	push	bx
	mov	mapo,0
	xor	bl,bl
	mov	cx,12
	lea	si,pinsthl
	mov	ah,[si]
	inc	si
lft:	mov	al,[si]
	cmp	ah,al
	jne	aym
lfb:	mov	ah,al
	inc	si
	loop	lft
	mov	al,bl
	pop	bx
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	li1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	li
	ret
aym:	inc	bl
	jmp	lfb
li1:	inc	bx
li:	mov	mapo,1
	ret
;
enal1:	mov	mapo,0
	push	bx
	xor	bl,bl
	mov	cx,8
	lea	si,pinsthl
	mov	ah,[si]
	inc	si
lftq:	mov	al,[si]
	cmp	ah,al
	jne	aymq
lfbq:	mov	ah,al
	inc	si
	loop	lftq
	mov	al,bl
	pop	bx
	mov	ah,al
	add	ah,4
	cmp	es:arxdat[bx+2],1
	je	enoxi
	cmp	ah,es:arxdat[bx]
	jb	li1q
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	liq
	ret
enoxi:	cmp	al,es:arxdat[bx]
	jb	li1q
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	liq
	ret
aymq:	inc	bl
	jmp	lfbq
li1q:	inc	bx
liq:	mov	mapo,1
	ret
enalag	endp
;
symetr	proc	near		;summetrika
	mov	mapo,0
	cmp	pinsthl[12],4
	je	sym1
	push	bx
	xor	bl,bl
	lea	si,pinsthl
	lea	di,pinsthl+12
	mov	cx,6
mngr1:	mov	al,[si]
	mov	ah,[di]
	cmp	al,ah
	je	poyt
mngr2:	inc	si
	dec	di
	loop	mngr1
	mov	al,bl
	pop	bx
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	la1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	la
	ret
poyt:	inc	bl
	jmp	mngr2
la1:	inc	bx
la:	mov	mapo,1
	ret
sym1:	inc	bx
	cmp	es:arxdat[bx+1],1
	je	sym2
	ret
sym2:	mov	mapo,1
	ret
symetr	endp
;
baros	proc	near		;baros
	cmp	pinsthl[12],4
	je	bar1
	mov	mapo,0
	mov	cx,13
	xor	ah,ah
	lea	si,pinsthl
beros:	add	ah,[si]
	inc	si
	loop	beros
	sub	ah,13
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	na1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	na
	ret
na1:	inc	bx
na:	mov	mapo,1
	ret
;
bar1:	mov	mapo,0
	mov	cx,9
	xor	ah,ah
	lea	si,pinsthl
berosq: add	ah,[si]
	inc	si
	loop	berosq
	sub	ah,9
	cmp	es:arxdat[bx+2],1
	je	baroxi
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	naq
	ret
baroxi: cmp	ah,es:arxdat[bx]
	jb	na1q
	add	ah,8
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	naq
	ret
na1q:	inc	bx
naq:	mov	mapo,1
	ret
baros	endp
;
emfgen	proc	near
	mov	mapo,0
	cmp	pinsthl[12],4
	je	@emf01
	mov	ax,g_emf
	mov	g_emf,0
	cmp	al,es:arxdat[bx]
	jb	@emf02
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	@emf03
	ret
@emf02: inc	bx
@emf03: mov	mapo,1
	ret
@emf01: inc	bx
	cmp	es:arxdat[bx+1],1
	je	@emf03
	ret
emfgen	endp
;
emfgenXn	proc	near
	mov	mapo,0
	cmp	pinsthl[12],4
	je	@emfx01
	xor	cx,cx
	mov	cl,es:arxdat[bx]
	inc	bx
	xor	dx,dx
	xor	ax,ax
	mov	al,es:arxdat[bx]
	mul	cx
	cmp	g_emf,ax
	jb	@emfx02
	inc	bx
	xor	dx,dx
	xor	ax,ax
	mov	al,es:arxdat[bx]
	dec	al
	mul	cx
	cmp	g_emf,ax
	ja	@emfx03
	mov	g_emf,0
	ret
@emfx02: inc	bx
@emfx03: mov	mapo,1
	ret
@emfx01:
	inc	bx
	inc	bx
	cmp	es:arxdat[bx+1],1
	jne	@emfx04
	mov	mapo,1
@emfx04: ret
emfgenXn	endp
;
periodo proc	near
	mov	mapo,0
	cmp	pinsthl[12],4
	je	perod0
	inc	periodos
	mov	ah,periodos
	cmp	ah,es:arxdat[bx]
	jb	noperi
	mov	periodos,0
	inc	bx
	ret
noperi: inc	bx
noper1: mov	mapo,1
	ret
perod0: inc	bx
	cmp	es:arxdat[bx+1],1
	je	noper1
	ret
periodo endp
;
baros_2 proc	near		;baros
	cmp	pinsthl[12],4
	je	bar1_2
	mov	mapo,0
	mov	cx,13
	xor	ax,ax
	lea	si,pinsthl
beros_2:
	mov	al,[si]
	cmp	al,1
	je	_as
	cmp	al,3
	je	_di
_pisv:	inc	si
	loop	beros_2
	jmp	_df

_di:	inc	ah
_as:	inc	ah
	jmp	_pisv

_df:	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	na1_2
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	na_2
	ret
na1_2:	inc	bx
na_2:	mov	mapo,1
	ret

_di1:	inc	ah
_as1:	inc	ah
	jmp	_pisv1

bar1_2: mov	mapo,0
	mov	cx,8
	xor	ax,ax
	lea	si,pinsthl
berosq_2:
	mov	al,[si]
	cmp	al,1
	je	_as1
	cmp	al,3
	je	_di1
_pisv1: inc	si
	loop	berosq_2
	cmp	es:arxdat[bx+2],1
	je	baroxi_2
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	naq_2
	ret
baroxi_2:
	cmp	ah,es:arxdat[bx]
	jb	na1q_2
	add	ah,10
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	naq_2
	ret
na1q_2: inc	bx
naq_2:	mov	mapo,1
	ret
baros_2 endp
;
genika_par proc	near		;genika paragvga
	cmp	pinsthl[12],4
	je	gen1
	mov	mapo,0
	mov	cx,13
	xor	ax,ax
	lea	si,pinsthl
	mov	al,es:arxdat[bx]
ikop2:	cmp	al,[si]
	jne	ikpo
	inc	ah
ikpo:	inc	si
	loop	ikop2
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	inc	bx
	cmp	al,es:arxdat[bx]
	jb	ilo1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	ilo
	ret
ilo1:	inc	bx
ilo:	mov	mapo,1
	ret
gen1:	mov	mapo,0
	mov	cx,9
	xor	ax,ax
	lea	si,pinsthl
	mov	al,es:arxdat[bx]
ikop2q: cmp	al,[si]
	jne	ikpoq
	inc	ah
ikpoq:	inc	si
	loop	ikop2q
	inc	bx
	mov	al,ah
	add	al,4
	cmp	es:arxdat[bx+2],1
	je	ibamoxi
	cmp	al,es:arxdat[bx]
	jb	ilo1q
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	iloq
	ret
ibamoxi:
	cmp	ah,es:arxdat[bx]
	jb	ilo1q
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	iloq
	ret
ilo1q:	inc	bx
iloq:	mov	mapo,1
	ret
genika_par	endp
;
basmon	proc	near		;basikes mones sthles
	cmp	pinsthl[12],4
	je	basm1
	mov	mapo,0
	mov	cx,13
	xor	ah,ah
	lea	si,pinsthl
kop2:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	kpo
	cmp	al,[si]
	je	naia
kpo:	inc	si
	inc	bx
	loop	kop2
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	lo1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	lo
	ret
naia:	inc	ah
	jmp	kpo
lo1:	inc	bx
lo:	mov	mapo,1
	ret
basm1:	mov	mapo,0
	mov	cx,9
	xor	ah,ah
	lea	si,pinsthl
kop2q:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	kpoq
	cmp	al,[si]
	je	naiaq
kpoq:	inc	si
	inc	bx
	loop	kop2q
	add	bx,4
	mov	al,ah
	add	al,4
	cmp	es:arxdat[bx+2],1
	je	bamoxi
	cmp	al,es:arxdat[bx]
	jb	lo1q
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	loq
	ret
bamoxi: cmp	ah,es:arxdat[bx]
	jb	lo1q
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	loq
	ret
naiaq:	inc	ah
	jmp	kpoq
lo1q:	inc	bx
loq:	mov	mapo,1
	ret
basmon	endp
;
basdip	proc	near		;basikes diples sthles
	cmp	pinsthl[12],4
	je	basd1
	mov	mapo,0
	mov	cx,13
	xor	ah,ah
	lea	si,pinsthl
kop1:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	kaliaz
	cmp	al,[si]
	je	naiz
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	lox1
	cmp	al,[si]
	je	naiz1
lox1:	inc	si
	inc	bx
	loop	kop1
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	ma1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	ma
	ret
kaliaz: inc	bx
	jmp	lox1
naiz:	inc	bx
naiz1:	inc	ah
	jmp	lox1
ma1:	inc	bx
ma:	mov	mapo,1
	ret
;
basd1:	mov	mapo,0
	mov	cx,9
	xor	ah,ah
	lea	si,pinsthl
kop1q:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	kaliazq
	cmp	al,[si]
	je	naizq
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	lox1q
	cmp	al,[si]
	je	naiz1q
lox1q:	inc	si
	inc	bx
	loop	kop1q
	add	bx,8
	mov	al,ah
	add	al,4
	cmp	es:arxdat[bx+2],1
	je	bsdoxi
	cmp	al,es:arxdat[bx]
	jb	ma1q
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	maq
	ret
bsdoxi: cmp	ah,es:arxdat[bx]
	jb	ma1q
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	maq
	ret
kaliazq: inc	bx
	jmp	lox1q
naizq:	inc	bx
naiz1q: inc	ah
	jmp	lox1q
ma1q:	inc	bx
maq:	mov	mapo,1
	ret
basdip	endp
;
;
bastri	proc	near			;basikes triples sthles
	cmp	pinsthl[12],4
	je	bast1
	mov	mapo,0
	mov	cx,13
	xor	ah,ah
	lea	si,pinsthl
kop:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	kalia
	cmp	[si],al
	je	nai0
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	kalia1
	cmp	al,[si]
	je	nai1
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	lox
	cmp	al,[si]
	je	nai2
lox:	inc	si
	inc	bx
	loop	kop
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	mh1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	mh
	ret
nai0:	inc	bx
nai1:	inc	bx
nai2:	inc	ah
	jmp	lox
kalia:	inc	bx
kalia1: inc	bx
	jmp	lox
mh1:	inc	bx
mh:	mov	mapo,1
	ret
;
bast1:	mov	mapo,0
	mov	cx,9
	xor	ah,ah
	lea	si,pinsthl
kopq:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	kaliaq
	cmp	[si],al
	je	nai0q
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	kalia1q
	cmp	al,[si]
	je	nai1q
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	loxq
	cmp	al,[si]
	je	nai2q
loxq:	inc	si
	inc	bx
	loop	kopq
	add	bx,12
	mov	al,ah
	add	al,4
	cmp	es:arxdat[bx+2],1
	je	bstoxi
	cmp	al,es:arxdat[bx]
	jb	mh1q
	inc	bx
	cmp	ah,es:arxdat[bx]
	jae	mhq
	ret
bstoxi: cmp	ah,es:arxdat[bx]
	jb	mh1q
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	mhq
	ret
nai0q:	inc	bx
nai1q:	inc	bx
nai2q:	inc	ah
	jmp	loxq
kaliaq: inc	bx
kalia1q:
	inc	bx
	jmp	loxq
mh1q:	inc	bx
mhq:	mov	mapo,1
	ret
bstrt:	add	bx,40
	mov	mapo,1
	ret
bastri	endp
;
omsyn	proc	near		;omades synexomenvn
	cmp	pinsthl[12],4
	je	oqms1
	mov	mapo,0
	xor	ah,ah
	lea	si,pinsthl
	mov	cx,13
palis:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	keno
	cmp	al,[si]
	je	nai
keno:	inc	bx
	inc	si
	loop	palis
ejvsh:	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	lii1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	lii
	ret
lii1:	inc	bx
lii:	mov	mapo,1
	ret
nai:	loop	oxi
ejvsh1: inc	bx
	jmp	ejvsh
oxi:	inc	bx
	inc	si
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	nai
	cmp	al,[si]
	jne	keno
	inc	ah
oxi2:	loop	oxi1
	jmp	ejvsh1
oxi1:	inc	bx
	inc	si
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	oxi2
	cmp	al,[si]
	je	oxi2
	jmp	keno
;
oqms1:	cmp	es:arxdat[bx+15],1
	je	omsrt
	mov	mapo,0
	xor	ah,ah
	lea	si,pinsthl
	mov	cx,9
palisp: mov	al,es:arxdat[bx]
	cmp	al,0
	je	kenop
	cmp	al,[si]
	je	naip
kenop:	inc	bx
	inc	si
	loop	palisp
ejvshp: add	bx,5
	cmp	ah,es:arxdat[bx]
	jae	liip
	ret
liip:	mov	mapo,1
	ret
naip:	loop	oxip
	jmp	ejvsh1p
oxip:	inc	bx
	inc	si
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	naip
	cmp	al,[si]
	jne	kenop
	inc	ah
oxi2p:	loop	oxi1p
ejvsh1p: inc	bx
	jmp	ejvshp
oxi1p:	inc	bx
	inc	si
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	oxi2p
	cmp	al,[si]
	je	oxi2p
	jmp	kenop
omsrt:	add	bx,14
	mov	mapo,1
	ret
omsyn	endp
;
parsmo	proc	near		;parastaseis staueres me orous
	cmp	pinsthl[12],4
	jne	parsm1
	jmp	parsm2
parsm1: push	bx
	xor	ah,ah
	mov	mapo,ah
	mov	cx,13
	lea	di,pinsthl1
vrvm:	mov	[di],ah
	inc	di
	loop	vrvm
	mov	cx,13
	lea	si,pinsthl2
	lea	di,pinsthl1
colitm: cmp	es:arxdat[bx],1
	jne	colotm
	mov	al,[si]
	mov	[di],al
	inc	di
	inc	ah
colotm: inc	si
	inc	bx
	loop	colitm
	lea	si,pinsthl1
	cmp	ah,0
	je	clabm
	mov	cl,ah
	xor	ah,ah
kobam:	mov	al,es:arxdat[bx]
	cmp	al,[si]
	je	idiazm
kloam:	inc	si
	loop	kobam
	pop	bx
	add	bx,26
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	clab1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	clab2
	jmp	moynb
clabm:	pop	bx
	add	bx,26
clab1:	inc	bx
clab2:	mov	mapo,1
	ret
idiazm: push	bx
	push	si
kliem:	inc	bx
	inc	si
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	vjvm
	cmp	al,[si]
	je	kliem
	pop	si
	pop	bx
	jmp	kloam
vjvm:	pop	di
	pop	bx
	push	di
hhkm:	mov	byte ptr [di],0
	inc	di
	cmp	si,di
	ja	hhkm
	inc	ah
	pop	si
	jmp	kloam
moynb:	mov	al,es:arxdat[bx+1]
	cmp	al,0
	je	moynam
	ret
moynam: push	bx
	sub	bx,27
	mov	cx,13
	lea	si,pinsthl1
	lea	di,pinsthl2
moynim: cmp	es:arxdat[bx],1
	jne	kolosm
	mov	al,[si]
	mov	[di],al
	inc	si
kolosm: inc	bx
	inc	di
	loop	moynim
	pop	bx
	ret
parsm2: cmp	es:arxdat[bx+28],0
	je	parsm3
	add	bx,27
	mov	mapo,1
	ret
parsm3: add	bx,27
	mov	mapo,0
	ret
parsmo	endp
;
parsxo	proc	near		;parastaseis staueres xvris orous
	mov	mapo,0
	cmp	pinsthl[12],4
	jne	psx1
	add	bx,27
	cmp	es:arxdat[bx+1],1
	je	psx2
	ret
psx2:	mov	mapo,1
	ret
psx1:	xor	ah,ah
	push	bx
	mov	cx,13
	lea	di,pinsthl1
vrv:	mov	[di],ah
	inc	di
	loop	vrv
	mov	cx,13
	lea	si,pinsthl2
	lea	di,pinsthl1
colita: cmp	es:arxdat[bx],1
	jne	colota
	mov	al,[si]
	mov	[di],al
	inc	di
	inc	ah
colota: inc	si
	inc	bx
	loop	colita
	lea	si,pinsthl1
	cmp	ah,0
	je	clab
	mov	cl,ah
	xor	ah,ah
koba:	mov	al,es:arxdat[bx]
	cmp	al,[si]
	je	idiaz
kloa:	inc	si
	loop	koba
clab:	pop	bx
	add	bx,27
	mov	mapo,1
	ret
idiaz:	push	bx
	push	si
klie:	inc	bx
	inc	si
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	vjv
	cmp	al,[si]
	je	klie
	pop	si
	pop	bx
	jmp	kloa
vjv:	pop	di
	pop	bx
hhk:	mov	byte ptr [di],0
	inc	di
	cmp	si,di
	ja	hhk
	pop	bx
	mov	al,es:arxdat[bx+28]
	cmp	al,mapo
	je	moynar
	add	bx,27
	ret
moynar: push	bx
	mov	cx,13
	lea	si,pinsthl1
	lea	di,pinsthl2
moyni:	cmp	es:arxdat[bx],1
	jne	kolos
	mov	al,[si]
	mov	[di],al
	inc	si
kolos:	inc	bx
	inc	di
	loop	moyni
        pop     bx
        add     bx,27
	ret
parsxo	endp
;
paremo	proc	near		;parastaseis eleyueres me orous
	cmp	pinsthl[12],4
	jne	parem1
	jmp	parem2
parem1: xor	ah,ah
	lea	si,pinsthl1
	mov	cx,13
rrv:	mov	[si],ah
	inc	si
	loop	rrv
	mov	mapo,ah
	mov	cx,13
	lea	si,pinsthl
	lea	di,pinsthl1
	push	bx
folita: cmp	es:arxdat[bx],1
	jne	loloti
	mov	al,[si]
	mov	[di],al
	inc	di
	inc	ah
loloti: inc	bx
	inc	si
	loop	folita
	cmp	ah,0
	je	ejv2
	lea	di,pinsthl1
	mov	cl,ah
	xor	ah,ah
lib:	mov	al,[di]
	cmp	al,es:arxdat[bx]
	je	idie
elab:	inc	di
	loop	lib
	jmp	ejv1
idie:	push	bx
	push	di
klib:	inc	di
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	ek
	cmp	al,[di]
	je	klib
	pop	di
	pop	bx
	jmp	elab
ek:	pop	di
	pop	bx
	inc	ah
	jmp	elab
ejv1:	pop	bx
	add	bx,26
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	moyt
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	moyf
	ret
ejv2:	pop	bx
	add	bx,26
moyt:	inc	bx
moyf:	mov	mapo,1
	ret
parem2: cmp	es:arxdat[bx+28],0
	je	parem3
	add	bx,27
	mov	mapo,1
	ret
parem3: mov	mapo,0
	add	bx,27
	ret
paremo	endp
;
parexo	proc	near		;parastaseis eleyueres xvris orous
	mov	mapo,0
	cmp	pinsthl[12],4
	jne	prx1
	add	bx,27
	cmp	es:arxdat[bx+1],1
	jne	mpouri
	mov	mapo,1
mpouri: ret
prx1:	xor	ah,ah
	lea	si,pinsthl1
	mov	cx,13
rrvx:	mov	[si],ah
	inc	si
	loop	rrvx
	mov	cx,13
	lea	si,pinsthl
	lea	di,pinsthl1
	push	bx
folitx: cmp	es:arxdat[bx],1
	jne	lolotx
	mov	al,[si]
	mov	[di],al
	inc	di
	inc	ah
lolotx: inc	bx
	inc	si
	loop	folitx
	cmp	ah,0
	je	ejv2x
	lea	di,pinsthl1
	mov	cl,ah
	xor	ah,ah
libx:	mov	al,[di]
	cmp	al,es:arxdat[bx]
	je	idiex
elabx:	inc	di
	loop	libx
	jmp	ejv2x
idiex:	push	bx
	push	di
klibx:	inc	di
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	ekx
	cmp	al,[di]
	je	klibx
	pop	di
	pop	bx
	jmp	elabx
ekx:	pop	di
	pop	bx
	pop	bx
	add	bx,27
	ret
ejv2x:	pop	bx
	add	bx,27
qwera:	mov	mapo,1
	ret
parexo	endp
;
parago	proc	near		;paragvga
	cmp	pinsthl[12],4
	je	parag1
	mov	di,bx
	mov	bl,1
	mov	mapo,0
	xor	ah,ah
	mov	cx,13
	lea	si,pinsthl
pipa:	cmp	es:arxdat[di],0
	je	poph
	cmp	byte ptr [si],1
	je	aass
	cmp	byte ptr [si],2
	je	xxii
poph:	inc	si
	inc	di
	loop	pipa
	cmp	ah,es:arxdat[di]
	jne	kla1
	inc	di
	cmp	bl,es:arxdat[di]
	jne	kla
	jmp	klai
	ret
kla1:	inc	di
kla:	mov	mapo,1
klai:	mov	bx,di
	ret
aass:	inc	ah
	jmp	poph
xxii:	inc	bl
	jmp	poph
;
parag1: cmp	es:arxdat[bx+15],1
	je	parag2
	mov	di,bx
	mov	bl,1
	mov	mapo,0
	xor	ah,ah
	mov	cx,9
	lea	si,pinsthl
pipap:	cmp	es:arxdat[di],0
	je	pophp
	cmp	byte ptr [si],1
	je	aassp
	cmp	byte ptr [si],2
	je	xxiip
pophp:	inc	si
	inc	di
	loop	pipap
	add	di,4
	cmp	ah,es:arxdat[di]
	ja	kla1p
	inc	di
	cmp	bl,es:arxdat[di]
	ja	klap
	mov	bx,di
	ret
kla1p:	inc	di
klap:	mov	mapo,1
	mov	bx,di
	ret
parag2: add	bx,14
	mov	mapo,1
	ret
aassp:	inc	ah
	jmp	pophp
xxiip:	inc	bl
	jmp	pophp
parago	endp
;
monazy	proc	near		;mona-zuga
	mov	mapo,0
	cmp	pinsthl[12],4
	jne	monz9
	add	bx,13
	cmp	es:arxdat[bx+1],1
	je	monz8
	ret
monz8:	mov	mapo,1
	ret
monz9:	mov	cx,13
	xor	ah,ah
	lea	si,pinsthl
kop5:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	lpo
	cmp	al,[si]
	je	naik
lpo:	inc	bx
	inc	si
	loop	kop5
	rcr	ah,1
	mov	ah,0
	rcl	ah,1
	xor	ah,es:arxdat[bx]
	jne	ko
	ret
naik:	inc	ah
	jmp	lpo
ko:	mov	mapo,1
	ret
monazy	endp
;
synmon	proc	near
	cmp	pinsthl[12],4
	jne	synm4
	jmp	synm9
synm4:	mov	mapo,0
	lea	si,pinsthl
	xor	ax,ax
	mov	cx,13
synm_loop:
	mov	dl,es:arxdat[bx]
	cmp	dl,0
	je	synm_keno
	cmp	[si],dl
	jne	synm_1
	inc	ah
synm_keno:
	inc	si
	inc	bx
	loop	synm_loop
	jmp	synm_out
synm_1:	cmp	al,ah
	jae	synm_xno
	mov	al,ah
synm_xno:
	mov	ah,0
	inc	si
	inc	bx
	loop	synm_loop
synm_out:
	cmp	al,ah
	jae	synm_xnr
	mov	al,ah
synm_xnr:
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	synm_cut1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	synm_cut2
	ret
synm_cut1:
	inc	bx
synm_cut2:
	mov	mapo,1
	ret
;
synm9:	cmp	es:arxdat[bx+15],0
	je	synm_n
	add	bx,14
	mov	mapo,1
	ret
synm_n:	mov	mapo,0
	lea	si,pinsthl
	xor	ax,ax
	mov	cx,9
synm_loop1:
	mov	dl,es:arxdat[bx]
	cmp	dl,0
	je	synm_keno1
	cmp	[si],dl
	jne	synm_11
	inc	ah
synm_keno1:
	inc	si
	inc	bx
	loop	synm_loop1
	jmp	synm_out1
synm_11:
	cmp	al,ah
	jae	synm_xno1
	mov	al,ah
synm_xno1:
	mov	ah,0
	inc	si
	inc	bx
	loop	synm_loop1
synm_out1:
	cmp	al,ah
	jae	synm_xnr1
	mov	al,ah
synm_xnr1:
	add	bx,5
	cmp	al,es:arxdat[bx]
	jae	synm_cut2
	ret
synmon	endp
;
syndon	proc	near
	cmp	pinsthl[12],4
	jne	synd4
	jmp	synd9
synd4:	mov	mapo,0
	lea	si,pinsthl
	xor	ax,ax
	mov	cx,13
synd_loop:
	mov	dl,es:arxdat[bx]
	cmp	dl,0
	je	synd_keno
	cmp	[si],dl
	je	synd_ok
	mov	dl,es:arxdat[bx+1]
	cmp	[si],dl
	jne	synd_1
synd_ok:
	inc	ah
synd_keno:
	inc	si
	inc	bx
	inc	bx
	loop	synd_loop
	jmp	synd_out
synd_1:	cmp	al,ah
	jae	synd_xno
	mov	al,ah
synd_xno:
	mov	ah,0
	inc	si
	inc	bx
	inc	bx
	loop	synd_loop
synd_out:
	cmp	al,ah
	jae	synd_xnr
	mov	al,ah
synd_xnr:
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	synd_cut1
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	synd_cut2
	ret
synd_cut1:
	inc	bx
synd_cut2:
	mov	mapo,1
	ret
;
synd9:	cmp	es:arxdat[bx+28],0
	je	synd_n
	add	bx,27
	mov	mapo,1
	ret
synd_n:	mov	mapo,0
	lea	si,pinsthl
	xor	ax,ax
	mov	cx,9
synd_loop1:
	mov	dl,es:arxdat[bx]
	cmp	dl,0
	je	synd_keno1
	cmp	[si],dl
	je	synd_ok1
	mov	dl,es:arxdat[bx+1]
	cmp	[si],dl
	jne	synd_11
synd_ok1:
	inc	ah
synd_keno1:
	inc	si
	inc	bx
	inc	bx
	loop	synd_loop1
	jmp	synd_out1
synd_11:
	cmp	al,ah
	jae	synd_xno1
	mov	al,ah
synd_xno1:
	mov	ah,0
	inc	si
	inc	bx
	inc	bx
	loop	synd_loop1
synd_out1:
	cmp	al,ah
	jae	synd_xnr1
	mov	al,ah
synd_xnr1:
	add	bx,9
	cmp	al,es:arxdat[bx]
	jae	synd_cut21
	ret
synd_cut21:
	mov	mapo,1
	ret
syndon	endp
;
pardip	proc	near		;diples parastaseis
	cmp	pinsthl[12],4
	je	prdp1
	mov	mapo,0
	lea	si,pinsthl
	mov	cx,13
	xor	ah,ah
libd:	mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	idied
	cmp	es:arxdat[bx+1],0
	je	elabd
	cmp	al,es:arxdat[bx+1]
	je	idied
elabd:	inc	si
	loop	libd
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	add	bx,26
	cmp	al,es:arxdat[bx]
	jb	moytd
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	moyfd
	ret
idied:	push	bx
	push	si
klibd:	add	bx,2
	inc	si
	cmp	es:arxdat[bx],0
	je	ekd
	mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	klibd
	cmp	es:arxdat[bx+1],0
	je	nklibdn
	cmp	al,es:arxdat[bx+1]
	je	klibd
nklibdn: pop	si
	pop	bx
	jmp	elabd
ekd:	pop	si
	pop	bx
	inc	ah
	jmp	elabd
moytd:	inc	bx
moyfd:	mov	mapo,1
	ret
;
prdp1:	cmp	es:arxdat[bx+28],1
	je	prdp2
	mov	mapo,0
	lea	si,pinsthl
	mov	cx,9
	xor	ah,ah
libdp:	mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	idiedp
	cmp	al,es:arxdat[bx+1]
	je	idiedp
elabdp: inc	si
	loop	libdp
	add	bx,27
	cmp	ah,es:arxdat[bx]
	jae	moyfdp
	ret
prdp2:	add	bx,27
	mov	mapo,1
	ret
idiedp: push	bx
	push	si
klibdp: add	bx,2
	inc	si
	cmp	es:arxdat[bx],0
	je	ekdp
	mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	klibdp
	cmp	al,es:arxdat[bx+1]
	je	klibdp
	pop	si
	pop	bx
	jmp	elabdp
ekdp:	pop	si
	pop	bx
	inc	ah
	jmp	elabdp
moyfdp: mov	mapo,1
	ret
pardip	endp
;
partri	proc	near		;triples parastaseis
	cmp	pinsthl[12],4
	jne	prtr
	jmp	prtr1
prtr:	mov	mapo,0
	lea	si,pinsthl
	mov	cx,13
	xor	ah,ah
tlibd:	mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	tidied
	cmp	es:arxdat[bx+1],0
	je	telabd
	cmp	al,es:arxdat[bx+1]
	je	tidied
	cmp	es:arxdat[bx+2],0
	je	telabd
	cmp	al,es:arxdat[bx+2]
	je	tidied
telabd: inc	si
	loop	tlibd
	add	bx,39
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	tmoytd
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	tmoyfd
	ret
tidied: push	bx
	push	si
tklibd: add	bx,3
	inc	si
	cmp	es:arxdat[bx],0
	je	tekd
	mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	tklibd
	cmp	es:arxdat[bx+1],0
	je	ntklibd
	cmp	al,es:arxdat[bx+1]
	je	tklibd
	cmp	es:arxdat[bx+2],0
	je	ntklibd
	cmp	al,es:arxdat[bx+2]
	je	tklibd
ntklibd: pop	si
	pop	bx
	jmp	telabd
tekd:	pop	si
	pop	bx
	inc	ah
	jmp	telabd
tmoytd: inc	bx
tmoyfd: mov	mapo,1
	ret
;
prtr1:	cmp	es:arxdat[bx+41],1
	je	tprtr2
	mov	mapo,0
	lea	si,pinsthl
	mov	cx,9
	xor	ah,ah
tlibdp: mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	tidiedp
	cmp	es:arxdat[bx+1],0
	je	telabdp
	cmp	al,es:arxdat[bx+1]
	je	tidiedp
	cmp	es:arxdat[bx+2],0
	je	telabdp
	cmp	al,es:arxdat[bx+2]
	je	tidiedp
telabdp: inc	si
	loop	tlibdp
	add	bx,40
	cmp	ah,es:arxdat[bx]
	jae	tmoyfdp
	ret
tprtr2:	add	bx,40
tmoyfdp: mov	mapo,1
	 ret
tidiedp: push	bx
	 push	si
tklibdp: add	bx,3
	inc	si
	cmp	es:arxdat[bx],0
	je	tekdp
	mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	tklibdp
	cmp	es:arxdat[bx+1],0
	je	ntklibdp
	cmp	al,es:arxdat[bx+1]
	je	tklibdp
	cmp	es:arxdat[bx+2],0
	je	ntklibdp
	cmp	al,es:arxdat[bx+2]
	je	tklibdp
ntklibdp: pop	si
	pop	bx
	jmp	telabdp
tekdp:	pop	si
	pop	bx
	inc	ah
	jmp	telabdp
partri	endp
;
parmon	proc	near		;mones parastaseis
	cmp	pinsthl[12],4
	je	prmp1
	mov	mapo,0
	lea	si,pinsthl
	mov	cx,13
	xor	ah,ah
libp:	mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	idiep
elabp:	inc	si
	loop	libp
	add	bx,13
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	moytp
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	moyfp
	ret
idiep:	push	bx
	push	si
klibp:	inc	si
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	ekp
	cmp	al,[si]
	je	klibp
	pop	si
	pop	bx
	jmp	elabp
ekp:	pop	si
	pop	bx
	inc	ah
	jmp	elabp
moytp:	inc	bx
moyfp:	mov	mapo,1
	ret
;
prmp1:	cmp	es:arxdat[bx+15],1
	je	prmp2
	mov	mapo,0
	lea	si,pinsthl
	mov	cx,9
	xor	ah,ah
libpp:	mov	al,[si]
	cmp	al,es:arxdat[bx]
	je	idiepp
elabpp: inc	si
	loop	libpp
	add	bx,14
	cmp	ah,es:arxdat[bx]
	jae	moyfpp
	ret
prmp2:	add	bx,14
	mov	mapo,1
	ret
idiepp: push	bx
	push	si
klibpp: inc	si
	inc	bx
	mov	al,es:arxdat[bx]
	cmp	al,0
	je	ekpp
	cmp	al,[si]
	je	klibpp
	pop	si
	pop	bx
	jmp	elabpp
ekpp:	pop	si
	pop	bx
	inc	ah
	jmp	elabpp
moyfpp: mov	mapo,1
	ret
parmon	endp
;
barana	proc	near		;baros ana uesh
	cmp	pinsthl[12],4
	je	barsu1
	mov	mapo,0
	mov	cx,13
	xor	ah,ah
	lea	si,pinsthl
barn1:	mov	al,es:arxdat[bx]
	cmp	al,0
	je	barn2
	add	ah,[si]
	dec	ah
barn2:	inc	bx
	inc	si
	loop	barn1
	mov	al,ah
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	barn3
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	barn4
	ret
barn3:	inc	bx
barn4:	mov	mapo,1
	ret
;
barsu1: cmp	es:arxdat[bx+15],1
	je	barsu2
	mov	mapo,0
	add	bx,14
	ret
barsu2: add	bx,14
	mov	mapo,1
	ret
barana	endp
;
synomad proc	near			;omades 12x
	mov	mapo,0
	cmp	pinsthl[12],4
	jne	pip1
	jmp	pipi9
pip1:	xor	ax,ax
	xor	di,di
	lea	si,pinsthl
	mov	al,[si]
	inc	si
	mov	cx,13
goril1: cmp	al,[si]
	jne	kok
	inc	ah
kok1:	inc	si
	loop	goril1
	mov	ax,di
	mov	ah,0
	add	g_emf,ax
	cmp	al,es:arxdat[bx]
	jb	gril
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	gril1
	ret
gril:	inc	bx
gril1:	mov	mapo,1
	ret
kok:	mov	al,[si]
	cmp	ah,1
	jb	kok1
	inc	di
	xor	ah,ah
	jmp	kok1
;
pipi9:	cmp	es:arxdat[bx+2],1
	je	igrel
	xor	ax,ax
	xor	di,di
	lea	si,pinsthl
	mov	al,[si]
	inc	si
	mov	cx,9
igoril1:
	cmp	al,[si]
	jne	ikok
	inc	ah
ikok1:	inc	si
	loop	igoril1
	mov	ax,di
	mov	ah,al
	inc	ah
	inc	ah
	cmp	ah,es:arxdat[bx]
	jb	igril
	inc	bx
	cmp	al,es:arxdat[bx]
	jae	igril1
	ret
igril:	inc	bx
igril1: mov	mapo,1
	ret
igrel:	inc	bx
	mov	mapo,1
	ret
ikok:	mov	al,[si]
	cmp	ah,1
	jb	ikok1
	inc	di
	xor	ah,ah
	jmp	ikok1
;
synomad endp
;*****************************************************
;**                GIA TIS PROTASEIS                **
;***************************************************** 
hdiaz	proc	near				;h
	mov	al,pinprot[si]
	inc	si
	inc	si
	inc	si
	mov	ah,pinprot[si]
	and	al,ah
	mov	pinprot[si],al
	ret
hdiaz	endp
;
hdoxi	proc	near				;ho
	mov	al,pinprot[si]
	inc	si
	inc	si
	inc	si
	mov	ah,pinprot[si]
	not	ah
	and	ah,1
	and	al,ah
	mov	pinprot[si],al
	ret
hdoxi	endp
;
skoxi	proc	near				;o
	mov	al,pinprot[si+3]
	not	al
	and	al,1
	mov	pinprot[si+3],al
	ret
skoxi	endp
;
kaii	proc	near				;k
	mov	al,pinprot[si]
	inc	si
	inc	si
	inc	si
	mov	ah,pinprot[si]
	or	al,ah
	mov	pinprot[si],al
	ret
kaii	endp
;
kaoxi	proc	near				;ko
	mov	al,pinprot[si]
	inc	si
	inc	si
	inc	si
	mov	ah,pinprot[si]
	not	ah
	and	ah,1
	or	al,ah
	mov	pinprot[si],al
	ret
kaoxi	endp
;*****************************************************
;**                   PERIORISMOI                   **
;***************************************************** 
perior	proc	near
;**********************************************************
IFDEF	@TRIADES_POLLAPL
	mov	triades_pollapl[0],0
	mov	triades_pollapl[2],0
ENDIF
;**********************************************************
dialogh0:
	jmp	short dialogh_stadio1
dialepis:
	mov	bx,poros
	cmp	ypor,0
	je	ttt1
	jmp	ypoxro		;y/o
ttt1:	cmp	pror,0
	je	ttt2
	jmp	anpro		;protaseis
ttt2:	inc	bx
	cmp	asor,0
	je	ttt3
	jmp	omastr		;omades ***
ttt3:	inc	bx
	cmp	omor[0],0
	je	ttt4
	jmp	ommade		;omades a,b,c,d
ttt4:	jmp	metr1
;***************************************************** dialogh
dialogh_stadio1:
	cmp	metabl,1
	jne	dial0
	jmp	dialepis

dial0:	cmp	servieta,1
	jne	dial00
	jmp	dialepis

dial00: cmp	pinsthl[12],4
	je	dial1

	mov	epig[0],0
	mov	epig[1],0
	mov	epig[2],0
	xor	di,di
	xor	ax,ax
	mov	cx,13
	lea	si,pinsthl
dia1:	mov	al,pindial[di]
	cmp	al,0
	je	pidos
	cmp	al,[si]
	je	pidos
	inc	ah
	cmp	ah,3
	jb	pidos
	ret
pidos:	inc	di
	inc	si
	loop	dia1
	mov	al,ah
	xor	ah,ah
	mov	si,ax
	mov	epig[si],1
	
	jmp	dialepis
;
dial1:	mov	cx,9
	xor	di,di
	xor	ax,ax
	lea	si,pinsthl
dia2:	mov	al,pindial[di]
	cmp	al,0
	je	pidos1
	cmp	al,[si]
	je	pidos1
	inc	ah
	cmp	ah,3
	jb	pidos1
	ret
pidos1: inc	di
	inc	si
	loop	dia2
	jmp	metr1
;***************************************************** y/o
ypoxro: mov	cx,13
	lea	si,pinsthl
	lea	di,pinsthl2
ypox2:	mov	al,[si]
	mov	[di],al
	inc	si
	inc	di
	loop	ypox2
	xor	ax,ax
	mov	g_emf,ax
	mov	cx,ypor
ypoxr5: push	cx
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	call	ax
	inc	bx
	mov	ah,es:arxdat[bx]
	inc	bx
	pop	cx
	xor	mapo,ah
	jne	pel0998
	loop	ypoxr5
;**********************************************************
IFDEF	@TRIADES_POLLAPL
	@LCMPN	triades_pollapl,triades_poll_eos
	ja	pelex099
	@LCMPN	triades_pollapl,triades_poll_apo
	jb	pelex099
ENDIF
;**********************************************************
paries:
	cmp	pror,0
	je	yyy1
	jmp	anpro
pel0998: jmp 	pelex099
yyy1:	inc	bx
	cmp	asor,0
	je	yyy2
	jmp	omastr
yyy2:	inc	bx
	cmp	omor[0],0
	je	yyy3
	jmp	ommade
yyy3:	jmp	metr1
pelex099:
	cmp	cx,ypor1
	ja	pelex0
	call	metrima_pliri
pelex0: jmp	elex0				;ret
;***************************************************** protaseis
anpro:	cmp	pinsthl[12],4
	jne	lalas
	mov	bx,callipr[398]
	jmp	ejods3
lalas:	inc	bx
	mov	porel,300
amp1:	mov	si,0
	mov	di,0
amp4:	add	porel,4
	push	si
	cmp	pinprot[si],"O"
	jne	amp11
	inc	si
	inc	si
	inc	si
amp11:	mov	bx,callipr[di]
	inc	di
	inc	di
	cmp	bx,0
	je	ejodos
	jmp	ann1
ann99:	mov	al,mapo
	mov	pinprot[si],al
	cmp	pinprot[si+1],3
	je	analis
	inc	si
	inc	si
	inc	si
	cmp	pinprot[si],"O"
	jne	amp12
	inc	si
	inc	si
	inc	si
amp12:	mov	bx,callipr[di]
	inc	di
	inc	di
	cmp	bx,0
	je	ejodos
	jmp	ann1
ejodos: mov	bx,callipr[di]
	pop	si
ejods3: cmp	asor,0
	je	yyy22
	jmp	omastr
yyy22:	inc	bx
	cmp	omor[0],0
	je	yyy33
	jmp	ommade
yyy33:	jmp	metr1
;
ejodos1:mov	di,0
	mov	cx,400
ejjj2:	cmp	callipr[di],0
	je	ejjj1
	inc	di
	inc	di
	loop	ejjj2
	mov	dl,"*"
	call	biosdisp
ejjj1:	inc	di
	inc	di
	jmp	ejodos
analis: pop	si
anal1:	cmp	pinprot[si+1],"T"
	je	apotel
	mov	ah,pinprot[si+1]
	mov	al,pinprot[si+2]
	call	ax
	cmp	pinprot[si],"O"
	jne	amp13
	inc	si
	inc	si
	inc	si
amp13:	jmp	anal1
apotel: cmp	pinprot[si],0
	je	ani1
	jmp	amp15
ani1:	inc	si
	inc	si
	inc	si
apot1:	cmp	pinprot[si+1],3
	je	apot2
	mov	ah,pinprot[si+1]
	mov	al,pinprot[si+2]
	call	ax
	cmp	pinprot[si],"O"
	jne	amp14
	inc	si
	inc	si
	inc	si
amp14:	jmp	apot1
apot2:	cmp	pinprot[si],0
	jne	pelex199
	inc	si
	inc	si
	jmp	amp4
pelex199:
	call	metrima_pliri
pelex1:	jmp	elegx				; ret
amp15:	cmp	pinprot[si+1],3
	je	amp16
	inc	si
	inc	si
	inc	si
	jmp	amp15
amp16:	inc	si
	inc	si
	jmp	amp4
;
ann1:	push	si
	push	di
	xor	ax,ax
	mov	comast,ax
	mov	g_emf,ax
	mov	cx,13
	lea	si,pinsthl
	lea	di,pinsthl2
aoms2:	mov	al,[si]
	mov	[di],al
	inc	si
	inc	di
	loop	aoms2
	inc	bx
	mov	ch,es:arxdat[bx]
	inc	bx
	mov	cl,es:arxdat[bx]
	inc	bx
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	push	ax
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	push	ax
aoms3:	push	cx
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	call	ax
	inc	bx
	mov	ah,es:arxdat[bx]
	inc	bx
	xor	mapo,ah
	je	aoms4
	pop	cx
	loop	aoms3
	jmp	aoms9
aoms4:	pop	cx
	inc	comast
	loop	aoms3
aoms9:	pop	ax
	cmp	comast,ax
	ja	aoms11
poir:	pop	ax
	cmp	comast,ax
	jb	aoms12
	mov	mapo,0
	pop	di
	pop	si
	jmp	ann99
aoms11: pop	ax
aoms12: mov	mapo,1
	pop	di
	pop	si
	jmp	ann99
;***************************************************** omades *
omastr: inc	bx
	mov	porel,380
	mov	cx,asor
oms1:	push	cx
	xor	ax,ax
	mov	comast,ax
	mov	g_emf,ax
	mov	cx,13
	lea	si,pinsthl
	lea	di,pinsthl2
oms2:	mov	al,[si]
	mov	[di],al
	inc	si
	inc	di
	loop	oms2
	inc	bx
	mov	ch,es:arxdat[bx]
	inc	bx
	mov	cl,es:arxdat[bx]
	inc	bx
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	push	ax
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	push	ax
oms3:	push	cx
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	call	ax
	inc	bx
	mov	ah,es:arxdat[bx]
	inc	bx
	xor	mapo,ah
	je	oms4
	pop	cx
	loop	oms3
	jmp	oms9
oms99:	jmp	oms1
oms4:	inc	comast
	pop	cx
	loop	oms3
oms9:	pop	ax
	cmp	pinsthl[12],4
	je	poir1
	cmp	comast,ax
	ja	oms11
poir1:	pop	ax
	cmp	comast,ax
	jb	oms12
ppor:	add	porel,4
	pop	cx
	loop	oms99
omm1:	cmp	omor[0],0
	je	yyy34
	jmp	ommade
yyy34:	jmp	metr1
oms11:	pop	ax
oms12:	pop	cx
	call	metrima_pliri
pelex2:	jmp	elegx				; ret
;***************************************************** omades a,b,c,d
ommade: inc	bx
	mov	porel,520
	mov	si,1
lll1:	mov	al,omor[si]
	cmp	al,1
	jne	ttt5
	jmp	omom99
ttt5:	inc	bx
	inc	bx
	inc	bx
	inc	bx
	inc	si
	cmp	si,5
	jb	lll1
	jmp	metr1
;
omom99: add	porel,4
	push	si
	mov	comom,0
	xor	ch,ch
	mov	cl,es:arxdat[bx]
	inc	bx
	xor	ah,ah
	mov	al,es:arxdat[bx]
	inc	bx
	push	ax
	mov	al,es:arxdat[bx]
	inc	bx
	push	ax
omomj:	push	cx
	jmp	omom1
omome:	cmp	mapo,0
	je	ominc
	pop	cx
	loop	omomj
omom6:	pop	ax
	cmp	pinsthl[12],4
	je	poir3
	cmp	comom,al
	ja	omos11
poir3:	pop	ax
	cmp	comom,al
	jb	omos12
	pop	si
	cmp	si,4
	jae	omretd
	inc	bx
	inc	si
	jmp	lll1
omretd: jmp	metr1
ominc:	inc	comom
	pop	cx
	loop	omomj
	jmp	omom6
omos11: pop	ax
omos12: pop	si
	call	metrima_pliri
pelex3:	jmp	elegx				; ret
;
omom1:	xor	ax,ax
	mov	comast,ax
	mov	g_emf,ax
	mov	cx,13
	lea	si,pinsthl
	lea	di,pinsthl2
omom2:	mov	al,[si]
	mov	[di],al
	inc	si
	inc	di
	loop	omom2
	inc	bx
	mov	ch,es:arxdat[bx]
	inc	bx
	mov	cl,es:arxdat[bx]
	inc	bx
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	push	ax
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	push	ax
omom3:	push	cx
	mov	ah,es:arxdat[bx]
	inc	bx
	mov	al,es:arxdat[bx]
	inc	bx
	call	ax
	inc	bx
	mov	ah,es:arxdat[bx]
	inc	bx
	xor	mapo,ah
	je	omom4
	pop	cx
	loop	omom3
	jmp	omom9
omom4:	pop	cx
	inc	comast
	loop	omom3
omom9:	pop	ax
	cmp	pinsthl[12],4
	je	poir2
	cmp	comast,ax
	ja	omos1
poir2:	pop	ax
	cmp	comast,ax
	jb	omos2
	mov	mapo,0
	jmp	omome
omos1:	pop	ax
omos2:	mov	mapo,1
	jmp	omome

;***************************************************** METABLHTO
metabl999:
	xor	bx,bx
janamt: xor	di,di
	xor	ax,ax
	mov	cx,13
alqp:	cmp	pin_ues_met[di],1
	jne	metep
	mov	al,pinmet[bx][di]
	cmp	al,0
	je	metej
	cmp	al,pinsthl[di]
	je	metep
	inc	ah
	cmp	ah,metablhths
	jae	pernas
metep:	inc	di
	loop	alqp
	cmp	ah,0
	je	pernas
	call	metrima_pliri
pelexm:	cmp	pinsthl[12],4
	jne	no4
	@LADDN	pinbil[8],poson
	ret
no4:	@INCL	pinbil[8]
	ret
pernas: add	bx,13
	jmp	janamt
metej:	mov	bx,metp
	xor	di,di
	mov	cx,13
metmet: mov	al,pinsthl[di]
	mov	pinmet[bx][di],al
	inc	di
	loop	metmet
	add	bx,13
	cmp	bx,filtra
	jb	entaj
	xor	bx,bx
entaj:	mov	metp,bx
	jmp	short ascii
;****************************************************************
metr1:		jmp	short metr2		; xor al,al
metbl1:		jmp	short metablhto		; xor al,al
ascii:		jmp	short fascii		; xor al,al
sthmnhm:	jmp	short gia_mnhmh		; xor al,al
plhrak:		jmp	short plhrk		; xor al,al
aepib:		jmp	short aepib1		; xor al,al
binlk:		jmp	short binel		; xor al,al
ayjhsh:		jmp	short prntr1		; xor al,al
dialogh1:	jmp	short dialog		; xor al,al
stl2prn:	jmp	short stl2prn1		; xor al,al

;***************************************************************
aujis:		@INCL	pinbil
		@INCL	cound
		ret
;****************************************************************
metr2:		jmp	metrv1

binel:		@INCL	cound
		jmp	binelk

prntr1:		jmp	stl2screen

aepib1:		@INCL	cound
		jmp	plhrakia	;axb

plhrk:		@INCL	cound
		jmp	plhrakia

dialog:		jmp	dialogh_stadio2

fascii:		jmp	save_ascii

stl2prn1:	jmp	stl_to_prn

gia_mnhmh:	jmp	apoustil

metablhto:	jmp	metabl999
;****************************************************************
metrima_pliri:
	CMP	PINSTHL[12],4
	je	isst4
	@INCL	pinbil
	ret
isst4:	@LADDN	pinbil,poson
	ret
;***************************************************** SHMEIA ANA UESI
binelk:	@PUSH
	xor	si,si
	mov	cx,13
	xor	bx,bx
	xor	di,di
trelos:	mov	bl,pinsthl[si]
	cmp	bx,0
	je	bink1
	shl	bx,1
	shl	bx,1
	@INCL	pinbil1[di][bx]
bink1:	inc	si
	add	di,12
	loop	trelos
;*****************************************************  PARAGVGA
	mov	word ptr cs:b_parag,0
	mov	word ptr cs:b_parag[2],0
	mov	cx,13
	xor	si,si
	xor	bx,bx
trl5:	mov	bl,pinsthl[si]
	inc	byte ptr cs:b_parag[bx]
	inc	si
	loop	trl5

	xor	ax,ax
	mov	al,cs:b_parag[1]
	mov	cx,12
	mul	cx
	mov	bx,ax
	@INCL	pinbil1[bx][160]

	xor	ax,ax
	mov	al,cs:b_parag[2]
	mov	cx,12
	mul	cx
	add	ax,4
	mov	bx,ax
	@INCL	pinbil1[bx][160]

	xor	ax,ax
	mov	al,cs:b_parag[3]
	mov	cx,12
	mul	cx
	add	ax,8
	mov	bx,ax
	@INCL	pinbil1[bx][160]

	@CPLRNS
	jnc	belxi
	call	binpr
	cmp	al,@ESCAPE
	jne	belxi
	call	diakopi

belxi:	@POP
	ret
b_parag	db	0,0,0,0,0

;*****************************************************  ELEGXOS ypoxrevtikoi oroi
elex0:	@PUSH
	cmp	cx,ypor1
	jbe	no45
	jmp	ret9
no45:	cmp	pinsthl[12],4
	jne	no43
	@LADDN	pinbil[4],poson
	jmp	short no44
no43:	@INCL	pinbil[4]	;y/o
no44:	mov	si,ypor1
	sub	si,cx
	cmp	si,64
	ja	ret9
	add	si,4
	shl	si,1
	shl	si,1
	cmp	pinsthl[12],4
	jne	no41
	@LADDN	pinbil[si],poson
	jmp	short ret9

no41:	@INCL	pinbil[si]

ret9:	@CPLRNS
	jnc	paters
	call	elegxpr
	cmp	al,@ESCAPE
	jne		paters
	call	diakopi

paters: @POP
	ret
;***************************************************** ELEGXOS alloi oroi
elegx:	@PUSH
	mov	di,porel
	cmp	pinsthl[12],4
	jne	no52
	@LADDN	pinbil[di],poson
	jmp	short no53

no52:	@INCL	pinbil[di]
no53:	add	porel,4

	@CPLRNS
	jnc	pate1
	call	elegxpr
	cmp	al,@ESCAPE
	jne	pate1
	call	diakopi

pate1:	@POP
	ret
;*****************************************************
dialogh_stadio2:
	@PUSH
	@CHANGESEGM	ds,DATAS1
	cmp	metabl,1
	je	dialmetb9
	cmp	servieta,1
	je	dialmetb9
	jmp	short metdi

dialmetb9: jmp	dialmetb

metdi:	xor	ax,ax
	mov	al,epig[0]
	add	sepig[0],ax

	@LTOA	sepig[0],0,strbuf
	@WPRINT	13,4,strbuf

	mov	al,epig[1]
	add	sepig[2],ax
	@LTOA	sepig[2],0,strbuf
	@WPRINT	13,5,strbuf

	mov	al,epig[2]
	add	sepig[4],ax
	@LTOA	sepig[4],0,strbuf
	@WPRINT	13,6,strbuf

	@POP
	ret
dialmetb:
	mov	epig[0],0
	mov	epig[1],0
	mov	epig[2],0
	xor	di,di
	xor	ax,ax
	mov	cx,13
	lea	si,pinsthl
dia1m:	mov	al,pindial[di]
	cmp	al,0
	je	pidosm
	cmp	al,[si]
	je	pidosm
	inc	ah
	cmp	ah,3
	jb	pidosm
	@POP
	ret
pidosm: inc	di
	inc	si
	loop	dia1m
	mov	al,ah
	xor	ah,ah
	mov	si,ax
	mov	epig[si],1
	jmp	metdi

;********************************************* save_ascii
save_ascii:
	@PUSH
	mov	cx,13
	xor	bx,bx
kker1:	mov	al,pinsthl[bx]
	cmp	al,1
	jne	noal1
	mov	al,"1"
	jmp	kker
noal1:	cmp	al,2
	jne	noal2
	mov	al,"X"
	jmp	kker
noal2:	cmp	al,3
	jne	noal3
	mov	al,"2"
	jmp	kker
noal3:	mov	al," "
kker:	mov	pinsthl3[bx],al
	inc	bx
	loop	kker1
	@WRITE_HANDLE	cs:ascii_handle,pinsthl3,15
	@POP
	jmp	aujis

perior	endp

;***************************************************** TYPOMA BINELIKIA
binpr	proc	near
	@PUSH
	@TAKEWIND
	push	ax
	@SELECTWIND	wparag
	@CHANGESEGM	ds,DATAS1
	mov	grammh,5
	mov	bx,4

	mov	cx,14
binpr3:	push	cx
	push	bx
	push	bx

	cmp	cx,1
	je	binpr4

	mov	sthlh,7
	mov	cx,3
binpr1:	@LTOAN	pinbil1[bx],strbuf
	@USING	strbuf,7
	@WPRINT	sthlh,grammh,strbuf
	add	bx,4
	add	sthlh,10
	loop	binpr1

binpr4:	pop	bx
	mov	sthlh,43
	mov	cx,3
binpr2:	@LTOAN	pinbil1[bx][156],strbuf
	@USING	strbuf,7
	@WPRINT	sthlh,grammh,strbuf
	add	bx,4
	add	sthlh,10
	loop	binpr2

	pop	bx
	inc	grammh
	add	bx,12
	pop	cx
	loop	binpr31

	@LTOAN	cound,strbuf
	@WPRINT	13,19,strbuf

	pop	ax
	@SELECTWI	al
	@POP
	ret
binpr31: jmp	binpr3
binpr	endp

;***************************************************** TYPOMA ELEGXOS
elegxpr	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@TAKEWIND
	push	ax
	@SELECTWIND	welegx

	@LTOAN	pinbil,strbuf
	@WPRINT	19,1,strbuf

	@LTOAN	pinbil[8],strbuf
	@WPRINT	40,1,strbuf

	@LTOAN	cound,strbuf
	@WPRINT	59,1,strbuf

	@LTOAN	pinbil[4],strbuf
	@USING	strbuf,7
	@WPRINT	32,2,strbuf

;*************************************** Y/O
	mov	si,16
	mov	dh,3

	mov	cx,7
elg15:	push	cx

	mov	dl,5
	mov	cx,8
elg14:	@LTOAN	pinbil[si],strbuf
	@USING	strbuf,7
	@WPRINT	dl,dh,strbuf
	add	dl,9
	add	si,4
	loop	elg14

	pop	cx
	inc	dh
	loop	elg15
;*************************************** PROTASIS
	mov	pinbil[590],0
	mov	pinbil[592],0
	mov	si,304
	mov	dh,11

	mov	cx,2
elg21:	push	cx

	mov	dl,4
	mov	cx,8
elg20:	@LADDN	pinbil[590],pinbil[si]
	@LTOAN	pinbil[si],strbuf
	@USING	strbuf,7
	@WPRINT	dl,dh,strbuf
	add	dl,9
	add	si,4
	loop	elg20

	pop	cx
	inc	dh
	loop	elg21

	@LTOAN	pinbil[590],strbuf
	@USING	strbuf,7
	@WPRINT	32,10,strbuf

;************************ OMADES ola 0
	mov	dh,14

	mov	cx,5
elg18:	push	cx

	mov	dl,5
	mov	cx,7
elg17:	mov	strbuf[0],"0"
	mov	strbuf[1],0
	@USING	strbuf,7
	@WPRINT	dl,dh,strbuf
	add	dl,10
	loop	elg17

	pop	cx
	inc	dh
	loop	elg18
;*************************************** OMADES
	mov	pinbil[590],0
	mov	pinbil[592],0
	mov	si,380
	mov	cx,34
	xor	di,di
elg16:	xor	ax,ax
	mov	al,elepin[di]
	cmp	ax,0
	jne	elg19

	jmp	elg99

elg19:	push	cx

	sub	al,2
	xor	dx,dx
	mov	cx,7
	div	cx
	push	dx
	add	al,14
	mov	dh,al
	pop	ax
	push	dx
	mov	cx,10
	mul	cx
	pop	dx
	add	ax,5
	mov	dl,al

	@LTOAN	pinbil[si],strbuf
	@USING	strbuf,7
	@WPRINT	dl,dh,strbuf

	@LADDN	pinbil[590],pinbil[si]

	pop	cx
	add	si,4
	inc	di
	loop	elg169
	jmp	elg99

elg169:	jmp	elg16

elg99:	@LTOAN	pinbil[590],strbuf
	@USING	strbuf,7
	@WPRINT	32,13,strbuf

;*************************************** YPEROMADES
	mov	pinbil[590],0
	mov	pinbil[592],0
	mov	si,524

	mov	dl,6
	mov	cx,4
elg23:	@LADDN	pinbil[590],pinbil[si]
	@LTOAN	pinbil[si],strbuf
	@USING	strbuf,7
	@WPRINT	dl,20,strbuf
	add	dl,15
	add	si,4
	loop	elg23

	@LTOAN	pinbil[590],strbuf
	@USING	strbuf,7
	@WPRINT	32,19,strbuf

	pop	ax
	@SELECTWI	al
	@POP
	ret
elegxpr	endp
;***************************************************** 
stl2screen  proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	bx,0
	mov	si,pointp
	mov	cx,13
pri8:	mov	dl,pinsthl[bx]
	mov	buf24[si],dl
	inc	si
	inc	bx
	loop	pri8
	mov	pointp,si
	cmp	si,312
	jne	prpr

	call	stl2ouoni
	mov	pointp,0
	mov	cx,312
	mov	di,0
st2o1:	mov	buf24[di],0
	inc	di
	loop	st2o1
prpr:	@POP
	ret
stl2screen  endp
;
stl_to_prn	proc	near
	@PUSH
	mov	bx,0
	mov	cx,13
sci8:	mov	dl,pinsthl[bx]
	call	findsimio
	@LPRINTCHR	dl,lpt_number,cs:print_stack
	inc	bx
	loop	sci8
	inc	sel
	cmp	sel,7
	jb	sci0
	@LPRINTSTR	prn_line_feed,lpt_number,cs:print_stack
	mov	sel,0
	@POP
	ret
sci0:	@LPRINTCHR	" ",lpt_number,cs:print_stack
	@LPRINTCHR	"-",lpt_number,cs:print_stack
	@LPRINTCHR	" ",lpt_number,cs:print_stack
	@POP
	ret
stl_to_prn	endp

findsimio	proc	near
	cmp	dl,1
	je	fsis1
	cmp	dl,2
	je	fsisX
	cmp	dl,3
	je	fsis2
	mov	dl," "
	ret
fsis1:	mov	dl,"1"
	ret
fsis2:	mov	dl,"2"
	ret
fsisX:	mov	dl,"X"
	ret
findsimio	endp

CODESG	ends
	end
