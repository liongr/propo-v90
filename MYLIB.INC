
INCLUDE	MDOS.INC

@MAXREC = 32769

@BRIGHT = 00001000b
@FLASH = 10000000b
@FLASHBRIGHT = 10001000b
@NULL = 0

@WIN_INDEX = 0
@WIN_X = 1
@WIN_Y = 2
@WIN_X1 = 3
@WIN_Y1 = 4
@WIN_ATR = 5
@WIN_BOX = 6

@NAME1 = 4
@NAME2 = 44
@NAME3 = 84

MCODE	segment public
global	_leotime:word
global	tis_ekato:proc
global	prnerror:proc
global	set_win_segm:proc
global	take_win_segm:proc
global	initscreen:proc
global	initwind:proc
global	winddel:proc
global	winddel1:proc
global	windmake:proc
global	clswind:proc
global	popmake:proc
global	setfores:proc
global	selectw:proc
global	takeselect:proc
global	selectwi:proc
global	windprint:proc
global	numbers:proc
global	boxwind:proc
global	boxbuf:proc
global	setbox:proc
global	winddisp:proc
global	windinput:proc
global	windinputg:proc
global	wcodeinput:proc
global	windinputnum:proc
global	winputnumbers:proc
global	qprint:proc
global	qtake:proc
global	iwait:proc
global	myrnd:proc
global	startrnd:proc
global	endrnd:proc
global	strlen:proc
global	strcpy:proc
global	strxor:proc
global	strcmp:proc
global	winvstr:proc
global	bell:proc
global	mbell:proc
global	fillscr:proc
global	asciiz:proc
global	endchar:proc
global	chkplhktro:proc
global	chkwordbuf:proc
global	chkbytebuf:proc
global	atoi:proc
global	itoa:proc
global	ltoa:proc
global	atol:proc
global	usenum:proc
global	using:proc
global	isgreek:proc
global	isenglish:proc
global	take_curs_word:proc
global	toupper:proc
global	greekax:proc
global	upperax:proc
global	clrcurs:proc
global	bigcurs:proc
global	curswait:proc
global	strcopy:proc
global	userbox:proc
global	userchr:proc
global	useratr:proc
global	userw:proc
global	initw:proc
global	fillstr:proc
global	strxchg:proc
global	locate:proc
global	prints:proc
global	printc:proc
global	sound:proc
global	winddir:proc
global	diskspace:proc
global	getplhktro:proc
global	getfirstdir:proc
global	getnextdir:proc
global	start_prg:proc
global	chktime:proc
global	end_prg:proc
global	exit:proc
global	reset:proc
global	lprintchr:proc
global	lprintstr:proc
global	lprintStart:proc
global	lprintStop:proc
global	test_drive:proc
global	test_file:proc
global	get_start_drive:proc

global	make_task:proc
global	multi:proc
global	multistop:proc
global	_prg:proc
global	_task:proc
global	_tswitch:proc

global	longmul:proc

global	names:word
global	start_drv:byte
global	start_attr:byte
global	error_code:byte
global	is_error:byte
global	_sscreen:word
global	_scrpage:word
global	_inctime:word
global	_lfnum:word
global	_pagelength:word
global	_switch:word
MCODE	ends

@POSOSTO	macro	num1,num2,buffer
		push	ax
		push	cx
		push	dx
		push	bx
		mov	ax,word ptr num1
		mov	dx,word ptr num1[2]
		mov	cx,word ptr num2
		mov	bx,word ptr num2[2]
		mov	si,offset buffer
		call	far ptr tis_ekato
		pop	bx
		pop	dx
		pop	cx
		pop	ax
		endm

@SETWINSEGM	macro	segm
		push	ax
		mov	ax,segm
		call	far ptr set_win_segm
		pop	ax
		endm

@TAKEWINSEGM	macro	segm
		call	far ptr take_win_segm
		endm

@PAGEL		macro	length
		push	ds
		push	ax
		mov	ax,MCODE
		mov	ds,ax
		mov	_pagelength,length
		mov	_lfnum,0
		pop	ax
		pop	ds
		endm

@PRNERROR	macro	STACKPRN
		LOCAL	litsa
		call	far ptr prnerror
		jnc	litsa
		mov	sp,STACKPRN
		@POP
		retf
litsa: 		nop
		endm

@EXIT		macro
		call	far ptr exit
		endm

@RESET		macro
		call	far ptr reset
		endm

@LMOVN		macro	num1,num2
		push	ax
		mov	ax,word ptr num2[0]
		mov	word ptr num1[0],ax
		mov	ax,word ptr num2[2]
		mov	word ptr num1[2],ax
		pop	ax
		endm

@LCMPN		macro	num1,num2
		LOCAL	ismeg,ismin,fige
		push	ax
		push	dx
		mov	ax,word ptr num1[0]
		mov	dx,word ptr num1[2]
		cmp	dx,word ptr num2[2]
		ja	ismeg
		jb	ismin
		cmp	ax,word ptr num2[0]
		ja	ismeg
		jb	ismin
		xor	dx,dx
		jmp	short fige
		pop	ax
ismeg:		mov	ax,100
		cmp	ax,10
		jmp	short fige
ismin:		mov	ax,10
		cmp	ax,100
fige:		pop	dx
		pop	ax
		endm

@LADDN		macro	num1,num2
		push	cx
		push	bx
		push	ax
		push	dx
		mov	dx,word ptr num1[2]
		mov	ax,word ptr num1[0]
		mov	cx,word ptr num2[2]
		mov	bx,word ptr num2[0]
		add	ax,bx
		adc	dx,cx
		mov	word ptr num1[2],dx
		mov	word ptr num1[0],ax
		pop	dx
		pop	ax
		pop	bx
		pop	cx
		endm

@LADD		macro	high1,low1,high2,low2
		push	cx
		push	bx
		mov	dx,high1
		mov	ax,low1
		mov	cx,high2
		mov	bx,low2
		add	ax,bx
		adc	dx,cx
		mov	high1,dx
		mov	low1,ax
		pop	bx
		pop	cx
		endm

@LSUBN		macro	num1,num2
		push	cx
		push	bx
		push	ax
		push	dx
		mov	dx,word ptr num1[2]
		mov	ax,word ptr num1[0]
		mov	cx,word ptr num2[2]
		mov	bx,word ptr num2[0]
		sub	ax,bx
		sbc	dx,cx
		mov	word ptr num1[2],dx
		mov	word ptr num1[0],ax
		pop	dx
		pop	ax
		pop	bx
		pop	cx
		endm

@LSUB		macro	high1,low1,high2,low2
		push	cx
		push	bx
		mov	dx,high1
		mov	ax,low1
		mov	cx,high2
		mov	bx,low2
		sub	ax,bx
		sbc	dx,cx
		mov	high1,dx
		mov	low1,ax
		pop	bx
		pop	cx
		endm

@INCL		macro	number
		LOCAL	@1
		inc	word ptr number
		jnz	@1
		inc	word ptr number[2]
@1:		nop
		endm

@DECL		macro	number
		LOCAL	@2,@3
		cmp	number,0
		je	@3
		dec	number
		jnz	@2
@3:		cmp	number[2],0
		je	@2
		dec	number[2]
@2:		nop
		endm

@INC_FP		macro	fpoint,segm
		LOCAL	@11
		push	ax
		inc	word ptr fpoint
		jnz	@11
		mov	ax,segm
		add	word ptr fpoint[2],ax
@11:		pop	ax
		endm

@DEC_FP		macro	fpoint,segm
		LOCAL	@12
		push	ax
		dec	word ptr fpoint
		jnz	@12
		mov	ax,segm
		sub	word ptr fpoint[2],ax
@12:		pop	ax
		endm

@ADD_FP		macro	fpoint,number
		LOCAL	@13
		push	ax
		mov	ax,number
		add	word ptr fpoint,ax
		jnc	@13
		mov	ax,segm
		add	word ptr fpoint[2],ax
@13:		pop	ax
		endm

@CHKTIME	macro	dekata
		push	ax
		mov	ax,dekata
		call	far ptr chktime
		pop	ax
		endm

@ZEROWBUF	macro	_buffer,words,char
		LOCAL	nxtzw
		push	ax
		push	bx
		push	cx
		xor	bx,bx
		mov	cx,words
	IFB	<char>
		xor	ax,ax
	ELSE
		mov	ax,char
	ENDIF
nxtzw:		mov	word ptr _buffer[bx],ax
		inc	bx
		inc	bx
		loop	nxtzw
		pop	cx
		pop	bx
		pop	ax
		endm

@ZEROBBUF	macro	_buffer,bytes,char
		LOCAL	nxtzb
		push	ax
		push	bx
		push	cx
		xor	bx,bx
		mov	cx,bytes
	IFB	<char>
		xor	ax,ax
	ELSE
		mov	al,char
	ENDIF
nxtzb:		mov	byte ptr _buffer[bx],al
		inc	bx
		loop	nxtzb
		pop	cx
		pop	bx
		pop	ax
		endm

@CHK_PL	macro
	LOCAL	chk1,chk2
        mov	ah,0bh
        int	21h
	cmp	al,0ffh
	je	chk1
	clc
	jmp	short chk2
chk1:	mov	ah,08h
	int	21h
	stc
chk2:	nop
	endm

@CPLRNS		macro
		LOCAL	belxi,belxi1
		xor	al,al
		mov	ah,01h
		int	16h
		jz	belxi
		@TAKEKEYB
		@UPPERAX
		stc
		jmp	belxi1
	belxi:  clc
	belxi1:	nop
		endm

@JUMPONKEY	macro	position
		LOCAL	nokeyb
		@CPLRNS
		jnc	nokeyb
		@BELL
		jmp	position
nokeyb:		nop
		endm

@CHKKEYB	macro
		push	ax
		xor	al,al
		mov	ah,01h
        	int	16h
		pop	ax
	       	endm

@TAKEKEYB	macro
		mov	ah,0
		int	16h
		endm

@CLRPLBUF	macro
		push	ax
	        mov     ah,0ch
	        mov     al,00h
	        int     21h
		pop	ax
		endm

@STARTPRG	macro
		push	ds
		mov	ax,0
		push	ax
		call	far ptr start_prg
		endm

@ENDPRG		macro
		call	far ptr end_prg
		endm

@GET_STARTDRV	macro
		call	far ptr get_start_drive
		endm

@GETERROR	macro
		cmp	byte ptr cs:error_code,0
		je	no_err
		mov	al,byte ptr cs:error_code
		mov	byte ptr cs:error_code,0
		stc
		jmp	short is_err
no_err:		clc
is_err:		nop
		endm


@LPRINTCHR	macro	char,lptname,STACKPRN
		LOCAL	leo3
		push	si
		push	ax
		mov	al,BYTE PTR char
		mov	si,lptname
		call	far ptr lprintchr
		jnc	leo3
		mov	sp,STACKPRN
		@POP
		retf
leo3:  		pop	ax
		pop	si
		endm

@LPRINT_START	macro	lptname
		push	si
		mov	si,lptname
		call	far ptr lprintStart
		pop	si
		endm

@LPRINT_STOP	macro
		call	far ptr lprintStop
		endm

@LPRINTSTR	macro	string,lptname,STACKPRN
		LOCAL	leo4
		push	si
		push	bx
		mov	bx,offset string
		mov	si,lptname
		call	far ptr lprintstr
		jnc	leo4
		mov	sp,STACKPRN
		@POP
		retf
leo4: 		pop	bx
		pop	si
		endm

@INITSCREEN	macro
		call	far ptr initscreen
		endm

@CLSWIND	macro	window
		push	bx
                mov     bx,offset @WINDOWS:window
                call	far ptr clswind
		pop	bx
                endm

@DELWIND        macro	buffer
		push	bx
		mov	bx,offset @WINDOWS:buffer
                call	far ptr winddel
		pop	bx
                endm

@DELWINDI       macro	index
		push	ax
		mov	ax,index
                call	far ptr winddel1
		pop	ax
                endm

@SETWIND        macro   window
		push	bx
                mov     bx,offset @WINDOWS:window
                call	far ptr windmake
		pop	bx
                endm

@SETPOPUP       macro   window
		push	bx
                mov     bx,offset @WINDOWS:window
                call	far ptr popmake
		pop	bx
                endm

@SETFORES	macro	num
		push	ax
		mov	ax,num
		call	far ptr setfores
		pop	ax
		endm

@SELECTWIND	macro	buffer
		push	bx
		mov	bx,offset @WINDOWS:buffer
		call	far ptr selectw
		pop	bx
		endm

@TAKEWIND	macro
		call	far ptr takeselect
		endm

@SELECTWI	macro	windindex
		push	ax
		xor	ax,ax
		mov	al,windindex
		call	far ptr selectwi
		pop	ax
		endm

@WPRINT         macro   x,y,string,attr
		push	dx
		push	bx
		push	ax
                mov     dl,x
                mov     dh,y
                mov     bx,offset string
	IFB	<attr>
		mov	ax,0
	ELSE
		mov	ax,attr
	ENDIF
                call	far ptr windprint
		pop	ax
		pop	bx
		pop	dx
                endm

@WNUMBER	macro   x,y,string,attr
		push	dx
		push	bx
		push	ax
                mov     dl,x
                mov     dh,y
                mov     si,offset string
	IFB	<attr>
		mov	ax,0
	ELSE
		mov	ax,attr
	ENDIF
                call	far ptr numbers
		pop	ax
		pop	bx
		pop	dx
                endm

@PRINTTOW       macro   windbuf,x,y,string,attr
		push	dx
		push	bx
		push	ax
		push	si
		call	far ptr takeselect
		mov	si,ax
		mov	bx,offset @WINDOWS:windbuf
		call	far ptr selectw
                mov     dl,x
                mov     dh,y
                mov     bx,offset string
	IFB	<attr>
		mov	ax,0
	ELSE
		mov	ax,attr
	ENDIF
                call	far ptr windprint
		mov	ax,si
		call	far ptr selectwi
		pop	si
		pop	ax
		pop	bx
		pop	dx
                endm

@WPRINTSI       macro   x,y,attr
		push	dx
		push	bx
		push	ax
                mov     dl,x
                mov     dh,y
                mov     bx,si
	IFB	<attr>
		mov	ax,0
	ELSE
		mov	ax,attr
	ENDIF
                call	far ptr windprint
		pop	ax
		pop	bx
		pop	dx
                endm

@WPRINTCH       macro   x,y,char,attr
		push	dx
		push	ax
                mov     dl,x
                mov     dh,y
                mov     al,char
	IFB	<attr>
		mov	ah,0
	ELSE
		mov	ah,attr
	ENDIF
                call	far ptr winddisp
		pop	ax
		pop	dx
                endm

@BOXWIND	macro	Wbuffer,boxtype
		push	bx
		push	ax
		mov	bx,offset @WINDOWS:Wbuffer
	IFB	<boxtype>
		mov	ax,1
	ELSE
		mov	ax,boxtype
	ENDIF
		call	far ptr boxwind
		pop	ax
		pop	bx
		endm

@SETBOXBUF	macro	boxbuffer
		push	bx
		mov	bx,offset boxbuffer
		call	far ptr boxbuf
		pop	bx
		endm

@SETBOX		macro	x,y,x1,y1,atr,boxtype
		push	dx
		push	bx
		push	ax
		push	di
		mov	dl,x
		mov	dh,y
		mov	bl,x1
		mov	bh,y1
		mov	di,boxtype
		mov	ah,atr
		call	far ptr setbox
		pop	di
		pop	ax
		pop	bx
		pop	dx
		endm

@WINPUT		macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,offset buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr windinput
		pop	si
		pop	bx
		pop	dx
                endm

@WINPUTGREEK	macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,offset buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr windinputg
		pop	si
		pop	bx
		pop	dx
                endm

@WINPUFGREEK	macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr windinputg
		pop	si
		pop	bx
		pop	dx
                endm

@WINPUF	macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr windinput
		pop	si
		pop	bx
		pop	dx
                endm

@WCODEINPUT	macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,offset buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr wcodeinput
		pop	si
		pop	bx
		pop	dx
                endm

@WCODEINPUF	macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr wcodeinput
		pop	si
		pop	bx
		pop	dx
                endm

@WINPUTNUM	macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,offset buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr winputnum
		pop	si
		pop	bx
		pop	dx
                endm

@WINPUFNUM	macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr winputnum
		pop	si
		pop	bx
		pop	dx
                endm

@WINPUTNUMBER   macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,offset buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr winputnumbers
		pop	si
		pop	bx
		pop	dx
                endm

@WINPUFNUMBER   macro   x,y,buf,buf1
		push	dx
		push	bx
		push	si
                mov     dl,x
                mov     dh,y
                mov     bx,buf
	IFB	<buf1>
		mov	si,65535
	ELSE
		mov	si,offset buf1
	ENDIF
                call	far ptr winputnumbers
		pop	si
		pop	bx
		pop	dx
                endm

@QPRINT         macro   x,y,char,attr
		push	dx
		push	ax
                mov     dl,x
                mov     dh,y
                mov     al,char
                mov     ah,attr
                call	far ptr qprint
		pop	ax
		pop	dx
                endm

@QTAKE          macro   x,y,char,attr
		push	dx
                mov     dl,x
                mov     dh,y
                call	far ptr qtake
		pop	dx
                endm

@RND	macro
	call	far ptr myrnd
	endm

@STARTRND	macro
	call	far ptr startrnd
	endm

@ENDRND	macro
	call	far ptr endrnd
	endm

@WAIT           macro   time
                push    dx
	IFB	<time>
		mov	dx,500
	ELSE	
                mov     dx,time
	ENDIF
                call	far ptr iwait
                pop     dx
                endm

@WAITL          macro
		LOCAL	@qw
                push    dx
                mov     dx,1000
@qw:            call	far ptr iwait
		jnc	@qw
                pop     dx
                endm

@STRLEN		macro	string
		push	si
		mov	si,offset string
		call	far ptr strlen
		pop	si
		endm

@STRCPY         macro   str1,str2
		push	bx
		push	si
                mov     bx,offset str1
                mov     si,offset str2
                call	far ptr strcpy
		pop	si
		pop	bx
                endm

@STRXOR         macro   str,xorb,len
		push	si
		push	dx
		push	cx
	IFB	<len>
		xor	cx,cx
	ELSE
		mov	cx,len
	ENDIF
                mov     si,offset str
                mov     dx,offset xorb
                call	far ptr strxor
		pop	cx
		pop	dx
		pop	si
                endm

@STRCMP         macro   str1,str2
		push	bx
		push	si
                mov     bx,offset str1
                mov     si,offset str2
                call	far ptr strcmp
		pop	si
		pop	bx
                endm
@STRCMPO        macro   str1,str2
		push	bx
		push	si
                mov     bx,str1
                mov     si,str2
                call	far ptr strcmp
		pop	si
		pop	bx
                endm

@INVERSE        macro   x,y,len
		push	dx
		push	cx
                mov     dl,x
                mov     dh,y
		xor	cx,cx
                mov     cl,len
                call	far ptr winvstr
		pop	cx
		pop	dx
                endm

@BELL		macro
		call	far ptr bell
		endm

@MBELL		macro
		call	far ptr bell	;mbell
		endm

@FILLSCR	macro	char,attr
		push	ax
		mov	al,char
		mov	ah,attr
		call	far ptr fillscr
		pop	ax
		endm

@ASCIIZ		macro	buffer
		push	bx
		mov	bx,offset buffer
		call	far ptr asciiz
		pop	bx
		endm

@ENDCHAR	macro	buffer,len,char
		push	bx
		push	dx
		push	cx
		mov	bx,offset buffer
	IFB	<char>
		mov	dl,0
	ELSE
		mov	dl,char
	ENDIF
		mov	cx,len
		call	far ptr endchar
		pop	cx
		pop	dx
		pop	bx
		endm

@CLRCURS	macro
		call	far ptr clrcurs
		endm

@BIGCURS	macro
		call	far ptr bigcurs
		endm

@CURSW		macro	x,y
		push	dx
		mov	dl,x
		mov	dh,y
		call	far ptr curswait
		pop	dx
		endm

@CHKPLHKTRO	macro	buffer,chkword
		push	bx
		push	ax
		mov	bx,offset buffer
	IFB	<chkword>
		
	ELSE	
		mov	ax,chkword
	ENDIF
		call	far ptr chkplhktro
		pop	ax
		pop	bx
		endm

@CPLR		macro	plhktro
		LOCAL	@ok,@ok1
		push	ax
@ok1:		@WAITL
		@UPPERAX
		cmp	al,plhktro
		je	@ok
		jmp	@ok1
@ok:		pop	ax
		endm

@PLHKTRO	macro
		call	far ptr getplhktro
		endm

@CHKWORDBUF	macro	buffer,chkword
		push	bx
		push	ax
		mov	bx,offset buffer
	IFB	<chkword>
		
	ELSE	
		mov	ax,chkword
	ENDIF
		call	far ptr chkwordbuf
		pop	ax
		pop	bx
		endm

@CHKBYTEBUF	macro	buffer,chkbyte
		push	bx
		push	ax
		mov	bx,offset buffer
	IFB	<chkbyte>
		
	ELSE	
		mov	al,chkbyte
	ENDIF
		call	far ptr chkbytebuf
		pop	ax
		pop	bx
		endm

@ATOI		macro	str
		push	si
		mov	si,offset str
		call	far ptr atoi
		pop	si
		endm

@ATOIF		macro	str
		push	si
		mov	si,str
		call	far ptr atoi
		pop	si
		endm

@ITOAL		macro	str,using,number
		push	ax
		push	cx
		mov	si,offset str
	IFB	<number>
		IFB	<using>
			mov	cx,5
		ELSE
			mov	cx,using
		ENDIF
	ELSE
		mov	ax,number
		IFB	<using>
			mov	cx,5
		ELSE
			mov	cx,using
		ENDIF
	ENDIF
		call	far ptr itoa
		pop	cx
		pop	ax
		endm

@ITOA		macro	str,using,number
		push	ax
		push	cx
		push	si
		mov	si,offset str
	IFB	<number>
		IFB	<using>
			mov	cx,5
		ELSE
			mov	cx,using
		ENDIF
	ELSE
		mov	ax,word ptr number
		IFB	<using>
			mov	cx,5
		ELSE
			mov	cx,using
		ENDIF
	ENDIF
		call	far ptr itoa
		pop	si
		pop	cx
		pop	ax
		endm

@ITOAB		macro	str,using,number
		push	ax
		push	cx
		push	si
		mov	si,offset str
	IFB	<number>
		IFB	<using>
			mov	cx,5
		ELSE
			mov	cx,using
		ENDIF
	ELSE
		xor	ax,ax
		mov	al,byte ptr number
		IFB	<using>
			mov	cx,5
		ELSE
			mov	cx,using
		ENDIF
	ENDIF
		call	far ptr itoa
		pop	si
		pop	cx
		pop	ax
		endm

@USING		macro	buffer,use,char
		push	si
		push	cx
		push	ax
		mov	cx,use
		mov	si,offset buffer

	IFB	<char>
		mov	al,"."
	ELSE
		mov	al,char
	ENDIF

		call	far ptr using
		pop	ax
		pop	cx
		pop	si
		endm

@LTOA		macro	low,high,buffer
		push	ax
		push	dx
		push	bx
		mov	ax,word ptr low
		mov	dx,word ptr high
		mov	bx,offset buffer
		call	far ptr ltoa
		call	far ptr usenum
		pop	bx
		pop	dx
		pop	ax
		endm

@LTOAN		macro	number,buffer
		push	ax
		push	dx
		push	bx
		mov	ax,word ptr number
		mov	dx,word ptr number[2]
		mov	bx,offset buffer
		call	far ptr ltoa
		call	far ptr usenum
		pop	bx
		pop	dx
		pop	ax
		endm

@LTOA10		macro	low,high,buffer
		push	ax
		push	dx
		push	bx
		mov	ax,word ptr low
		mov	dx,word ptr high
		mov	bx,offset buffer
		call	far ptr ltoa
		pop	bx
		pop	dx
		pop	ax
		endm

@ATOL		macro	buffer
		push	bx
		mov	bx,offset buffer
		call	far ptr atol
		pop	bx
		endm

@USENUM		macro	string_num
		push	bx
		mov	bx,offset string_num
		call	far ptr usenum
		pop	bx
		endm

@ISGREEK	macro
		call	far ptr isgreek
		endm

@ISENGLISH	macro
		call	far ptr isenglish
		endm

@TAKECURSWORD	macro	buffer,cursor_position,end_word_buffer
		push	si
		push	bx
		push	dx
	IFB	<end_word_buffer>
		mov	si,65535
	ELSE
		mov	si,offset end_word_buffer
	ENDIF
		mov	bx,offset buffer
		mov	dx,cursor_position
		call	far ptr take_curs_word
		pop	dx
		pop	bx
		pop	si
		endm

@TAKEWORDXY	macro	x,y,buffer,end_word_buffer
		push	si
		push	bx
		push	dx
	IFB	<end_word_buffer>
		mov	si,65535
	ELSE
		mov	si,offset end_word_buffer
	ENDIF
		mov	dl,x
		mov	dh,y
		mov	bx,offset buffer
		call	far ptr take_curs_word
		pop	dx
		pop	bx
		pop	si
		endm

@TOUPPER	macro	buffer
		push	bx
		mov	bx,offset buffer
		call	far ptr toupper
		pop	ax
		endm

@GREEKAX	macro
		call	far ptr greekax
		endm

@UPPERAX	macro
		call	far ptr upperax
		endm


@STRCOPY        macro   str1,str2,len	;str2=str1
		push	bx
		push	si
		push	cx
                mov     bx,offset str1
                mov     si,offset str2
		mov	cx,len
                call	far ptr strcopy
		pop	cx
		pop	si
		pop	bx
                endm

@USERBOX	macro	char
		push	ax
		mov	al,char
		call	far ptr userbox
		pop	ax
		endm

@USERCHAR	macro	char
		push	ax
		mov	al,char
		call	far ptr userchr
		pop	ax
		endm

@USERATR	macro	char
		push	ax
		mov	al,char
		call	far ptr useratr
		pop	ax
		endm

@USERW		macro	char,attr
		push	ax
		mov	ah,char
		mov	al,attr
		call	far ptr userw
		pop	ax
		endm

@INITW		macro
		call	far ptr initw
		endm

@FILLSTR	macro	buffer,char,len
		push	bx
		push	ax
		push	cx
		mov	bx,offset buffer
		mov	al,char
		mov	cx,len
		call	far ptr fillstr
		pop	cx
		pop	ax
		pop	bx
		endm

@STRXCHG        macro   str1,str2,len
		push	bx
		push	si
		push	cx
                mov     bx,offset str1
                mov     si,offset str2
		mov	cx,len
                call	far ptr strxchg
		pop	cx
		pop	si
		pop	bx
                endm

@LOCATE		macro	x,y
		push	dx
		mov	dl,x
		mov	dh,y
		call	far ptr locate
		pop	dx
		endm

@PRINTS		macro	str
		push	bx
		mov	bx,offset str
		call	far ptr prints
		pop	bx
		endm

@PRINTC		macro	char
		push	ax
		mov	al,char
		call	far ptr printc
		pop	ax
		endm

@SOUND		macro	met1,met2
		push	cx
		push	bx
		mov	bx,met1
		mov	cx,met2
		call	far ptr sound
		pop	bx
		pop	cx
		endm
		
@SETDIRWIND     macro   window,filename,arxh0_epomeno1
		push	bx
		push	si
		push	ax
                mov     bx,offset @WINDOWS:window
		mov	si,offset filename
	IFB	<arxh0_epomeno1>
		mov	ax,0
	ELSE
		mov	ax,arxh0_epomeno1
	ENDIF
                call	far ptr winddir
		pop	ax
		pop	si
		pop	bx
                endm

@GETFIRSTFILE   macro   filename,buffer
		push	si
		push	di
		mov	si,offset filename
		mov	di,offset buffer
                call	far ptr getfirstdir
		pop	di
		pop	si
                endm

@GETNEXTFILE    macro	buffer
		push	di
		mov	di,offset buffer
                call	far ptr getnextdir
		pop	di
                endm

@DISKSPACE	macro	drive
		mov	al,drive
		call	far ptr diskspace
		endm

@TESTDRIVE	macro	drive
		push	ax
		mov	al,drive
		call	far ptr test_drive
		pop	ax
		endm

@TESTFILE	macro	fnameoffset
		push	ax
		mov	ax,offset fnameoffset
		call	far ptr test_file
		pop	ax
		endm

@MAKETASK	macro	adress,numtask
		push	bx
		push	cx
		mov	bx,offset adress
		mov	cx,numtask
		call	far ptr make_task
		pop	cx
		pop	bx
		endm

@MULTITASK	macro
		call	far ptr multi
		endm

@ENDTASK	macro	numtask
		LOCAL	tsou
		mov	byte ptr cs:_prg[numtask],0
		mov	byte ptr cs:_prg,1
		mov	word ptr cs:_task,1
	tsou:	jmp	tsou
		endm

@MULTIPAUSE	macro
		mov	word ptr cs:_task,0
		endm

@MULTISTART	macro
		mov	word ptr cs:_task,1
		endm

@MULTISTOP	macro
		LOCAL	mana
		mov	word ptr cs:_task,0
		call	far ptr multistop
		mov	word ptr cs:_task,1
	mana:	jmp	mana
		endm

@TASKPAUSE	macro	numtask
		mov	byte ptr cs:_prg[numtask],0
		endm

@TASKSTART	macro	numtask
		mov	byte ptr cs:_prg[numtask],1
		endm


@LMUL		macro	high1,low1,high2,low2	;->ax:dx
		push	cx
		push	bx
		mov	dx,high1
		mov	ax,low1
		mov	cx,high2
		mov	bx,low2
		call	far ptr longmul
		pop	bx
		pop	cx
		endm
		
@LMULBUF	macro	bufnum1,bufnum2
		push	cx
		push	bx
		push	si
		mov	si,offset bufnum1
		mov	dx,[si+2]	;high
		mov	ax,[si]		;low
		mov	si,offset bufnum2
		mov	cx,[si+2]	;high
		mov	bx,[si]		;low
		call	far ptr longmul
		pop	si
		pop	bx
		pop	cx
		endm

@LMULN		macro	bufnum1,bufnum2
		push	cx
		push	bx
		push	si
		mov	si,offset bufnum1
		mov	dx,[si+2]	;high
		mov	ax,[si]		;low
		mov	si,offset bufnum2
		mov	cx,[si+2]	;high
		mov	bx,[si]		;low
		call	far ptr longmul
		pop	si
		pop	bx
		pop	cx
		endm

