
@WINDOWS=MCODE1

INCLUDE	mylib.inc
INCLUDE	keys.inc
INCLUDE	sindisk.inc

MCODE1	segment	public

	assume	cs:mcode1,ds:mcode1

indisk	proc	near
	@PUSH
	push	ax
	@TAKEWINSEGM
	mov	cs:_oldwinsegm,ax
	pop	ax
	@SETWINSEGM	MCODE1
	push	cs
	pop	ds
	sub	ax,64
	mov	cl,5
	mul	cl
	mov	_cx,al
	@SETWIND	w_abcd
	@SELECTWIND	w_abcd
ind00:	cmp	_cx,5
	jae	ind01
	mov	_cx,5
ind01:	cmp	_cx,30
	jbe	ind02
	mov	_cx,5
ind02:	@INVERSE	_cx,4,3
	@WAITL
	@INVERSE	_cx,4,3
	@UPPERAX
	cmp	ah,@RIGHT_ARROW
	jne	indnr
	add	_cx,5
	jmp	ind00
indnr:	cmp	ah,@LEFT_ARROW
	jne	indnl
	sub	_cx,5
	jmp	ind00
indnl:	cmp	al,"A"
	jne	indna
	jmp	indok
indna:	cmp	al,"B"
	jne	indnb
	jmp	indok
indnb:	cmp	al,"C"
	jne	indnc
	jmp	indok
indnc:	cmp	al,"D"
	jne	indnd
	jmp	indok
indnd:	cmp	al,"E"
	jne	indne
	jmp	indok
indne:	cmp	al,"F"
	jne	indnf
	jmp	indok
indnf:	cmp	al,@ESCAPE
	jne	indnes
	jmp	indak
indnes:	cmp	al,@ENTER
	jne	indnen
	mov	ah,4
	mov	al,_cx
	inc	al
	@TAKECURSWORD	_strbuf,ax
	mov	al,_strbuf
indok:	mov	_cx,al
	@DELWIND	w_abcd
	@SETWINSEGM	cs:_oldwinsegm
	@POP
	mov	al,cs:_cx
	clc
	retf
indak:	@DELWIND	w_abcd
	@SETWINSEGM	cs:_oldwinsegm
	@POP
	stc
	retf
indnen:	@MBELL
	jmp	ind00
_oldwinsegm	dw	0
_cx		db	0
_strbuf		db	0,0,0
w_abcd		db	80,29,4,36,5,07h,1
		db	0
		db	"           EèàäéÇÜ Éàëâéì",0
		db	0
		db	"     A    B    C    D    E    F",0
		db	0
indisk	endp

mcode1	ends
	end
