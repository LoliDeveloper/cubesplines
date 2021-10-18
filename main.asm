    global _main
    extern  _GetStdHandle@4
    extern  _WriteFile@20
    extern  _ExitProcess@4
    extern _HeapCreate
    extern _HeapAlloc

    section .bss

hStdOut: 	resd 	1
heapPtr:	resd 	1
convertDDBuffer: resb 10

    section .text


_main:

    push    -11
    call    _GetStdHandle@4 ; hStdOut = GetstdHandle( STD_OUTPUT_HANDLE)
    mov     [hStdOut], eax  

	; heap create
	; HeapCreate([in] DWORD  flOptions,  [in] SIZE_T dwInitialSize,  [in] SIZE_T dwMaximumSize);
	push 	dword 	0
	push 	dword 	0
	push 	dword 	0
	call 	_HeapCreate
	cmp 	eax, 0
	je 		error
	mov 	[heapPtr], eax

	;DECLSPEC_ALLOCATOR LPVOID HeapAlloc([in] HANDLE hHeap,  [in] DWORD  dwFlags,  [in] SIZE_T dwBytes);
	push 	dword [N]
	push 	dword 0x00000008
	push 	dword [heapPtr]
	call 	_HeapAlloc
	cmp 	eax, 0
	je 		error
	mov 	ebx, eax
	mov 	ecx, 2					; i = 2
circleEratosphen:
	mov 	eax, ecx 				; j = i + i
	add 	eax, ecx
iter:
	cmp 	eax, [N]
	jge		iter_end 				; while(j < N)
	inc 	dword [ebx + eax] 		; ++(mem[j])
	add 	eax, ecx
	jmp 	iter
iter_end:
	inc 	ecx 					; ++i
	cmp 	dword ecx, [N] 			
    jl 		circleEratosphen 		; while(i < N)

    ; WriteFile( hstdOut, &message, length(message), &bytes, 0);
    push 	0
    push 	0
    push 	(success_message_end - success_message)
    push 	success_message 
    push 	dword [hStdOut]
    call 	_WriteFile@20 			;Eratosphen successfully


    
    ;main code
    ;ebx contains ptr to array
    xor     ecx, ecx ;i = 0
print_loop:
    cmp     ecx, [N]
    jge     end

    mov     eax, [ebx + ecx]
    cmp     eax, 0
    jne print_loop_continue
    ;eax == 0
    call    convertECXToStr ;return eax with pointer to converted string
    mov     edx, eax
    add     edx, 10
    sub     edx, convertDDBuffer

    push    0
    push    0
    push    edx
    push    eax
    push    dword [hStdOut]
    call    _WriteFile@20

print_loop_continue:
    inc     ecx
    jmp     print_loop

skip:
	; WriteFile( hstdOut, message, length(message), &bytes, 0);
    push 	0
    push 	0
    push 	(nomemory_message_end - nomemory_message)
    push 	nomemory_message
    push 	dword [hStdOut]
    call 	_WriteFile@20
    jmp 	end

error:
; WriteFile( hstdOut, message, length(message), &bytes, 0);
    push 	0
    push 	0
    push 	(error_message_end - error_message)
    push 	error_message 
    push 	dword [hStdOut]
    call 	_WriteFile@20 ;Fill successfully
    jmp 	end

end:
    ; ExitProcess(0)
    push    0
    call    _ExitProcess@4

    ; never here
    hlt

    ;--------------------------------CONST---------------------------
nomemory_message:
	db		'No memory',10
nomemory_message_end:

error_message:
	db		'Error happend',10
error_message_end:

success_message:
	db  	'Eratosphen successfully',10
success_message_end:

N: 	dd		 0xF ;
;----------------------------------------------------------------

;----------------------------------PROCS-------------------------
convertECXToStr:
    
convertECXToStr_end:
;----------------------------------------------------------------