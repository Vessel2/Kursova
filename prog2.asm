.386
.model flat, stdcall
option casemap :none

include masm32\include\windows.inc
include masm32\include\kernel32.inc
include masm32\include\masm32.inc
include masm32\include\user32.inc
include masm32\include\msvcrt.inc
includelib masm32\lib\kernel32.lib
includelib masm32\lib\masm32.lib
includelib masm32\lib\user32.lib
includelib masm32\lib\msvcrt.lib

.DATA
;===User Data================================================================================
	aaaaaaaa_	dd	0
	bbbbbbbb_	dd	0
	cccccccc_	dd	0

	String_0	db	"Input A: ", 0
	String_1	db	"Input B: ", 0
	String_2	db	"Input C: ", 0
	String_3	db	13, 10, 0
	String_4	db	13, 10, 0
	String_5	db	13, 10, 0

;===Addition Data============================================================================
	hConsoleInput	dd	?
	hConsoleOutput	dd	?
	endBuff			db	5 dup (?)
	msg1310			db	13, 10, 0

	CharsReadNum	dd	?
	InputBuf		db	15 dup (?)
	OutMessage		db	"%d", 0
	ResMessage		db	20 dup (?)

.CODE
start:
invoke AllocConsole
invoke GetStdHandle, STD_INPUT_HANDLE
mov hConsoleInput, eax
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov hConsoleOutput, eax
	invoke WriteConsoleA, hConsoleOutput, ADDR String_0, SIZEOF String_0 - 1, 0, 0
	call Input_
	mov aaaaaaaa_, eax
	invoke WriteConsoleA, hConsoleOutput, ADDR String_1, SIZEOF String_1 - 1, 0, 0
	call Input_
	mov bbbbbbbb_, eax
	invoke WriteConsoleA, hConsoleOutput, ADDR String_2, SIZEOF String_2 - 1, 0, 0
	call Input_
	mov cccccccc_, eax
	push aaaaaaaa_
	push bbbbbbbb_
	call Greate_
	pop eax
	cmp eax, 0
	je endIf2
	push aaaaaaaa_
	push cccccccc_
	call Greate_
	pop eax
	cmp eax, 0
	je elseLabel1
	jmp aisbig03_
	jmp endIf1
elseLabel1:
	push cccccccc_
	call Output_
	jmp getoutif_
aisbig03_:
	push aaaaaaaa_
	call Output_
	jmp getoutif_
endIf1:
endIf2:
	push bbbbbbbb_
	push cccccccc_
	call Less_
	pop eax
	cmp eax, 0
	je elseLabel3
	push cccccccc_
	call Output_
	jmp endIf3
elseLabel3:
	push bbbbbbbb_
	call Output_
endIf3:
getoutif_:
	invoke WriteConsoleA, hConsoleOutput, ADDR String_3, SIZEOF String_3 - 1, 0, 0
	push aaaaaaaa_
	push bbbbbbbb_
	call Equal_
	push aaaaaaaa_
	push cccccccc_
	call Equal_
	call And_
	push bbbbbbbb_
	push cccccccc_
	call Equal_
	call And_
	pop eax
	cmp eax, 0
	je elseLabel4
	push dword ptr 1
	call Output_
	jmp endIf4
elseLabel4:
	push dword ptr 0
	call Output_
endIf4:
	invoke WriteConsoleA, hConsoleOutput, ADDR String_4, SIZEOF String_4 - 1, 0, 0
	push aaaaaaaa_
	push dword ptr 0
	call Less_
	push bbbbbbbb_
	push dword ptr 0
	call Less_
	call Or_
	push cccccccc_
	push dword ptr 0
	call Less_
	call Or_
	pop eax
	cmp eax, 0
	je elseLabel5
	push dword ptr -1
	call Output_
	jmp endIf5
elseLabel5:
	push dword ptr 0
	call Output_
endIf5:
	invoke WriteConsoleA, hConsoleOutput, ADDR String_5, SIZEOF String_5 - 1, 0, 0
	push aaaaaaaa_
	push bbbbbbbb_
	push cccccccc_
	call Add_
	call Less_
	call Not_
	pop eax
	cmp eax, 0
	je elseLabel6
	push dword ptr 10
	call Output_
	jmp endIf6
elseLabel6:
	push dword ptr 0
	call Output_
endIf6:
exit_label:
invoke WriteConsoleA, hConsoleOutput, ADDR msg1310, SIZEOF msg1310 - 1, 0, 0
invoke ReadConsoleA, hConsoleInput, ADDR endBuff, 5, 0, 0
invoke ExitProcess, 0


;===Procedure Add============================================================================
Add_ PROC
	mov eax, [esp + 8]
	add eax, [esp + 4]
	mov [esp + 8], eax
	pop ecx
	pop eax
	push ecx
	ret
Add_ ENDP
;============================================================================================


;===Procedure And============================================================================
And_ PROC
	pushf
	pop cx

	mov eax, [esp + 8]
	cmp eax, 0
	jnz and_t1
	jz and_false
and_t1:
	mov eax, [esp + 4]
	cmp eax, 0
	jnz and_true
and_false:
	mov eax, 0
	jmp and_fin
and_true:
	mov eax, 1
and_fin:
	push cx
	popf

	mov [esp + 8], eax
	pop ecx
	pop eax
	push ecx
	ret
And_ ENDP
;============================================================================================


;===Procedure Equal==========================================================================
Equal_ PROC
	pushf
	pop cx

	mov eax, [esp + 8]
	cmp eax, [esp + 4]
	jne equal_false
	mov eax, 1
	jmp equal_fin
equal_false:
	mov eax, 0
equal_fin:
	push cx
	popf

	mov [esp + 8], eax
	pop ecx
	pop eax
	push ecx
	ret
Equal_ ENDP
;============================================================================================


;===Procedure Greate=========================================================================
Greate_ PROC
	pushf
	pop cx

	mov eax, [esp + 8]
	cmp eax, [esp + 4]
	jle greate_false
	mov eax, 1
	jmp greate_fin
greate_false:
	mov eax, 0
greate_fin:
	push cx
	popf

	mov [esp + 8], eax
	pop ecx
	pop eax
	push ecx
	ret
Greate_ ENDP
;============================================================================================


;===Procedure Input==========================================================================
Input_ PROC
	invoke ReadConsoleA, hConsoleInput, ADDR InputBuf, 13, ADDR CharsReadNum, 0
	invoke crt_atoi, ADDR InputBuf
	ret
Input_ ENDP
;============================================================================================


;===Procedure Less===========================================================================
Less_ PROC
	pushf
	pop cx

	mov eax, [esp + 8]
	cmp eax, [esp + 4]
	jge less_false
	mov eax, 1
	jmp less_fin
less_false:
	mov eax, 0
less_fin:
	push cx
	popf

	mov [esp + 8], eax
	pop ecx
	pop eax
	push ecx
	ret
Less_ ENDP
;============================================================================================


;===Procedure Not============================================================================
Not_ PROC
	pushf
	pop cx

	mov eax, [esp + 4]
	cmp eax, 0
	jnz not_false
not_t1:
	mov eax, 1
	jmp not_fin
not_false:
	mov eax, 0
not_fin:
	push cx
	popf

	mov [esp + 4], eax
	ret
Not_ ENDP
;============================================================================================


;===Procedure Or=============================================================================
Or_ PROC
	pushf
	pop cx

	mov eax, [esp + 8]
	cmp eax, 0
	jnz or_true
	jz or_t1
or_t1:
	mov eax, [esp + 4]
	cmp eax, 0
	jnz or_true
or_false:
	mov eax, 0
	jmp or_fin
or_true:
	mov eax, 1
or_fin:
	push cx
	popf

	mov [esp + 8], eax
	pop ecx
	pop eax
	push ecx
	ret
Or_ ENDP
;============================================================================================


;===Procedure Output=========================================================================
Output_ PROC value: dword
	invoke wsprintf, ADDR ResMessage, ADDR OutMessage, value
	invoke WriteConsoleA, hConsoleOutput, ADDR ResMessage, eax, 0, 0
	ret 4
Output_ ENDP
;============================================================================================
end start
