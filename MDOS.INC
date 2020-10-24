

I_RECORDSIZE = 0eh
I_RELATIVERECORD = 21h
I_READ = 0
I_WRITE = 1
I_RW = 2
I_BEG = 0
I_CUR = 1
I_END = 2

@ENDCODE	MACRO	code
	mov	al,code
	mov	ah,4ch
	int	21h
	endm

@CHANGESEGM	macro	segreg,seg
		assume	segreg:seg
		push	ax
		mov	ax,seg
		mov	segreg,ax
		pop	ax
		endm

@KEYBRR	MACRO	delay,rate
	push	bx
	push	ax
	mov	ah,03h
	mov	al,05h
	mov	bh,delay
	mov	bl,rate
	int	16h
	pop	ax
	pop	bx
	endm

XORDATA	MACRO	string,xxor
	IRPC	x,<string>
	db	"&x" XOR xxor
	endm
	endm

@DOSPRINT	macro	char
	push	ax
	push	dx
	mov	dl,char
	mov	ah,02h
	int	21h
	pop	dx
	pop	ax
	endm

@DOSLPRINT	macro	char
	push	dx
	push	ax
	mov	dl,char
	mov	ah,05h
	int	21h
	pop	ax
	pop	dx
	endm
	
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

@PUSHAX	macro
	push	ds
	push	es
	push	bx
	push	dx
	push	cx
	push	si
	push	di
	endm

@POPAX	macro
	pop	di
	pop	si
	pop	cx
	pop	dx
	pop	bx
	pop	es
	pop	ds
	endm

@GET_DATE	macro	;cx=xronos,dh=mhnas,dl=mera,al=mera ebdomadas
	mov	ah,2ah
	int	21h
	endm

@SET_DATE	macro xronos,mhnas,mera
	push	ax
	push	dx
	push	cx
	mov	cx,xronos
	mov	dh,mhnas
	mov	dl,mera
	mov	ah,2bh
	int	21h
	pop	cx
	pop	dx
	pop	ax
	endm

@CHANGE_DIR	macro	DIRNAME
	push	dx
	push	ax
	mov	dx,offset DIRNAME
	mov	ah,3bh
	int	21h
	pop	ax
	pop	dx
	endm

@GET_TIME	macro
	mov	ah,2ch
	int	21h
	endm

@SET_TIME_R	macro
	mov	ah,2dh
	int	21h
	endm
@SET_TIME	macro	ora,lepta,deytera
	push	ax
	push	dx
	push	cx
	mov	ch,ora
	mov	cl,lepta
	mov	dh,deytera
	mov	ah,2dh
	int	21h
	pop	cx
	pop	dx
	pop	ax
	endm

@SETBLOCKOFMEMORY	macro	startparagraph,numberofparagraphs
			push	es
			push	bx
			mov	es,startparagraph
			mov	bx,numberofparagraphs
			mov	ah,4ah
			int	21h
			pop	bx
			pop	es
			endm

@ALLOCATEMEMORY	macro	bytes		;AX
		push	bx
		push	cx
		mov	bx,bytes
		mov	cl,4
		shr	bx,cl
		inc	bx
		mov	ah,48h
		int	21h
		pop	cx
		pop	bx
		endm

@FREEMEMORY	macro	seg_adr
		push	ax
		push	es
		mov	ax,seg_adr
		mov	es,ax
		mov	ah,49h
		int	21h
		pop	es
		pop	ax
		endm

@INITWIND	macro	x,y,x1,y1,attr
		push	ax
		push	cx
		push	dx
		push	bx
		mov	cl,x
		mov	ch,y
		mov	dl,x1
		mov	dh,y1
		mov	bh,attr
		mov	al,0
		mov	ah,06h
		int	10h
		pop	bx
		pop	dx
		pop	cx
		pop	ax
		endm

@FINDFIRSTFILE	macro	filenameoffset,attrib		;DTA
		push	dx
		push	cx
		push	ax
		mov	dx,filenameoffset
		mov	cx,attrib
		mov	ah,4eh
		int	21h
		pop	ax
		pop	cx
		pop	dx
		endm

@FINDNEXTFILE	macro		;DTA
		push	ax
		mov	ah,4fh
		int	21h
		pop	ax
		endm

@RENAME_FILE	macro
	push	ax
	push	es
	push	ds
	pop	es
	mov	ah,56h
	int	21h
	pop	es
	pop	ax
	endm

@DELETE_FILE    macro
        mov     ah,41h
        int     21h
        endm

@SELECT_DRIVE	macro	drive
		push	dx
		push	ax
		mov	dl,drive
		sub	dl,"A"
                mov     ah,0eh
                int     21h
		pop	ax
		pop	dx
                endm

@GETDTA		macro		;ES:BX
		push	ax
		mov	ah,2fh
		int	21h
		pop	ax
		endm

@GETPSP		macro		;BX
		push	ax
		mov	ah,62h
		int	21h
		pop	ax
		endm

@GETINT		macro	intcode	;es:bx
		push	ax
		mov	ah,35h
		mov	al,intcode
		int	21h
		pop	ax
		endm

@DOINT		macro	intcode	;ds:dx
		push	ax
		mov	ah,25h
		mov	al,intcode
		int	21h
		pop	ax
		endm

@GETDISKSPACE	macro	drive		;ax=sector,bx=clusters
		mov	dl,drive	;cx=bytes per sector
		mov	ah,36h		;dx=total clusters
		int	21h
		endm

@CREATEDIR	macro	name
		mov	ah,39h
		mov	dx,offset name
		int	21h
		endm

@CREATEFCB      macro   fcb
                mov     dx,offset fcb
                mov     ah,16h
                int     21h
                endm

@OPENFCB        macro   fcb
                mov     dx,offset fcb
                mov     ah,0fh
                int     21h
                endm

@CLOSEFCB       macro   fcb
                mov     dx,offset fcb
                mov     ah,10h
                int     21h
                endm

@RANDOMREAD     macro   fcb
                mov     dx,offset fcb
                mov     ah,21h
                int     21h
                endm

@RANDOMWRITE    macro   fcb
                mov     dx,offset fcb
                mov     ah,22h
                int     21h
                endm

@SETDTA         macro   buffer
                mov     dx,offset buffer
                mov     ah,1ah
                int     21h
                endm

@CREATEHANDLE   macro   path,attrib
                mov     dx,offset path
                mov     cx,attrib
                mov     ah,3ch
                int     21h
                endm

@OPENHANDLE     macro   path,access
                mov     dx,offset path
                mov     al,access
                mov     ah,3dh
                int     21h
                endm

@CLOSEHANDLE    macro   handle
                mov     bx,handle
                mov     ah,3eh
                int     21h
                endm

@READHANDLE     macro   handle,buffer,bytes
                mov     bx,handle
                mov     dx,offset buffer
                mov     cx,bytes
                mov     ah,3fh
                int     21h
                endm

@WRITEHANDLE    macro   handle,buffer,bytes
                mov     bx,handle
                mov     dx,offset buffer
                mov     cx,bytes
                mov     ah,40h
                int     21h
                endm

@MOVEFP         macro   handle,high,low,method
                mov     bx,handle
                mov     cx,high
                mov     dx,low
                mov     al,method
                mov     ah,42h
                int     21h
                endm


@CREATE_HANDLE  macro   path,attr
		push	dx
		push	cx
                mov     dx,offset path
                mov     cx,attr
                mov     ah,3ch
                int     21h
		pop	cx
		pop	dx
                endm

@OPEN_HANDLE    macro	path,access
		push	dx
                mov     dx,offset path
                mov     al,access
                mov     ah,3dh
                int     21h
		pop	dx
                endm

@CLOSE_HANDLE   macro   handle
		push	ax
		push	bx
                mov     bx,handle
                mov     ah,3eh
                int     21h
		pop	bx
		pop	ax
                endm

@READ_HANDLE    macro   handle,buffer,bytes
		LOCAL	readerr
		push	ax
		push	cx
		push	bx
		push	dx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,offset buffer 
                mov     ah,3fh
                int     21h
		cmp	ax,cx
		je	readerr
		stc
readerr:	pop	dx
		pop	bx
		pop	cx
		pop	ax
                endm

@WRITE_HANDLE   macro   handle,buffer,bytes
		LOCAL	writerr
		push	cx
		push	ax
		push	dx
		push	bx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,offset buffer
                mov     ah,40h
                int     21h
		cmp	ax,cx
		je	writerr
		stc
writerr:	pop	bx
		pop	dx
		pop	ax
		pop	cx
                endm

@READ_MEM	macro   handle,buffer,bytes
		LOCAL	mreaderr
		push	ax
		push	cx
		push	bx
		push	dx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,buffer
                mov     ah,3fh
                int     21h
		cmp	ax,cx
		je	mreaderr
		stc
mreaderr:	pop	dx
		pop	bx
		pop	cx
		pop	ax
                endm

@WRITE_MEM	macro   handle,buffer,bytes
		LOCAL	mwriterr
		push	cx
		push	ax
		push	dx
		push	bx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,buffer
                mov     ah,40h
                int     21h
		cmp	ax,cx
		je	mwriterr
		stc
mwriterr:	pop	bx
		pop	dx
		pop	ax
		pop	cx
                endm


@READ_MEM_AX	macro   handle,buffer,bytes
		LOCAL	mreaderrax
		push	cx
		push	bx
		push	dx
                mov     cx,bytes
                mov     bx,handle
                mov     dx,buffer
                mov     ah,3fh
                int     21h
		cmp	ax,cx
		je	mreaderrax
		stc
mreaderrax:	pop	dx
		pop	bx
		pop	cx
                endm

@READS  macro   STARTSEC,NUMBSEC,TRACK,HEAD,DRIVE,BUFFER,PROSP
	LOCAL	r1,r2
        push    es
        push    ds
        pop     es
IFB	<prosp>
	nop
ELSE
	mov	byte ptr prosp,3
ENDIF
r2:     mov     al,NUMBSEC
        mov     cl,STARTSEC
        mov     ch,TRACK
        mov     dh,HEAD
        mov     dl,DRIVE
        mov     bx,offset BUFFER
        mov     ah,02h
        int     13h
IFB	<prosp>
	nop
ELSE
	jnc	r1
	@RESET	DRIVE
	dec	byte ptr prosp
	jz	r1
	jmp	r2
ENDIF
r1:     pop     es
        endm

@WRITES  macro   STARTSEC,NUMBSEC,TRACK,HEAD,DRIVE,BUFFER,PROSP
	LOCAL	r1,r2
        push    es
        push    ds
        pop     es
IFB	<prosp>
	nop
ELSE
	mov	byte ptr prosp,3
ENDIF
r2:     mov     al,NUMBSEC
        mov     cl,STARTSEC
        mov     ch,TRACK
        mov     dh,HEAD
        mov     dl,DRIVE
        mov     bx,offset BUFFER
        mov     ah,03h
        int     13h
IFB	<prosp>
	nop
ELSE
	jnc	r1
	@RESET	DRIVE
	dec	byte ptr prosp
	jz	r1
	jmp	r2
ENDIF
r1:     pop     es
        endm


@VERIFY macro   STARTSEC,NUMBSEC,TRACK,HEAD,DRIVE,BUFFER,PROSP
	LOCAL	r1,r2
        push    es
        push    ds
        pop     es
IFB	<prosp>
	nop
ELSE
	mov	byte ptr prosp,3
ENDIF
r2:     mov     al,NUMBSEC
        mov     cl,STARTSEC
        mov     ch,TRACK
        mov     dh,HEAD
        mov     dl,DRIVE
        mov     bx,offset BUFFER
        mov     ah,04h
        int     13h
IFB	<prosp>
	nop
ELSE
	jnc	r1
	@RESET	DRIVE
	dec	byte ptr prosp
	jz	r1
	jmp	r2
ENDIF
r1:     pop     es
        endm

@RESET  macro   DRIVE
        LOCAL   gro
gro:    mov     dl,DRIVE
        mov     ah,0
        int     13h
        jc      gro
        endm
	
@RESETHRD	macro
	mov	ah,13
	int	13h
	endm

@READDS  macro   DISK,STARTSEC,NUMBSEC,BUFFER
	push	ax
	push	dx
	push	cx
	push	bx
        mov     al,DISK
        mov     dx,STARTSEC
        mov     cx,NUMBSEC
        mov     bx,offset BUFFER
        int     25h
	pop	ax
	pop	bx
	pop	cx
	pop	dx
	pop	ax
        endm

@WRITEDS  macro   DISK,STARTSEC,NUMBSEC,BUFFER
	push	ax
	push	dx
	push	cx
	push	bx
        mov     al,DISK
        mov     dx,STARTSEC
        mov     cx,NUMBSEC
        mov     bx,offset BUFFER
        int     26h
	pop	ax
	pop	bx
	pop	cx
	pop	dx
	pop	ax
        endm

@RESETDISKBUF	macro
	push	ax
	mov	ah,13
	int	21h
	pop	ax
	endm
