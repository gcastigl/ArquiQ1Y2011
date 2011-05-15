GLOBAL  _read_msw,_lidt
GLOBAL  _int_08_hand
GLOBAL	_int_09_hand
GLOBAL _int_80_hand
GLOBAL  _mascaraPIC1,_mascaraPIC2,_Cli,_Sti
GLOBAL  _debug
GLOBAL	_outb
GLOBAL	_inb
GLOBAL _reset
GLOBAL _SysCall
EXTERN  int_08
EXTERN	int_09
EXTERN	int_80

SECTION .text


_Cli:
	cli	; limpia flag de interrupciones
	ret

_Sti:

	sti	; habilita interrupciones por flag
	ret

_outb:
	push	ebp
	mov		ebp, esp
	mov		edx, [ss:ebp+8] ;Grab data
	mov		eax, [ss:ebp+12] ;Grab port
	out		dx, ax
	pop		ebp
	retn

_inb:
	push	ebp
	mov		ebp, esp
	mov		dx, [ss:ebp+8] ;Grab port
	in		ax, dx
	mov		esp, ebp
	pop		ebp
	retn

_mascaraPIC1:			; Escribe mascara del PIC 1
	push	ebp
	mov		ebp, esp
	mov		ax, [ss:ebp+8]  ; ax = mascara de 16 bits
	out		21h,al
	pop		ebp
	retn

_mascaraPIC2:			; Escribe mascara del PIC 2
	push	ebp
	mov		ebp, esp
	mov		ax, [ss:ebp+8]  ; ax = mascara de 16 bits
	out		0A1h,al
	pop		ebp
	retn

_read_msw:
	smsw	ax		; Obtiene la Machine Status Word
	retn


_lidt:				; Carga el IDTR
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ebx, [ss: ebp + 6] ; ds:bx = puntero a IDTR
	rol		ebx,16
	lidt	[ds: ebx]          ; carga IDTR
	pop		ebx
	pop		ebp
	retn


_int_08_hand:				; Handler de INT 8 ( Timer tick)
	push	ds
	push	es                      ; Se salvan los registros
	pusha                           ; Carga de DS y ES con el valor del selector
	mov		ax, 10h			; a utilizar.
	mov		ds, ax
	mov		es, ax
	call	int_08
	mov		al,20h			; Envio de EOI generico al PIC
	out		20h,al
	popa
	pop		es
	pop		ds
	iret

_int_09_hand:				; Handler de INT 9 ( Teclado )
	push	ds
	push	es
	pusha
	call	int_09
	mov		al,20h			; Envio de EOI generico al PIC
	out		20h,al
	popa
	pop		es
	pop		ds
	iret

_int_80_hand:				; Handler de INT 80h
	iret		;<----------------iret!
	push ebp
	mov ebp, esp			;StackFrame
	pusha
	
	push ebp				; Puntero al array de argumentos
	push eax				; Numero de Systemcall
		
	call int_80
	mov	al,20h			; Envio de EOI generico al PIC
	out	20h,al
	pop ebp
	pop eax

	popa
	mov esp, ebp
	pop ebp
	iret

_SysCall:
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp + 8] ; Syscall number
	mov ebx, [ebp + 12]; Arg1
	mov ecx, [ebp + 16]; Arg2
	mov edx, [ebp + 20]; Arg3
	;mov esi, [ebp + 24]; Arg4
	;mov edi, [ebp + 28]; Arg5

	int 80h

	popa
	mov esp, ebp
	pop ebp
	ret

_reset:
.wait1:
	in		al, 64h
	test	al, 02h
	jne		.wait1
	mov		al, 0FEh
	out		64h, al
	ret

; Debug para el BOCHS, detiene la ejecución
; Para continuar colocar en el BOCHSDBG: set $eax=0


_debug:
	push    bp
	mov     bp, sp
	push	ax
vuelve:
	mov     ax, 1
	cmp	ax, 0
	jne	vuelve
	pop	ax
	pop     bp
	retn


