TITLE Project1    (Proj1_prulhiec.asm)

; Author: 	Calder Prulhiere
; Last Modified:	July 17 2023
; Course number/section:   CS271 Section 400
; Description: This file uses basic logic and arithmetic, presents text output, takes input and returns a calculation.

INCLUDE Irvine32.inc

.data
Greeting		BYTE	"Calder Prulhiere, Basic Logic and Arithmeic", 0
instruction		BYTE	"Enter three numbers strictly in decending order: ", 0
prompt1		    BYTE	"Please enter the first number: ",0
valueA			DWORD	?	
prompt2			BYTE	"Please enter Second Number:", 0
valueB			DWORD	?
prompt3			BYTE	"Please enter Third Number:", 0
valueC			DWORD	?
sumAB			DWORD	?
sumAC			DWORD	?
sumBC			DWORD	?
difAB			DWORD	?
difAC			DWORD	?
difBC			DWORD	?
sumABC			DWORD	?

equal			BYTE	" = ", 0
plus			BYTE	" + ", 0
minus			BYTE	" - ", 0

goodbye			BYTE	"goodbye"



.code
main PROC

; Diplay name and program name
	mov		edx, OFFSET Greeting
	call	WriteString
	call	CrLf

; Display instructions
	mov		edx, OFFSET instruction
	call	WriteString
	call	CrLf

; Recieve first number input from user
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov		valueA, eax
	call	CrLf

; Recieve second number input from user
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		valueB, eax
	call	CrLf

; Recieve Third number input from user
	mov		edx, OFFSET prompt3
	call	WriteString
	call	ReadInt
	mov		valueC, eax
	call	CrLf

; Calculate A+B
	mov		eax, valueA
	mov		ebx, valueB
	add		eax, ebx
	mov		sumAB, eax

; Calculate A-B
	mov		eax, valueA
	mov		ebx, valueB
	sub		eax, ebx
	mov		difAB, eax

; Calculate A+C
	mov		eax, valueA
	mov		ebx, valueC
	add		eax, ebx
	mov		sumAC, eax

; Calculate A-C
	mov		eax, valueA
	mov		ebx, valueC
	sub		eax, ebx
	mov		difAC, eax

; Calculate B+C
	mov		eax, valueB
	mov		ebx, valueC
	add		eax, ebx
	mov		sumBC, eax

; Calculate B-C
	mov		eax, valueB
	mov		ebx, valueC
	sub		eax, ebx
	mov		difBC, eax

; Calculate A+B+C
	mov		eax, sumAB
	mov		ebx, valueC
	add		eax, ebx
	mov		sumABC, eax

;Print A+B
	mov		eax, valueA
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, valueB
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sumAB
	call	WriteDec
	call	CrLf

;Print A-B
	mov		eax, valueA
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, valueB
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, difAB
	call	WriteDec
	call	CrLf

;Print A+C
	mov		eax, valueA
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, valueC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sumAC
	call	WriteDec
	call	CrLf

;Print A-C
	mov		eax, valueA
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, valueC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, difAC
	call	WriteDec
	call	CrLf

;Print B+C
	mov		eax, valueB
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, valueC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sumBC
	call	WriteDec
	call	CrLf

;Print B-C
	mov		eax, valueB
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, valueC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, difBC
	call	WriteDec
	call	CrLf

;Print A+B+C
	mov		eax, valueA
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, valueB
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, valueC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sumABC
	call	WriteDec
	call	CrLf


; Diplay GOODBYE
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP


END main
