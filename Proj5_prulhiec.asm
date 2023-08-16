TITLE Project5     (Proj5_prulhiec.asm)

; Author: Calder Prulhiere 
; Last Modified: 8/14/2023
; OSU email address: prulhiec@oregonstate.edu
; Course number/section:400  CS271 Section ???
; Project Number: 5              Due Date:8/13/2023
; Description: Arrays, Addressing, and Stack-Passed Parameters

INCLUDE Irvine32.inc

LO = 15 
HI = 50 

ARRAYSIZE = 200 
array_Min = 10 

.data


intro					BYTE	"Generating, Sorting, and Counting Random integers!                      Programmed by Calder Prulhiere", 0
instr_1					BYTE	"This program generates 200 random integers between 15 and 50, inclusive.", 0
instr_2					BYTE	"It then displays the original list, sorts the list, displays the median value of the list, displays the list sorted in ascending order, and finally displays the number of instances of each generated value, starting with the number of lowest. ", 0

prompt					BYTE	"Enter the total amount of numbers you wish to generate within the range of 10 - 200: ", 0
good_bye				BYTE	"Goodbye", 0


error					BYTE	"Out of Range, try again.", 0
space 					BYTE 	" ", 0 
unsorted				BYTE	"Your unsorted random numbers:", 0
sorted					BYTE	"Your sorted random numbers:", 0
median					BYTE	"The median value of the array: ", 0

half					BYTE	".5", 0

num						DWORD	200
unsortedArray			DWORD	ARRAYSIZE DUP(0)

counts					DWORD HI-LO+1 DUP(0) ; to store the counts of each number
show_counts				BYTE "Counts of each number:", 0

.code
main PROC

	call	introduction
	push	OFFSET num
	call	get_Input
	push 	num
	push 	OFFSET unsortedArray
	call 	fillArray 
	call	unsortedLabel 
	push	num
	push 	OFFSET unsortedArray
	call 	displayArray 
	push	num
	push 	OFFSET unsortedArray
	call	sortArray 
	push	num
	push 	OFFSET unsortedArray
	call	median_Show
	call	sortedLabel 
	push	num
	push 	OFFSET unsortedArray
	call 	displayArray 
	call    countOccurrences
	call    displayCounts
	call	goodbye

	exit	
main ENDP


introduction PROC USES edx
; ---------------------------------------------------------
; Display introduction to program and instructions
; ---------------------------------------------------------

	mov		edx, OFFSET intro
	call	WriteString	
	call	CrLf
	mov		edx, OFFSET instr_1
	call	WriteString 
	call	CrLf
	mov		edx, OFFSET instr_2
	call	WriteString 
	call	CrLf
	call	CrLf

	ret
introduction ENDP



get_Input PROC
; ---------------------------------------------------------
; Get input from user, check input
; ---------------------------------------------------------
	pushad
	mov		ebp, esp

	User_Num:
		mov		edx, OFFSET prompt
		call	WriteString	
		call	ReadInt 

		mov 	ecx, 0 
		call	num_Check

		cmp		ecx, 1
		je		User_Num 
		mov		ebx, [ebp+36] 
		mov		[ebx], eax 
		call	CrLf

		popad
		ret		4

get_Input ENDP


num_Check PROC USES eax edx
; ---------------------------------------------------------
; Procedure to validate user number input
; ---------------------------------------------------------
		cmp		eax, ARRAYSIZE
		jle		check_Low 
		jg		displayError ;if more than max

	check_Low:
		cmp		eax, array_Min
		jl		displayError
		mov		ecx, 0 
		jmp		endValidate

	displayError:
		mov		edx, OFFSET error
		call	WriteString 
		call	CrLf
		mov		ecx, 1 

	endValidate:
		ret

num_Check ENDP


unsortedLabel PROC USES edx
; ---------------------------------------------------------
; Unsorted array title 
; ---------------------------------------------------------
	mov 	edx, OFFSET unsorted
	call 	writestring ; Displays the unsorted array message
	call 	CrLf
	ret
unsortedlabel ENDP 


fillArray PROC
; ---------------------------------------------------------
; Procedure fills an array with random numbers
; ---------------------------------------------------------
	pushad

	mov 	ebp, esp
	mov 	ecx, [ebp+40] 
	mov 	esi, [ebp+36] 

	call Randomize
	
	mov		eax, HI 
	sub 	eax, LO 
	inc 	eax 
	
	repeatFillArray:
		call 	RandomRange
		add 	eax, LO 
		mov 	[esi], eax
		add 	esi, 4 
		loop 	repeatFillArray

	popad
	ret 8
fillArray ENDP


displayArray PROC
; ---------------------------------------------------------
; Display the given array
; ---------------------------------------------------------
	pushad

	mov 	ebp, esp
	mov 	ecx, [ebp+40] 
	mov 	esi, [ebp+36] 
	mov 	ebx, 0 

	displayNextElement:
		
		mov 	eax, [esi]
		call 	writedec 
		add 	esi, 4

		mov		edx, OFFSET space
		call 	writestring 
		
		inc 	ebx
		push 	ebx
		call 	line_Break ;
		loop 	displayNextElement

		call	CrLf
		call	CrLf
	popad
	ret 8 
displayArray ENDP 


line_Break PROC
	pushad
	mov 	ebp, esp
	mov 	eax, [ebp+36] 
	mov 	ecx, 20
	cdq
	div 	ecx ; if divisable by 10 new line

	cmp 	edx, 0
	jne		exitline_Break

	call 	CrLf ; new line

	exitline_Break:
	popad
	ret 4
line_Break ENDP

sortedLabel PROC USES edx
; ---------------------------------------------------------
; Shows the label for the sorted array section 
; ---------------------------------------------------------

	mov 	edx, OFFSET sorted
	call 	writestring 
	call 	CrLf
	ret

sortedLabel ENDP 


median_Show PROC
; ---------------------------------------------------------
; Display median 
; ---------------------------------------------------------
	pushad

	mov 	ebp, esp
	mov 	ecx, [ebp+40] 
	mov 	esi, [ebp+36] 

	mov 	edx, OFFSET median
	call 	writestring 
	
	mov		eax, ecx 
	cdq
	mov		ebx, 2
	div 	ebx
	cmp 	edx, 1
	je 		odd_Array 
							  
	push 	eax 
	push 	esi 
	call 	even_ArrayMedian
	jmp 	Exitmedian_Show

	odd_Array: 
		push 	eax 
		push 	esi 
		call 	odd_ArrayMedian



	Exitmedian_Show:
		

	call CrLf	
	call CrLf	
	popad
	ret 8
median_Show ENDP


even_ArrayMedian PROC
; ---------------------------------------------------------
; Displays the median two num, averages
; ---------------------------------------------------------
	pushad

	mov 	ebp,esp
	mov 	ecx, [ebp+40] 
	mov 	esi, [ebp+36] 
	
	mov 	ebx, ecx 
	dec 	ebx 

	mov 	eax, TYPE esi
	mul 	ecx  
	mov 	ecx, [esi+eax] 

	mov 	eax, TYPE esi
	mul 	ebx 
	mov 	eax, [esi+eax] 

	add 	eax, ecx 
	mov 	ebx, 2
	cdq 
	div 	ebx 
	cmp 	edx, 1
	je 		DisplayAverageWithDecimal 
	call 	writedec 
	jmp 	ExitDisplayMedEvenArray

	DisplayAverageWithDecimal:
		call 	writedec 
		mov 	edx, OFFSET half 
		call 	writestring

	ExitDisplayMedEvenArray:

	popad
	ret 8
even_ArrayMedian ENDP 


odd_ArrayMedian PROC
	pushad

	mov 	ebp,esp
	mov 	ecx, [ebp+40] 
	mov 	esi, [ebp+36] 

	mov 	eax, TYPE esi
	mul 	ecx 
	mov 	eax, [esi+eax] 
	call	writedec 

	popad
	ret 8
odd_ArrayMedian ENDP 


sortArray PROC
; ---------------------------------------------------------
; Sort array in descending order
; ---------------------------------------------------------
	pushad

	mov 	ebp, esp
	mov 	ebx, [ebp+40] 
	mov 	esi, [ebp+36] 

	mov 	edx, 0 
	dec 	ebx 
	sortArrayOuterLoop:
		
		push 	edx 
		push 	ebx 
		push 	esi 
		call 	Swap

		inc 	edx
		cmp 	edx, ebx 
		jl 		sortArrayOuterLoop  						 

	popad
	ret 8 
sortArray ENDP 


Swap PROC
; ---------------------------------------------------------
; Swap the current element in an array with the highest element
; ---------------------------------------------------------

	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esp
	push	esi
	push	edi
	push	ebp
	
	mov 	ebp, esp
	sub 	esp, 16 
	mov 	esi, [ebp+36] 
	mov 	ebx, [ebp+40] 
	inc 	ebx 
	mov 	edx, [ebp+44] 
	mov		DWORD PTR [ebp-16], edx
	mov 	edi, edx 	

	mov		eax, edx 
	LoopStart:
		inc 	eax 

		cmp		eax, ebx
		jge		LoopEnd 

		mov 	DWORD PTR [ebp-4], eax 
		mov 	DWORD PTR [ebp-8], edi 
		mov 	DWORD PTR [ebp-12], eax 

		mov 	eax, [ebp-4]	
		mov 	ecx, 4
		mul 	ecx 
		mov 	DWORD PTR [ebp-4], eax 

		mov 	eax, [ebp-8]	
		mov 	ecx, 4
		mul 	ecx 
		mov 	DWORD PTR [ebp-8], eax 

		mov 	eax, [ebp-4] 
		mov 	ecx, [esi+eax] 
		mov 	eax, [ebp-8]
		cmp		ecx, [esi+eax] 
		jle 	continueLoop 
		mov		eax, [ebp-12] 
		mov 	edi, eax 

		
		continueLoop:
		mov		eax, [ebp-12] 
		cmp		eax, ebx
		jl 		LoopStart 

	LoopEnd:
		
		mov		edx, [ebp-16]
		push	esi 
		push 	edx	
		push 	edi	
		call	swapNumbers

	
	mov		esp, ebp 
	pop 	ebp
	pop	 	edi
	pop 	esi
	pop 	esp
	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax
	ret		12
Swap ENDP



swapNumbers PROC
; ---------------------------------------------------------
;Swaps array values
; ---------------------------------------------------------
	push 	eax
	push 	ebx
	push 	ecx
	push 	esi
	push	ebp
	mov		ebp, esp
	sub		esp, 4 
	mov 	esi, [ebp+32] 

	
	mov 	eax, [ebp+28] 
	mov 	ebx, 4
	mul		ebx
	mov 	ebx, [esi+eax]
	mov 	DWORD PTR [ebp-4], ebx 

	mov 	eax, [ebp+24] 
	mov 	ebx, 4
	mul		ebx 
	mov 	ecx, [esi+eax] 
	mov 	eax, [ebp+28] 
	mul		ebx
	mov 	[esi+eax], ecx 

	mov 	eax, [ebp+24] 
	mov 	ebx, 4
	mul		ebx 
	mov 	ecx, [ebp-4]
	mov 	[esi+eax], ecx 

	mov		esp, ebp 
	pop		ebp
	pop 	esi
	pop 	ecx
	pop		ebx
	pop 	eax
	ret 	12  
swapNumbers ENDP

countOccurrences PROC
	pushad
	mov esi, OFFSET unsortedArray 
	mov ecx, num                  ; Loop counter set to number of elements
countLoop:
	mov eax, [esi]                ; Load the current value from randArray
	sub eax, LO                   ; Subtract LO to get the index in counts
	add counts[eax*4], 1         ; Increment the count for that number
	add esi, 4                    ; Move to the next element in randArray
	loop countLoop                ; Repeat for all numbers
	popad
	ret
countOccurrences ENDP

displayCounts PROC
    pushad
    mov edx, OFFSET show_counts
    call WriteString
    call CrLf

    mov ecx, HI-LO+1 ; Number of elements in counts
    mov esi, OFFSET counts
displayCountsLoop:
    mov eax, esi
    sub eax, OFFSET counts
    shr eax, 2      ; Divide by 4 to get index
    add eax, LO     ; Add LO to get the actual number
    call WriteDec   ; Display the number
    mov edx, OFFSET space
    call WriteString
    mov edx, OFFSET half
    call WriteString
    mov eax, [esi]  ; Load the count for the current number
    call WriteDec   ; Display the count
    call CrLf       ; New line for next number
    add esi, 4      ; Move to next count
    loop displayCountsLoop
    popad
    ret
displayCounts ENDP


goodbye PROC
; Display Exit message
; -------------------------------------------------------------------
		
		mov		edx, OFFSET good_bye
		call	WriteString
		call	CrLf
		ret

goodbye ENDP
END main
