TITLE Program Template     (Proj3_prulhiec.asm)

; Author: Calder Prulhiere
; Last Modified: 7/23/2023
; OSU email address: prulhiec@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 3                Due Date: 7/23/2023
; Description: Data Validation, Looping, and Constants

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

intro_1		BYTE	"You again.... ugh this is Integer Accumulator by Calder Prulhiere", 0
intro_2		BYTE	"We will be accumulating user-input negative integers between the specified bounds, then displaying statistics of the input values including minimum, maximum, and average values values, total sum, and total number of valid inputs.", 0
prompt_1	BYTE	"Alright I dont have all day hurry up and enter your name?", 0	
greeting	BYTE	"*computer sarcasm* Welcome ", 0	
inst_1		BYTE	"Please enter numbers in [-200, -100] or [-50, -1].", 0	
inst_2		BYTE	"Enter a non-negative number when you are finished to see results.", 0	
prompt_2	BYTE	"Enter a number: ", 0	
good_bye	BYTE	", I've done enough for you I think its time you leave", 0
space		BYTE	"------------", 0
inv_rng		BYTE	"Invalid Input, outside specified range", 0
invalid		BYTE	"No valid numbers have been entered.", 0
valid_info	BYTE	"Valid Numbers Entered: ", 0
min_		BYTE	"Minimum Value: ", 0
max_		BYTE	"Maximum Value: ", 0
sum			BYTE	"Sum: ", 0
round_avg	BYTE	"Rounded average: ", 0

username	BYTE	33 DUP(0)	;entered user name
num			SDWORD	?			;entered number
limit1_H	SDWORD	-100		;input range highest
limit1_L	SDWORD	-200		;input range lowest
input_num	DWORD	1			;valid inputs
num_valid	DWORD	0			;number of valid inputs
sum_value	SDWORD	0			;sum of valid inputs
average		SDWORD	0			;average of valid inputs
remainder	DWORD	0			;records remainder
num_limit	DWORD	10			;times 10
half		DWORD	2			; /2 rounding
min_value	SDWORD	7FFFFFFFh	;min valid input
max_value	SDWORD	-7FFFFFFFh	;max valid input



.code
main PROC

; Program Title and Programmer name
		mov			edx, OFFSET intro_1
		call	WriteString
		call	CrLf

; line break
		mov			edx, OFFSET space
		call	WriteString
		call	CrLf

; Display instructions
		mov			edx, OFFSET intro_2
		call	WriteString
		call	CrLf

; line break
		mov			edx, OFFSET space
		call	WriteString
		call	CrLf
		
; Prompt user to enter name
		mov			edx, OFFSET prompt_1
		call	WriteString
		mov		edx, OFFSET username
		mov		ecx, 32
		call	ReadString

; line break
		mov			edx, OFFSET space
		call	WriteString
		call	CrLf

; Welcome user by name
		mov			edx, OFFSET greeting
		call	WriteString
		mov			edx, OFFSET username
		call	Writestring
		call	CrLf
		call	CrLf


start:
		mov			edx, OFFSET inst_1
		call	WriteString
		call	CrLf
		mov			edx, OFFSET inst_2
		call	WriteString
		call	CrLf
		jmp				body


body: 
		mov			edx, OFFSET prompt_2	;prompt for num input
		call	WriteString
		call	ReadInt
		mov			num, eax
		call	CrLf
		mov			ebx, limit1_H
		cmp			ebx, eax				;limit high is larger than input check 					
		jge		above_Low					;Limit Low is smaller than input check
		mov			eax, num_valid
		cmp			eax, 0
		jg		check
		mov			edx, OFFSET invalid
		call	WriteString
		call	CrLf
		jmp				goodbye

above_Low:									;input (num) is below limit1_H so check if its above limit1_L
		mov			ebx, limit1_L		
		mov			eax,num
		cmp			ebx, eax
		jle		passed
		mov			edx, OFFSET inv_rng			
		call	WriteString
		call	CrLf
		jmp			start


passed:										; Increment valid input counters and sum of valid inputs
		inc		input_num					
		inc		num_valid					
		add		sum_value, eax
		call	check_min					; check if new minimum
		call	check_max					; check if new maximum
		jmp			body 


check:										; Print the number of valid inputs

		mov			edx, OFFSET valid_info				
		call	WriteString
		mov			eax, num_valid
		call	WriteDec
		call	CrLf
		jmp			calculate	



calculate:									; Print the number of valid inputs
		mov			eax, sum_value
		mov			ebx, num_valid
		cdq
		idiv	ebx							
		mov			average, eax
		mov			remainder, edx			; Calculate the remainder for rounding	
		neg			remainder
		mov			eax, remainder			;remainder*10
		mul			num_limit
		mov			remainder, eax				
		mov			eax, num_valid				
		mul			num_limit
		mov			num_limit, eax				
		div			half
		cmp			remainder, eax
		jge			round					; Round down if the remainder is less than half	
		call	CrLf
		call	CrLf
		jmp			results


round:
	dec		average	


;Display Results
results:
		mov			edx, OFFSET sum
		call	WriteString
		mov			eax, sum_value
		call	WriteInt
		call	CrLf
		mov			edx, OFFSET min_
		call	WriteString
		mov			eax, min_value
		call	WriteInt
		call	CrLf
		mov			edx, OFFSET max_
		call	WriteString
		mov			eax, max_value
		call	WriteInt
		call	CrLf
		mov			edx, OFFSET round_avg
		call	WriteString
		mov		eax, average
		call	WriteInt
		call	CrLf

goodbye:
		mov			edx, OFFSET username
		call	WriteString
		mov			edx, OFFSET good_bye
		call	WriteString
		call	CrLf




	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

check_min PROC
	mov		eax, num
	cmp		eax, min_value
	jge		done_check_min	; if num is greater or equal, done
	mov		min_value, eax	; otherwise, update min_value
done_check_min:
	ret
check_min ENDP

; Check maximum value procedure
check_max PROC
	mov		eax, num
	cmp		eax, max_value
	jle		done_check_max	; if num is less or equal, done
	mov		max_value, eax	; otherwise, update max_value
done_check_max:
	ret
check_max ENDP

END main

