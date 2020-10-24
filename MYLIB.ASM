
INCLUDE mylib.inc
INCLUDE	xaza.inc

ESCAPE	= 27
LEFT	= 75
RIGHT	= 77
UP	= 72
DOWN	= 80
RETURN	= 13
TAB	= 9
INSER	= 52h
DEL	= 53h
LINE_FEED = 10
BACK_SPACE = 8		

@KEYBINT = 16h
@CTRL_BREAK = 1bh
@CTRL_C = 23h
@ERROR_HANDLE = 24h
@TIMER = 08h
@BREAKPOINT = 03h

@TESTFORDEBUG	macro
	local	no_debuger
	@PUSH
	@GETINT	@BREAKPOINT
	mov	ax,offset cs:BreakPoint
	cmp	ax,bx
	je	no_debuger
	call	exit
no_debuger:
	@POP
	endm

mcode	segment	public

	assume	cs:MCODE,ds:MCODE

find_sect       proc    near
	@PUSH
	push	cs
	pop	ds
        push    ax
        xor     dx,dx
        mov     cx,9
        div     cx
        push    ax
        xor     dx,dx
        mov     cx,2
        div     cx
        mov     _track,al
        cmp     dx,0
        je      _zyga
        mov     _head,1
        jmp     _synex
_zyga:  mov     _head,0
_synex: pop     ax
        xor     dx,dx
        mov     cx,9
        mul     cx
        pop     dx
        sub     dx,ax
        inc     dl
        mov     _sector,dl
	@POP
	retf
find_sect       endp

variabl	proc	near
_buffer	db	512 dup(0)
_sector	db	0
_track	db	0
_head	db	0
_drive	db	0
sector	dw	0
variabl	endp

set_win_segm	proc	near
	mov	cs:win_segment,ax
	retf
win_segment	dw	0
set_win_segm	endp

take_win_segm	proc	near
	mov	ax,cs:win_segment
	retf
take_win_segm	endp

start_prg	proc	near
	mov	ax,sp
	add	ax,2
	mov	cs:tstack,sp
	mov	ax,ds
	mov	cs:_prg_ds,ax

	@XAZOMARES

	@PUSH
	mov	al,1			;break off
	mov	dl,0
	mov	ah,19h			;drive
	int	21h
	mov	cs:start_drv,al
	call	far ptr initscreen
	mov	ah,08h			;attribute ouonhs
	mov	bx,cs:_scrpage
	int	10h
	mov	cs:start_attr,ah
	@GETINT	@CTRL_BREAK
	mov	cs:old_ctrl_break,bx
	mov	cs:old_ctrl_break[2],es
	@GETINT	@CTRL_C
	mov	cs:old_ctrl_c,bx
	mov	cs:old_ctrl_c[2],es
	@GETINT	@ERROR_HANDLE
	mov	cs:old_eror_handle,bx
	mov	cs:old_eror_handle[2],es
	@GETINT	@TIMER
	mov	cs:old_timer1,bx
	mov	cs:old_timer1[2],es
	@GETINT	@BREAKPOINT			;ean debuger
	mov	cs:old_breakpoint,bx
	mov	cs:old_breakpoint[2],es
	push	cs
	pop	ds
	mov	dx,offset cs:ctrl_c
;;	@DOINT	@CTRL_C
;;	mov	dx,offset cs:ctrl_break
;;	@DOINT	@CTRL_BREAK
;;	mov	dx,offset cs:error_handle
;;	@DOINT	@ERROR_HANDLE
;;	mov	dx,offset cs:BreakPoint
;;	@DOINT	@BREAKPOINT
	@POP
	retf
start_drv	db	0
start_attr	db	0
old_breakpoint	dw	0,0
old_ctrl_c	dw	0,0
old_ctrl_break	dw	0,0
old_eror_handle	dw	0,0
old_timer1	dw	0,0
tstack	dw	0
_prg_ds	dw	0
lock3	db	0
start_prg	endp

end_prg	proc	near
	@PUSH

	@XAZOMARES

	push	ds
	lds	dx,dword ptr cs:old_ctrl_c
	@DOINT	@CTRL_C
	lds	dx,dword ptr cs:old_ctrl_break
	@DOINT	@CTRL_BREAK
	lds	dx,dword ptr cs:old_eror_handle
	@DOINT	@ERROR_HANDLE
	lds	dx,dword ptr cs:old_timer1
	@DOINT	@TIMER
	lds	dx,dword ptr cs:old_breakpoint
	@DOINT	@BREAKPOINT
	pop	ds
	mov	dl,cs:start_drv
	mov	ah,0eh
	int	21h
	call	far ptr bigcurs
	@POP
	retf
end_prg	endp

get_start_drive	proc	near
	mov	al,cs:start_drv
	retf
get_start_drive	endp

reset	proc	near
	push	cs
	pop	ds

	@XAZOMARES

	mov	dx,offset cs:for_reset
	@DOINT	@TIMER

	@XAZOMARES

	retf
reset	endp

exit	proc	near

	@XAZOMARES

	push	ax
	push	cx
	inc	byte ptr cs:retffar
	pop	ax
	pop	cx
	mov	ax,cs:_prg_ds
	push	ax
	xor	ax,ax
	push	ax
	@PUSH
	call	far ptr end_prg
	call	far ptr bigcurs
	@POP
	pop	ax
	xchg	ax,dx
	push	dx
retffar	db	0cah	;0cbh - 1 = retff - 1
exit	endp

ctrl_c	proc	far
	sti
	iret
ctrl_c	endp

chktime	proc	near
	@PUSH
	mov	cs:_mytime,ax
	@GETINT	@TIMER
	mov	cs:old_timer,bx
	mov	cs:old_timer[2],es
	push	cs
	pop	ds
	mov	dx,offset cs:my_timer
	@DOINT	@TIMER
	mov	dx,_mytime
	call	far ptr iwait
	pushf
	lds	dx,dword ptr cs:old_timer
	@DOINT	@TIMER
	popf
	@POP
	retf
old_timer	dw	0,0
_mytime	dw	0
chktime	endp

for_reset	proc	far
	@XAZOMARES
	ret
for_reset endp

endrnd	proc	near
	@PUSH
	lds	dx,dword ptr cs:old_timer
	@DOINT	@TIMER
	@POP
	retf
endrnd	endp

startrnd proc	near
	@PUSH
	@PUSH
	mov	ax,40h
	mov	ds,ax
	mov	ax,ds:6ch
	mov	cs:_inctime,ax
	@POP
	@GETINT	@TIMER
	mov	cs:old_timer,bx
	mov	cs:old_timer[2],es
	push	cs
	pop	ds
	mov	dx,offset cs:my_timer
	@DOINT	@TIMER
	@POP
	retf
startrnd endp

error_handle	proc	far
	mov	ax,di
	mov	byte ptr cs:error_code,al
	mov	byte ptr cs:is_error,1
	mov	ax,0
	stc
	iret
error_code	db	0
is_error	db	0
error_handle	endp

ctrl_break	proc	far
	sti
	iret
ctrl_break	endp

my_timer proc	far
	add	word ptr cs:_inctime,771
	pushf
	cli
	call	dword ptr cs:old_timer
	iret
_inctime dw	0
	dw	0
my_timer endp

breakpoint proc	far
	@PUSH
	@XAZOMARES
	call	reset
	@XAZOMARES
	@XAZOMARES
	pushf
	cli
	iret
breakpoint endp

lprintStart	proc	near
	@PUSH
	mov	byte ptr cs:error_code,0
	@OPEN_HANDLE	si,I_WRITE
	mov	cs:_prnhandle,ax
	@POP
	retf
lprintStart	endp

lprintStop	proc	near
	@PUSH
	push	cs
	pop	ds
	@CLOSE_HANDLE	_prnhandle
	mov	_prnhandle,0
	@POP
	retf
lprintStop	endp

lprintstr proc	near
	@PUSH
arxt:	mov	al,[bx]
	cmp	al,0
	je	telt
	call	far ptr lprintchr
	jc	teltc
	inc	bx
	jmp	arxt
telt:	@POP
	clc
	retf
teltc:	@POP
	stc
	retf
_prnhandle	dw	0
_toprn		db	0
lprintstr endp

lprintchr proc	near
	@PUSH
	cmp	cs:_prnhandle,0
	jne	is_start
	call	far ptr lprintStart
is_start:
	push	cs
	pop	ds
	mov	_toprn,al
jiok2:	
	@WRITE_HANDLE	_prnhandle,_toprn,1

;------------------------------------------------------ PRN ERROR (NO FOR XP!!)
;	jc	ertr
;	mov	dl,byte ptr error_code
;	cmp	dl,0
;	je	_sinr
;ertr:	mov	byte ptr error_code,0
;	call	far ptr prnerror
;	jnc	jiok2
;	@POP
;	stc
;	retf
;_sinr:
;------------------------------------------------------
	@POP
	clc
	retf
lprintchr endp

prnerror	proc	near
	@PUSH
	push	cs
	pop	ds
	call	far ptr takeselect
	push	ax
	mov	ax,cs:win_segment
	push	ax
	mov	ax,MCODE
	mov	cs:win_segment,ax

	mov	bx,offset wprn_err
	call	far ptr windmake
musag:	@BELL
	mov	dx,30
	call	far ptr iwait
	jnc	musag
	mov	bx,offset wprn_err
	call	far ptr winddel
	call	far ptr upperax
	cmp	al,"T"
	jne	notaf1
	@CLOSE_HANDLE	cs:_prnhandle
	pop	ax
	mov	cs:win_segment,ax
	pop	ax
	call	far ptr selectwi
	@POP
	stc
	retf
notaf1:	pop	ax
	mov	cs:win_segment,ax
	pop	ax
	call	far ptr selectwi
	@POP
	clc
	retf
wprn_err db	90,20,9,29,7,70h,2
	db	0
	db	"     äÄáéë ëíéå ÑâíìèóíÜ",0
	db	"     èÄíÜëíÑ ÑåÄ èäÜâíêé",0
	db	"           ⁄ƒø",0
	db	"   èÄíÜëíÑ ≥í≥ ÇàÄ ÄâìêóëÜ",0
 	db	"           ¿ƒŸ",0
	db	0
prnerror	endp

;-----------------------------
; âÄáéêàëãéë âÄêíÄë éáéåÜë
;	úß†©´®ú≠ú† ©´û§
;	£ú´òô¢û´û	cs:sscreen
;	´¶ segment ´û™ ¶üÊ§û™
;	õ†ò≠¶®ú´†°ò ò§òôú† ´¶
;	 Carry Flag
;-----------------------------
initscreen proc near
	push	bx
	push	ax
	mov	byte ptr cs:_iscga,0
	mov	ah,0fh
	int	10h
	cmp	al,7
	je	herc
	cmp	al,2
	je	cga
	cmp	al,3
	je	cga
	stc
	retf
herc:	mov	ax,0b000h
	jmp	inretf
cga:	mov	byte ptr cs:_iscga,1
	mov	ax,0b800h
	cmp	bh,0
	je	inretf
	mov	cl,bh
	mov	ch,0
pagen:	add	ax,4000
	loop	pagen
inretf:	mov	word ptr cs:_sscreen,ax
	mov	word ptr cs:_scrpage,bx
	pop	ax
	pop	bx
	clc
	retf
_sscreen dw	?,?
_scrpage dw	?,?
_iscga	 db	0
initscreen endp

initwind proc	near
	push	ax
	push	bx
	mov	ax,0
	mov	cs:_freemem,ax
	@GETPSP
	mov	ax,endsegm
	sub	ax,bx
	add	ax,256
	@SETBLOCKOFMEMORY	bx,ax
	jnc	inier
ini1:	pop	bx
	pop	ax
	retf
inier:	mov	ax,1
	mov	cs:_freemem,ax
	clc
	jmp	short ini1
_freemem	dw	0
initwind endp

;-------------------------------------------
;		INVERSE
;	ú†©òö‡öû : ´¶ attribute ©´¶§ ax
; úß†©´®ú≠ú† : ©´¶§ ax ´¶ attribute inverse
;-------------------------------------------

inverse proc	near
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
	retf
lock4	db	0
inverse endp

;-------------------------------------------------------
;	ÄèéáÜâÑìëÜ èÄêÄáìêéì ëÑ ÅUFFER
;	ú†©òö‡öú™ : dh ´¶ ß·§‡ ßú®†ü‡®†¶
;		dl ´¶ ò®†©´ú®¶ ßú®†ü‡®†¶
;		ah ö®ò££ú™ ßò®òü¨®¶¨
;		al ©´û¢ú™ ßò®òü¨®¶¨
;		bx offset buffer
;-------------------------------------------------------

getwind	proc near
	push	si
	push	bx
	push	dx
	push	cx
	push	ax
	mov	si,bx 
	xor	cx,cx
	mov	cl,ah
bb1:	pop	ax
	push	ax
	push	cx
	xor	cx,cx
	mov	cl,al
bbb:	call	far ptr qtake
	mov	word ptr [bx],ax
	inc	dx
	inc	bx
	inc	bx
	loop	bbb
	pop	cx
	inc	dh
	pop	ax
	push	ax
	sub	dl,al
	loop	bb1
	pop	ax
	pop	cx
	pop	dx
	pop	bx
	pop	si
	retf
getwind	endp

;-------------------------------------------------------
;	 âÄäÑëãÄ èÄêÄáìêéì Aèé ÅUFFER
;	ú†©òö‡öú™ : dh ´¶ ß·§‡ ßú®†ü‡®†¶
;		dl ´¶ ò®†©´ú®¶ ßú®†ü‡®†¶
;		ah ö®ò££ú™ ßò®òü¨®¶¨
;		al ©´û¢ú™ ßò®òü¨®¶¨
;		bx offset buffer
;-------------------------------------------------------

delwind	proc near
	push	si
	push	bx
	push	dx
	push	cx
	push	ax
	xor	cx,cx
	mov	cl,ah
cc1:	pop	ax
	push	ax
	push	cx
	mov	si,dx
	xor	cx,cx
	mov	cl,al
ccc:	mov	ax,word ptr [bx]
	call	far ptr qprint
	inc	bx
	inc	bx
	inc	dx
	loop	ccc
	mov	dx,si
	inc	dh
	pop	cx
	loop	cc1
	pop	ax
	pop	cx
	pop	dx
	pop	bx
	pop	si
	retf
delwind	endp

;-------------------------------------------------------
;	 ÉÜãàéìêÇàÄ èÄêÄáìêéì Aèé ÅUFFER
;	ú†©òö‡öú™ : dh ´¶ ß·§‡ ßú®†ü‡®†¶
;		dl ´¶ ò®†©´ú®¶ ßú®†ü‡®†¶
;		ah ö®ò££ú™ ßò®òü¨®¶¨
;		al ©´û¢ú™ ßò®òü¨®¶¨
;		cl attribute ßò®òü¨®¶¨
;		di ú†õ¶™ ß¢ò†©†¶¨
;		bx offset buffer
;-------------------------------------------------------

setwind	proc near
	push	bx
	push	si
	push	di
	push	dx
	push	cx
	push	ax
	push	ax
	push	ax
	mov	ax,cs:win_segment
	mov	es,ax
	pop	ax
	mov	byte ptr cs:_windAttr,cl
	mov	ah,cl
	mov	si,dx
	xor	cx,cx
	mov	cl,al
	mov	al,byte ptr cs:_boxtype[di]
	call	far ptr qprint
	inc	dx
	mov	al,byte ptr cs:_boxtype[di+1]
siz0:	call	far ptr qprint
	inc	dx
	loop	siz0
	mov	al,byte ptr cs:_boxtype[di+2]
	call	far ptr qprint
	inc	dx
	mov	dx,si
	inc	dh
	mov	si,dx
	pop	ax
	push	ax
	xor	cx,cx
	mov	cl,ah
	mov	word ptr cs:_metrcx,cx
dd1:	pop	ax
	push	ax
	push	cx
	xor	cx,cx
	mov	cl,al
	mov	ah,byte ptr cs:_windAttr
	mov	al,byte ptr cs:_boxtype[di+3]
	call	far ptr qprint
	inc	dx
ddd:	mov	al,es:[bx]
	cmp	al,0
	je	qw13
	cmp	al,1
	je	qw131
	call	far ptr qprint
	inc	bx
	inc	dx
	loop	ddd
	jmp	qw12
qw131:	mov	al,es:[bx-1]
	jmp	ddd3
qw13:	mov	al," "
ddd3:	call	far ptr qprint
	inc	dx
	loop	ddd3
	inc	bx
qw12:	mov	ah,byte ptr cs:_windAttr
	mov	al,byte ptr cs:_boxtype[di+3]
	call	far ptr qprint
	cmp	cx,word ptr cs:_metrcx
	je	qsex
	inc	dx
	cmp	byte ptr cs:_iscga,0
	je	ishrc1
	cmp	byte ptr cs:_winatr,0
	je	ishrc1
	call	far ptr qtake
	mov	ah,byte ptr cs:_winatr
	call	far ptr qprint
	inc	dx
	call	far ptr qtake
	mov	ah,byte ptr cs:_winatr
	call	far ptr qprint
	jmp	qsex
dd111:	jmp	dd1
ishrc1:	mov	al,byte ptr cs:_winchar
	cmp	al,0
	je	qsex
	mov	ah,byte ptr cs:_windAttr
	call	far ptr qprint
	inc	dx
	call	far ptr qprint
qsex:	mov	dx,si
	inc	dh
	mov	si,dx
	pop	cx
	loop	dd111
	pop	ax
	push	ax
	xor	cx,cx
	mov	cl,al
	mov	ah,byte ptr cs:_windAttr
	mov	al,byte ptr cs:_boxtype[di+4]
	call	far ptr qprint
	inc	dx
	mov	al,byte ptr cs:_boxtype[di+1]
siz4:	call	far ptr qprint
	inc	dx
	loop	siz4
	mov	ah,byte ptr cs:_windAttr
	mov	al,byte ptr cs:_boxtype[di+5]
	call	far ptr qprint
	inc	dx
	cmp	byte ptr cs:_iscga,0
	je	ishrc2
	cmp	byte ptr cs:_winatr,0
	je	ishrc2
	call	far ptr qtake
	mov	ah,byte ptr cs:_winatr
	call	far ptr qprint
	inc	dx
	call	far ptr qtake
	mov	ah,byte ptr cs:_winatr
	call	far ptr qprint
	jmp	qsex1
ishrc2:	mov	al,byte ptr cs:_winchar
	cmp	al,0
	je	qsex1
	mov	ah,byte ptr cs:_windAttr
	call	far ptr qprint
	inc	dx
	call	far ptr qprint
qsex1:	mov	dx,si
	inc	dh
	inc	dx
	inc	dx
	pop	ax
	xor	cx,cx
	mov	cl,al
	inc	cx
	inc	cx
	cmp	byte ptr cs:_iscga,0
	je	ishrc3
	cmp	byte ptr cs:_winatr,0
	je	ishrc3
sd13:	call	far ptr qtake
	mov	ah,byte ptr cs:_winatr
	call	far ptr qprint
	inc	dx
	loop	sd13
	jmp	pidame
ishrc3: mov	ah,byte ptr cs:_windAttr
	mov	al,byte ptr cs:_winchar
	cmp	al,0
	je	pidame
siz5:	call	far ptr qprint
	inc	dx
	loop	siz5
pidame:	pop	ax
	pop	cx
	pop	dx
	pop	di
	pop	si
	pop	bx
	retf
_winchar db	"≤"		; ïÄêÄâíÜêÄë ëâàÄë èÄêÄáìêéì (HERCULES)
_winatr	 db	12h		; ATTRIBUTE èäÄàëàéì (CGA)

_metrcx	dw	?		; ÑëóíÑêàâÜ ãEíÄÅäÜíÜ
_windAttr db	?		; ATTRIBUTE èÄêÄáìêéì
_boxtype db	"      "	; ÑàÉéë èäÄàëàéì
	db	"⁄ƒø≥¿Ÿ"
	db	"…Õª∫»º"
setwind	endp

initw	proc	near
	mov	cs:_winchar,"≤"
	mov	cs:_winatr,12h
	retf
initw	endp

boxwind	proc	near
	@PUSH
	push	ax
	mov	ax,cs:win_segment
	mov	es,ax
	pop	ax
	mov	di,ax
	mov	si,bx
	mov	dl,es:[si+1]
	mov	dh,es:[si+2]
	mov	bl,es:[si+3]
	mov	bh,es:[si+4]
	add	bx,0202h
	mov	ah,es:[si+5]
	call	far ptr setbox_popup
	@POP
	retf
boxwind	endp

boxbuf	proc	near
	@PUSH
	xor	ax,ax
	mov	al,[bx+5]
	mov	di,ax
	mov	si,bx
	mov	dl,[si]
	mov	dh,[si+1]
	mov	bl,[si+2]
	mov	bh,[si+3]
	mov	ah,[si+4]
	call	far ptr setbox
	@POP
	retf
boxbuf	endp

setbox	proc	near
	push	bx
	push	si
	push	di
	push	dx
	push	cx
	push	ax
	push	ax
	dec	bh
	dec	bl
	mov	ax,di
	mov	cl,6
	mul	cl
	mov	di,ax
	pop	ax
	mov	al,cs:_boxtype[di]
	call	far ptr winddisp
 	add	dh,bh
	mov	al,cs:_boxtype[di+4]
	call	far ptr winddisp
	sub	dh,bh
	push	dx
	xor	cx,cx
	mov	cl,bl
	mov	al,cs:_boxtype[di+1]
setb1:	inc	dl
	call	far ptr winddisp
	add	dh,bh
	call	far ptr winddisp
	sub	dh,bh
	loop	setb1
	mov	al,cs:_boxtype[di+2]
	call	far ptr winddisp
	add	dh,bh
	mov	al,cs:_boxtype[di+5]
	call	far ptr winddisp
	pop	dx
	xor	cx,cx
	mov	cl,bh
	dec	cx
	mov	al,cs:_boxtype[di+3]
setb2:	inc	dh
	call	far ptr winddisp
	add	dl,bl
	call	far ptr winddisp
	sub	dl,bl
	loop	setb2		
	pop	ax
	pop	cx
	pop	dx
	pop	di
	pop	si
	pop	bx
	retf
setbox	endp

setbox_popup	proc	near
	push	bx
	push	si
	push	di
	push	dx
	push	cx
	push	ax
	push	ax
	dec	bh
	dec	bl
	mov	ax,di
	mov	cl,6
	mul	cl
	mov	di,ax
	pop	ax
	mov	al,cs:_boxtype[di]
	call	far ptr qprint
 	add	dh,bh
	mov	al,cs:_boxtype[di+4]
	call	far ptr qprint
	sub	dh,bh
	push	dx
	xor	cx,cx
	mov	cl,bl
	mov	al,cs:_boxtype[di+1]
psetb1:	inc	dl
	call	far ptr qprint
	add	dh,bh
	call	far ptr qprint
	sub	dh,bh
	loop	psetb1
	mov	al,cs:_boxtype[di+2]
	call	far ptr qprint
	add	dh,bh
	mov	al,cs:_boxtype[di+5]
	call	far ptr qprint
	pop	dx
	xor	cx,cx
	mov	cl,bh
	dec	cx
	mov	al,cs:_boxtype[di+3]
psetb2:	inc	dh
	call	far ptr qprint
	add	dl,bl
	call	far ptr qprint
	sub	dl,bl
	loop	psetb2
	pop	ax
	pop	cx
	pop	dx
	pop	di
	pop	si
	pop	bx
	retf
setbox_popup	endp

dopopup	proc	near
	@PUSH
	mov	cs:_popatr,cl
	push	ax
	mov	ax,di
	mov	cl,6
	div	cl
	mov	di,ax
	pop	ax
	add	ah,1
	push	ax
	mov	cx,cs:_fores
	shr	al,cl
	mov	cs:_poplx,al
	shr	al,1
	mov	cs:_poppx,al
	shr	ah,cl
	mov	cs:_poply,ah
	shr	ah,1
	mov	cs:_poppy,ah
	pop	cx
	mov	al,cl
	shr	al,1
	mov	cs:_popx,al
	add	cs:_popx,dl
	mov	al,ch
	shr	al,1
	mov	cs:_popy,al
	add	cs:_popy,dh
	mov	ax,cs:_fores
	rol	ax,1
	mov	cx,ax
nextpopcx:
	push	cx
	mov	al,cs:_poppx
	sub	cs:_popx,al
	mov	al,cs:_popx
	mov	cs:_popx1,al
	mov	al,cs:_poppy
	sub	cs:_popy,al
	mov	al,cs:_popy
	mov	cs:_popy1,al
	mov	al,cs:_poplx
	add	cs:_popx1,al
	mov	al,cs:_poply
	add	cs:_popy1,al
	@INITWIND cs:_popx,cs:_popy,cs:_popx1,cs:_popy1,cs:_popatr
	mov	dl,cs:_popx
	mov	dh,cs:_popy
	mov	bl,cs:_poplx
	mov	bh,cs:_poply
	cmp	bl,3
	jb	pida
	cmp	bh,3
	jb	pida
	mov	ah,cs:_popatr
	inc	bl
	inc	bl
	inc	bh
	call	far ptr setbox_popup
pida:	mov	al,cs:_poppx
	add	cs:_poplx,al
	add	cs:_poplx,al
	mov	al,cs:_poppy
	add	cs:_poply,al
	add	cs:_poply,al
	mov	dx,1
	call	far ptr iwait
	pop	cx
	loop	nextpopcx1
	inc	cs:_popx1
	@INITWIND cs:_popx,cs:_popy,cs:_popx1,cs:_popy1,cs:_popatr
	@POP
	retf
nextpopcx1:	jmp	nextpopcx
_poplx	db	0
_poply	db	0
_popx	db	0
_popy	db	0
_poppx	db	0
_poppy	db	0
_popx1	db	0
_popy1	db	0
_popatr	db	0
_fores	dw	2
dopopup	endp

setfores proc	near
	mov	cs:_fores,ax
	retf
setfores endp

userbox	proc	near
	@PUSH
	xor	bx,bx
	mov	cx,6
ub0:	mov	byte ptr cs:_boxtype[bx],al
	inc	bx
	loop	ub0
	@POP
	retf
userbox	endp

userchr proc	near
	mov	byte ptr cs:_winchar,al
	retf
userchr	endp

useratr proc	near
	mov	byte ptr cs:_winatr,al
	retf
useratr	endp

userw	proc	near
	mov	byte ptr cs:_winatr,al
	mov	byte ptr cs:_winchar,ah
	retf
userw	endp

;--------------------------------
;	ú†©òö‡öú™ : dh ´¶ y
;		dl ´¶ x
;	úß†©´®ú≠ú† : ah ´¶ attribute
;		al o Æò®ò°´û®ò™
;--------------------------------

qtake	proc	near
	push	si
	call	far ptr scrOffset
	push	ds
	push	ax
	mov	ax,word ptr cs:_sscreen
	mov	ds,ax
	pop	ax
	mov	ax,word ptr [si]
	pop	ds
	pop	si
	retf
qtake	endp

;------------------------------
;	INVERSE STRING
;	ú†©òö‡öú™ : dh ´¶ Æ
;		dl ´¶ y
;		cx ß¶©ò byte
;------------------------------

winvstr	proc	near
	push	si
	push	dx
	push	ax
	push	cx
invnxt:	call	far ptr windtake
	call	far ptr inverse
	call	far ptr winddisp
	inc	dx
	loop	invnxt
	pop	cx
	pop	ax
	pop	dx
	pop	si
	retf
winvstr endp

;--------------------------------
;	ú†©òö‡öú™ : dh ´¶ y
;		dl ´¶ x
;			ah ´¶ attributr
;		al o Æò®ò°´û®ò™
;--------------------------------

qprint	proc	near
	push	si
	call	far ptr scrOffset
	push	ds
	push	ax
	mov	ax,word ptr cs:_sscreen
	mov	ds,ax
	pop	ax
	mov	word ptr [si],ax
	pop	ds
	pop	si
	retf
qprint	endp

;--------------------------------
;	 OFFSET OáéåÜë
;	ú†©òö‡öú™ : dh ´¶ y
;		dl ´¶ x
;	ú•òö‡öú™ : si offset
;--------------------------------

scroffset proc near
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
	retf
scroffset endp

clswind	proc	near
	push	si
	push	cx
	push	ax
	push	dx
	push	bx
	push	ds
	push	ax
	mov	ax,cs:win_segment
	mov	es,ax
	pop	ax
	mov	si,bx
	mov	dl,es:[si+1]
	mov	dh,es:[si+2]
	mov	al,es:[si+3]
	mov	ah,es:[si+4]
	mov	bl,es:[si+5]
	add	al,dl
	add	ah,dh
	inc	dh
	inc	dl
	@INITWIND	dl,dh,al,ah,bl
	pop	ds
	pop	bx
	pop	dx
	pop	ax
	pop	cx
	pop	si
	retf
clswind endp

;---------------------------------------
; ÉÜãàéìêÇàÄ èÄêÄáìêéì Äèé BUFFER
;	ú†©òö‡öú™ : bx buffer
;	´ò ß®‡´ò 6 bytes ú†§ò† :
;		1o	index
;	 2o	x
;	 3o	y
;	 4o	ö®ò££ú™
;	 5¶	©´û¢ú™
;	 6o	attribute
;	 7o	ß¢ò†©†¶
;		8o - ... ´¶ string ´¶¨ ßò®òü¨®¶¨
; °ò¢ú† ´û§ get_window °ò† òß¶üû°ú¨ú†
;	´û§ ¶ü¶§û °ò´‡ òß¶ ´¶ ßò®òü¨®¶
;	©´o§ ß†§ò°ò windows_buffer
;---------------------------------------

windmake proc	near
	push	di
	push	si
	push	cx
	push	ax
	push	dx
	push	bx
	push	ds
	push	ax
	mov	ax,cs:win_segment
	mov	es,ax
	pop	ax
	mov	ax,cs:_freemem
	cmp	ax,1
	je	_wm1
	call	far ptr initwind
_wm1:	xor	ax,ax
	mov	al,es:[bx+6]
	mov	cl,6
	mul	cl
	mov	di,ax
	xor	ax,ax
	mov	al,es:[bx]
	mov	si,ax
	mov	dl,es:[bx+1]
	mov	dh,es:[bx+2]
	mov	al,es:[bx+3]
	mov	ah,es:[bx+4]
	mov	cl,es:[bx+5]
	add	bx,7
	push	bx
	add	ax,0000001100000100b
	push	ax
	push	cx
	mov	cl,ah
	inc	cl
	mov	ah,0
	inc	ax
	mul	cl
	rol	ax,1
	add	ax,4
	push	ax
	push	si
	rol	si,1
	mov	ax,cs:_windIndex[si]
	cmp	ax,0
	je	mkw17
	mov	ds,ax
	@FREEMEMORY ds
mkw17:	pop	si
	pop	ax
	@ALLOCATEMEMORY	ax
	jnc	_noer
	pop	cx
	pop	ax
	pop	bx
	pop	ds
	pop	bx
	pop	dx
	pop	ax
	pop	cx
	pop	si
	pop	di
	stc
	retf
_noer:	mov	ds,ax
	mov	bx,4
	pop	cx
	pop	ax
	call	far ptr getwind
	mov	bx,0
	mov	[bx],dx
	mov	[bx+2],ax
	rol	si,1
	mov	cs:_windIndex[si],ds
	pop	bx
	pop	ds
	sub	ax,0000001100000100b
	call	far ptr setwind
	pop	bx
	pop	dx
	pop	ax
	pop	cx
	pop	si
	pop	di
	clc
	retf
_windIndex	dw	105 dup(0)
windmake endp

;---------------------------------------
; ÉÜãàéìêÇàÄ èÄêÄáìêéì 'POP UP' Äèé BUFFER
;	ú†©òö‡öú™ : bx buffer
;	´ò ß®‡´ò 6 bytes ú†§ò† :
;		1o	index
;	 2o	x
;	 3o	y
;	 4o	ö®ò££ú™
;	 5¶	©´û¢ú™
;	 6o	attribute
;	 7o	ß¢ò†©†¶
;		8o - ... ´¶ string ´¶¨ ßò®òü¨®¶¨
; °ò¢ú† ´û§ get_window °ò† òß¶üû°ú¨ú†
;	´û§ ¶ü¶§û °ò´‡ òß¶ ´¶ ßò®òü¨®¶
;	©´o§ ß†§ò°ò windows_buffer
;---------------------------------------

popmake proc	near
	push	di
	push	si
	push	cx
	push	ax
	push	dx
	push	bx
	push	ds
	push	ax
	mov	ax,cs:win_segment
	mov	es,ax
	pop	ax
	mov	ax,cs:_freemem
	cmp	ax,1
	je	_wp1
	call	far ptr initwind
_wp1:	xor	ax,ax
	mov	al,es:[bx+6]
	mov	cl,6
	mul	cl
	mov	di,ax
	xor	ax,ax
	mov	al,es:[bx]
	mov	si,ax
	mov	dl,es:[bx+1]
	mov	dh,es:[bx+2]
	mov	al,es:[bx+3]
	mov	ah,es:[bx+4]
	mov	cl,es:[bx+5]
	add	bx,7
	push	bx
	add	ax,0000001100000100b
	push	ax
	push	cx
	mov	cl,ah
	inc	cl
	mov	ah,0
	inc	ax
	mul	cl
	rol	ax,1
	add	ax,4
	push	ax
	push	si
	rol	si,1
	mov	ax,cs:_windIndex[si]
	cmp	ax,0
	je	pop17
	mov	ds,ax
	@FREEMEMORY ds
pop17:	pop	si
	pop	ax
	@ALLOCATEMEMORY	ax
	jnc	_noerp
	pop	cx
	pop	ax
	pop	bx
	pop	ds
	pop	bx
	pop	dx
	pop	ax
	pop	cx
	pop	si
	pop	di
	stc
	retf
_noerp:	mov	ds,ax
	mov	bx,4
	pop	cx
	pop	ax
	call	far ptr getwind
	mov	bx,0
	mov	[bx],dx
	mov	[bx+2],ax
	rol	si,1
	mov	cs:_windIndex[si],ds
	pop	bx
	pop	ds
	sub	ax,0000001100000100b
	call	far ptr dopopup
	call	far ptr setwind
	pop	bx
	pop	dx
	pop	ax
	pop	cx
	pop	si
	pop	di
	clc
	retf
popmake endp

;------------------------------------
;	°¢ú†§ú† ´¶ index ßò®òü¨®¶
;	ß¶¨ õû£†¶¨®öûüû°ú £ú ´û§
;		windmake
;	ò§òôú† ´¶ carry ¶´ò§ õú§ ¨ßò®Æú†
;		´ú´¶†¶ ßò®òü¨®¶ 
;------------------------------------

winddel proc	near
	push	bx
	push	ax
	push	ax
	mov	ax,cs:win_segment
	mov	es,ax
	pop	ax
	xor	ax,ax
	mov	al,es:[bx]
	call	far ptr winddel1
	pop	ax
	pop	bx
	retf
winddel endp

winddel1 proc	near
	push	si
	push	dx
	push	ax
	push	bx
	push	ds
	mov	si,ax
	rol	si,1
	mov	ax,cs:_windIndex[si]
	cmp	ax,0
	je	windcarry
	mov	ds,ax
	mov	bx,0
	mov	dx,[bx]
	mov	ax,[bx+2]
	add	bx,4
	call	far ptr delwind
	@FREEMEMORY ds
	jc	windcarry
	mov	ax,0
	mov	cs:_windIndex[si],ax
	pop	ds
	pop	bx
	pop	ax
	pop	dx
	pop	si
	clc
	retf
windcarry:
	pop	ds
	pop	bx
	pop	ax
	pop	dx
	pop	si
	stc
	retf
winddel1 endp

selectw	proc	near
	push	ax
	push	ax
	mov	ax,cs:win_segment
	mov	es,ax
	pop	ax
	xor	ax,ax
	mov	al,es:[bx]
	mov	cs:_windSelect,ax
	pop	ax
	retf
_windSelect	dw	0
selectw	endp

selectwi proc	near
	mov	cs:_windSelect,ax
	retf
selectwi endp

takeselect proc	near
	mov	ax,cs:_windSelect
	retf
takeselect endp

;-----------------------------------------
;	©¨§´ú´òö£ú§ú™ ßò®òü¨®¶¨
;	ú†©òö‡öû : dx ©¨§´ú´òö£ú§ú™ ßò®òü¨®¶¨
; úß†©®ú≠ú† : dx ©¨§´ú´òö£ú§ú™ ¶ü¶§û™
;-----------------------------------------

windcurs proc	near
	push	bx
	push	ax
	push	ds
	mov	bx,cs:_windSelect
	cmp	bx,0
	je	cnowi
	rol	bx,1
	mov	ax,cs:_windIndex[bx]
	cmp	ax,0
	je	cnowi
	mov	ds,ax
	mov	bx,0
	mov	ax,word ptr [bx]
	add	dx,ax
cnowi:	pop	ds
	pop	ax
	pop	bx
	retf
windcurs endp

takeinf	proc	near		;bx = wind index
	push	bx
	push	ax
	push	ds
	mov	bx,cs:_windSelect
	cmp	bx,0
	je	cnowi1
	rol	bx,1
	mov	ax,cs:_windIndex[bx]
	cmp	ax,0
	je	cnowi1
	mov	ds,ax
	mov	bx,0
	mov	ax,[bx]
	mov	cs:_infdx,ax
	mov	ax,[bx+2]
	mov	cs:_infax,ax
	add	cs:_infdx,0101h
	sub	cs:_infax,0304h
	mov	ax,cs:_infdx
	add	cs:_infax,ax
pis12:	pop	ds
	pop	ax
	pop	bx
	retf
cnowi1:	mov	cs:_infdx,0000
	mov	cs:_infax,184fh
	jmp	pis12
_infdx	dw	0
_infax	dw	0
takeinf	endp

winddisp proc	near
	push	dx
	push	bx
	call	far ptr windcurs
	cmp	ah,0
	jne	www1
	mov	bl,al
	call	far ptr qtake
	mov	al,bl
www1:	call	far ptr qprint
	pop	bx
	pop	dx
	retf
winddisp endp

windtake proc	near
	push	dx
	call	far ptr windcurs
	call	far ptr qtake
	pop	dx
	retf
windtake endp

numbers	proc	near
	@PUSH
	push	si
	push	si
	pop	di
	xor	cx,cx
	mov	bx,6
	
num5:	cmp	byte ptr [si],0
	je	telk
	inc	si
	jmp	num5
telk:	dec	si
	cmp	si,di
	jb	num6
	cmp	byte ptr [si],"0"
	jb	num6
	cmp	byte ptr [si],"9"
	ja	num6
	inc	cx
	cmp	cx,3
	jne	nocx3
	mov	cs:_numbuf[bx],si
	sub	bx,2
	xor	cx,cx
nocx3:	jmp	telk

num6:	add	bx,2
	cmp	cx,0
	jne	num7
	add	bx,2
num7:	pop	si
num4:	cmp	si,cs:_numbuf[bx]
	jne	nutel

	call	telia

nutel:	xor	ax,ax
	mov	al,[si]
	cmp	al," "
	je	numken
	cmp	al,"0"
	jb	nonum
	cmp	al,"9"
	ja	nonum
	jmp	isnum
nonum:	@POP
	retf
numken:	inc	si
	jmp	num4

isnum:	@PUSH
	push	cs
	pop	ds
	push	dx
	sub	ax,"0"
	mov	cx,25
	mul	cx
	pop	dx
	mov	bx,offset cs:cifia
	add	bx,ax
	xor	ax,ax
	call	far ptr windprint
	inc	dh
	add	bx,5
	call	far ptr windprint
	inc	dh
	add	bx,5
	call	far ptr windprint
	inc	dh
	add	bx,5
	call	far ptr windprint
	inc	dh
	add	bx,5
	call	far ptr windprint
	@POP
	inc	si
	add	dl,4
	jmp	num4

telia:	@PUSH
	mov	cx,4
tel1:	xor	ax,ax
	mov	al," "
	call	far ptr winddisp
	inc	dl
	call	far ptr winddisp
	dec	dl
	inc	dh
	loop	tel1
	mov	al,"€"
	call	far ptr winddisp
	inc	dl
	mov	al," "
	call	far ptr winddisp
	@POP
	add	bx,2
	add	dl,2
	ret

cifia	label	byte
cif00:	db	"€€€ ",0
	db	"€ € ",0
	db	"€ € ",0
	db	"€ € ",0
	db	"€€€ ",0

cif01:	db	"€€  ",0
	db	" €  ",0
	db	" €  ",0
	db	" €  ",0
	db	"€€€ ",0

cif02:	db	"€€€ ",0
	db	"  € ",0
	db	"€€€ ",0
	db	"€   ",0
	db	"€€€ ",0

cif03:	db	"€€€ ",0
	db	"  € ",0
	db	" €€ ",0
	db	"  € ",0
	db	"€€€ ",0

cif04:	db	"€   ",0
	db	"€   ",0
	db	"€ € ",0
	db	"€€€ ",0
	db	"  € ",0

cif05:	db	"€€€ ",0
	db	"€   ",0
	db	"€€€ ",0
	db	"  € ",0
	db	"€€€ ",0

cif06:	db	"€€€ ",0
	db	"€   ",0
	db	"€€€ ",0
	db	"€ € ",0
	db	"€€€ ",0

cif07:	db	"€€€ ",0
	db	"  € ",0
	db	"  € ",0
	db	"  € ",0
	db	"  € ",0

cif08:	db	"€€€ ",0
	db	"€ € ",0
	db	"€€€ ",0
	db	"€ € ",0
	db	"€€€ ",0

cif09:	db	"€€€ ",0
	db	"€ € ",0
	db	"€€€ ",0
	db	"  € ",0
	db	"€€€ ",0

_numbuf	dw	0,0,0,0,0
numbers	endp

windprint proc	near
	push	ax
	push	dx
	push	bx
	push	cx
	mov	cs:_wpatr,al
	mov	cx,dx
	call	far ptr windtake
	cmp	cs:_wpatr,0
	je	skitso
	or	ah,cs:_wpatr
	jmp	wpep
skitso:	and	ah,01110111b
wpep:	mov	al,[bx]
	cmp	al,0
	je	wpout
	cmp	al,13
	jne	wpn13
	mov	dl,cl
	inc	bx
	jmp	wpep
wpn13:	cmp	al,10
	jne	wpn10
	inc	dh
	inc	bx
	jmp	wpep
wpn10:	call	far ptr winddisp
	inc	bx
	inc	dx
	jmp	wpep
wpout:	pop	cx
	pop	bx
	pop	dx
	pop	ax
	retf
_wpatr	db	0
windprint endp

windinput proc	near
	push	cx
	push	dx
	push	bx
	mov	ax,0
	call	far ptr windprint
	xor	cx,cx
wip2:	cmp	byte ptr [bx],0
	je	wip1
	inc	bx
	inc	cx
	jmp	wip2
winpojo:
	pop	bx
	pop	dx
	pop	cx
	retf
wip1:	cmp	cx,0
	je	winpojo
	cmp	cx,79
	ja	winpojo
	pop	bx
	push	bx
	call	far ptr winvstr
wpali:	call	far ptr curswait
	push	bx
	mov	bx,si
	call	far ptr chkplhktro
	pop	bx
	jc	nik99
	jmp	went2
nik99:	cmp	al,0
	je	@@@9
	jmp	@@@1
@@@9:	cmp	ah,LEFT
	jne	nleft
	pop	ax
	push	ax
	cmp	bx,ax
	jbe	wpali
	call	far ptr windtake
	mov	al,[bx]
	call	far ptr winddisp
	dec	bx
	dec	dx
	jmp	wpali
wendp:	call	far ptr mbell
	jmp	wpali
nleft:	cmp	ah,RIGHT
	jne	w@@1
	cmp	byte ptr [bx],0
	je	wendp
	inc	dx
	inc	bx
	jmp	wpali
w@@1:	cmp	ah,INSER
	jne	nins
	jmp	insit
nins:	cmp	ah,DEL
	jne	nind
	jmp	delit
nind:	jmp	wpali
@@@1:	cmp	al,BACK_SPACE
	jne	@1
	jmp	wdelw
@1:	cmp	al,RETURN
	jne	@22
	xor	ax,ax
	jmp	went
@22:	cmp	al,ESCAPE
	jne	@3
	jmp	went2
@3:	cmp	byte ptr [bx],0
	je	wendp
	cmp	al,32
	jb	wpali
	cmp	al,254
	ja	wpali
	call	far ptr upperax
	mov	[bx],al
	call	far ptr windtake
	mov	al,[bx]
	call	far ptr winddisp
	inc	bx
	inc	dx
	jmp	wpali
wdelw:	pop	ax
	push	ax
	cmp	bx,ax
	ja	maxel
	jmp	wpali
maxel:	dec	bx
	dec	dx
	call	far ptr windtake
	mov	al," "
	call	far ptr winddisp
	mov	byte ptr [bx]," "
	jmp	wpali
went:	mov	word ptr cs:_curs_pos,dx
	push	ax
	call	far ptr windtake
	mov	al,[bx]
	cmp	al,0
	je	wpim
	call	far ptr winddisp
wpim:	pop	ax
	pop	bx
	pop	dx
	call	far ptr winvstr
	pop	cx
	mov	dx,word ptr cs:_curs_pos
	clc
	retf
went2:	mov	word ptr cs:_curs_pos,dx
	push	ax
	call	far ptr windtake
	mov	al,[bx]
	cmp	al,0
	je	wpim2
	call	far ptr winddisp
wpim2:	pop	ax
	pop	bx
	pop	dx
	call	far ptr winvstr
	pop	cx
	mov	dx,word ptr cs:_curs_pos
	stc
	retf

insit:	push	cx
	push	bx
	push	dx
	mov	cx,bx
	dec	cx
ins03:	cmp	byte ptr [bx],0
	je	ins00
	inc	bx
	inc	dx
	jmp	ins03
ins00:	dec	bx
ins02:	dec	bx
	dec	dx
	cmp	bx,cx
	je	ins01
	call	far ptr windtake
	mov	al,[bx]
	mov	[bx+1],al
	call	far ptr winddisp
	jmp	ins02
ins01:	pop	dx
	pop	bx
	mov	al," "
	mov	byte ptr [bx],al
	call	far ptr winddisp
	pop	cx
	jmp	wpali

delit:	push	bx
	push	dx
	dec	dx
del02:	inc	bx
	inc	dx
	call	far ptr windtake
	mov	al,[bx]
	cmp	al,0
	je	del01
	mov	[bx-1],al
	call	far ptr winddisp
	jmp	del02
del01:	mov	al," "
	mov	byte ptr [bx-1],al
	call	far ptr winddisp
	pop	dx
	pop	bx
	jmp	wpali
_curs_pos dw	0
windinput endp

wcodeinput proc	near
	mov	cs:_krifo,1
	push	cx
	push	dx
	push	bx
	mov	ax,0
	call	far ptr windprint
	xor	cx,cx
cwip2:	cmp	byte ptr [bx],0
	je	cwip1
	inc	bx
	inc	cx
	jmp	cwip2
cwinpojo:
	pop	bx
	pop	dx
	pop	cx
	mov	cs:_krifo,0
	retf
cwip1:	cmp	cx,0
	je	cwinpojo
	cmp	cx,79
	ja	cwinpojo
	pop	bx
	push	bx
	call	far ptr winvstr
cwpali: call	far ptr curswait
	push	bx
	mov	bx,si
	call	far ptr chkplhktro
	pop	bx
	jc	cnik99
	jmp	cwent2
cnik99:	cmp	al,0
	je	c@@@9
	jmp	c@@@1
c@@@9:	cmp	ah,LEFT
	jne	cnleft
	pop	ax
	push	ax
	cmp	bx,ax
	jbe	cwpali
	call	far ptr windtake
	mov	al,[bx]
	cmp	al," "
	jbe	ken000
	mov	al,"*"
ken000:	call	far ptr winddisp
	dec	bx
	dec	dx
	jmp	cwpali
cwendp:	call	far ptr mbell
	jmp	cwpali
cnleft:	cmp	ah,RIGHT
	jne	cw@@1
	cmp	byte ptr [bx],0
	je	cwendp
	inc	dx
	inc	bx
	jmp	cwpali
cw@@1:	jmp	cwpali
c@@@1:	cmp	al,BACK_SPACE
	jne	c@1
	jmp	cwdelw
c@1:	cmp	al,RETURN
	jne	c@22
	xor	ax,ax
	jmp	cwent
c@22:	cmp	al,ESCAPE
	jne	c@3
	jmp	cwent2
c@3:	cmp	byte ptr [bx],0
	je	cwendp
	cmp	al,32
	jb	cwpali
	cmp	al,254
	ja	cwpali
	mov	[bx],al
	call	far ptr windtake
	mov	al,[bx]
	cmp	al," "
	jbe	ken001
ken001: mov	al,"*"
	call	far ptr winddisp
	inc	bx
	inc	dx
	jmp	cwpali
cwdelw: pop	ax
	push	ax
	cmp	bx,ax
	ja	cmaxel
	jmp	cwpali
cmaxel:	dec	bx
	dec	dx
	call	far ptr windtake
	mov	al," "
	call	far ptr winddisp
	mov	byte ptr [bx]," "
	jmp	cwpali
cwent:	mov	word ptr cs:_curs_pos,dx
	push	ax
	call	far ptr windtake
	mov	al,[bx]
	cmp	al," "
	jbe	ken002
	mov	al,"*"
ken002:	call	far ptr winddisp
	pop	ax
	pop	bx
	pop	dx
	call	far ptr winvstr
	pop	cx
	mov	dx,word ptr cs:_curs_pos
	mov	cs:_krifo,0
	clc
	retf
cwent2:	mov	word ptr cs:_curs_pos,dx
	push	ax
	call	far ptr windtake
	mov	al,[bx]
	cmp	al," "
	jbe	ken003
	mov	al,"*"
ken003:	call	far ptr winddisp
	pop	ax
	pop	bx
	pop	dx
	call	far ptr winvstr
	pop	cx
	mov	dx,word ptr cs:_curs_pos
	mov	cs:_krifo,0
	stc
	retf
wcodeinput endp

winputnumbers proc	near
	push	cx
	push	dx
	push	bx
	mov	ax,0
	call	far ptr windprint
	xor	cx,cx
nwip2:	cmp	byte ptr [bx],0
	je	nwip1
	inc	bx
	inc	cx
	jmp	nwip2
nwinpojo:
	pop	bx
	pop	dx
	pop	cx
	retf
nwip1:	cmp	cx,0
	je	nwinpojo
	cmp	cx,79
	ja	nwinpojo
	pop	bx
	push	bx
	call	far ptr winvstr
nwpali:	call	far ptr curswait
	call	far ptr upperax
	push	bx
	mov	bx,si
	call	far ptr chkplhktro
	pop	bx
	jc	nok99
	jmp	nwent2
nok99:	cmp	al,0
	je	n@@@9
	cmp	al,RETURN
	je	nw99
	cmp	al,ESCAPE
	je	nw99
	cmp	al,BACK_SPACE
	je	nw99
	cmp	al,"0"
	jb	nok0
	cmp	al,"9"
	ja	nok0
nw99:	jmp	n@@@1
nok0:	jmp	nwendp
n@@@9:	cmp	ah,LEFT
	jne	nnleft
	pop	ax
	push	ax
	cmp	bx,ax
	jbe	nwpali
	call	far ptr windtake
	mov	al,[bx]
	call	far ptr winddisp
	dec	bx
	dec	dx
	jmp	nwpali
nwendp:	call	far ptr mbell
	jmp	nwpali
nnleft:	cmp	ah,RIGHT
	jne	nw@@1
	cmp	byte ptr [bx],0
	je	nwendp
	inc	dx
	inc	bx
	jmp	nwpali
nw@@1:	jmp	nwpali
n@@@1:	cmp	al,BACK_SPACE
	jne	n@1
	jmp	nwdelw
n@1:	cmp	al,RETURN
	jne	n@22
	xor	ax,ax
	jmp	nwent
n@22:	cmp	al,ESCAPE
	jne	n@3
	jmp	nwent2
nwpali12:
	jmp	nwpali
n@3:	cmp	byte ptr [bx],0
	je	nwendp
	mov	[bx],al
	push	bx
	push	dx
nlq0011:
	inc	bx
	inc	dl
	cmp	byte ptr [bx],0
	je	nlq001
	mov	byte ptr [bx]," "
	call	far ptr windtake
	mov	al," "
	call	far ptr winddisp
	jmp	nlq0011
nlq001:	pop	dx
	pop	bx
	call	far ptr windtake
	mov	al,[bx]
	call	far ptr winddisp
	inc	bx
	inc	dx
	jmp	nwpali
nwdelw:	pop	ax
	push	ax
	cmp	bx,ax
	ja	nw18
	jmp	nwpali
nw18:	dec	bx
	dec	dx
	call	far ptr windtake
	mov	al," "
	call	far ptr winddisp
	mov	byte ptr [bx]," "
	jmp	nwpali
nwent:	mov	word ptr cs:_curs_pos,dx
	push	ax
	call	far ptr windtake
	mov	al,[bx]
	cmp	al,0
	je	nwpin
	call	far ptr winddisp
nwpin:	pop	ax
	pop	bx
	pop	dx
	call	far ptr winvstr
	pop	cx
	mov	dx,word ptr cs:_curs_pos
	clc
	retf
nwent2:	mov	word ptr cs:_curs_pos,dx
	push	ax
	call	far ptr windtake
	mov	al,[bx]
	cmp	al,0
	je	nwpin2
	call	far ptr winddisp
nwpin2:	pop	ax
	pop	bx
	pop	dx
	call	far ptr winvstr
	pop	cx
	mov	dx,word ptr cs:_curs_pos
	stc
	retf
winputnumbers endp

windinputnum proc near
wnpal1: push	bx
	push	dx
	call	far ptr windinput
wnum0:	cmp	byte	ptr [bx],0
	je	wnout
	cmp	byte ptr [bx]," "
	je	wnl1
	cmp	byte ptr [bx],"0"
	jb	wnpal
	cmp	byte ptr [bx],"9"
	ja	wnpal
wnl1:	inc	bx
	jmp	wnum0
wnpal:	push	cx
wsasa:	mov	byte	ptr [bx]," "
	inc	bx
	loop	wsasa
	mov	byte ptr [bx],0
	pop	cx
	pop	dx
	pop	bx
	call	far ptr mbell
	jmp	wnpal1
wnout:	pop	dx
	pop	bx
	retf
windinputnum endp

windinputg proc	near
	push	cx
	push	dx
	push	bx
	mov	ax,0
	call	far ptr windprint
	xor	cx,cx
gwip2:	cmp	byte ptr [bx],0
	je	gwip1
	inc	bx
	inc	cx
	jmp	gwip2
gwinpojo:
	pop	bx
	pop	dx
	pop	cx
	retf
gwip1:	cmp	cx,0
	je	gwinpojo
	cmp	cx,79
	ja	gwinpojo
	pop	bx
	push	bx
	call	far ptr winvstr
gwpali:	call	far ptr curswait
	push	bx
	mov	bx,si
	call	far ptr chkplhktro
	pop	bx
	jc	gnik99
	jmp	gwent2
gnik99:	cmp	al,0
	je	g@@@9
	jmp	g@@@1
g@@@9:	cmp	ah,LEFT
	jne	gnleft
	pop	ax
	push	ax
	cmp	bx,ax
	jbe	gwpali
	call	far ptr windtake
	mov	al,[bx]
	call	far ptr winddisp
	dec	bx
	dec	dx
	jmp	gwpali
gwendp:	call	far ptr mbell
	jmp	gwpali
gnleft:	cmp	ah,RIGHT
	jne	gw@@1
	cmp	byte ptr [bx],0
	je	gwendp
	inc	dx
	inc	bx
	jmp	gwpali
gw@@1:	cmp	ah,INSER
	jne	gnins
	jmp	ginsit
gnins:	cmp	ah,DEL
	jne	gnind
	jmp	gdelit
gnind:	jmp	gwpali
g@@@1:	cmp	al,BACK_SPACE
	jne	g@1
	jmp	gwdelw
g@1:	cmp	al,RETURN
	jne	g@22
	xor	ax,ax
	jmp	gwent
g@22:	cmp	al,ESCAPE
	jne	g@3
	jmp	gwent2
g@3:	cmp	byte ptr [bx],0
	je	gwendp
	cmp	al,32
	jb	gwpali
	cmp	al,254
	ja	gwpali
	call	far ptr upperax
	call	far ptr greekax
	mov	[bx],al
	call	far ptr windtake
	mov	al,[bx]
	call	far ptr winddisp
	inc	bx
	inc	dx
	jmp	gwpali
gwdelw:	pop	ax
	push	ax
	cmp	bx,ax
	ja	gmaxel
	jmp	gwpali
gmaxel:	dec	bx
	dec	dx
	call	far ptr windtake
	mov	al," "
	call	far ptr winddisp
	mov	byte ptr [bx]," "
	jmp	gwpali
gwent:	mov	word ptr cs:_curs_pos,dx
	push	ax
	call	far ptr windtake
	mov	al,[bx]
	cmp	al,0
	je	gwpim
	call	far ptr winddisp
gwpim:	pop	ax
	pop	bx
	pop	dx
	call	far ptr winvstr
	pop	cx
	mov	dx,word ptr cs:_curs_pos
	clc
	retf
gwent2:	mov	word ptr cs:_curs_pos,dx
	push	ax
	call	far ptr windtake
	mov	al,[bx]
	cmp	al,0
	je	gwpim2
	call	far ptr winddisp
gwpim2:	pop	ax
	pop	bx
	pop	dx
	call	far ptr winvstr
	pop	cx
	mov	dx,word ptr cs:_curs_pos
	stc
	retf

ginsit:	push	cx
	push	bx
	push	dx
	mov	cx,bx
	dec	cx
gins03:	cmp	byte ptr [bx],0
	je	gins00
	inc	bx
	inc	dx
	jmp	gins03
gins00:	dec	bx
gins02:	dec	bx
	dec	dx
	cmp	bx,cx
	je	gins01
	call	far ptr windtake
	mov	al,[bx]
	mov	[bx+1],al
	call	far ptr winddisp
	jmp	gins02
gins01:	pop	dx
	pop	bx
	mov	al," "
	mov	byte ptr [bx],al
	call	far ptr winddisp
	pop	cx
	jmp	gwpali

gdelit:	push	bx
	push	dx
	dec	dx
gdel02:	inc	bx
	inc	dx
	call	far ptr windtake
	mov	al,[bx]
	cmp	al,0
	je	gdel01
	mov	[bx-1],al
	call	far ptr winddisp
	jmp	gdel02
gdel01:	mov	al," "
	mov	byte ptr [bx-1],al
	call	far ptr winddisp
	pop	dx
	pop	bx
	jmp	gwpali
windinputg endp

clrcurs proc	near
	push	ax
	push	cx
	push	bx
	mov	ah,1
	mov	ch,20h
	int	10h
	pop	bx
	pop	cx
	pop	ax
	retf
clrcurs endp

bigcurs proc	near
	push	ax
	push	cx
	mov	ah,1
	mov	ch,3
	mov	cl,7
	int	10h
	pop	cx
	pop	ax
	retf
bigcurs endp

;--------------------------------------------------
;	ò§ò£¶§û ©¨ö°ú°®†£ú§¶¨ Æ®¶§¶¨
;	°ò† õ†ò°¶ßû £ú ß¢û°´®¶
;	ú†©òö‡öû : dx Æ®¶§¶™ ©ú õú°ò´ò
; úß†©´®¶≠û : ò§ ßò´ûüú† °òß¶†¶ ß¢û°´®¶
;		ò§òôú† ´¶ carry flag
;		°ò† úß†©´®ú≠ú† ´¶ ß¢û°´®¶ ©´¶§ ax
;--------------------------------------------------

iwait	proc	near
	push	ax
	push	cx
	push	bx
	push	dx
	push	ds
	mov	ax,40h
	mov	ds,ax
	mov	ax,dx
	add	ax,2
	xor	dx,dx
	mov	cx,18
	mul	cx
	mov	cx,10
	div	cx
	mov	cx,ax
	add	cx,word ptr ds:6ch
	jnc	waitmore
	mov	cx,65535
waitmore:
	mov	ax,word ptr ds:6ch
	cmp	ax,cx
	jae	waitstop
	mov	ah,01h
	int	16h
	jne	waitbreak
	jmp	waitmore
waitstop:
	pop	ds
	pop	dx
	pop	bx
	pop	cx
	pop	ax
	clc
	retf
waitbreak:
	pop	ds
	pop	dx
	pop	bx
	pop	cx
	pop	ax
	mov	ah,0
	int	16h
	mov	word ptr cs:_switch,ax
	stc
	retf
_switch	dw	0
iwait	endp

myrnd	proc	near
	@PUSHAX
arkas:	mov	bx,cs:_inctime
	and	bx,0001111111111111b
	mov	ax,cs:[bx]
	cmp	ax,cs:_oldax
	jne	ok
	add	cs:_inctime,771
	jmp	arkas
ok:	mov	cs:_oldax,ax
	@POPAX
	retf
_oldax	dw	0
myrnd	endp

curswait proc	near
curs0:	call	far ptr windtake
	call	far ptr inverse
	call	far ptr winddisp
	push	dx
	mov	dx,2
	call	far ptr iwait
	pop	dx
	jc	cej
	call	far ptr windtake
	call	far ptr inverse
	cmp	al," "
	jbe	kr100
	cmp	cs:_krifo,0
	je	kr100
	mov	al,"*"
kr100:	call	far ptr winddisp
	push	dx
	mov	dx,2
	call	far ptr iwait
	pop	dx
	jc	cej1
	jmp	curs0
cej:	push	ax
	call	far ptr windtake
	call	far ptr inverse
	cmp	al," "
	jbe	kr101
	cmp	cs:_krifo,0
	je	kr101
	mov	al,"*"
kr101:	call	far ptr winddisp
	pop	ax
cej1:	retf
_krifo	db	0
curswait endp

getkey	proc	near
	mov	ah,0
	int	16h
	call	far ptr upperax
	retf
getkey	endp

upperax	proc	near
	cmp	al,0
	je	rtr
	cmp	al,"a"
	jb	rtr
	cmp	al,"z"
	ja	rtr
	sub	al,"a"-"A"
rtr:	retf
upperax	endp

chkwordbuf	proc	near
	@PUSH
chkwn:	mov	dx,[bx]
	cmp	dx,0
	je	chkwt
	cmp	ax,dx
	je	chkwf
	inc	bx
	inc	bx
	jmp	chkwn
chkwt:	@POP
	stc
	retf
chkwf:	@POP
	clc
	retf
chkwordbuf	endp

chkbytebuf	proc	near
	@PUSH
chkbn:	mov	dl,[bx]
	cmp	dl,0
	je	chkbt
	cmp	al,dl
	je	chkbf
	inc	bx
	jmp	chkbn
chkbt:	@POP
	stc
	retf
chkbf:	@POP
	clc
	retf
chkbytebuf	endp

chkplhktro	proc	near
	@PUSH
	cmp	bx,65535
	je	chkpt
chkpn:	mov	dx,[bx]
	cmp	dx,0
	je	chkpt
	cmp	dh,0
	je	chkpq
	cmp	ax,dx
	je	chkpf
	inc	bx
	inc	bx
	jmp	chkpn
chkpq:	cmp	al,dl
	je	chkpf
	inc	bx
	inc	bx
	jmp	chkpn
chkpt:	@POP
	stc
	retf
chkpf:	@POP
	clc
	retf
chkplhktro	endp

getplhktro proc	near
	mov	ah,0ch
	mov	al,07h
	int	21h
	retf
getplhktro endp

;------------------------------------------
;	£ú´ò´®¶ßû ascii string ©ú ò°ú®ò†¶
;------------------------------------------

atoi	proc	near
	push	bx
	push	si
	push	cx
	push	dx
	mov	cs:_atoi,0
	xor	bx,bx
numepom:
	mov	al,byte ptr [si]
	cmp	al,0
	je	numout
	cmp	al," "
	jne	num001
	cmp	cs:_atoi,1
	je	numout
	cmp	bx,0
	jne	num001
	jmp	numepm
num001: sub	al,30h
	jl	numout
	cmp	al,9
	jg	numout
	cbw
	xchg	ax,bx
	mov	cx,10
	mul	cx
	xchg	ax,bx
	add	bx,ax
	mov	cs:_atoi,1
numepm: inc	si
	jmp	numepom
numout: mov	ax,bx
	pop	dx
	pop	cx
	pop	si
	pop	bx
	retf
_atoi	db	0
atoi	endp

;------------------------------------------
;	£ú´ò´®¶ßû ò°ú®ò†¶¨ ©ú ascii string
;------------------------------------------

itoa	proc	near
	push	bx
	push	cx
	push	dx
	push	ax
	push	cx
itoa2:	mov	byte ptr [si]," "
	inc	si
	loop	itoa2
	mov	byte ptr [si],0
	dec	si
	pop	cx
itoa1:	xor	dx,dx
	mov	bx,10
	div	bx
	add	dl,30h
	mov	[si],dl
	cmp	ax,0
	je	itend
	dec	si
	loop	itoa1
itend:	pop	ax
	pop	dx
	pop	cx
	pop	bx
	retf
itoa	endp

atol	proc	near
	push	cx
	push	di
	push	si
	push	ds
	push	bx
	mov	cs:_number,0
	mov	cs:_number[2],0
	xor	di,di
	mov	cx,10
alodi:	mov	cs:_atol[di],0
	inc	di
	loop	alodi
	mov	di,9
	mov	si,9
	mov	cx,10
_lzrb:	mov	al,[bx][si]
	cmp	al," "
	je	lsra
	cmp	al,48
	jae	lzra
	mov	al,48
lzra:	sub	al,48
	mov	cs:_atol[di],al
	dec	di
lsra:	dec	si
	loop	_lzrb
atl4:	xor	ax,ax
	mov	cx,10
	mov	di,9
atl1:	mov	al,cs:_atol[di]
	mov	dl,cs:_maxb[di]
	add	dl,ah
	mov	ah,0
	cmp	al,dl
	jae	atl0
	add	al,10
	mov	ah,1
atl0:	sub	al,dl
	mov	cs:_atol1[di],al
	dec	di
	loop	atl1
	cmp	ah,0
	jne	atl3
	inc	cs:_number
	mov	cx,10
	xor	di,di
atl5:	mov	al,cs:_atol1[di]
	add	al,48
	mov	cs:_atol1[di],al
	inc	di
	loop	atl5
	push	ds
	push	cs
	pop	ds
	mov	si,offset _atol1
	call	far ptr atoi
	pop	ds
	mov	cs:_number[2],ax
	mov	cx,10
	xor	di,di
atl2:	mov	al,cs:_atol1[di]
	sub	al,48
	mov	cs:_atol[di],al
	mov	cs:_atol1[di],0
	inc	di
	loop	atl2
	jmp	atl4
atl3:	mov	dx,cs:_number
	mov	ax,cs:_number[2]
	cmp	dx,0
	jne	nodx0
	cmp	ax,0
	jne	nodx0
	pop	si
	push	si
	call	far ptr atoi
nodx0:	pop	bx
	pop	ds
	pop	si
	pop	di
	pop	cx
	retf
_atol	db	11 dup(0)
_atol1	db	11 dup(0)
_maxb	db	0,0,0,0,0,6,5,5,3,6
_number	dw	0,0
atol	endp

ltoa	proc	near
	@PUSH
	mov	si,0
	mov	di,bx
	mov	cx,10
_zrb:	mov	byte ptr[di],0
	inc	di
	loop	_zrb
	mov	di,bx
	mov	cx,16
_rot:	rcl	dx,1
	jnc	_ep
	call	far ptr _prosu
_ep:	add	si,10
	loop	_rot
	mov	cx,16
_rt1:	rcl	ax,1
	jnc	_er1
	call	far ptr _prosu
_er1:	add	si,10
	loop	_rt1
	call	far ptr bcd2dec
	@POP
	retf
_prosu:	@PUSH
	add	si,9
	add	di,9
	xor	ax,ax
	mov	cx,10
_nxt:	add	al,[di]
	mov	dl,cs:_num[si]
	add	al,dl
	aaa
	mov	[di],al
	mov	al,ah
	mov	ah,0
	dec	si
	dec	di
	loop	_nxt
	@POP
	retf
_num	db	2,1,4,7,4,8,3,6,4,7
	db	1,0,7,3,7,4,1,8,2,4
	db	0,5,3,6,8,7,0,9,1,2
	db	0,2,6,8,4,3,5,4,5,6
	db	0,1,3,4,2,1,7,7,2,8
	db	0,0,6,7,1,0,8,8,6,4
	db	0,0,3,3,5,5,4,4,3,2
	db	0,0,1,6,7,7,7,2,1,6
	db	0,0,0,8,3,8,8,6,0,8
	db	0,0,0,4,1,9,4,3,0,4
	db	0,0,0,2,0,9,7,1,5,2
	db	0,0,0,1,0,4,8,5,7,6
	db	0,0,0,0,5,2,4,2,8,8
	db	0,0,0,0,2,6,2,1,4,4
	db	0,0,0,0,1,3,1,0,7,2
	db	0,0,0,0,0,6,5,5,3,6
	db	0,0,0,0,0,3,2,7,6,8
	db	0,0,0,0,0,1,6,3,8,4
	db	0,0,0,0,0,0,8,1,9,2
	db	0,0,0,0,0,0,4,0,9,6
	db	0,0,0,0,0,0,2,0,4,8
	db	0,0,0,0,0,0,1,0,2,4
	db	0,0,0,0,0,0,0,5,1,2
	db	0,0,0,0,0,0,0,2,5,6
	db	0,0,0,0,0,0,0,1,2,8
	db	0,0,0,0,0,0,0,0,6,4
	db	0,0,0,0,0,0,0,0,3,2
	db	0,0,0,0,0,0,0,0,1,6
	db	0,0,0,0,0,0,0,0,0,8
	db	0,0,0,0,0,0,0,0,0,4
	db	0,0,0,0,0,0,0,0,0,2
	db	0,0,0,0,0,0,0,0,0,1
ltoa	endp

bcd2dec	proc	near
	@PUSH
	mov	cx,10
_b2d:	mov	al,[bx]
	or	al,48
	mov	[bx],al
	inc	bx
	loop	_b2d
	@POP
	retf
bcd2dec	endp

usenum	proc	near
	@PUSH
	mov	di,bx
	mov	cx,10
usn2:	cmp	byte ptr [di],"0"
	je	usn0
	cmp	byte ptr [di]," "
	je	usn0
	jmp	usn1
usn0:	inc	di
	loop	usn2
	mov	byte ptr [bx+1],0
	jmp	usn3
usn1:	cmp	di,bx
	je	usn3
usn4:	mov	al,[di]
	mov	[bx],al
	inc	di
	inc	bx
	loop	usn4
	mov	byte ptr [bx],0
usn3:	@POP
	retf
usenum	endp

using	proc	near
	@PUSH
	push	si
	push	cx
	push	cx
	xor	di,di
usi1:	mov	byte ptr cs:_strbufl[di],al
	inc	di
	loop	usi1
	mov	byte ptr cs:_strbufl[di],0

	mov	dx,si
	mov	cx,11
usi3:	cmp	byte ptr [si],0
	je	usi2
	inc	si
	loop	usi3

usi2:	pop	cx
usi4:	dec	di
	dec	si
	mov	al,[si]
	mov	cs:_strbufl[di],al
	cmp	si,dx
	je	usi6
	loop	usi4
usi6:	pop	cx
	pop	si
	xor	bx,bx
usi5:	mov	al,cs:_strbufl[bx]
	mov	[si][bx],al
	inc	bx
	loop	usi5
	mov	byte ptr [si][bx],0
	@POP
	retf
_strbufl	db	20 dup(0)
using	endp

;-----------------------------------------
; öú£†ùú† ´û§ ¶ü¶§û £ú ´¶§ Æò®ò°´û®ò al
;	 °ò† ´¶ attribute ah
;-----------------------------------------
fillscr proc	near
	push	dx
	push	cx
	push	ax
	xor	dx,dx
	mov	cx,25
ms2:	push	cx
	mov	cx,80
ms1:	call	far ptr qprint
	inc	dx
	loop	ms1
	pop	cx
	inc	dh
	mov	dl,0
	loop	ms2
	pop	ax
	pop	cx
	pop	dx
	retf
fillscr endp

;---------------------------------------
;	úß†©´®ú≠ú† ©´¶§ òÆ
;	´¶ £û°¶™ ´¶¨ string
;	©´¶§ si
;---------------------------------------

strlen	proc	near
	push	si
	xor	ax,ax
slt0:	cmp	byte ptr [si],0
	je	slt9
	inc	ax
	inc	si
	jmp	slt0
slt9:	pop	si
	retf
strlen	endp

;---------------------------------------
;	ò§´†ö®ò≠ú† ú§ò string ©ú ú§ò ò¢¢¶
;	ú†©¶õ¶™ : bx 1o string
;		si 2o string
;---------------------------------------

strcpy	proc	near
	push	ax
	push	si
	push	bx
stp0:	cmp	byte ptr [si],0
	je	stpout
	mov	al,[bx]
	cmp	al,0
	je	stpoul
	mov	[si],al
	inc	bx
	inc	si
	jmp	stp0
stpoul: mov	byte ptr [si]," "
	inc	si
	cmp	byte ptr [si],0
	je	stpout
	jmp	stpoul
stpout: pop	bx
	pop	si
	pop	ax
	retf
strcpy	endp

strxor	proc	near
	push	cx
	push	ax
	push	si
	push	dx
	push	bx
	mov	bx,0
	cmp	cx,0
	jne	xtp0
	mov	cx,65535
	mov	bx,1
xtp0:	mov	al,[si]
	cmp	bx,0
	je	xtp1
	cmp	al,0
	je	xtpout
xtp1:	xor	al,dl
	mov	[si],al
	inc	si
	loop	xtp0
xtpout:	pop	bx
	pop	dx
	pop	si
	pop	ax
	pop	cx
	retf
strxor	endp

strcopy proc	near
	push	cx
	push	ax
	push	si
	push	bx
stp01:	mov	al,[bx]
	mov	[si],al
	inc	bx
	inc	si
	loop	stp01
	pop	bx
	pop	si
	pop	ax
	pop	cx
	retf
strcopy endp

strxchg	proc	near
	push	cx
	push	ax
	push	si
	push	bx
stpx1:	mov	al,[bx]
	mov	ah,[si]
	mov	[si],al
	mov	[bx],ah
	inc	bx
	inc	si
	loop	stpx1
	pop	bx
	pop	si
	pop	ax
	pop	cx
	retf
strxchg	endp

;-----------------------------------
;	©¨ö°®†©û 2 string 
; ú†©òö‡öú™ : bx 1o string
;		si 2o string
;
; úò§ ú†§ò† †©ò cf -> 0
; úò§ 1¶>2¶	cf -> 1 , ax=1
; úò§ 1¶<2¶	cf -> 1 , ax=0
;-----------------------------------

strcmp	proc	near
	push	ax
	push	si
	push	bx
stc0:	cmp	byte ptr [si],0
	je	stcout
	mov	al,[bx]
	cmp	al,0
	je	stcout
	cmp	[si],al
	je	stiso
	ja	stmax
	jmp	stmin
stiso:	inc	bx
	inc	si
	jmp	stc0
stcout: pop	bx
	pop	si
	pop	ax
	clc
	retf
stmax:	pop	bx
	pop	si
	pop	ax
	mov	ax,1
	stc
	retf
stmin:	pop	bx
	pop	si
	pop	ax
	mov	ax,0
	stc
	retf
strcmp	endp

fillstr	proc	near
	@PUSH
	cmp	cx,0
	je	fst03
fst01:	mov	byte ptr [bx],al
	inc	bx
	loop	fst01
fst03:	mov	byte ptr [bx],0
	@POP
	retf
fillstr	endp

asciiz	proc	near
	@PUSH
	push	bx
chz0:	cmp	byte ptr [bx],0
	je	chz1
	inc	bx
	jmp	chz0
chz1:	dec	bx
	cmp	byte ptr [bx]," "
	jne	chzout
	pop	ax
	push	ax
	cmp	bx,ax
	je	chzer
	jmp	chz1
chzout:	mov	byte ptr [bx+1],0
	pop	ax
	sub	bx,ax
	mov	cs:_val,bx
	@POP
	mov	ax,cs:_val
	inc	ax
	clc
	retf
chzer:	pop	ax
	@POP
	stc
	retf
_val	dw	0
asciiz	endp

endchar	proc	near
	@PUSH
@nxt:	cmp	byte ptr [bx]," "
	jae	@isok
	mov	byte ptr [bx]," "
@isok:	inc	bx
	loop	@nxt
	mov	byte ptr [bx],dl
	@POP
	retf
endchar	endp

take_curs_word proc	near
	push	si
	push	dx
	push	ax
	push	bx
	mov	word ptr cs:save_si,si
next0:	call	far ptr windtake
	cmp	al,32
	jbe	brika_arxi
	cmp	al,176
	jb	check_users
	cmp	al,224
	jb	brika_arxi
	cmp	al,234
	jbe	check_users
	jmp	brika_arxi
check_users:
	mov	si,word ptr cs:save_si
	cmp	si,65535
	je	next1
next2:	cmp	al,byte ptr [si]
	je	brika_arxi
	cmp	byte ptr [si],0
	je	next1
	inc	si
	jmp	next2
next1:	cmp	dl,0
	jbe	brika_0
	dec	dx
	jmp	next0

brika_arxi:

next3:	inc	dx

brika_0:
	call	far ptr windtake
	cmp	al,32
	jbe	brika_telos
	cmp	al,176
	jb	check_users1
	cmp	al,224
	jb	brika_telos
	cmp	al,234
	jbe	check_users1
	jmp	brika_telos
check_users1:
	mov	si,word ptr cs:save_si
	cmp	si,65535
	je	next5
next4:	cmp	al,byte ptr [si]
	je	brika_telos
	cmp	byte ptr [si],0
	je	next5
	inc	si
	jmp	next4
next5:	mov	byte ptr [bx],al
	cmp	dl,79
	jae	brika_telos
	inc	bx
	jmp	next3
brika_telos:
	mov	byte ptr [bx],0
	pop	bx
	pop	ax
	pop	dx
	pop	si
	retf
save_si	dw	?
take_curs_word endp

isenglish proc	near
	cmp	al,"A"
	jb	ieexit
	cmp	al,"Z"
	jbe	ieok
	cmp	al,"a"
	jb	ieexit
	cmp	al,"z"
	jbe	ieok
ieexit:	stc
	retf
ieok:	clc
	retf
isenglish endp

isgreek	proc	near
	cmp	al,128	;"A"
	jb	igexit
	cmp	al,175	;"z"
	jbe	igok
	cmp	al,224	;"‡"
	jb	igexit
	cmp	al,234	;"ó"
	jbe	igok
igexit:	stc
	retf
igok:	clc
	retf
isgreek	endp

toupper	proc	near
	push	ax
	push	bx
	push	cx
	push	si
upnext:	mov	al,byte ptr [bx]
	cmp	al,0
	je	upexit
	cmp	al,97	; "a"
	jb	upinc
	cmp	al,122
	ja	upgr
	sub	al,"a"-"A"
upinc:	mov	byte ptr [bx],al
	inc	bx
	jmp	upnext
upexit:	pop	si
	pop	cx
	pop	bx
	pop	ax
	retf
upgr:	cmp	al,152
	jb	upinc
	cmp	al,170
	jae	grek_style
	sub	al,152-128
	jmp	upinc
grek_style:
	xor	si,si
	mov	cx,16
other1:	cmp	al,byte ptr cs:_uptable[si]
	jne	other
	mov	al,byte ptr cs:_uptable[si+16]
	jmp	upinc
other:	inc	si
	loop	other1
	jmp	upinc
_uptable db	"™´¨≠ÆØ‡·‚„Â‰ÈÊÁË"
	db	"ëíìîïñóÄÑÜààóéìì"
toupper	endp

greekax	proc	near
	push	cx
	push	si
	cmp	al," "
	jb	_ep2
	cmp	al,126
	ja	_ep2
	mov	si,offset cs:engl
	mov	cx,24
_ep1:	cmp	al,byte ptr cs:[si]
	je	_ep3
	inc	si
	loop	_ep1
	jmp	_ep2
_ep3:	add	si,24
	mov	al,byte ptr cs:[si]
	jmp	_ep2
engl	db	"ABGDEZHUIKLMNJOPRSTYFXCV"
	db	"ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñó"
_ep2:	pop	si
	pop	cx
	retf
greekax	endp

bell	proc	near
	push	ax
	mov	al,7
	mov	ah,0eh
	int	10h
	pop	ax
	retf
bell	endp

mbell	proc	near
	@PUSH
	mov	cx,40
	mov	ax,400
mb01:	push	cx
	mov	cx,ax
	mov	bx,8
	call	far ptr sound
	pop	cx
	loop	mb01
	@POP
	retf
mbell	endp

locate	proc	near
	call	far ptr windcurs
	add	dx,0101h
	mov	cs:_locate,dx
	call	far ptr takeinf
	retf
_locate dw	0
_tabshm	db	0
locate	endp

prints	proc	near
	@PUSH
ps01:	mov	al,[bx]
	cmp	al,0
	je	psout
	call	far ptr printc
	inc	bx
	jmp	ps01
psout:	@POP
	retf
prints	endp

printc	proc	near
	@PUSH
	mov	dx,cs:_locate
	call	far ptr cursinwind
	jnc	klama
	@POP
	retf
klama:	cmp	al,32
	jb	chunc
	jmp	prch1
chunc:	cmp	al,LINE_FEED
	jne	ch1
	inc	dh
	mov	ax,cs:_infax
	cmp	dh,ah
	jb	pc02
	call	far ptr scrst
pc02:	jmp	pcout
ch1:	cmp	al,RETURN
	jne	ch3
	mov	ax,cs:_infdx
	mov	dl,al
	jmp	pcout
ch3:	cmp	cs:_tabshm,0
	je	ch5
	mov	dl,al
	jmp	pcout
ch5:	cmp	al,TAB
	jne	ch2
	mov	cs:_tabshm,1
	jmp	pcout
ch2:	cmp	al,BACK_SPACE
	jne	ch4
	mov	ax,cs:_infdx
	cmp	dl,al
	je	ch01
	dec	dl
	jmp	pcout
ch01:	cmp	dh,ah
	je	pc03
	dec	dh
	mov	ax,cs:_infax
	mov	dl,al
pc03:	jmp	pcout
ch4:	jmp	pcout
prch1:	push	ax
	call	far ptr qtake
	pop	cx
	mov	al,cl
	call	far ptr qprint
	inc	dl
	mov	ax,cs:_infax
	cmp	dl,al
	jb	pc01
	inc	dh
	mov	ax,cs:_infdx
	mov	dl,al
	mov	ax,cs:_infax
	cmp	dh,ah
	jb	pc01
	call	far ptr scrst
pcout:
pc01:	mov	cs:_locate,dx
	@POP
	retf
;
scrst:	@PUSH
	call	far ptr qtake
	mov	bh,ah
	mov	ax,0601h
	mov	cx,cs:_infdx
	mov	dx,cs:_infax
	sub	dx,0101h
	int	10h
	@POP
	dec	dh
	retf
printc	endp

cursinwind	proc	near
	@PUSH
	mov	ax,cs:_infdx
	cmp	dh,ah
	jb	retf_c
	cmp	dl,al
	jb	retf_c
	mov	ax,cs:_infax
	cmp	dh,ah
	ja	retf_c
	cmp	dl,al
	ja	retf_c
	@POP
	clc
	retf
retf_c:	@POP
	stc
	retf
cursinwind	endp

sound	proc	near
	push	ax
	push	bx
	push	cx
	in	al,61h
	and	al,0fch
pulse:	push	cx
	xor	al,2
	out	61h,al
s199:	loop	s199
	pop	cx
	dec	bx
	jnz	pulse
	and	al,0fch
	out	61h,al
	pop	cx
	pop	bx
	pop	ax
	retf
sound	endp

;------------------------------------ DIRECTORIES

winddir	proc	near
	@PUSH
	mov	cs:_dirchk1,al
	mov	al,[bx+5]
	mov	cs:_diratr,al
	xor	ax,ax
	mov	al,[bx+3]
	mov	cl,10
	div	cl
	mov	ah,0
	mov	cs:_dirlx,ax
	xor	ax,ax
	mov	al,[bx+4]
	sub	al,3
	mov	cs:_dirly,ax
	mov	cs:_dirx,3
	mov	cs:_diry,3
	mov	dh,3
	mov	dl,1
	call	far ptr windcurs
	mov	cs:_dirx1,dl
	mov	cs:_dirx2,dl
	mov	cs:_diry1,dh
	mov	cs:_diry2,dh
	mov	dl,[bx+3]
	mov	dh,[bx+4]
	sub	dh,3
	dec	dl
	add	cs:_dirx2,dl
	dec	dh
	add	cs:_diry2,dh
	@INITWIND cs:_dirx1,cs:_diry1,cs:_dirx2,cs:_diry2,cs:_diratr
	cmp	cs:_dirchk1,0
	je	dir00
	cmp	cs:_dirchk,0
	jne	direp
	jmp	direrror
dir00:	@FINDFIRSTFILE	si,0
	jc	direrror
direp:	@GETDTA
	add	bx,1eh
	mov	ax,es
	mov	ds,ax
	mov	cx,cs:_dirly
	dec	cx
ldir2:	push	cx
	mov	cx,cs:_dirlx
ldir1:	push	cx
	mov	cx,8
	xor	di,di
ldir3:	mov	al,[bx][di]
	cmp	al,"."
	je	ldir4
	inc	di
	loop	ldir3
ldir4:	mov	al,0
	mov	[bx][di],al
	pop	cx
	mov	dh,cs:_diry
	mov	dl,cs:_dirx
	call	far ptr windprint
	add	cs:_dirx,10
	@FINDNEXTFILE
	jc	ldir0
	loop	ldir1
	inc	cs:_diry
	mov	cs:_dirx,3
	pop	cx
	loop	ldir2
	mov	byte ptr cs:_dirchk,1
	@POP
	clc
	retf
ldir0:	pop	cx
direrror:
	mov	byte ptr cs:_dirchk,0
	@POP
	stc
	retf
_diratr	db	0
_dirlx	dw	0
_dirly	dw	0
_dirx	db	0
_diry	db	0
_dirx1	db	0
_diry1	db	0
_dirx2	db	0
_diry2	db	0
_dirchk	db	0
_dirchk1 db	0
winddir	endp	

getfirstdir	proc	near
	@PUSH
	@FINDFIRSTFILE	si,0
	jc	gdirerror
	@GETDTA
	add	bx,1eh
	mov	cx,8
gldir3:	mov	al,es:[bx]
	cmp	al,"."
	je	gldir4
	mov	[di],al
	inc	di
	inc	bx
	loop	gldir3
gldir4:	mov	al,0
	mov	[di],al
	@POP
	clc
	retf
gdirerror:
	@POP
	stc
	retf
getfirstdir	endp	

getnextdir	proc	near
	@PUSH
	@FINDNEXTFILE
	jc	ndirerror
	@GETDTA
	add	bx,1eh
	mov	cx,8
nldir3:	mov	al,es:[bx]
	cmp	al,"."
	je	nldir4
	mov	[di],al
	inc	di
	inc	bx
	loop	nldir3
nldir4:	mov	al,0
	mov	[di],al
	@POP
	clc
	retf
ndirerror:
	@POP
	stc
	retf
getnextdir	endp	

diskspace proc	near
	@PUSH
	@GETDISKSPACE	al
	xor	dx,dx
	mul	bx
	mov	bx,2000
	div	bx
	mov	cs:_disks1,ax
	mov	ax,dx
	xor	dx,dx
	mov	bx,200
	div	bx
	mov	bl,10
	mul	bl
	mov	cs:_disks2,ax
	mov	ax,dx
	xor	dx,dx
	mov	bx,20
	div	bx
	add	cs:_disks2,ax
	@POP
	mov	ax,cs:_disks1
	mov	dx,cs:_disks2
	retf
_disks1	dw	0
_disks2	dw	0
diskspace endp	

;------------------------------------ MATHS

public	longmul

longmul	proc	near	; ÑàëÄÇóÇÑë DX:AX & CX:BX
	push	si
	push	cx
	push	bx
	xchg	si,ax
	xchg	dx,ax
	test	ax,ax
	je	w0001
	mul	bx
w0001:	xchg	cx,ax
	test	ax,ax
	je	w0002
	mul	si
	add	cx,ax
w0002:	xchg	si,ax
	mul	bx
	add	dx,cx
	pop	bx
	pop	cx
	pop	si
	retf
longmul	endp
	
test_drive	proc	near
	@PUSH
	push	cs
	pop	ds
	mov	ah,0
	call	far ptr upperax
	sub	al,"A"
	cmp	al,1
	ja	_okk
	mov	_drive,al
	mov	ax,0
	call	far ptr find_sect
	@VERIFY _sector,1,_track,_head,_drive,_buffer
	jnc	_okk
	@POP
	stc
	retf
_okk:	@POP
	clc
	retf
test_drive endp

test_file proc	near
	@PUSH
	@FINDFIRSTFILE	ax,02
	jc	_nfile
	cmp	al,18
	je	_nfile
	@POP
	clc
	retf
_nfile:	@POP
	stc
	retf
test_file endp

tis_ekato	proc	near	; ax:dx=dieretis, cx:bx=diereteos , si=buffer
	@PUSH
	
	mov	byte ptr [si],"-"
	mov	byte ptr [si][1],"-"
	mov	byte ptr [si][2],"-"
	mov	byte ptr [si][3],"."
	mov	byte ptr [si][4],"-"
	mov	byte ptr [si][5],"%"
	mov	byte ptr [si][6],0
	cmp	ax,0
	jne	ekat1
	cmp	dx,0
	jne	ekat1
	@POP
	retf
ekat1:	cmp	cx,0
	jne	ekat2
	cmp	bx,0
	jne	ekat2
	@POP
	retf
ekat2:	push	si
	push	ds
	push	cs
	pop	ds
	
	mov	cs:_m1,cx
	mov	cs:_m2,bx
	mov	cs:_m3,ax
	mov	cs:_m4,dx
	@LTOA10	cs:_m1,cs:_m2,cs:_num1
	mov	cx,8
	mov	bx,0
alo1:	mov	al,cs:_num1[bx+2]
	mov	cs:_num1[bx],al
	inc	bx
	loop	alo1
	xor	ax,ax
	mov	cs:_num1[8],"0"
	mov	cs:_num1[9],"0"
	@LTOA10	cs:_m3,cs:_m4,cs:_num2
diera:	@FILLSTR	cs:_num3,0,10
	call	aferesi
	jc	diert
	inc	ax
	@STRCOPY	cs:_num3,cs:_num1,10
	jmp	diera
diert:	@ITOA	cs:_num4,3
	mov	cx,9
	mov	bx,0
alo11:	mov	al,cs:_num1[bx+1]
	mov	cs:_num1[bx],al
	inc	bx
	loop	alo11
	xor	ax,ax
	mov	cs:_num1[9],"0"
diera1:	@FILLSTR	cs:_num3,0,10
	call	aferesi
	jc	diert1
	inc	ax
	@STRCOPY	cs:_num3,cs:_num1,10
	jmp	diera1
diert1:	mov	cs:_num4[3],"."
	@ITOA	cs:_num4[4],1
	mov	cx,9
	mov	bx,0
alo12:	mov	al,cs:_num1[bx+1]
	mov	cs:_num1[bx],al
	inc	bx
	loop	alo12
	xor	ax,ax
	mov	cs:_num1[9],"0"
diera2:	@FILLSTR	cs:_num3,0,10
	call	aferesi
	jc	diert2
	inc	ax
	@STRCOPY	cs:_num3,cs:_num1,10
	jmp	diera2
diert2:	@ITOA	cs:_num4[5],1
	pop	ds
	pop	si
	mov	cx,5
	xor	bx,bx
dirt12:	mov	al,cs:_num4[bx]
	mov	[si],al
	inc	si
	inc	bx
	loop	dirt12
	mov	byte ptr [si],"%"
	mov	byte ptr [si+1],0
	@POP
	retf
_m1	dw	0
_m2	dw	0
_m3	dw	0
_m4	dw	0
_num1	db	10 dup(0),0
_num2	db	10 dup(0),0
_num3	db	10 dup(0),0
_num4	db	10 dup(0),0
_krat	db	0
tis_ekato	endp

aferesi	proc	near
	@PUSH
	mov	cx,10
	mov	bx,9
	mov	cs:_krat,0
alon:	mov	al,cs:_num2[bx]
	sub	al,"0"
	mov	ah,cs:_num1[bx]
	sub	ah,"0"
	add	al,cs:_krat
	cmp	al,ah
	ja	kra1
	mov	cs:_krat,0
	jmp	ok23
kra1:	add	ah,10
	mov	cs:_krat,1
ok23:	sub	ah,al
	add	ah,"0"
	mov	cs:_num3[bx],ah
	dec	bx
	loop	alon
	cmp	cs:_krat,0
	je	oklc
	@POP
	stc
	ret
oklc:	@POP
	clc
	ret
aferesi	endp


mcode	ends

endsegm	segment
endsegm	ends

	end
