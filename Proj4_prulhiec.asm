TITLE Project4     (Proj4_prulhiec.asm)

; Author: Calder Prulhiere 
; Last Modified: 8/1/2023
; OSU email address: prulhiec@oregonstate.edu
; Course number/section:400  CS271 Section ???
; Project Number: 4                Due Date:
; Description: Nested Loops and Procedures

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

intro			BYTE	"Program: Prime Number Calculater Programmer: Calder Prulhiere", 0
instru			BYTE	"Enter the number of prime numbers you would like to see.. Range [1-200]", 0
prompt			BYTE	"Enter the number of Primes: ", 0
good_bye		BYTE	"Goodbye", 0

n				DWORD	?
error			BYTE	"Error: Value entered is outside range", 0

boolV			BYTE	0
spc				BYTE	"   ",0
colNum			DWORD	1				
count			DWORD	1				
check			DWORD	?
arr				DWORD   200 DUP(?)
arrsize			DWORD	0

.code

main PROC
	
		call	introduction 

		call	getUserData

		call	showPrimes

		call	goodbye 



	Invoke ExitProcess,0	; exit to operating system
main ENDP

introduction proc
; Display Program title, Programmer Name, Instructions
; -------------------------------------------------------------------
		
		mov			edx, OFFSET intro
		call	WriteString			
		call	Crlf
		call	Crlf
		mov			edx, OFFSET instru
		call	WriteString			
		call	Crlf
		call	Crlf
		ret

introduction ENDP





getUserData proc
; Prompt user to enter value, check value, error
; -------------------------------------------------------------------

;check if within range
get_input: 

		mov			edx, OFFSET prompt
		call	WriteString					
		call	ReadDec						
		mov			n, eax
		cmp			n, 1
		jl		invalid_error				
		cmp			n, 200
		jg		invalid_error				
		ret

; error message, resart
invalid_error:
		mov			edx, OFFSET error			
		call	WriteString
		call	Crlf
		jmp		get_input						
		ret

getUserData ENDP



showPrimes PROC
; Find and display all prime numbers
; display n prime numbers; utilize counting loop and the LOOP instruction to keep track of the number primes displayed
; -------------------------------------------------------------------
		
		; display num and spaces, exit, move
		mov			eax, 2
		call	Crlf
		call	WriteDec						
		mov			edx, OFFSET spc
		call	WriteString						 
		inc		colNum
		cmp		n, 1							
		je		spExt
		inc		count								
		mov			esi, OFFSET arr					
		mov			[esi], eax						
		inc		arrsize							
		mov		ecx, 3

Loop1:
		;while conditional check, call isPrime
		mov			eax, count
		cmp			eax, n
		jg		spExt						
		pushad
 		call	isPrime							
		popad
		cmp		boolV, TRUE					
		jne		nxt							

			mov			esi, OFFSET arr
			mov			eax, 4
			mul		arrsize
			add			esi, eax
			mov			[esi], ecx
			inc		arrsize
			mov			eax, [esi]			
			cmp		colNum, 10
			jle		space	
			mov		colNum, 1						
			call	Crlf							

	space:

			mov			eax, ecx
			call	WriteDec						
			mov			edx, OFFSET spc
			call	WriteString						
			inc		colNum							
			inc		count							

	nxt:
		add			ecx, 2							
		jmp		Loop1							

spExt:
		call	Crlf
		ret



showPrimes ENDP


isPrime PROC
; receive candidate value, return boolean (0 or 1) indicating whether candidate value is prime (1) or not prime (0)
; -------------------------------------------------------------------

		mov			ebx, 0							
		mov			esi, OFFSET arr					
		mov		check, ecx						
		cmp			ecx, 3
		je		numP

	checkLoop:									
		cmp			ebx, arrsize					
		jge		numP						
		mov			ecx, [esi]						
		mov			edx, 0
		mov			eax, check
		div			ecx
		cmp			edx, 0
		je		numF						
		add				esi, 4							
		inc			ebx
		jmp		numP

numP:	
	mov booLV, TRUE
	ret

numF:
	mov boolV, FALSE
	ret

isPrime ENDP




goodbye PROC
; Display Exit message
; -------------------------------------------------------------------
		
		mov			edx, OFFSET good_bye
		call	WriteString
		call	CrLf
		ret

goodbye ENDP

END main
