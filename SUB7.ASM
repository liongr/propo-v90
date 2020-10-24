	page
;
INCLUDE EQUS.H
;
codesg	segment	public
;
extrn	uu1:near,uu2:near,uu3:near,uu4:near,uu5:near,axb4:near,uu8:near
extrn	uu7:near,prina:near,uu31:near,uu9:near
extrn	uu34:near,uu15:near,uu21:near,uu36:near
extrn	uu37:near,uu35:near,uu61:near,uu62:near,uu63:near
;
	assume	cs:codesg,ds:datas1

axbpoke	proc	near
	xor	dx,dx
	mov	dl,axbuesi
	cmp	dl,2
	jb	kladi
	cmp	dl,12
	ja	kladi
	push	dx
	jmp	pkoe
kladi:	mov	axbuesi,11
	xor	dx,dx
	mov	dl,11
	push	dx

;---------------- a ------------------

pkoe:	mov	word ptr [cs:uu2+1],dx
	mov	word ptr [cs:uu4+1],dx
	mov	word ptr [cs:uu5+1],dx
	mov	word ptr [cs:uu7+1],dx
	mov	word ptr [cs:prina+1],dx
	mov	byte ptr [cs:uu31+1],dl
	mov	word ptr [cs:uu36+1],dx
	mov	word ptr [cs:uu35+1],dx
	mov	word ptr [cs:uu61+1],dx
	mov	word ptr [cs:uu63+1],dx
	dec	dx
	mov	word ptr [cs:uu1+1],dx
	inc	dx
	inc	dx
	mov	word ptr [cs:uu8+1],dx
	mov	word ptr [cs:uu3+1],dx
	dec	dx
	mov	ax,dx

	mov	cx,11
	mul	cx
	mov	word ptr [cs:uu9+1],ax

;-------------------- b ----------------

	pop	ax
	mov	dx,13
	sub	dx,ax
	mov	word ptr [cs:axb4+1],dx
	mov	word ptr [cs:uu34+1],dx
	mov	byte ptr [cs:uu37+1],dl
	mov	word ptr [cs:uu62+1],dx
	mov	ax,dx

	mov	cx,10
	mul	cx
	mov	word ptr [cs:uu15+1],ax
	ret
axbpoke	endp

codesg	ends
	end
