
INCLUDE equs.h
INCLUDE xaza.inc

STACKSG SEGMENT STACK
		dw      2000 dup(?)
STACKSG ENDS

CODESG  segment public
extrn   x21:near,naoxi:near,edit_copy_0:near,pelexm:near,eisag_edit:near
extrn   bbuf:near,clr_scr:near,setcurs:near,ekdel:near,mettyp:near,binlk:near
extrn   dispmhn:near,bin_dec:near,dosdisp:near,help:near
extrn   dec_bin:near,apou2:near,apou3:near,predit:near,bbuffer:near
extrn   tajinom:near,xarakt:near,asteri:near,edast:near,capo:near
extrn   omades:near,metrima:near,edomad:near,editq:near,editr:near
extrn   editomr:near,editot:near,cersor:near
extrn   tend:near,dioru:near,tselid:near,editor:near,editor1:near
extrn   editor2:near,tchar:near,kauar:near,prometr:near
extrn   tajasc:near,plhra:near,ayjhsh:near,metrpr:near,edtomr1:near
extrn   pelex0:near,pelex1:near,pelex2:near,pelex3:near,arxeia:near
extrn   binpr:near,elegxpr:near,pr24s:near
extrn   axbpr:near,axbmet:near,aepib:near,deltyp:near
extrn   plhrakia_print:near,plhrak:near
extrn   epejergasia:near,telikh_epejergasia:near,taj_metab:near
extrn   dialogh0:near,dialogh1:near,eisagvgh_dialoghs:near,metbl1:near
extrn   sthmnhm:near,sbmon:near,grmon:near,dilpis:near
extrn   klidvma:near,klidvma_oxi:near,toobig:near,dial_ret:near
extrn   configs:near,kauarisma_metab:near,all_or_basikvn:near,init_code:near
extrn   putsthles:near,getkey:near,copyright:near,chk_crght:near


	ASSUME  CS:CODESG,DS:DATAS1,ES:DATANA

main	proc	far
	@STARTPRG
	@SETWINSEGM	WINSEGM
	@USERW	0,0
	@CHANGESEGM	ds,DATAS1
	@CHANGESEGM	es,DATANA
	@FILLSCR	"°",07h
	@CLRCURS
	@SETWIND	wstart

	call	far ptr klidi_do_poke
	jmp	klidi_epistrofi

main	endp


;**************************************************************************
;**********                     EXOYN  ELEGXUEI                  **********
;**************************************************************************
input_name_ascii	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@SETWIND	wsaveAscii
sav7:	@SELECTWIND	wsaveAscii
	@FILLSTR	asciiname," ",8
	@WINPUT	22,3,asciiname
	jnc	sav4
	jmp	sav8
sav4:	call	addext_asc
	cmp	asciiname,"."
	jne	sav6
	jmp	sav8
sav6:	@STRCMP	asciidisk,FileMetraAscii
	jnc	sav7
	@TESTDRIVE	asciidisk
	jnc	sav21
	call	in_drive
	jnc	sav6
	jmp	sav8
sav21:	@TESTFILE	asciidisk
	jc	sav5
	mov	byte ptr strbuf,0
	@NAIOXI	34,6,strbuf,myparx1,myparx2
	jnc	sav5
	cmp	ax,0
	je	sav71
	jmp	sav8
sav71:	jmp	sav7
sav5:	@DELWIND	wsaveAscii
	@POP
	clc
	ret
sav8:	@DELWIND	wsaveAscii
	@POP
	stc
	ret
input_name_ascii	endp

load_lpt proc   near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	@OPEN_HANDLE    lptfile,I_READ
	jnc     st201
	jmp     stend2
st201:  mov     cs:handlef,ax
	xor     bx,bx
	xor     si,si
aloch:  mov     strbuf,0
	@READ_HANDLE    cs:handlef,strbuf,1
	mov     al,strbuf
	cmp     al,0
	jne     st203
	jmp     stend
st203:  cmp     al," "
	jb      stend1
	cmp     al,"~"
	ja      stend1
	jmp     nst200

stend1: jmp     stend

nst200: cmp     al,13
	jne     nst13
	mov     lptnames[bx],0
	add     si,15
	cmp     si,30
	ja      stend
	mov     bx,si
	jmp     aloch

nst13:  mov     lptnames[bx],al
	inc     bx
	jmp     aloch

stend:  @CLOSE_HANDLE   cs:handlef
stend2: @POP
	ret
handlef dw      0
load_lpt endp   

utils	proc	near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	@TAKEWIND
	push    ax
utiar:	@SETWIND        wutils
	@SELECTWIND     wutils
	@PLHKTRO
	@UPPERAX
	@DELWIND	wutils
	cmp	al,"0"
	jb	chkutno
	cmp	al,"E"
	ja	chkutno
	jmp	chkut
chkutno:
	pop	ax
	@SELECTWI	al
	@POP
	ret
;****************************
chkut:	cmp	al,"0"
	jne	utin0
	call    save_ascii
	jmp	utiar
utin0:	cmp	al,"1"
	jne	utin1
	call	eidos_oroy
	jmp	utiar

utin1:	cmp	al,"2"
	jne	utin2
	call    metatr_basikes
	jmp	utiar
utin2:	cmp	al,"3"
	jne	utin3
	call    metatr_triades
	jmp	utiar
utin3:	cmp	al,"4"
	jne	utin4
	call    allagi_omadas
	jmp	utiar
utin4:	cmp	al,"5"
	jne	utin5
	call    antig_omadas
	jmp	utiar
utin5:	cmp	al,"6"
	jne	utin6
	call    sbisimo_omadas
	jmp	utiar
utin6:	cmp	al,"7"
	jne	utin7
	call    allagi_orion
	jmp	utiar
utin7:	cmp	al,"8"
	jne	utin8
	call	antik_sim
	jmp	utiar
utin8:	cmp	al,"9"
	jne	utin9
	call    geniki_taj
	call    bale_omada
	call    screen
	call    prbuf
	jmp	utiar
utin9:	cmp	al,"A"
	jne	utinA
	call	far ptr auristos
	jmp	utiar
utinA:	cmp	al,"B"
	jne	utinB
	call	far ptr wind_statistika
	jmp	utiar
utinB:	cmp	al,"C"
	jne	utinC
;;	call	timi_stilis
	call	save_inf
	jmp     utiar

utinC:	cmp	al,"D"
	jne	utinD
;***************************************
IFDEF	@TRIADES_POLLAPL
	call	far ptr pollaplasiast
	ENDIF
;***************************************
	jmp	utiar
utinD:	jmp	utiar
utils	endp

ektip	proc	near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	@TAKEWIND
	push    ax
ektiar1:
	@SETWIND        wektiposis
	@SELECTWIND     wektiposis
	@PLHKTRO
	@UPPERAX
	@DELWIND	wektiposis
	cmp	al,"0"
	jb	chkektno
	cmp	al,"Z"
	ja	chkektno
	jmp	chkekt

chkektno:
ektiar:	pop	ax
	@SELECTWI	al
	@POP
	ret
chkekt: cmp	al,"4"
	jne	ektin4
	call    deltia_plirakia
	call	savesys
	jmp	ektiar
ektin4:	cmp	al,"5"
	jne	ektin5
	call    dialogi_plirakia
	jmp	ektiar
ektin5:
ektin7:
ektous:	
ektin9:
ektin8:	
ektinA:	
ektinB:
ektinD:	
ektinR:	jmp	ektiar
ektip	endp

ekt_oron_plus	proc	near
	@PUSH
	call    check_all
	jnc     ektor1
	@POP
	ret
ektor1:	@CHANGESEGM	ds,DATAS1
	@SETWIND	wsimet
	@SELECTWIND	wsimet
	mov	simetoxes,5
	mov	ax,simetoxes
	@ITOA	strbuf,2
	@WINPUTNUMBER	19,2,strbuf
	jnc	ektor2
	@DELWIND	wsimet
	@POP
	ret
ektor2:	@ATOI	strbuf
	cmp	ax,0
	ja	ektor3
	mov	ax,1
ektor3:	mov	simetoxes,ax
	@DELWIND	wsimet
	call    for_metrima
;;;;;	call    for_pinakes
;;;;;	call	for_elegxos
	call    plhra
	mov	simea_ekt_oron,1

	mov	cx,simetoxes
sim102:	
;	call    far ptr ekt_oron
	loop	sim102

	@BELL
	@POP
	ret
ekt_oron_plus	endp

ektip_stiles	proc	near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     errorpl,0
	call    check_plhres
	jnc     kokepr
	mov     errorpl,1
kokepr:	call    check_all
	jnc     kokep1
	@POP
	retf
kokep1:	@SETWIND	wplwait
	mov	ax,offset lptnames
	mov	lpt_number,ax
	mov	cs:print_stack,sp
;************************************************
	@LPRINT_START	lpt_number
;************************************************
	mov	ax,0
;	call	far ptr PCLorEPSON
	@LPRINTSTR	prn_reset,lpt_number,cs:print_stack
	@LPRINTSTR	prn_set_conden,lpt_number,cs:print_stack
;-----------------------------------------------------
	call	for_stl2prn
	call    plhra
	@LPRINTSTR	prn_formfeed,lpt_number,cs:print_stack
;************************************************
	@LPRINT_STOP
;************************************************
	mov	cs:patise_taf,1
	call    genend
	@DELWIND	wplwait
	@POP
	retf
ektip_stiles	endp

newline	proc	near
	@LPRINTSTR	prn_line_feed,lpt_number,cs:print_stack
	ret
newline	endp

tajinompr       proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	@SETWIND        wtajin
	call    tajinom
	@DELWIND        wtajin
	@POP
	ret
tajinompr       endp

plirakia_4	proc	near
	@PUSH
	mov	ax,word ptr cs:forplr_4[0]
	mov	word ptr cs:plr4_1,ax
	mov	ax,word ptr cs:forplr_4[2]
	mov	word ptr cs:plr4_2,ax
	mov	ax,word ptr cs:forplr_4[4]
	mov	word ptr cs:plr4_3,ax
	mov	ax,word ptr cs:forplr_4[6]
	mov	word ptr cs:plr4_4,ax

;;;;;;;	call    dialogi_plirakia	den doyleuei?????

	call    deltia_plirakia
	mov	al,byte ptr cs:nopit
	mov	byte ptr cs:plr4_1[0],al
	mov	byte ptr cs:plr4_1[1],al
	mov	byte ptr cs:plr4_2[0],al
	mov	byte ptr cs:plr4_2[1],al
	mov	byte ptr cs:plr4_3[0],al
	mov	byte ptr cs:plr4_3[1],al
	mov	byte ptr cs:plr4_4[0],al
	mov	byte ptr cs:plr4_4[1],al
	@POP
	ret
plirakia_4	endp

take_code_plr4	proc	near
	@PUSH
	mov	ax,word ptr cs:plr4_1
	mov	word ptr cs:forplr_4[0],ax
	mov	ax,word ptr cs:plr4_2
	mov	word ptr cs:forplr_4[2],ax
	mov	ax,word ptr cs:plr4_3
	mov	word ptr cs:forplr_4[4],ax
	mov	ax,word ptr cs:plr4_4
	mov	word ptr cs:forplr_4[6],ax
	mov	al,byte ptr cs:nopit
	mov	byte ptr cs:plr4_1[0],al
	mov	byte ptr cs:plr4_1[1],al
	mov	byte ptr cs:plr4_2[0],al
	mov	byte ptr cs:plr4_2[1],al
	mov	byte ptr cs:plr4_3[0],al
	mov	byte ptr cs:plr4_3[1],al
	mov	byte ptr cs:plr4_4[0],al
	mov	byte ptr cs:plr4_4[1],al
	@POP
	ret
forplr_4	dw	0,0,0,0
take_code_plr4	endp

check_plhres    proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	cmp     arxascii,0
	je      arkas
	mov     bx,0
	@CHANGESEGM     ds,DATASC
allopl: mov     dl,arxasc[bx]
	cmp     dl,"0"
	jne     arkas
	push    bx
	mov     cx,13
	inc     bx
plq32:  cmp     arxasc[bx]," "
	je      exei_kenol
	cmp     arxasc[bx],0
	je      exei_kenol
	add     bx,3
	loop    plq32
	pop     bx
	add     bx,48
	jmp     allopl
exei_kenol:
	pop     bx
	@POP
	stc
	ret
arkas:  @POP
	clc
	ret
check_plhres    endp

if_plires       proc    near
	@PUSH
	@CHANGESEGM     ds,DATASC
	cmp     arxasc[0],"0"
	je      if_pl1
	@POP
	stc
	ret
if_pl1: @POP
	clc
	ret
if_plires       endp

if_mnimi_on     proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	cmp     memory,1
	je      if_m1
	@POP
	stc
	ret
if_m1:  @POP
	clc
	ret
if_mnimi_on     endp

if_mnimi        proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	cmp     memory,1
	je      if_mn1
	@POP
	stc
	ret
if_mn1: cmp     exomnimi,1
	je      if_mn2
	@POP
	stc
	ret
if_mn2: @POP
	clc
	ret
if_mnimi        endp

if_ascii	proc	near
	@PUSH
	cmp	metraAscii,1
	je	isasc1	
	@POP
	stc
	ret
isasc1:	@POP
	clc
	ret
if_ascii	endp

genend  proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	cmp	cs:patise_taf,1
	je	patataf
	jmp	oxitaf
patataf:
	@TAKEWIND
	push    ax
	@SETWIND        wgen
	@SELECTWIND     wgen
	@WPRINT 29,1,mtelos
	@BELL
	@CPLR   "T"
	@DELWIND        wgen
	pop     ax
	@SELECTWI       al
oxitaf:	cmp     fatal_stack,0
	jne     no_diakopi
	mov     ax,coundq
	mov     cound,ax
	mov     ax,coundq[2]
	mov     cound[2],ax
no_diakopi:
	call    putsthles
	call	sbmon
	call    chk_ascii
	call    chk_mnimi
	mov     ax,cound
	mov     coundq,ax
	mov     ax,cound[2]
	mov     coundq[2],ax
	call    init_code
	@POP
	ret
patise_taf	db	0
genend  endp

chk_mnimi       proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	cmp     memory,1
	jne     lina
	call    grmon
	@POP
	ret
lina:   @POP
	ret
chk_mnimi       endp

chk_ascii       proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	cmp     metraAscii,1
	jne     lina1
	call    grAscii
	@POP
	ret
lina1:  @POP
	ret
chk_ascii       endp

pinakes proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    check_all
	jnc     secam6
	@POP
	ret
secam6: call    for_pinakes
	@SETWIND        wparag
	call    binpr
	call    plhra
	call    binpr
	mov	cs:patise_taf,1
	call    genend
	@DELWIND        wparag
	@POP
	ret
pinakes endp

elegxos proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    check_all
	jnc     secam7
	@POP
	ret
secam7: call    for_elegxos
	@SETWIND        welegx
	call    elegxpr
	call    plhra
	call    elegxpr
	mov	cs:patise_taf,1
	call    genend
	@DELWIND        welegx
	@POP
	ret
elegxos endp

geniki_taj      proc    near
	@PUSH
	call    kauarisma_metab
	call    tajinompr
	call    prometr
	call    metrima
	call    editomr
	call    tajasc
	jnc     bug0
	call    toobig
	@POP
	stc
	ret
bug0:   @POP
	clc
	ret
geniki_taj      endp

for_stl2prn     proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     ax,prog[30]
	mov     word ptr cs:stl2prn,ax
	@POP
	ret
for_stl2prn     endp

for_pinakes     proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     ax,prog[14]
	mov     word ptr cs:binlk,ax
	@POP
	ret
for_pinakes     endp

for_metrima     proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     al,byte ptr prog[8]
	mov     byte ptr cs:metrima_print,al
	@POP
	ret
for_metrima     endp

for_ascii     proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     ax,prog[22]
	mov     word ptr cs:ascii,ax
	@POP
	ret
for_ascii   endp

for_elegxos     proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     al,byte ptr prog[2]
	mov     byte ptr cs:pelex0,al
	mov     al,byte ptr prog[3]
	mov     byte ptr cs:pelex1,al
	mov     al,byte ptr prog[4]
	mov     byte ptr cs:pelex2,al
	mov     al,byte ptr prog[5]
	mov     byte ptr cs:pelex3,al
	mov     al,byte ptr prog[7]
	mov     byte ptr cs:pelexm,al
	@POP
	ret
for_elegxos     endp

for_dialogi_ouoni       proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     ax,dialogp[0]
	mov     word ptr cs:dialogh0,ax
	mov     ax,dialogp[2]
	mov     word ptr cs:dialogh1,ax
	mov     ax,prog[16]
	mov     word ptr cs:metr1,ax
	@POP
	ret
for_dialogi_ouoni       endp

for_ekt_ouoni   proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     ax,prog[0]
	mov     word ptr cs:ayjhsh,ax
	@POP
	ret
for_ekt_ouoni   endp

for_dlt_axb     proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     ax,prog[18]
	mov     word ptr cs:aepib,ax
	@POP
	ret
for_dlt_axb     endp

for_dlt_plirakia        proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     ax,pokeplr
	mov     word ptr cs:plhrak,ax
	@POP
	ret
for_dlt_plirakia        endp

take_code       proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     ax,word ptr cs:sthmnhm
	mov     stilmn,ax
	mov     ax,word ptr cs:ayjhsh
	mov     word ptr prog[0],ax
	mov     al,byte ptr cs:pelex0
	mov     byte ptr prog[2],al
	mov     al,byte ptr cs:pelex1
	mov     byte ptr prog[3],al
	mov     al,byte ptr cs:pelex2
	mov     byte ptr prog[4],al
	mov     al,byte ptr cs:pelex3
	mov     byte ptr prog[5],al
	mov     al,byte ptr cs:pelexm
	mov     byte ptr prog[7],al
	mov     al,byte ptr cs:metrima_print
	mov     byte ptr prog[8],al
	mov     ax,word ptr cs:binlk
	mov     prog[14],ax
	mov     ax,word ptr cs:metr1
	mov     prog[16],ax
	mov     ax,word ptr cs:aepib
	mov     prog[18],ax
	mov     ax,word ptr cs:ascii
	mov     prog[22],ax
	mov     ax,word ptr cs:stl2prn
	mov     prog[30],ax
	mov     ax,word ptr cs:plhrak
	mov     pokeplr,ax
	mov     ax,word ptr cs:dialogh0
	mov     dialogp[0],ax
	mov     ax,word ptr cs:dialogh1
	mov     dialogp[2],ax
	mov     ax,word ptr cs:metbl1
	mov     pokmetbl,ax
	@POP
	ret
take_code       endp

sbisimo_omadas  proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    geniki_taj
	call    set_sbise
	mov     ax,coundq
	mov     cound,ax
	mov     ax,coundq[2]
	mov     cound[2],ax
	call    screen
	call    prbuf
	@POP
	ret
sbisimo_omadas  endp

antik_sim	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	call	geniki_taj
	call	set_antikat_sim
	mov	ax,coundq
	mov	cound,ax
	mov	ax,coundq[2]
	mov	cound[2],ax
	call	screen
	call	prbuf
	@POP
	ret
antik_sim	endp

allagi_omadas   proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    geniki_taj
	cmp     tipos_orou,"B"
	jne     noBB1
	mov     tipos_orou,"W"
noBB1:  call    set_allagi
	mov     ax,coundq
	mov     cound,ax
	mov     ax,coundq[2]
	mov     cound[2],ax
	call    screen
	call    prbuf
	@POP
	ret
allagi_omadas   endp

allagi_orion    proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    geniki_taj
	call    set_oria
	mov     ax,coundq
	mov     cound,ax
	mov     ax,coundq[2]
	mov     cound[2],ax
	call    screen
	call    prbuf
	@POP
	ret
allagi_orion    endp

antig_omadas    proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    geniki_taj
	cmp     tipos_orou,"B"
	jne     noBB2
	mov     tipos_orou,"W"
noBB2:  call    set_antigrafi
	mov     ax,coundq
	mov     cound,ax
	mov     ax,coundq[2]
	mov     cound[2],ax
	call    screen
	call    prbuf
	@POP
	ret
antig_omadas    endp

metatr_basikes  proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    if_mnimi
	jnc     metrb1
	@POP
	ret
metrb1: cmp     arxascii,0
	je      denes
	@NAIOXI 34,12,mmetatr1,mmetatr2,msigor
	jc      antom2
	call    sbise_orous
denes:  call    geniki_taj
	jnc     bug01
antom2: @POP
	ret
bug01:  mov     metatropi_se_basikes,1
	call    plhra
	mov     metatropi_se_basikes,0
	call    init_code
	call    screen
	call    prbuf
	@POP
	ret
metatr_basikes  endp

metatr_triades  proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    if_mnimi
	jnc     metrt1
	@POP
	ret
metrt1: cmp     arxascii,0
	je      denest
	@NAIOXI 34,12,mmetatr1,mmetatr2,msigor
	jc      antomt2
	call    sbise_orous
denest: call    geniki_taj
	jnc     bugt01
antomt2: @POP
	ret
bugt01: mov     metatropi_se_basikes,2
	call    plhra
	mov     metatropi_se_basikes,0
	call    init_code
	call    screen
	call    prbuf
	@POP
	ret
metatr_triades  endp

metrima_stilon  proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    check_all
	jnc     secam9
	@POP
	ret

secam9: call    if_mnimi_on
	je      krit3
	jmp     plir

krit3:  mov     segm,0
	mov     shmeat,0
	mov     mema,0
	call    if_mnimi
	jnc     krit1
	jmp     krit2

krit1:  cmp     arxascii,0
	je      krit2
	mov     strbuf,0
	@NAIOXI 34,12,mdokim1,strbuf,mdokim2
	jnc     plir
	cmp     ax,1
	je      akiro

krit2:  mov     mema,1
	mov     ax,stilmn
	mov     word ptr cs:sthmnhm,ax

plir:   call    for_metrima
	@SETWIND        wmetrima
	call    metrima_print
	call    plhra
	call    metrima_print

	cmp     mema,0
	je      kln
;	cmp     fatal_stack,0
;	je      goris
	cmp     cound,0
	jne     exstl
	cmp     cound[2],0
	jne     exstl
	mov     memory,0
	mov     exomnimi,0
	call    klidvma_oxi
	jmp     kln

exstl:  cmp     arxascii,0
	je      goris
	call    klidvma

goris:  call    if_mnimi_on
	jnc     kln
	call    klidvma_oxi
kln:    mov     mema,0
	mov	cs:patise_taf,1
	call    genend
akiro:  @DELWIND        wmetrima
	@POP
	ret
metrima_stilon  endp


get_mnimi       proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	cmp     memory,0
	je      for_mnimi_1

	mov     strbuf,0
	@NAIOXI 34,12,mmnimi1,strbuf,mmnimi3
	jnc     zer_mnimi
	@POP
	ret

zer_mnimi:
	mov     memory,0
	mov     exomnimi,0
	call    klidvma_oxi
	call    sbmon
	@POP
	ret

for_mnimi_1:
	call    if_plires
	jc      no_plr
	mov     strbuf,0
	@NAIOXI 34,12,mmnimi1,strbuf,mmnimi2
	jnc     set_mnimi
no_plr: @POP
	ret
set_mnimi:
	call    tajinompr
	call    prbuf
	call    putsthles
	call    clear_sthl_buf
	mov     memory,1
	mov     exomnimi,0
	call    grmon
	@POP
	ret
get_mnimi       endp

ekt_ouoni       proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     errorpl,0
	call    check_plhres
	jnc     kokoe
	mov     errorpl,1
kokoe:  call    check_all
	jnc     secam8
	@POP
	ret
secam8: @TAKEWIND
	push    ax
	@SETWIND        wstlouoni
	@SELECTWIND     wstlouoni
	call    for_ekt_ouoni
	call    plhra
	call    stl2ouoni
	mov	cs:patise_taf,1
	call    genend
crh3:   @DELWIND        wstlouoni
	pop     ax
	@SELECTWI       al
	@POP
	ret
ekt_ouoni       endp

chk_pindial     proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1

;----------------------------------------- Agonas14	
	mov	al,dialsuper13
	cmp	al,"1"
	jne	ndtt1
	mov	Agonas14_Dialogi,1
	jmp	ndtt3
ndtt1:	cmp	al,"X"
	jne	ndtt2
	mov	Agonas14_Dialogi,2
	jmp	ndtt3
ndtt2:	cmp	al,"2"
	jne	ndtt1
	mov	Agonas14_Dialogi,3
  
ndtt3:	mov     cx,13
	xor     bx,bx
	xor     ax,ax
ckpin1: cmp     pindial[bx],0
	jne     ckpin3
	inc     ax
	cmp     ax,6
	jae     ckpin2
ckpin3: inc     bx
	loop    ckpin1
	@POP
	clc
	ret
ckpin2: @POP
	stc
	ret
chk_pindial     endp

dialogi_ouoni   proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    chk_pindial
	jc      pind0
	call    check_all
	jnc     seca88
pind0:  @POP
	ret

seca88: @TAKEWIND
	push    ax
	@SETWIND        wdialogi
	@SELECTWIND     wdialogi
	call    for_dialogi_ouoni
	call    plhra
	mov     fatal_stack,0
	mov	cs:patise_taf,1
	call    genend
	@DELWIND        wdialogi
	pop     ax
	@SELECTWI       al
	@POP
	ret
dialogi_ouoni   endp

save_ascii proc    near
;****************************************
IFNDEF	@DEMO
;****************************************
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    check_all
	jnc     assecam9
feta:	@POP
	ret
assecam9:
;********************************* elegxos an metablhto
	mov     bx,arxascii
	cmp     bx,0
	je      feta
	sub     bx,48
	@CHANGESEGM     ds,DATASC
	mov     dl,arxasc[bx]
	@CHANGESEGM     ds,DATAS1
	cmp     dl,"M"
	je      feta
;*********************************
	call    if_mnimi_on
	je      askrit3
	jmp     asplir

askrit3:  mov     segm,0
	mov     shmeat,0
	mov     mema,0

asplir: call    for_ascii
	@CHANGESEGM	ds,DATAS1

	mov	pinsthl3[13],13
	mov	pinsthl3[14],10
	call	input_name_ascii
	jnc	kitare
	@POP
	ret

kitare:	@SETWIND	wplwait
	@CREATE_HANDLE	asciidisk,0
	mov	cs:ascii_handle,ax

	call    metrima_print
	call    plhra
	call    metrima_print
	@CLOSE_HANDLE	cs:ascii_handle
	cmp     mema,0
	je      askln
	cmp     fatal_stack,0
	je      asgoris
	cmp     cound,0
	jne     asexstl
	cmp     cound[2],0
	jne     asexstl
	mov     memory,0
	mov     exomnimi,0
	call    klidvma_oxi
	jmp     askln

asexstl:  cmp     arxascii,0
	je      asgoris
	call    klidvma

asgoris:  call    if_mnimi_on
	jnc     askln
	call    klidvma_oxi
askln:  mov     mema,0
	mov	cs:patise_taf,0
	call    genend
asakiro: @DELWIND        wplwait
	@POP
;****************************************
ENDIF
;****************************************
	ret
save_ascii  endp


deltia_plirakia proc    near
;*****************************************
IFDEF   @NORMAL
;*****************************************
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    check_plhres
	jc      delpl2
	call    check_all
	jnc     secam4
delpl2: @POP
	ret

secam4: @TAKEWIND
	push    ax
	@SETWIND        wdeltio_pliraki
	@SELECTWIND     wdeltio_pliraki

	call	super13ari

	call    for_dlt_plirakia
	@CREATE_HANDLE  aples_file,0
	jc      crh2
	mov     aples_handle,ax

	call    plhra

	cmp     fatal_stack,0
	je      crh2
	call    plir_1
	cmp     fatal_stack,0
	je      crh2
	call    plir_2
	@CLOSE_HANDLE   aples_handle
	cmp     fatal_stack,0
	je      crh2
	cmp     exi_aples,0
	je      crh2
	
	call    plir_3
	jmp     crh4
	
crh2:   mov	cs:patise_taf,1
	call    genend
	@DELWIND        wdeltio_pliraki
crh4:   pop     ax
	@SELECTWI       al
	@POP
;*****************************************
ENDIF
;*****************************************
	ret
deltia_plirakia endp

super13ari	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@SETWIND	wsuper13
	@SELECTWIND	wsuper13
	xor	ax,ax
	mov	al,Agonas14_Anaposa
	@ITOA	strbuf,2
	@WPRINT	13,5,strbuf
	
	xor	ax,ax
	mov	al,Agonas14_Thesi
	@ITOA	strbuf,2
	@WPRINT	13,6,strbuf

alis0:	@WPRINT	13,3,Agonas14_Simio
	@CURSW	13,3
	@UPPERAX

alis8:	cmp	al,"1"
	jne	fghj1
	jmp	alis1

fghj1:	cmp	al,"2"
	jne	fghj2
	jmp	alis2
	
fghj2:	cmp	al,"3"
	jne	fghj3
	jmp	alis3

fghj3:	cmp	al,"4"
	jne	fghj4
	jmp	alis4

fghj4:	cmp	al,"5"
	jne	fghj5
	jmp	alis5

fghj5:	cmp	al,"6"
	jne	fghj6
	jmp	alis6

fghj6:	cmp	al,"7"
	jne	jjkf
	jmp	alis7

jjkf:	cmp	al,13
	jne	krity
	jmp	alis13

krity:	jmp	alis0
	
alis1:	mov	Agonas14_Simio[0],"1"
	mov	Agonas14_Simio[1]," "
	mov	Agonas14_Simio[2]," "
	mov	Agonas14_Simio_Code[0],2
	mov	Agonas14_Simio_Code[1],0
	mov	Agonas14_Simio_Code[2],0
	mov	Agonas14_Simio_Code[4],2
	jmp	alis0
alis2:	mov	Agonas14_Simio[0],"2"
	mov	Agonas14_Simio[1]," "
	mov	Agonas14_Simio[2]," "
	mov	Agonas14_Simio_Code[0],4
	mov	Agonas14_Simio_Code[1],0
	mov	Agonas14_Simio_Code[2],0
	mov	Agonas14_Simio_Code[4],4
	jmp	alis0
alis3:	mov	Agonas14_Simio[0],"X"
	mov	Agonas14_Simio[1]," "
	mov	Agonas14_Simio[2]," "
	mov	Agonas14_Simio_Code[0],3
	mov	Agonas14_Simio_Code[1],0
	mov	Agonas14_Simio_Code[2],0
	mov	Agonas14_Simio_Code[4],3
	jmp	alis0
alis4:	mov	Agonas14_Simio[0],"1"
	mov	Agonas14_Simio[1],"2"
	mov	Agonas14_Simio[2]," "
	mov	Agonas14_Simio_Code[0],4
	mov	Agonas14_Simio_Code[1],2
	mov	Agonas14_Simio_Code[2],0
	mov	Agonas14_Simio_Code[4],6
	jmp	alis0
alis5:	mov	Agonas14_Simio[0],"X"
	mov	Agonas14_Simio[1],"2"
	mov	Agonas14_Simio[2]," "
	mov	Agonas14_Simio_Code[0],4
	mov	Agonas14_Simio_Code[1],3
	mov	Agonas14_Simio_Code[2],0
	mov	Agonas14_Simio_Code[4],7
	jmp	alis0
alis6:	mov	Agonas14_Simio[0],"1"
	mov	Agonas14_Simio[1],"X"
	mov	Agonas14_Simio[2]," "
	mov	Agonas14_Simio_Code[0],3
	mov	Agonas14_Simio_Code[1],2
	mov	Agonas14_Simio_Code[2],0
	mov	Agonas14_Simio_Code[4],5
	jmp	alis0
alis7:	mov	Agonas14_Simio[0],"1"
	mov	Agonas14_Simio[1],"X"
	mov	Agonas14_Simio[2],"2"
	mov	Agonas14_Simio_Code[0],4
	mov	Agonas14_Simio_Code[1],3
	mov	Agonas14_Simio_Code[2],2
	mov	Agonas14_Simio_Code[4],9
	jmp	alis0
	
alis13:	xor	ax,ax
	mov	al,Agonas14_Anaposa
	@ITOA	strbuf,2
	@WINPUTNUMBER	13,5,strbuf
	@ATOI	strbuf
	mov	Agonas14_Anaposa,al

	xor	ax,ax
	mov	al,Agonas14_Thesi
	@ITOA	strbuf,2
	@WINPUTNUMBER	13,6,strbuf
	@ATOI	strbuf
	cmp	al,1
	jb	malar2
	cmp	al,14
	ja	malar2
	jmp	malar1
malar2:	mov	al,14
malar1:	mov	Agonas14_Thesi,al
	@DELWIND	wsuper13
	@POP
	ret
super13ari	endp

dialsup13	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@SETWIND	wdialsuper13
	@SELECTWIND	wdialsuper13
dslis0:	@WPRINTCH	13,3,dialsuper13
	@CURSW	13,3
	cmp	al,"1"
	je	dslis1
	cmp	al,"2"
	je	dslis2
	cmp	al,"3"
	je	dslis3
	cmp	al,13
	je	dslis13
	cmp	al,"T"
	je	dslis13
	cmp	al,"t"
	je	dslis13
	cmp	al,"."
	je	dslis13
	jmp	dslis0
dslis1:	mov	dialsuper13,"1"
	jmp	dslis0
dslis2:	mov	dialsuper13,"2"
	jmp	dslis0
dslis3:	mov	dialsuper13,"X"
	jmp	dslis0
dslis13:
	@DELWIND	wdialsuper13
	@POP
	ret
dialsup13	endp

plir_1  proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     fatal_stack,sp
	mov     ax,axbp
	cmp     ax,plirpoint
	je      epej

plr4_3:	jmp	epej2

	call    epejergasia
epej:   cmp     axbp,0
	je      epej1

plr4_4:	jmp	epej2

	call    telikh_epejergasia
epej1:  @POP
	ret
epej2:	call	buffer_full
	@POP
	ret
plir_1  endp

plir_2  proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     fatal_stack,sp
	cmp     axbp,0
	je      epej3
	call    plirakia_print
epej3:  @POP
	ret
plir_2  endp

plir_3  proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	@DELWIND        wdeltio_pliraki
	@SETWIND        wdeltio_axb
	@SELECTWIND     wdeltio_axb
	@BELL

	call    plir_31
	mov	cs:patise_taf,1
	call    genend
	@DELWIND        wdeltio_axb
	@POP
	ret
plir_3  endp

plir_31 proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     fatal_stack,sp
	call    apla_deltia_from_file
	@POP
	ret
plir_31 endp

omadopiisi      proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    savetmp
	mov     ax,cound
	mov     coundq,ax
	mov     ax,cound[2]
	mov     coundq[2],ax
	call    kauarisma_metab
	call    tajinompr
	call    omades
	call    prometr
	call    metrima
	call    metrpr
	call    edomad
	call    editr
	call    editomr
	call    edtomr1
	call    editot
	call    tajasc
	jnc     bug9
	call    toobig
bug9:   mov     ax,coundq
	mov     cound,ax
	mov     ax,coundq[2]
	mov     cound[2],ax
	call    savetmp
	call    screen
	call    prbuf
	@POP
	ret
omadopiisi      endp

dialogi_plirakia        proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	call    check_plhres
	jc      pind2
	call    chk_pindial
	jc      pind2
	call    check_all
	jnc     all_2
pind2:  @POP
	ret
all_2:  @TAKEWIND
	push    ax
	@SETWIND        wdial1
	@SETWIND        wdial2

	mov     dialogi,1
	mov     grammh,3

	call    for_dlt_plirakia
	@CREATE_HANDLE  aples_file,0
	jc      crhd2
	mov     aples_handle,ax

	call    plhra

	cmp     fatal_stack,0
	je      crhd2
	call    plir_1
	cmp     fatal_stack,0
	je      crhd2
	call    plir_21
	@CLOSE_HANDLE   aples_handle
	cmp     fatal_stack,0
	je      crhd2
	cmp     exi_aples,0
	je      crhd2
	
	@CLOSE_HANDLE   aples_handle
	call    plir_31
	
crhd2:  mov	cs:patise_taf,1
	cmp	dial_xarti,1
	jne	no2xartipl
	mov	cs:patise_taf,0
no2xartipl:
	call    genend
	@DELWIND        wdial2
	@DELWIND        wdial1
	pop     ax
	@SELECTWI       al
	@POP
	ret
dialogi_plirakia        endp

plir_21 proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     fatal_stack,sp
	cmp     axbp,0
	je      epej31

	call    plirakia_dialogi

epej31: @POP
	ret
plir_21 endp


check_all       proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
;	call    axbpoke 
	call    geniki_taj
	jnc     chkal2
	jmp     chkal1

chkal2: call    if_mnimi
	jnc     chkal0
	call    if_plires
	jnc     chkal0
	call	if_ascii
	jnc	chkal0
chkal1: @POP
	stc
	ret

chkal0: @POP
	clc
	ret
check_all       endp

testonom        proc    near
	@PUSH
	@CHANGESEGM     ds,WINSEGM
	@STRXOR tstcpr2,39
	@STRCMP tstcpr2,tstcpr1
	jnc     idio
	@EXIT
idio:   @STRXOR tstcpr2,39
	@STRXOR tstcpr4,27
	@STRCMP tstcpr4,tstcpr5
	jnc     idio1
	@EXIT
idio1:  @STRXOR tstcpr4,27
	@POP
	ret
testonom        endp

testonom1       proc    near
	@PUSH
	@CHANGESEGM     ds,CODESG
	@CHANGESEGM     es,WINSEGM
	xor     bx,bx
idio2:  mov     al,tstcpr3[bx]
	cmp     al,0
	je      idio3
	xor     al,161
	mov     es:tstcpr1[bx],al
	inc     bx
	jmp     idio2
idio3:  @POP
	ret
tstcpr3 label   byte
XORDATA <’…—’…A‰†‘ ƒ. & AAƒŽŽ“ŠŽ‘ Š.>,161
	db      0
testonom1       endp

clear_sthl_buf  proc    near
	@PUSH
	@CHANGESEGM     ds,MAST1
	mov     ax,MAST1
allo_segm:
	mov     ds,ax
	push    cx
	xor     dx,dx
	xor     bx,bx
	mov     cx,32752        ;65504/2
allo_word:
	mov     word ptr ds:[bx],dx
	inc     bx
	inc     bx
	loop    allo_word
	pop     cx
	add     ax,4094
	cmp     ax,MAST6
	jb      allo_segm
	@POP
	ret
clear_sthl_buf  endp

default_disk    proc    near
	@PUSH
	@CHANGESEGM     ds,DATAS1
	mov     disk,"C"
	@OPEN_HANDLE    def_disk_file,I_READ
	jc      nofi
	mov     cs:handle,ax
	@READ_HANDLE    cs:handle,disk,1
	@CLOSE_HANDLE   cs:handle
nofi:   mov     al,disk
	mov     filedisk,al
	mov     disk_v95,al
	mov     filedisk_v95,al
	mov     v97dir,al
	mov	disk_asc,al
	mov	asciidisk,al
	mov	stat_disk,al
	@CHANGE_DIR     v97dir
	@POP
	ret
handle  dw      0
default_disk    endp

MyProg  proc    near
	@PUSH
;*********************************
klidi_epistrofi:
;*********************************
	@SETWINSEGM     WINSEGM
	@CHANGESEGM     ds,DATAS1
	@CHANGESEGM     es,DATANA
	call    load_inf
	call    load_lpt
	call    testonom
	call    testonom1
	@WAIT   20
	@DELWIND        wstart
	call    take_code
	call    init_code
	call	take_code_plr4
	call    screen
	call    prbuf
	call    copyright
	@BIGCURS
	call    default_disk
;**************************************************
;**************************************************

aloop:  call    prbuf
	mov     plktr," "
	mov     dx,18
	call    setcurs
	mov     dl," "
	call    dosdisp
loopa1: mov     dx,18
	call    setcurs
	@WAITL
;******************************
fokia:  @UPPERAX
gousouroum:
	cmp     al,0
	je      kasa
;****************************
lup_2:  cmp     al,27           ;escape
	jne     pll1
	call    help
	jmp     gousouroum
;****************************
pll1:   cmp     al,"/"
	je      _kyma
	cmp     al,"]"
	jne     pll3
_kyma:  jmp     dioru1
;****************************
pll3:   mov     dl,al
	cmp     dl,8
	je      kasa
	cmp     dl," "
	jae     klic
	jmp     aloop
klic:   cmp     dl,"~"
	jbe     __dd
	jmp     aloop
;****************************
__dd:   call    dosdisp
kasa:   mov     plktr,ax
	jmp     elegx
;****************************
;****************************	DIORUOSI OROU
;****************************
dioru1: mov     dx,18
	call    setcurs
	mov     dl," "
	call    dosdisp
	call    dioru
	mov     dx,arxascii
	cmp     ax,dx
	jb      noynoy
	mov     dl,stili
	mov     dh,0
	call    setcurs
	mov     dl," "
	call    dosdisp
	jmp     aloop

noynoy: mov     shmea5,1
	mov     dl,asthlh
	push    dx
	mov     dl,sthlh
	mov     asthlh,dl
	mov     dx,arxascii
	push    dx
	mov     arxascii,ax
	jmp     mplek
rrr1:   call    editor
mplek:  mov     dh,0
	mov     dl,stili
	call    setcurs
	mov     dl,219
	call    dosdisp
	mov     dh,0
	mov     dl,18
	call    setcurs
	cmp     shmeat,1
	jne     plkt1
	mov     al,"T"
	jmp     pll19
plkt1:  call    getkey
	cmp     al,0
	jne     oxi0
	cmp     ah,50h
	je      pll18
oxi0:   cmp     al,"."
	je      pll18
	cmp     al,13
	je      pll18
	jmp     pll19
pll18:  cmp     buffers[0],"W"
	je	bbpl1
  	cmp     buffers[0],"#"
	jne	plle1
bbpl1:	jmp     rrr1
plle1:  cmp     buffers[0],"B"
	jne     pll150
	jmp     rrr1
pll150: cmp     buffers[0],"J"
	jne     pll70
pll72:  mov     shmeat,0
	call    edast
	mov     shmea8,1
	mov     shmea1,1
	mov     shmea3,0
	call    editor1
	call    capo
	jmp     mplek
pll70:  cmp     buffers[0],"M"
	jne     tlms
	mov     shmeat,0
	call    edast
	call    editor2
	jmp     mplek
tlms:   cmp     buffers[0],"K"
	jne     pll71
	jmp     pll72
pll71:  cmp     buffers[0],"I"
	je      pll182
	cmp     buffers[0],"H"
	je      pll182
	jmp     pll181
pll182: mov     shmea8,1
	mov     shmeat,0
	call    edast
	jmp     rrr1
pll181: cmp     buffers[0],"L"
	jne     pll183
	mov     shmeat,0
	call    edast
	call    editor2
	jmp     mplek
pll183:	cmp     buffers[0],"("
	je	likeD
	cmp     buffers[0],")"
	je	likeD
	cmp     buffers[0],"D"
	jne     plqq3
likeD:	mov     shmeat,0
	call    edast
	call    editor2
	jmp     mplek
plqq3:  cmp     buffers[0],"}"
	jne     plqw1
	mov     shmeat,0
	call    edast
	call    editor2
	jmp     mplek
plqw1:  cmp     buffers[0],"%"
	jne     plqw3
	mov     shmeat,0
	call    edast
	call    editor2
	jmp     mplek
plqw3:  cmp     buffers[0],"0"
	jne     pll31
	mov     shmea1,1
	mov     shmea3,0
	mov     shmeat,0
	call    editor1
	jmp     mplek
pll31:  cmp     buffers[0],"X"
	jne     pll32
	mov     shmea7,1
	jmp     rrr1
pll32:  cmp     buffers[0],"Y"
	jne     pll33
	mov     shmea7,2
	jmp     rrr1
pll33:  cmp     buffers[0],"Z"
	jne     pll24
	mov     shmea7,2
	jmp     rrr1
pll24:  cmp     buffers[0],"U"
	jne     pll24i
	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,1
	mov     shmea_diplh,1
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	call    editor2
	mov     shmea_diplh,0
	jmp     mplek
pll24i: cmp     buffers[0],"O"
	jne     _ep
	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,2
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	call    editor2
	jmp     mplek
_ep:	cmp     buffers[0],"!"
	je	likeR
	cmp     buffers[0],"$"
	je	likeR
	cmp     buffers[0],"R"
	jne     _epq
likeR:	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,2
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	call    editor2
	jmp     mplek
_epq:   cmp     buffers[0],"5"
	jne     _epqi
	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,2
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	call    editor2
	jmp     mplek
_epqi:  cmp     buffers[0],"P"
	je      aqua
	cmp     buffers[0],"Q"
	je      aqua
	cmp     buffers[0],"@"
	je      aqua
	cmp     buffers[0],"A"
	je      aqua
	cmp     buffers[0],"S"
	je      aqua
	cmp     buffers[0],"6"
	je      aqua
	cmp     buffers[0],"&"
	je      aquax10
	cmp     buffers[0],"1"
	je      aqua
	cmp     buffers[0],"V"
	je      aqua
IFDEF	@STATISTIKA
	cmp     buffers[0],"<"
	je      aqua
ENDIF
	cmp     buffers[0],"2"
	je      aqua
	cmp     buffers[0],"3"
	je      aqua
	cmp     buffers[0],"4"
	je      aqua
	cmp     buffers[0],"5"
	je      aqua
	cmp     buffers[0],"\"
	je      aqua
	cmp     buffers[0],"{"
	je      aqua
	cmp     buffers[0],"7"
	je      aqua
	jmp     pll19
aqua:   mov     shmeat,0
	call    editor2
	jmp     mplek
aquax10:
	mov     al,buffers[4]
	cmp	al," "
	jne	l5421
	mov	al,"1"
l5421:	mov     strbuf[0],al
	mov     strbuf[1],0
	@WINPUTNUMBER   17,3,strbuf,emfanejo
	mov     al,strbuf[0]
	cmp     al," "
	je    	l541
	mov     buffers[4],al
l541:	mov     shmeat,0
	call    editor2
	jmp     mplek

pll19:  cmp     al,"T"
	jne     pll5
_taf:	@WPRINTCH       stili,0," "

	jmp     taf
pll5:   cmp     al,"/"
	je      _taf
	cmp     al,8
	je      _as
	cmp     al,"-"
	je      _as
	cmp     al,81
	jne     pll6
_as:

	@WPRINTCH       stili,0," "

	jmp     delet
pll6:   mov     shmeat,0
	jmp     plkt1
;***************************************
;***************************************
elegx:  mov     ax,plktr
	cmp     al,"*"
	jne     pll7
;****************************** PROTASIS
IFDEF 	@DILONO_ELEGXO
	call	dilono_elegxo
ELSE
IFDEF   @PROTASI
	call    protas
ENDIF
ENDIF
;******************************
	jmp     aloop
pll7:   cmp     al,0
	je      super
	jmp     aplo
;******************************
super:  cmp     ah,RIGHT_ARROW
	jne     super1
	jmp     selidas
super1: cmp     ah,LEFT_ARROW
	jne     super2
	jmp     selidam
super2: cmp     ah,_HOME
	jne     super3
	mov     selida,0
	call    prbuf
	jmp     aloop
super3: cmp     ah,_END
	jne     super4
	mov     ax,bselida
	cmp     ax,90
	jb      keses
	mov     bselida,89
	mov     ax,89
keses:  mov     selida,ax
	call    prbuf
super4: jmp     aloop
;**************************
;**************************
;**************************
aplo:   cmp     al,"W"
	je	bble2
	cmp	al,"#"
	jne     pll25
bble2:	jmp     basthl
pll25:  cmp     al,"X"
	jne     pll26
	mov     shmea7,1
	jmp     basthl
pll26:  cmp     al,"Y"
	jne     pll27
	mov     shmea7,2
	jmp     basthl
pll27:  cmp     al,"Z"
	jne     pll8
	mov     shmea7,2
	jmp     basthl
pll8:   cmp     al,"+"
	jne     pll9
	jmp     selidas
pll9:   cmp     al,"-"
	jne     pll10
	jmp     selidam
;***************************************** OMADOPOIISI
pll10:  cmp     al,";"
	jne     pll16
	call    omadopiisi
	jmp     aloop
;*****************************************
pll16:  cmp     al,"U"
	jne     pll16i
	call    xarakt
	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,1
	mov     shmea_diplh,1
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	mov     shmea_diplh,0
	jmp     xxar
pll16i:	cmp     al,"O"
	jne     _ep1
	call    xarakt
	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,2
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	jmp     xxar
_ep1:   cmp	al,"!"
	je	likeR1
	cmp	al,"$"
	je	likeR1
	cmp     al,"R"
	jne     _ep1q
likeR1:	call    xarakt
	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,2
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	jmp     xxar
_ep1q:  cmp     al,"5"
	jne     _ep1qi
	call    xarakt
	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,2
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	jmp     xxar
_ep1qi: cmp     al,"P"
	je      aqua3
	cmp     al,"Q"
	je      aqua3
	cmp     al,"@"
	je      aqua3
	cmp     al,"A"
	je      aqua3
	cmp     al,"S"
	je      aqua3
	cmp     al,"5"
	je      aqua3
	cmp     al,"6"
	je      aqua3
	cmp     al,"&"
	je      aqua3
	cmp     al,"7"
	je      aqua3
	cmp     al,"1"
	je      aqua3
	cmp     al,"V"
	je      aqua3
IFDEF	@STATISTIKA
	cmp     al,"<"
	je      aqua3
ENDIF
	cmp     al,"2"
	je      aqua3
	cmp     al,"4"
	je      aqua3
	cmp     al,"3"
	je      aqua3
	cmp     al,"\"
	je      aqua3
	cmp     al,"{"
	je      aqua3
	jmp     pll17
aqua3:  jmp     xarak
pll17:  cmp     al,"0"
	jne     pll21
	call    if_mnimi_on
	jnc     pll21
	call    if_ascii
	jnc     pll21
	jmp     plhres
pll21:  cmp     al,"I"
	jne     pll38
	jmp     astra
pll38:  cmp     al,"H"
	jne     pll51
	jmp     astra
pll51:  cmp     al,"L"
	jne     pll52
	jmp     skast
pll52: 	cmp     al,"("
	je	likeD1
 	cmp     al,")"
	je	likeD1
	cmp     al,"D"
	jne     plqq2
likeD1:	jmp     skast
plqq2:  cmp     al,"}"
	jne     plqw2
	jmp     skast
plqw2:  cmp     al,"%"
	jne     plqw4
	jmp     skast
plqw4:  cmp     al,"J"
	jne     pll60
	jmp     xvris
pll60:  cmp     al,"K"
	jne     pll61
	jmp     xvris
pll61:  cmp     al,"B"
	jne     pqq90
	jmp     basthl
;***************************************
pqq90:  
;*************************************** diakoptis mnimis
pll90:  cmp     al,"?"
	jne     metsebas
	call    get_mnimi
	jmp     aloop
;***************************************
metsebas:
metsetri:
;;;	cmp     al,""
;;;	jne     plqwr1
;;;	jmp     aloop
;***************************************
plqwr1:
;;;	cmp     al,""
;;;	jne     ndos
;;;	jmp     aloop
;***************************************
ndos:
;;;	cmp     al,""
;;;	jne     klark
;;;	jmp     aloop
;*************************************** Utilities
klark:  cmp     al,"["
	jne     koyl13
	call	utils
	jmp	aloop
;***************************************
koyl13:
;;;	cmp     al,""
;;;	jne     nklar
;;;	jmp     aloop
;*************************************** metrhths
nklar:  cmp     al,"G"
	jne     peqr1
	call    metrima_stilon
	jmp     aloop
;*************************************** pinakes
peqr1:  cmp     al,"C"
	jne     peqi45
	call    pinakes
	jmp     aloop
;***************************************
peqi45:	cmp     al,">"
	jne     peqi11
	call	super13ari
	jmp     aloop
;*************************************** elegxos
peqi11: cmp     al,"E"
	jne     peqi1
	call    elegxos
	jmp     aloop
;***************************************
peqi1:
;;;	cmp     al,""
;;;	jne     peqc4
;;;	jmp     aloop
;***************************************
peqc4:
;;;	cmp     al,""
;;;	jne     peqf4
;;;	jmp     aloop
;*************************************** sthlh dialoghs
peqf4:  cmp     al,"8"
	jne     peql3
	@SETWIND        wnikitr
	call    eisagvgh_dialoghs
	@DELWIND        wnikitr
	call	dialsup13
	call    save_inf
	jmp     aloop
;*************************************** diaxeirhsh arxeivn
peql3:  cmp     al,"9"
	jne     peqd4
lklm:   call    check_plhres
	call    arxeia
	jc      lq13
	call    prbuf
	call    putsthles
	jmp     aloop
lq13:   @FILLSCR        " ",07h
	@ENDPRG
	retf
;*************************************** metablhto
peqd4:  cmp     al,"M"
	jne     pll94
	call    tajinompr
	mov     bx,arxascii
	cmp     bx,0
	je      nairi
	sub     bx,48
	@CHANGESEGM     ds,DATASC
	mov     dl,arxasc[bx]
	@CHANGESEGM     ds,DATAS1
	cmp     dl,"M"
	je      pll94
nairi:  jmp     skast
;*************************************** sthles xima
pll94:  cmp     al,"F"
	jne     peqi
	call    ekt_ouoni
	jmp     aloop
;*************************************** ektiposis
peqi:   cmp     al,"N"
	jne     peqb4
	call	ektip
	jmp     aloop
;***************************************
peqb4:
;;;	cmp     al,""
;;;	jne     peqb48
;;;	jmp     aloop
;***************************************
peqb48:
;;;	cmp     al,""
;;;	jne     peqwd4
;;;	jmp     aloop
;***************************************
peqwd4:
;;;	cmp     al,""
;;;	jne     leqe4
;;;	jmp     aloop
;***************************************
leqe4:
;;;	cmp     al,""
;;;	jne     peqe4
;;;	jmp     aloop
;*************************************** dialogh se ouonh
peqe4:  cmp     al,","
	jne     peqg4
	call    dialogi_ouoni
	jmp     aloop
;***************************************
peqg4:
;;;	cmp     al,""
;;;	jne     peqi4
;;;	jmp     aloop
;***************************************
peqi4:
;;;	cmp     al,""
;;;	jne     peqj4
;;;	jmp     aloop
;***************************************
peqj4: 	cmp     al,"~"
	jne     plql4
	call    copyright
	jmp     aloop
;***************************************
plql4:  cmp     al,"^"
	jne     qwer12
	call    get_plirof
	jmp     aloop
;***************************************
qwer12:
;;;	cmp	al,""
;;;	jne	fgert
;;;	jmp	aloop
;*************************************** ALLA PLIKTRA
fgert:
;***************************************
	jmp     aloop
;***************************************
;
;
;
;********************************************************
;****                EISAGVGH ORVN                   ****
;********************************************************
xvris:  mov     buffers[0],al
	mov     shmeat,0
	call    asteri
	call    edast
	mov     shmea8,1
	mov     shmea1,1
	mov     shmea3,0
	call    editor1
	call    capo
	jmp     bas1
skast:  mov     buffers[0],al
	mov     shmeat,0
	call    asteri
	call    edast
	jmp     xxar
astra:  mov     buffers[0],al
	mov     shmeat,0
	call    asteri
	call    edast
	mov     shmea8,1
	jmp     rrr
xarak:  call    xarakt
	jmp     xxar
plhres: mov     buffers[0],"0"
	mov     buffers[45],80
	mov     buffers[47],0
	jmp     bas2

basthl: mov     bx,0
	mov     buffers[bx],al
	inc     bx
rrr:    call    editor
	jmp     bas1
xxar:   cmp     buffers[0],"&"
	jne     xxar9
	
	mov	al,buffers[4]
	cmp	al," "
	jne	l544
	mov	al,"1"
l544:	mov     strbuf[0],al
	mov     strbuf[1],0
	@WINPUTNUMBER   17,3,strbuf,emfanejo
	mov     al,strbuf[0]
	cmp     al," "
	je	l542
   	mov     buffers[4],al
l542:	mov     shmeat,0

xxar9:  call    editor2
bas1:   mov     dh,0
	mov     dl,18
	call    setcurs
	cmp     shmeat,1
	jne     plhkt
	mov     al,"T"
	jmp     pll12
plhkt:  call    getkey
	cmp     al,0
	jne     oxi0_1
	cmp     ah,50h
	je      pll1222
oxi0_1: cmp     al,"."
	je      pll1222
	cmp     al,13
	je      pll1222
	jmp     pll12
pll1222:
	cmp     buffers[0],"I"
	jne     pll40
	call    edast
	jmp     rrr
pll40:  cmp     buffers[0],"J"
	jne     pll57
pll59:  call    edast
	mov     shmea1,1
	mov     shmea3,0
	mov     shmeat,0
	call    editor1
	call    capo
	jmp     bas1
pll57:  cmp     buffers[0],"K"
	jne     pll58
	jmp     pll59
pll58:  cmp     buffers[0],"H"
	jne     pll54
	call    edast
	jmp     rrr
pll54:  cmp     buffers[0],"L"
	jne     pqq53
	call    edast
	jmp     xxar
pqq53:  cmp     buffers[0],"("
	je	likeD2
	cmp     buffers[0],")"
	je	likeD2
	cmp     buffers[0],"D"
	jne     pll53
likeD2:	call    edast
	jmp     xxar
pll53:  cmp     buffers[0],"}"
	jne     pll537
	call    edast
	jmp     xxar
pll537: cmp     buffers[0],"%"
	jne     pll536
	call    edast
	jmp     xxar
pll536: cmp     buffers[0],"0"
	jne     pll22
bas2:   mov     shmea1,1
	mov     shmea3,0
	mov     shmeat,0
	call    editor1
	jmp     bas1
pll22:  cmp     buffers[0],"U"
	jne     pll22i
	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,1
	mov     shmea_diplh,1
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	mov     shmea_diplh,0
	jmp     xxar
pll22i: cmp     buffers[0],"O"
	jne     _ep2
likeO2:	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,2
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	jmp     xxar
_ep2:   cmp     buffers[0],"5"
	jne     _ep2q
	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,2
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	jmp     xxar
_ep2q:  cmp     buffers[0],"!"
	je	likeR2
	cmp     buffers[0],"$"
	je	likeR2
	cmp     buffers[0],"R"
	jne     _ep2qi
likeR2:	mov     shmea2,0
	mov     shmea3,0
	mov     shmea7,2
	mov     bx,4
	mov     dh,3
	mov     dl,17
	call    x21
	jmp     xxar
_ep2qi: cmp     buffers[0],"P"
	je      aqua1
	cmp     buffers[0],"Q"
	je      aqua1
	cmp     buffers[0],"@"
	je      aqua1
	cmp     buffers[0],"A"
	je      aqua1
	cmp     buffers[0],"S"
	je      aqua1
	cmp     buffers[0],"6"
	je      aqua1
	cmp     buffers[0],"&"
	je      aqua1
	cmp     buffers[0],"1"
	je      aqua1
	cmp     buffers[0],"V"
	je      aqua1
IFDEF	@STATISTIKA
	cmp     buffers[0],"<"
	je      aqua1
ENDIF
	cmp     buffers[0],"2"
	je      aqua1
	cmp     buffers[0],"3"
	je      aqua1
	cmp     buffers[0],"4"
	je      aqua1
	cmp     buffers[0],"5"
	je      aqua1
	cmp     buffers[0],"\"
	je      aqua1
	cmp     buffers[0],"{"
	je      aqua1
	cmp     buffers[0],"7"
	je      aqua1
	jmp     pll20
aqua1:  jmp     xxar
pll20:  jmp     rrr
pll12:  cmp     al,"T"
	je      taf
	cmp     al,"/"
	je      taf
	jmp     pll11
taf:    mov     shmeat,0
	cmp     buffers[0],"R"
	je      _rq
	cmp     buffers[0],"&"
	je      _rq
	cmp     buffers[0],"5"
	je      _rq
	cmp     buffers[0],"U"
	je      _rq
	cmp     buffers[0],"O"
	je      _rq
	cmp     buffers[0],"!"
	je      _rq
	cmp     buffers[0],"$"
	je      _rq
	jmp     _r
_rq:	cmp     buffers[4],"0"
	je     _rolo
	cmp     buffers[4]," "
	jne     _r
_rolo:	jmp     pipi3
_r:     cmp     buffers[0],"M"
	jne     zmal
	mov     buffers[47],99
	mov     buffers[45],"M"
	mov     buffers[46]," "
	mov     buffers[44]," "
	cmp     buffers[40]," "
	jne     metb7
	mov     buffers[40],"3"
	mov     buffers[41],"0"
	jmp     metb1
metb7:  cmp     buffers[40],"3"
	jbe     metb1
	cmp     buffers[41]," "
	je      metb1
	mov     buffers[40],"3"
metb1:  cmp     buffers[42],"1"
	je      metb2
	cmp     buffers[42],"6"
	jae     metb3
	mov     buffers[42],"1"
	mov     buffers[43],"2"
	jmp     dtend
metb2:  cmp     buffers[43],"2"
	jbe     metb4
	mov     buffers[43],"2"
metb4:  jmp     dtend
metb3:  mov     buffers[43]," "
	jmp     dtend
zmal:   cmp     buffers[0],"0"
	jne     pqq1
	mov     cx,13
	xor     ax,ax
	mov     bx,1
pll36:  cmp     buffers[bx]," "
	je      pqq5
	inc     ax
pqq5:   add     bx,3
	loop    pll36
	cmp     ax,1
	jae     konter
	jmp     pipi3
konter: jmp     dtend
pqq1:   cmp     buffers[0],"P"
	je      aqua4
	cmp     buffers[0],"Q"
	je      aqua4
	cmp     buffers[0],"@"
	je      aqua4
	cmp     buffers[0],"A"
	je      aqua4
	cmp     buffers[0],"S"
	je      aqua4
	cmp     buffers[0],"6"
	je      aqua4
	cmp     buffers[0],"&"
	je      aqua4
	cmp     buffers[0],"1"
	je      aqua4
	cmp     buffers[0],"V"
	je      aqua4
IFDEF	@STATISTIKA
	cmp     buffers[0],"<"
	je      aqua4
ENDIF
	cmp     buffers[0],"2"
	je      aqua4
	cmp     buffers[0],"3"
	je      aqua4
	cmp     buffers[0],"4"
	je      aqua4
	cmp     buffers[0],"5"
	je      aqua4
	cmp     buffers[0],"\"
	je      aqua4
	cmp     buffers[0],"{"
	je      aqua4
	cmp     buffers[0],"7"
	je      aqua4
	jmp     pqq9
aqua4:  cmp     buffers[0],"&"
	je      perl7
	cmp     buffers[0],"6"
	jne     pqq2
perl7:  cmp     buffers[47],1
	jne     pqq2
	jmp     pipi3
pqq9:   mov     cx,13
	mov     bx,1
pqq3:   cmp     buffers[bx]," "
	jne     pqq2
	add     bx,3
	loop    pqq3
	jmp     pipi3
pqq2:   cmp     buffers[0],"Z"
	je      pqq4
	cmp     buffers[0],"V"
	je      pqq4
IFDEF	@STATISTIKA
	cmp     buffers[0],"<"
	je      pqq4
ENDIF
	cmp     buffers[0],"7"
	je      pqq4
	cmp     buffers[0],"J"
	je      pll23
	cmp     buffers[0],"K"
	je      pll23
	cmp     buffers[42]," "
	jne     pqq4
	jmp     pipi3
pqq4:   cmp     buffers[0],"Z"
	je      leo32
	cmp     buffers[0],"7"
	je      leo32
	cmp     buffers[0],"V"
	je      leo32
IFDEF	@STATISTIKA
	cmp     buffers[0],"<"
	je      leo32
ENDIF
leo33:  cmp     buffers[40]," "
	jne     pll23
	jmp     pipi3
leo32:  mov     buffers[42]," "
	mov     buffers[43]," "
	cmp     buffers[0],"7"
	jne     leo33
	mov     buffers[44]," "
	mov     buffers[45],"1"
	mov     buffers[46]," "
	mov     buffers[47],1
	jmp     leo33
pll23:  jmp     ctend
pll11:  cmp     al,8
	je      _as1
	cmp     al,"-"
	je      _as1
	cmp     al,81
	jne     pll13
_as1:   jmp     delet
pll13:  jmp     plhkt
delet:  mov     shmea4,1
	mov     cx,48
	mov     bx,0
pll50:  mov     buffers[bx]," "
	inc     bx
	loop    pll50
	jmp     dtend
ctend:  cmp     buffers[44],"N"         ;bale n ean keno
	je      aqua2
	cmp     buffers[44],"O"
	je      aqua2
	mov     buffers[44],"N"
aqua2:  cmp     buffers[45],32
	jne     caplb
	mov     buffers[45],49
	mov     buffers[47],1
caplb:  cmp     shmea11,0
	je      dten1
	mov     bx,1
	jmp     koka
dten1:  cmp     shmea8,0
	je      dtend
	mov     bx,3
	jmp     koka
dtend:  call    tend
	mov     shmea8,0
	mov     shmea7,0
	mov     shmea11,0
	cmp     shmea5,1
	jne     pll14
	jmp     smea53
pll14:  cmp     shmea5,2
	jne     pll15
	jmp     delete
pll15:  jmp     aloop
smea53: mov     shmea5,0
	pop     dx
	mov     arxascii,dx
	pop     dx
	mov     asthlh,dl
	jmp     aloop
selidas:mov     ax,selida
	cmp     bselida,ax
	jne     ngrab
	jmp     gyrnab
ngrab:  inc     selida
	cmp     selida,90
	jb      selini
	dec     selida
selini: call    prbuf
	jmp     aloop
;************************************
selidam:
	cmp     selida,0
	je      gyrnab
	dec     selida
	call    prbuf
gyrnab: jmp     aloop
koka:   cmp     buffers[bx]," "
	je      pipi3
pqq6:   mov     cx,13
pipi1:  cmp     buffers[bx]," "
	je      pipi2
	add     bx,3
	loop    pipi1
	jmp     dtend
pipi2:  cmp     buffers[bx]," "
	jne     pipi3
	add     bx,3
	loop    pipi2
	jmp     dtend
pipi3:  cmp     shmea5,1
	jne     pipi4
	jmp     mplek
pipi4:  jmp     bas1
delete: mov     shmea5,0
	pop     ax
	push    ax
	mov     dx,arxascii
	add     dx,48
	sub     ax,dx
	cmp     ax,0
	je      manas3
	@CHANGESEGM     ds,DATASC
	mov     cx,ax
	mov     si,dx
	mov     bx,dx
manas:  mov     dl,arxasc[si]
	mov     arxasc[si-48],dl
	inc     si
	loop    manas
;**********************
	xor     dx,dx
	mov     cx,48
	div     cx
	mov     cx,ax
	xor     dx,dx
	mov     ax,bx
	mov     bx,48
	div     bx
	mov     di,ax
diai:   mov     dl,klioro[di]
	mov     klioro[di-1],dl
	inc     di
	loop    diai
;**********************
	@CHANGESEGM     ds,DATAS1
manas3: pop     dx
	sub     dx,48
	mov     arxascii,dx
	@CHANGESEGM     ds,DATASC
	mov     cx,48
	mov     si,dx
manas1: mov     arxasc[si]," "
	inc     si
	loop    manas1
;****************************
	mov     ax,dx
	xor     dx,dx
	mov     bx,48
	div     bx
	mov     di,ax
	mov     klioro[di],0
;****************************
	@CHANGESEGM     ds,DATAS1
	pop     dx
	sub     dx,4
	mov     asthlh,dl
	cmp     dl,19
	je      manas2
	call    prbuf
	jmp     aloop
manas2: mov     asthlh,75
	dec     bselida
	call    prbuf
	jmp     aloop
;************************************ BASIKI
WWWW:	mov	bx,0
	mov	buffers[bx],al
	inc	bx
wwww03:	call	editor
	mov	dx,18
	call	setcurs
	cmp	shmeat,1
	jne	wwww01
	jmp	wwww_it_is_T
wwww01:	call	getKey
	cmp	al,0
	jne	wwww02
	cmp	ah,50h
	je	wwww03
wwww02:	cmp	al,"."
	je	wwww03
	cmp	al,13
	je	wwww03
	cmp	al,"T"
	jne	wwww04
wwww_it_is_T:


wwww04:	@EXIT			;LEO????
;*************************************
Myprog  endp

check_1	proc	near
	@PUSHAX
	mov     cx,13
	xor     ax,ax
	mov     bx,1
filia_2:
	cmp     buffers[bx]," "
	je      filia_1
	inc     ax
filia_1:
	add     bx,3
	loop    filia_2
	cmp     ax,1
	jae	filia_3
	@POPAX
	stc
	ret
filia_3:
	@POPAX
	clc
	ret
check_1	endp

check_oria	proc	near
	@PUSH
	@POP
	stc
	ret
filia_5:
	@POP
	clc
	ret
check_oria	endp

;*****************************************
klidi_do_poke	proc	near
	@PUSH
	mov	al,byte ptr cs:nopit
	mov	byte ptr cs:do_poke,al
	@POP
	retf
nopit:	nop
klidi_do_poke	endp
;*****************************************
CODESG  ends

CODESG2	segment public

	ASSUME  CS:CODESG2,DS:DATAS1

wind_statistika proc	near
;*****************************************
IFDEF	@STATISTIKA
;*****************************************
	@PUSH
	@CHANGESEGM	ds,DATAS1
;	cmp	arxascii,0
;	je	telr1
;	@POP
;	retf
;telr1:	cmp	memory,0
;	je	fasc
;	cmp	exomnimi,1
;	je	telr
;fasc:	cmp	metraAscii,0
;	jne	telr
;	@POP
;	retf	
telr:	@SETWINSEGM	WINSEGM
        @SETWIND menu_statistika
	@SELECTWIND	menu_statistika
	mov	cx,11
	xor	bx,bx
	mov	dh,3
	mov	dl,24
io_nex:	cmp	pioi_oroi[bx],0
	je	_next
	@WPRINTCH	dl,dh,17
_next:	inc	bx
	inc	dh
	loop	io_nex
	mov	cx,11
	mov	dh,3
	mov	dl,50
io_nex1:
	cmp	pioi_oroi[bx],0
	je	_next1
	@WPRINTCH	dl,dh,17
_next1:	inc	bx
	inc	dh
	loop	io_nex1
stain:	@FILLSTR	stat_arxeio," ",8
	@WPRINT	18,15,stat_arxeio
	@WINPUT	18,15,stat_arxeio
	jc	sta43
	call	addstat
	cmp	stat_arxeio,"."
	je	sta43
	@TESTDRIVE	stat_disk
	jnc	sta21
sta43:	jmp	f8_o2
sta21:	@TESTFILE	stat_arxeio
	jnc	sta5
	jmp	stain
sta5:	@WAIT	600
	jnc	_fff
	cmp	al,9
	jne	no_91
	jmp	f8_o2
no_91:	cmp	ah,@LEFT_ARROW
	je	_ff
	cmp	ah,@UP_ARROW
	je	_ff
	cmp	ah,@DOWN_ARROW
	je	_ff
	cmp	ah,@RIGHT_ARROW
	je	_ff
	cmp	ah,@FUNC8
	jne	_fff
	xor	ax,ax
_fff:	jmp	f8_o1
_ff:	mov	dl,1
	mov	dh,3
st_pl:	@INVERSE	dl,dh,25
kanena:
st_epom:
	@WAIT	600
	jc	_er
	jmp	f8_o
_er:	cmp	al,27
	jne	_no
	xor	ax,ax
	jmp	f8_o1
_no:	cmp	al,9
	jne	no_9
	jmp	f8_o
no_9:	cmp	ah,@LEFT_ARROW
	je	_l
	cmp	ah,@RIGHT_ARROW
	je	_rr
	cmp	ah,@UP_ARROW
	je	_u
	cmp	ah,@DOWN_ARROW
	je	_d
	cmp	al,@ENTER
	jne	dfer
	jmp	_fenter
dfer:	jmp	st_epom
f8_o1:	@DELWIND  menu_statistika
	@POP
        retf
_l:	cmp	dl,1
	je	st_epom
	@INVERSE	dl,dh,25
	mov	dl,1
	jmp	st_pl
_rr:	cmp	dl,27
	je	st_epom
	@INVERSE	dl,dh,25
	mov	dl,27
	jmp	st_pl
_u:	cmp	dh,3
	jne	_q1
	jmp	st_epom
_q1:	@INVERSE	dl,dh,25
	dec	dh
	jmp	st_pl
_d:	cmp	dh,13
	jne	_q2
	jmp	st_epom
_q2:	@INVERSE	dl,dh,25
	inc	dh
	jmp	st_pl
_fenter:
	xor	bx,bx
	mov	bl,dh
	sub	bx,3
	cmp	dl,27
	jne	_oxi43
	add	bx,11
_oxi43:	push	dx
	add	dl,23
	add	dh,3
	add	dl,14
	@QTAKE	dl,dh
	sub	dh,3
	sub	dl,14
	cmp	al,17
	je	_keno
	mov	al,17
	mov	pioi_oroi[bx],1
	jmp	_tip
_keno:	mov	al," "
	mov	pioi_oroi[bx],0
_tip:	@WPRINTCH	dl,dh,al
	pop	dx
	jmp	st_epom
f8_o:	@INVERSE	dl,dh,25
f8_o2:	@DELWIND  menu_statistika
	@POP
;*****************************************
ENDIF
;*****************************************
	retf
wind_statistika endp

addstat	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	mov	bx,0
jana:	cmp	stat_arxeio[bx],0
	je	endit
	cmp	stat_arxeio[bx]," "
	je	endit
	cmp	stat_arxeio[bx],"."
	je	endit
	inc	bx
	jmp	jana
endit:	mov	stat_arxeio[bx],"."
	mov	stat_arxeio[bx+1],"S"
	mov	stat_arxeio[bx+2],"T"
	mov	stat_arxeio[bx+3],"A"
	mov	stat_arxeio[bx+4],0
	@POP
	ret
addstat	endp

auristos	proc	near
	@PUSH
	@SETWIND        waurist
	@SELECTWIND	waurist
aur000:	mov	ax,cs:piosaur
	@ITOA	strbuf,2
	@WINPUTNUMBER   22,1,strbuf
	jc	aur001
	@ATOI	strbuf
	cmp	ax,1
	jb	aur000
	cmp	ax,9
	ja	aur000
	jmp	aur002
aur001:	@DELWIND        waurist
	@POP
	retf
aur002:	mov	cs:piosaur,ax
	call	aurist2scr
	call	auristedit
	jmp	aur000
piosaur	dw	1
auristos	endp

auristedit	proc	near
	@PUSH
	mov	ax,piosaur
	dec	ax
	mov	cx,84
	mul	cx
	inc	ax
	inc	ax
	mov	bx,ax
	mov	cs:scry,3
	mov	cx,13
aurs03:	mov	ax,auristikos[bx]
	@ITOA	strbuf,3
aure01:	@WINPUTNUMBER	7,cs:scry,strbuf
	jnc	aurs05
	jmp	aurs00
aurs05:	@ATOI	strbuf
	cmp	ax,100
	ja	aure01
	mov	auristikos[bx],ax

	mov	ax,auristikos[bx+2]
	@ITOA	strbuf,3
aure02:	@WINPUTNUMBER	13,cs:scry,strbuf
	jnc	aurs06
	jmp	aurs00
aurs06:	@ATOI	strbuf
	cmp	ax,100
	ja	aure02
	mov	auristikos[bx+2],ax

	mov	ax,auristikos[bx+4]
	@ITOA	strbuf,3
aure03:	@WINPUTNUMBER	19,cs:scry,strbuf
	jnc	aurs07
	jmp	aurs00
aurs07:	@ATOI	strbuf
	cmp	ax,100
	ja	aure03
	mov	auristikos[bx+4],ax

	add	bx,6
	inc	cs:scry
	loop	aurs97
	jmp	aurs98

aurs97:	jmp	aurs03


aurs98:	mov	ax,auristikos[bx]
	@ITOA	strbuf,4
aure04:	@WINPUTNUMBER	8,17,strbuf
	jnc	aurs08
	jmp	aurs00
aurs08:	@ATOI	strbuf
	cmp	ax,1300
	ja	aure04
	mov	auristikos[bx],ax

	mov	ax,auristikos[bx+2]
	@ITOA	strbuf,4
aure05:	@WINPUTNUMBER	19,17,strbuf
	jnc	aurs09
	jmp	aurs00
aurs09:	@ATOI	strbuf
	cmp	ax,1300
	ja	aure05
	cmp	ax,auristikos[bx]
	jb	aure05
	mov	auristikos[bx+2],ax

aurs00:	@POP
	ret
auristedit	endp

aurist2scr	proc	near
	@PUSH
	mov	ax,piosaur
	dec	ax
	mov	cx,84
	mul	cx
	inc	ax
	inc	ax
	mov	bx,ax
	mov	cs:scry,3
	mov	cx,13
aurs01:	mov	ax,auristikos[bx]
	@ITOA	strbuf,3
	@WPRINT	7,cs:scry,strbuf
	mov	ax,auristikos[bx+2]
	@ITOA	strbuf,3
	@WPRINT	13,cs:scry,strbuf
	mov	ax,auristikos[bx+4]
	@ITOA	strbuf,3
	@WPRINT	19,cs:scry,strbuf
	add	bx,6
	inc	cs:scry
	loop	aurs99
	mov	ax,auristikos[bx]
	@ITOA	strbuf,4
	@WPRINT	8,17,strbuf
	mov	ax,auristikos[bx+2]
	@ITOA	strbuf,4
	@WPRINT	19,17,strbuf
	
	@POP
	ret
aurs99:	jmp	aurs01
scry	db	0
aurist2scr	endp

pollaplasiast	proc	near
	@PUSH
	@CHANGESEGM	ds,DATAS1
	@SETWINSEGM	WINSEGM
        @SETWIND wpollapl
	@SELECTWIND	wpollapl

	@FILLSTR	strbuf," ",12
	@LTOA	triades_poll_apo,triades_poll_apo[2],strbuf
	@USING	strbuf,10," "
	@WPRINT	8,3,strbuf

	@FILLSTR	strbuf," ",12
	@LTOA	triades_poll_eos,triades_poll_eos[2],strbuf
	@USING	strbuf,10," "
	@WPRINT	8,4,strbuf

	@LTOA	triades_poll_apo,triades_poll_apo[2],strbuf
	@USING	strbuf,10," "
	@WINPUTNUMBER	8,3,strbuf
	@ATOL	strbuf
	mov	triades_poll_apo,ax
	mov	triades_poll_apo[2],dx
	@FILLSTR	strbuf," ",12
	@LTOA	triades_poll_apo,triades_poll_apo[2],strbuf
	@USING	strbuf,10," "
	@WPRINT	8,3,strbuf

	@LTOA	triades_poll_eos,triades_poll_eos[2],strbuf
	@USING	strbuf,10," "
	@WINPUTNUMBER	8,4,strbuf
	@ATOL	strbuf
	mov	triades_poll_eos,ax
	mov	triades_poll_eos[2],dx
	@FILLSTR	strbuf," ",12
	@LTOA	triades_poll_eos,triades_poll_eos[2],strbuf
	@USING	strbuf,10," "
	@WPRINT	8,4,strbuf

	@DELWIND	wpollapl
	@POP
	retf
pollaplasiast	endp

CODESG2	ends

	end     main
 