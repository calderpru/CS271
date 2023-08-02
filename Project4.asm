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
colNum			DWORD	1				; column counter; < 10 to print next number 
count			DWORD	1				; counter for number of primes we've printed (<= n)
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

get_input: 

		mov			edx, OFFSET prompt
		call	WriteString					; prompt user to enter number
		call	ReadDec						; read number into n
		mov			n, eax
		cmp			n, 1
		jl		invalid_error				; if n < 1, invalid number
		cmp			n, 200
		jg		invalid_error				; if n > 200, invalid number
		ret


invalid_error:
		mov			edx, OFFSET error			; error message
		call	WriteString
		call	Crlf
		jmp		get_input						; try again
		ret

getUserData ENDP



showPrimes PROC
; Find and display all prime numbers
; display n prime numbers; utilize counting loop and the LOOP instruction to keep track of the number primes displayed
; -------------------------------------------------------------------
		
		mov			eax, 2
		call	Crlf
		call	WriteDec						; print 2
		mov			edx, OFFSET spc
		call	WriteString						; print spaces
		inc		colNum
		cmp		n, 1							; If n = 1, all done, so exit
		je		spExt
		inc		count							; else, increase count & continue		
		mov			esi, OFFSET arr					; point to array
		mov			[esi], eax						; move 2 to first index
		inc		arrsize							; inc size
		mov		ecx, 3

Loop1:

		mov			eax, count
		cmp			eax, n
		jg		spExt						; while count <= n
		pushad
 		call	isPrime							; call isPrime
		popad
		cmp		boolV, TRUE					; if isPrime(ecx)
		jne		nxt							; jump to end of loop

			mov			esi, OFFSET arr
			mov			eax, 4
			mul		arrsize
			add			esi, eax
			mov			[esi], ecx
			inc		arrsize
			mov			eax, [esi]			
			cmp		colNum, 10
			jle		space	
			mov		colNum, 1						; if colNum > 10 reset to 1
			call	Crlf							; start new line

	space:

			mov			eax, ecx
			call	WriteDec						; print prime
			mov			edx, OFFSET spc
			call	WriteString						; print spaces
			inc		colNum							; increment column number
			inc		count							; increment count

	nxt:
		add		ecx, 2							; increment ecx to next odd num
		jmp		Loop1							; loop

spExt:
		call	Crlf
		ret



showPrimes ENDP


isPrime PROC
; receive candidate value, return boolean (0 or 1) indicating whether candidate value is prime (1) or not prime (0)
; -------------------------------------------------------------------

		mov		ebx, 0							; ebx = current array index
		mov		esi, OFFSET arr					; esi = ptr to index in ebx
		mov		check, ecx						; number to find out if prime
		cmp		ecx, 3
		je		numP

	checkLoop:									; divide check by every number in array		
		cmp		ebx, arrsize					; while ebx < arrsize and check % factor != 0
		jge		numP						; reached end of array, no divisors found, so it's prime
		mov		ecx, [esi]						; move value
		mov		edx, 0
		mov		eax, check
		div		ecx
		cmp		edx, 0
		je		numF						; if remainder = 0, not prime
		add		esi, 4							; else continue searching array
		inc		ebx
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
