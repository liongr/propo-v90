mcode1	segment	public
global	indisk:proc
mcode1	ends

@INDISK	macro	disk
	mov	al,disk
	call	far ptr indisk
	endm
