    global _main
    extern  _GetStdHandle@4
    extern  _WriteFile@20
    extern  _ExitProcess@4
    extern _malloc
    extern _HeapCreate
    extern _HeapAlloc

    section .bss

hStdOut: 	resd 	1
memptr:		resd 	1
heapPtr:	resd 	1

    section .text
;--------------------------------CONST---------------------------
nomemory_message:
	db		'No memory',10
nomemory_message_end:

error_message:
	db		'Error happend',10
error_message_end:

success_message:
	db  	'Fill memory successfully',10
success_message_end:

N: 	dd		 0x2FFFFFFF
;----------------------------------------------------------------

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
	
    ; DWORD  	bytes;
    mov     ebp, esp
    sub     esp, 4
  

	push 	dword [N]
	call 	_malloc ;malloc(0x3FFFFFFF)

	cmp 	eax, 0
	je 		skip
	mov 	ecx, 0
circleFill:
	mov 	byte [eax], 0
	inc 	eax
	inc 	ecx
	cmp 	ecx, [N]
    jnge 	circleFill

    ; WriteFile( hstdOut, message, length(message), &bytes, 0);
    push 	0
    push 	0
    push 	(success_message_end - success_message)
    push 	success_message 
    push 	dword [hStdOut]
    call 	_WriteFile@20 ;Fill successfully

    xor 	ecx, ecx
    ;main code


    jmp 	end
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
