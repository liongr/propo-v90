        page
;
@get_wind       macro   mx,my,ix,iy
                push    dx
                push    ax
                mov     dl,mx
                mov     dh,my
                mov     al,ix
                mov     ah,iy
                call    get_window
                pop     ax
                pop     dx
                endm
;
@set_wind       macro   wind
                push    ax
                push    dx
                push    bx
                mov     bx,offset wind
                mov     dl,[bx]
                mov     dh,[bx+1]
                mov     al,[bx+2]
                mov     ah,[bx+3]
		add	bx,4
                call    get_window
                call    set_window
                pop     bx
                pop     dx
                pop     ax
                endm
;
@put_wind       macro   wind
                push    dx
                push    ax
                mov     bx,offset wind
                mov     dl,[bx]
                mov     dh,[bx+1]
                mov     al,[bx+2]
                mov     ah,[bx+3]
                call    put_window
                pop     ax
                pop     dx
                endm
;
@qprint		macro	mx,my,char,attr
		mov	dl,mx
		mov	dh,my
		mov	al,char
		mov	ah,attr
		call	qprint
		endm
;
@wait		macro	time
		push	dx
		mov	dx,time
		call	iwait
		pop	dx
		endm
;
@PUSH	macro
	push	ds
	push	es
	push	ax
	push	bx
	push	dx
	push	cx
	push	si
	push	di
	endm
;
@POP	macro
	pop	di
	pop	si
	pop	cx
	pop	dx
	pop	bx
	pop	ax
	pop	es
	pop	ds
	endm
;
create_handle   macro   path,attr
                mov     dx,offset path
                mov     cx,attr
                mov     ah,3ch
                int     21h
                endm
;
open_handle     macro path,access
                mov     dx,offset path
                mov     al,access
                mov     ah,3dh
                int     21h
                endm
;
close_handle    macro   handle
                mov     bx,handle
                mov     ah,3eh
                int     21h
                endm
;
read_handle     macro   handle,buffer,bytes
                mov     bx,handle
                mov     dx,offset buffer 
                mov     cx,bytes
                mov     ah,3fh
                int     21h
                endm
;
write_handle    macro   handle,data,bytes
                mov     bx,handle
                mov     dx,offset data
                mov     cx,bytes
                mov     ah,40h
                int     21h
                endm
;
move_ptr        macro   handle,high,low,method
                mov     bx,handle
                mov     cx,high
                mov     dx,low
                mov     al,method
                mov     ah,42h
                int     21h
                endm
;
;
;
stacksg segment stack
        dw      100 dup(?)
stacksg ends
;
;
;
data	segment
scrbuf  db      2000 dup(?)
screen	dw	0
attr	db	07h
attr1	db	70h
attribute db	70h
met0	dw	0
ascbuf	db	10 dup(0)
shmeio	db	0
	db	0
sthlh	db	13 dup(0)
	db	0
oria	db	0
oria1	db	0
oria2	db	0
string	db	40
chars	db	?
input	db	41 dup (?)
typos	db	"APXEIO : ",0
handle	dw	0
handle1	dw	0
bytes1	dw	0
bite	dw	0
asc_in	db	100 dup(?)
asc_out	db	60000 dup(?)
;-------------------------- parauira
scr	db	7,1,60,15
	db	25 dup(0)
data	ends
;
code	segment
;
assume	cs:code,ds:data,es:data
;
main	proc	far
	push    ds
	mov     ax,0
	push    ax
	mov	ax,data
	mov	ds,ax
	mov	es,ax
	lea	dx,typos
	call	dispmhn
	lea	dx,string
	mov	ah,0ah
	int	21h
	xor	bx,bx
	mov	bl,(chars)
	push	bx
	mov	input[bx],"."
	mov	input[bx+1],"T"
	mov	input[bx+2],"L"
	mov	input[bx+3],"K"
	mov	input[bx+4],0
	mov	dl,13
	call	biosdisp
	mov	dl,10
	call	biosdisp
	open_handle input,0
	jnc	_ok0
	mov	al,"2"
	pop	bx
	jmp	ejodos
_ok0:	mov	handle,ax
	pop	bx
	mov	input[bx+1],"S"
	mov	input[bx+2],"T"
	mov	input[bx+3],"A"
	mov	input[bx+4],0
	create_handle	input,0
	jnc	_ok2
	mov	al,"3"
	jmp	ejodos
;**************************************
_ok2:	mov	handle1,ax
;**************************************
	read_handle	handle,asc_in,16
	move_ptr	handle,0,0,0
	mov	bite,13
	cmp	asc_in[13]," "
	ja	ascalo
	inc	bite
	cmp	asc_in[14]," "
	ja	ascalo
	inc	bite
	cmp	asc_in[15]," "
	ja	ascalo
	jmp	ejodos
;**************************************************
ascalo:
	xor	si,si
epomenos:
	mov	asc_in[12],0
	read_handle	handle,asc_in,bite
	jnc	exok
	jmp	telos
exok:	cmp	asc_in[12],0
	jnc	exok1
	jmp	telos
exok1:	cmp	ax,bite
	je	exok2
	jmp	telos
exok2:
	mov	cx,13
	xor	bx,bx
asc12:	mov	al,asc_in[bx]
	mov	dl,al
	call	biosdisp
	call	ascicode
	mov	sthlh[bx],al
	inc	bx
	loop	asc12

	mov	dl,13
	call	biosdisp
;**************************************
	call	parago
	mov	al,(oria)
	call	poke
	mov	al,(oria2)
	call	poke
	mov	al,(oria1)
	call	poke
	call	symetr
	mov	al,(oria)
	call	poke
	call	enalag
	mov	al,(oria)
	call	poke
	call	ajones
	mov	al,(oria)
	call	poke
	call	baros
	mov	al,(oria)
	call	poke
	mov	(shmeio),1
	call	omassvn
	mov	al,(oria)
	call	poke
	mov	(shmeio),3
	call	omassvn
	mov	al,(oria)
	call	poke
	mov	(shmeio),2
	call	omassvn
	mov	al,(oria)
	call	poke
	call	dyades_syn
	mov	al,(oria)
	call	poke
	mov	(shmeio),1
	call	synmon
	mov	al,(oria)
	call	poke
	mov	(shmeio),3
	call	synmon
	mov	al,(oria)
	call	poke
	mov	(shmeio),2
	call	synmon
	mov	al,(oria)
	call	poke
	call	symetr_synex
	mov	al,(oria)
	call	poke
	call	enalag_omad
	mov	al,(oria)
	call	poke
	call	synomad
	mov	al,(oria)
	call	poke
	call	baros_2
	mov	al,(oria)
	call	poke
	mov	(shmeio),3
	call	asso_xi
	mov	al,(oria)
	call	poke
	mov	(shmeio),2
	call	asso_xi
	mov	al,(oria)
	call	poke
	mov	(shmeio),1
	call	asso_xi
	mov	al,(oria)
	call	poke
	call	triades_syn
	mov	al,(oria)
	call	poke
;*************************************
;	call	dyades_epanal	apo Genesis
;	mov	al,(oria)
;	call	poke
;	call	triades_epanal
;	mov	al,(oria)
;	call	poke
;*************************************
	jmp	epomenos
;*************************************
telos:	mov	al,200
	call	poke
	mov	bytes1,si
	write_handle	handle1,asc_out,bytes1
	close_handle	handle1
	ret
;*************************************
ejodos:	mov	dl,"e"
	call	biosdisp
	mov	dl,"r"
	call	biosdisp
	mov	dl,"r"
	call	biosdisp
	mov	dl,"o"
	call	biosdisp
	mov	dl,"r"
	call	biosdisp
	mov	dl," "
	call	biosdisp
	mov	dl,":"
	call	biosdisp
	mov	dl," "
	call	biosdisp
	mov	dl,al
	call	biosdisp
	ret
main	endp
;
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

poke	proc	near
	mov	asc_out[si],al
	inc	si
	cmp	si,59000
	jb	mikro
	pop	ax
	jmp	telos
mikro:	ret
poke	endp

dyades_syn proc	near
	push	si
	xor	ax,ax
	mov	cx,12
	lea	si,sthlh
dys_epom:
	mov	al,[si]
	cmp	al,[si+1]
	jne	dys_n
	inc	ah
dys_n:	inc	si
	loop	dys_epom
	mov	(oria),ah
	pop	si
        ret
dyades_syn endp
;
dyades_epanal proc	near
	push	si
	mov	cx,12
	lea	si,sthlh
	mov	di,offset cs:epanal
dy_01:	mov	dl,[si]
	mov	byte ptr [cs:di],dl
	inc	si
	inc	di
	loop	dy_01
	xor	ax,ax
	xor	dx,dx
	mov	si,offset cs:epanal
	mov	cx,6
dys_epepom1:
	cmp	cx,1
	je	di_ojo
	push	cx
	mov	al,[cs:si]
	cmp	al,10
	je	skouro
	mov	ah,[cs:si+1]
	mov	di,si
	inc	di
	inc	di
	dec	cx
dys_epepom:
	cmp	al,[cs:di]
	jne	dys_epn
	cmp	ah,[cs:di+1]
	jne	dys_epn
	inc	dl
	mov	byte ptr [cs:di],10
dys_epn:
	inc	di
	inc	di
	loop	dys_epepom
	cmp	dl,0
	je	skouro
	inc	dh
	xor	dl,dl
skouro:	pop	cx
	inc	si
	inc	si
	loop	dys_epepom1
di_ojo:
	mov	(oria),dh
	pop	si
        ret
epanal	db	12 dup(0)
dyades_epanal endp
;
triades_syn proc	near
	push	si
	xor	ax,ax
	mov	cx,11
	lea	si,sthlh
tris_epom:
	mov	al,[si]
	cmp	al,[si+1]
	jne	tris_n
	cmp	al,[si+2]
	jne	tris_n
	inc	ah
tris_n:	inc	si
	loop	tris_epom
	mov	(oria),ah
	pop	si
        ret
triades_syn endp
;
triades_epanal proc	near
	push	si
	mov	cx,12
	lea	si,sthlh
	mov	di,offset cs:epanal
tri_01:	mov	dl,[si]
	mov	byte ptr [cs:di],dl
	inc	si
	inc	di
	loop	tri_01
	xor	ax,ax
	xor	dx,dx
	mov	byte ptr [cs:eptri],0
	mov	si,offset cs:epanal
	mov	cx,4
tris_epepom1:
	cmp	cx,1
	je	tri_ojo
	push	cx
	mov	al,[cs:si]	
	cmp	al,10
	je	skouro1
	mov	ah,[cs:si+1]
	mov	dl,[cs:si+2]
	mov	di,si
	inc	di
	inc	di
	inc	di
	dec	cx
tris_epepom:
	cmp	al,[cs:di]
	jne	tris_epn
	cmp	ah,[cs:di+1]
	jne	tris_epn
	cmp	dl,[cs:di+2]
	jne	tris_epn
	inc	dh
	mov	byte ptr [cs:di],10
tris_epn:
	inc	di
	inc	di
	inc	di
	loop	tris_epepom
	cmp	dh,0
	je	skouro1
	inc	byte ptr [cs:eptri]
	xor	dh,dh
skouro1:
	pop	cx
	inc	si
	inc	si
	inc	si
	loop	tris_epepom1
tri_ojo:
	mov	ah,byte ptr [cs:eptri]
	mov	(oria),ah
	pop	si
        ret
eptri	db	?
triades_epanal endp
;
symetr_synex proc	near			;synexomena symetrika
	push	si
        lea     si,sthlh
        lea     di,sthlh+12
	xor	dx,dx
	xor	ax,ax
        mov     cx,6
sym_syn2:
	mov     al,[si]
        cmp     al,[di]
        jne     sym_syn_ch
	inc	ah
sym_s_epi:
	inc     si
        dec     di
        loop    sym_syn2
	cmp	dh,ah
	jae	sym_sq
	mov	dh,ah
sym_sq:	mov	(oria),dh
	pop	si
        ret
sym_syn_ch:
	mov	dl,ah
	xor	ax,ax
	cmp	dh,dl
	jae	sym_s_epi
	mov	dh,dl
	jmp	sym_s_epi
symetr_synex  endp
;
enalag_omad proc near			;omades enallagvn
	push	si
        mov     cx,12
	xor	dx,dx
	xor	ax,ax
        lea     si,sthlh
        mov     ah,[si]
        inc     si
olft:	cmp     ah,[si]
        je	olfb
	inc	al
	mov	ah,[si]
en_ome:
        inc     si
        loop    olft
	cmp	al,0
	je	en_ome1
	inc	dh
en_ome1:
	mov	(oria),dh
	pop	si
        ret
olfb:	mov	dl,al
	mov	al,0
	cmp	dl,0
	je	en_ome
	inc	dh
	jmp	en_ome
enalag_omad endp
;
ajones	proc	near			;ajones
	push	si
	mov	cx,11
	xor	ax,ax
	lea	si,sthlh
aj_epom:
	mov	al,[si]
	cmp	al,[si+2]
	jne	aj_oxi
	inc	ah
aj_oxi:	inc	si
	loop	aj_epom
	mov	(oria),ah
	pop	si
        ret
ajones	endp
;
enalag  proc    near            ;enallages
	push	si
        push    bx
        xor     bx,bx
        mov     cx,12
        lea     si,sthlh
        mov     ah,[si]
        inc     si
lft:    mov     al,[si]
        cmp     ah,al
        je	lfb
	inc	bl
lfb:    mov     ah,al
        inc     si
        loop    lft
        mov     al,bl
        pop     bx
	mov	(oria),al
	pop	si
        ret
enalag  endp
;
symetr  proc    near            ;summetrika
	push	si
        push    bx
        xor     bl,bl
        lea     si,sthlh
        lea     di,sthlh+12
        mov     cx,6
mngr1:  mov     al,[si]
        mov     ah,[di]
        cmp     al,ah
        jne     mngr2
	inc	bl
mngr2:  inc     si
        dec     di
        loop    mngr1
        mov     al,bl
        pop     bx
	mov	(oria),al
	pop	si
        ret
symetr  endp
;
omassvn proc    near            ;omades 1,x,2
	push	si
        xor     ax,ax
	mov	dl,(shmeio)
	inc	bx
        mov     cx,13
        lea     si,sthlh
aa:     mov     al,[si]
        cmp     al,dl
        je      ass
bb:     inc     si
        loop    aa
	mov	(oria),ah
	pop	si
        ret
ass:    dec     si
        cmp     al,[si]
        jne     gg
        inc     si
        jmp     bb
gg:     inc     ah
        inc     si
        jmp     bb
omassvn endp
;--------------------------------------------------------------
asso_xi	proc    near			;omades diplvn shmeivn
	push	si
        xor     ax,ax
	xor	dx,dx
        mov     cx,13
        lea     si,sthlh
	mov	al,(shmeio)
	inc	bx
ass_xi_epom:
        cmp     [si],al
        je      ass_xi_dio
	inc	dl
	jmp	ass_xi_no
ass_xi_dio:
	cmp	dl,1
	jbe	ass_xi_no_
	inc	ah
ass_xi_no_:
	xor	dx,dx
ass_xi_no:
	inc     si
        loop    ass_xi_epom
	cmp	dl,1
	jbe	ass_xi_oxi
	inc	ah
ass_xi_oxi:
	mov	(oria),ah
	pop	si
        ret
asso_xi	endp
;
;------------------------------------------------------
baros   proc    near            		;baros
	push	si
        mov     cx,13
        xor     ah,ah
        lea     si,sthlh
beros:  add     ah,[si]
        inc     si
        loop    beros
        sub     ah,13
	mov	(oria),ah
	pop	si
        ret
baros   endp
;
baros_2 proc    near            ;baros
	push	si
        mov     cx,13
        xor     ax,ax
        lea     si,sthlh
beros_2:
        mov     al,[si]
        cmp     al,1
        je      _as
        cmp     al,3
        je      _di
_pisv:  inc     si
        loop    beros_2
	mov	(oria),ah
	pop	si
	ret
_di:    inc     ah
_as:    inc     ah
        jmp     _pisv
baros_2 endp
;
synmon	proc	near
	push	si
	lea	si,sthlh
	xor	ax,ax
	mov	cx,13
synm_loop:
	mov	dl,(shmeio)
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
	mov	(oria),al
	pop	si
	ret
synmon	endp
;
synomad proc    near                    ;omades 12x
	push	si
	xor     ax,ax
        xor     di,di
        lea     si,sthlh
        mov     al,[si]
        inc     si
        mov     cx,13
goril1: cmp     al,[si]
        jne     kok
        inc     ah
kok1:   inc     si
        loop    goril1
        mov     ax,di
	mov	(oria),al
	pop	si
        ret
kok:    mov     al,[si]
        cmp     ah,1
        jb      kok1
        inc     di
        xor     ah,ah
        jmp     kok1
synomad endp
;
parago  proc    near            ;paragvga
	push	si
        xor     ax,ax
	xor	bx,bx
	mov	(oria2),al
        mov     cx,13
        lea     si,sthlh
pipa:	cmp     byte ptr [si],1
        je      aass
	cmp     byte ptr [si],2
        je      xxii
	inc	(oria2)
poph:   inc     si
        inc     di
        loop    pipa
	mov	(oria),ah
	mov	(oria1),bl
	pop	si
        ret
aass:   inc     ah
        jmp     poph
xxii:   inc     bl
        jmp     poph
parago	endp
;
bin_dec proc    near
	@PUSH
        sub     cx,cx
        lea     di,ascbuf
nextdig: push   cx
        mov     ax,dx
        sub     dx,dx
        mov     cx,10
        div     cx
        xchg    ax,dx
        add     al,30h
        mov     [di],al
        inc     di
        pop     cx
        inc     cx
        cmp     dx,0
        jnz     nextdig
emptbuf: dec    di
        mov     al,[di]
        mov     dl,al
        call    biosdisp
        mov     al,0
        mov     [di],al
        loop    emptbuf
	@POP
        ret
bin_dec endp
;
biosdisp proc   near
        push    ax
	mov     al,dl
	mov     ah,0eh
	int     10h
        pop     ax
        ret
biosdisp endp
;
dispmhn proc    near
        push    ax
        push    bx
        push    si
        xor     bx,bx
        mov     si,dx
mhn:    mov     dl,[si]
        cmp     dl,0
        je      endmhn
        call	biosdisp
        inc     si
        jmp     mhn
endmhn: pop     si
        pop     bx
        pop     ax
        ret
dispmhn endp
;
init_screen proc near
	mov	ah,0fh
	int	10h
	cmp	al,7
	je	herc
	cmp	al,2
	je	cga
	cmp	al,3
	je	cga
	pop	ds
	stc
	ret
herc:	mov	(screen),0b000h
	jmp	in_ret
cga:	mov	(screen),0b800h
in_ret:	mov	ah,(attribute)
	mov	(attr1),ah
	call	inverse
	mov	(attr),ah
	clc
	ret
init_screen endp
;
inverse	proc	near
	push	dx
	push	ax
	and	ah,00001111b
	shl	ah,1
	shl	ah,1
	shl	ah,1
	shl	ah,1
	pop	dx
	and	dh,11110000b
	shr	dh,1
	shr	dh,1
	shr	dh,1
	shr	dh,1
	or	ah,dh
	pop	dx
	ret
inverse	endp
;
get_window proc near
        call    clrcurs
	push	ax
        push    bx
        push    dx
        push    cx
	dec	dh
	dec	dl
	inc	ah
	inc	ah
	inc	ah
	inc	al
	inc	al
	inc	al
	inc	al
        push    ax
        mov     bx,0
        xor     cx,cx
        mov     cl,ah
bb1:    pop     ax
        push    ax
        push    cx
        xor     cx,cx
        mov     cl,al
bbb:    call    qtake
        mov     scrbuf[bx],al
        inc     dl
        inc     bx
        loop    bbb
        pop     cx
        inc     dh
        pop     ax
        push    ax
        sub     dl,al
        loop    bb1
        pop     ax
        pop     cx
        pop     dx
        pop     bx
	pop	ax
        call    bigcurs
        ret
get_window endp
;
put_window proc near
        call    clrcurs
        push    ax
        push    bx
        push    dx
        push    cx
	dec	dh
	dec	dl
	inc	ah
	inc	ah
	inc	ah
	inc	al
	inc	al
	inc	al
	inc	al
	push	ax
        xor     cx,cx
        mov     cl,ah
        mov     bx,0
cc1:    pop     ax
        push    ax
        push    cx
	mov	(met0),dx
        xor     cx,cx
        mov     cl,al
ccc:    mov     al,scrbuf[bx]
	mov	ah,(attr1)
        call    qprint
        inc     bx
	inc	dl
        loop    ccc
	mov	dx,(met0)
        inc     dh
        pop     cx
        loop    cc1
        pop     ax
        pop     cx
        pop     dx
        pop     bx
	pop	ax
        call    bigcurs
        ret
put_window endp
;
set_window proc near
        call    clrcurs
        push    bx
        push    dx
        push    cx
        push    ax
        sub     ah,2
        sub     al,2
        push    ax
	mov	ah,(attr)
	mov	(met0),dx
        xor     cx,cx
        mov     cl,al
        mov     al,"É"
        call    qprint
	inc	dl
        mov     al,"Í"
siz0:   call    qprint
	inc	dl
        loop    siz0
        mov     al,"»"
        call    qprint
	inc	dl
	mov	dx,(met0)
        inc     dh
	mov	(met0),dx
        pop     ax
        push    ax
        xor     cx,cx
        mov     cl,ah
	mov	di,cx
dd1:    pop     ax
        push    ax
        push    cx
        xor     cx,cx
        mov     cl,al
	mov	ah,(attr)
        mov     al,"º"
        call    qprint
	inc	dl
ddd:    mov     al,[bx]
	cmp	al,0
	je	_w13
	call    qprint
        inc     bx
	inc	dl
        loop    ddd
	jmp	_w12
_w13:	mov	al," "
ddd3:	call	qprint
	inc	dl
	loop	ddd3
	inc	bx
_w12:	mov	ah,(attr)
        mov     al,"º"
        call    qprint
	cmp	cx,di
	je	_sex
	inc	dl
        mov     al,"°"	;"±"
        call    qprint
	inc	dl
        mov     al,"°"	;"±"
        call    qprint
_sex:	mov	dx,(met0)
	inc     dh
	mov	(met0),dx
        pop     cx
        loop    dd1
        pop     ax
	push	ax
        xor     cx,cx
        mov     cl,al
	mov	ah,(attr)
        mov     al,"È"
        call    qprint
	inc	dl
        mov     al,"Í"
siz4:   call    qprint
	inc	dl
        loop    siz4
	mov	ah,(attr)
        mov     al,"¼"
        call    qprint
	inc	dl
        mov     al,"°"	;"±"
        call    qprint
	inc	dl
        mov     al,"°"	;"±"
        call    qprint
	mov	dx,(met0)
	inc	dh
	inc	dl
	inc	dl
	pop	ax
	xor	cx,cx
	mov	cl,al
	inc	cx
	inc	cx
	mov	ah,(attr)
        mov     al,"°"	;"±"
siz5:	call    qprint
	inc	dl
	loop	siz5
        pop     ax
        pop     cx
        pop     dx
        pop     bx
        call    bigcurs
        ret
set_window endp
;
qtake	proc	near
	call	scr_offset
	push	ds
	push	ax
	mov	ax,(screen)
	mov	ds,ax
	pop	ax
	mov	al,byte ptr [si]
	mov	ah,byte ptr [si+1]
	pop	ds
	ret
qtake	endp
;
invstr	proc	near
	push	si
	push	dx
	push	ax
	push	cx
inv_next:
	call	qtake
	call	inverse
	call	qprint
	inc	dl
	loop	inv_next
	pop	cx
	pop	ax
	pop	dx
	pop	si
	ret
invstr	endp
;
qprint	proc	near
	call	scr_offset
	push	ds
	push	ax
	mov	ax,(screen)
	mov	ds,ax
	pop	ax
	mov	byte ptr [si],al
	mov	byte ptr [si+1],ah
	pop	ds
	ret
qprint	endp
;
scr_offset proc	near
	push	dx
	push	ax
	push	cx
	push	dx
	xor	ax,ax
	mov	al,dh
	mov	cl,160
	mul	cl
	mov	si,ax
	pop	dx
	mov	dh,0
	rol	dx,1
	add	si,dx
	pop	cx
	pop	ax
	pop	dx
	ret
scr_offset endp
;	
clrcurs proc    near
        push    ax
        push    cx
        push    bx
        mov     ah,1
        mov     ch,20h
        int     10h
        pop     bx
        pop     cx
        pop     ax
        ret
clrcurs endp
;
bigcurs proc    near
        push    ax
        push    cx
        mov     ah,1
        mov     ch,3
        mov     cl,7
        int     10h
        pop     cx
        pop     ax
        ret
bigcurs endp
;
iwait	proc	near
	push	ax
	push	cx
	push	bx
	push	dx
	push	ds
	mov	ax,40h
	mov	ds,ax
	mov	ax,dx
	xor	dx,dx
	mov	cx,18
	mul	cx
	mov	cx,10
	div	cx
	mov	cx,ax
	add	cx,word ptr [ds:6ch]
	jnc	wait_more
	mov	cx,65535
wait_more:
        mov     ax,word ptr [ds:6ch]
	cmp	ax,cx
	jae	wait_stop
	mov     ah,0bh
        int     21h
        cmp     al,0ffh
        je      wait_break
	jmp	wait_more
wait_stop:
	pop	ds
	pop	dx
	pop	bx
	pop	cx
	pop	ax
	clc
	ret
wait_break:
        mov     ax,word ptr [ds:6ch]
	cmp	ax,cx
	jae	wait_stop
	pop	ds
	pop	dx
	pop	bx
	pop	cx
	pop	ax
	call	getkey
	mov	word ptr [cs:switch],ax
	stc
	ret
switch	dw	0
iwait	endp
;
getkey	proc	near
	ret
getkey	endp
;
fill_scr proc	near
	xor	dx,dx
	mov	cx,25
ms2:	push	cx
	mov	cx,80
ms1:	call	qprint
	inc	dl
	loop	ms1
	pop	cx
	inc	dh
	mov	dl,0
	loop	ms2
	ret
fill_scr endp
;
code	ends
	end	main
	


