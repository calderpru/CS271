TITLE Project 6     (Proj6_prulhiec.asm)



INCLUDE Irvine32.inc


mGetString MACRO inputPrompt, inputString, inputLengthLimit, inputStringLength, outputStringOffset, inputNumber
	; Save registers to stack
	push EAX
	push ECX
	push EDX

	; Display the input prompt
	mDisplayString inputPrompt

	; Write outputStringOffset and inputNumber
	push outputStringOffset
	push inputNumber
	call WriteVal

	; Add a colon and space after the displayed number
	mov AL, ':'
	call WriteChar
	mov AL, ' '
	call WriteChar

	; Read the input string
	mov EDX, inputString
	mov ECX, inputLengthLimit
	call ReadString

	; Store the string length
	mov inputStringLength, EAX

	; Restore the registers from the stack
	pop EDX
	pop ECX
	pop EAX

ENDM


mPrintTotal MACRO outputStringOffset, inputTotalString, inputTotal
	; Display a newline
	call CrLf

	; Display the total string description
	mDisplayString inputTotalString

	; Prepare to write the total value
	push outputStringOffset
	push inputTotal
	call WriteVal

	; Add another newline for clarity
	call CrLf

ENDM

mDisplayString MACRO outputStringOffset
	; Save EDX register value
	push EDX

	; Load the address of the string to display into EDX
	mov EDX, outputStringOffset

	; Call the function to write the string to the console
	call WriteString

	; Restore the original value of EDX
	pop EDX

ENDM


INTEGER_COUNT = 10
MAX_INPUT_LENGTH = 15

.data

programTitle		BYTE	"PROGRAMMING ASSIGNMENT 6: String Primitives and Macros ", 13, 10, 0
programByline		BYTE	"Written by: Calder Prulhiere ", 13, 10, 13, 10, 0
extraCredit1		BYTE	"**EC Number each line of user input and display a running subtotal of the user’s valid numbers.",13,10,13,10,0
instructions		BYTE	"Please provide 10 signed decimal integers.  ", 13, 10
					BYTE	"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw numbers I will display ", 13, 10
					BYTE	"a list of the integers, their sum, and their average value. ",13, 10, 13, 10, 0
inputTotal			BYTE	"running subtotal: ", 0
inputRequest		BYTE	"Please enter a signed number:", 0
inputErrorMsg		BYTE	"ERROR: You did not enter an signed number or your number was too big.", 13, 10, 0
userInput			BYTE	MAX_INPUT_LENGTH DUP(?)
inputLength			DWORD	0
inputErrorFlag		DWORD	0
inputSign			SDWORD	1
inputArray			SDWORD	INTEGER_COUNT DUP(?)
outputNumbers		BYTE	"You entered the following numbers: ", 13, 10, 0
outputSum			BYTE	"The sum of these numbers is: ", 0
outputAverage		BYTE	"The truncated average iss: ", 0
outputString		BYTE	MAX_INPUT_LENGTH DUP(?)

; Goodbye Identifiers
goodbye				BYTE	"Goodbye", 13, 10, 0

.code
main PROC

	; --- Introduction Section ---
	; Display program title, author's name, and extra credit description.
	mDisplayString	offset programTitle
	mDisplayString	offset programByline
	mDisplayString	offset extraCredit1

	; --- Instructions Section ---
	; Show instructions for the user on how to use the program.
	mDisplayString	offset instructions

	; --- Input Section ---
	; Collect INTEGER_COUNT number of valid integers from the user.
	; Re-prompt if the input is invalid.

	; Initializing registers for user input loop.
	mov ECX, INTEGER_COUNT
	mov EDI, offset inputArray

UserInputLoop:

	; Prompt user for signed integer input.
	push offset inputTotal
	push offset inputArray
	push ECX
	push offset outputString
	push offset inputErrorMsg
	push EDI
	push offset inputSign
	push offset inputErrorFlag
	push offset inputLength
	push offset userInput
	push offset inputRequest
	call ReadVal

	; Advance EDI to next slot in the array.
	add EDI, type SDWORD				

	; Repeat until all required integers are obtained.
	loop UserInputLoop

	; --- Output Section ---
	; Print user inputs, calculate & display sum, and show the rounded average.

	push offset outputString
	push offset inputArray
	push offset outputAverage
	push offset outputSum
	push offset outputNumbers
	call printOutput

	; --- Farewell Section ---
	; Display a goodbye message.
	call CrLf
	call CrLf
	mDisplayString	offset goodbye

	; Exit the program.
	Invoke ExitProcess, 0	
main ENDP

; ---------------------------------------------------------------------------------
; Procedure: ReadVal
; Description: Reads an integer from the user, validates it, and converts the string to an SDWORD.
; Preconditions: Expected arguments are correctly initialized and passed.
; Postconditions: Relevant data locations are updated based on the user's input.
; ---------------------------------------------------------------------------------
ReadVal PROC uses EAX EBX ECX EDX ESI EDI
	push EBP
	mov EBP, ESP

GetUserInput:

	; --- Calculate Input Count and Sum ---
	; Determine the current input number and compute the sum of valid integers so far.
	
	; Determine the current input number.
	mov EAX, INTEGER_COUNT
	sub EAX, [EBP + 64]
	inc EAX
	push EAX

	; Initialize for sum calculation.
	mov ECX, EAX
	mov ESI, [EBP + 68]
	xor EBX, EBX  ; Clear EBX for storing the sum.

SumLoop:
	; Compute sum of integers.
	xor EAX, EAX  ; Clear EAX.
	cld
	LODSD
	add EBX, EAX
	loop SumLoop

	pop EAX

	; --- Request and Validate User Input ---
	; Prompt user for an integer and ensure its validity.
	
	; Display current total and prompt user.
	mPrintTotal [EBP + 60], [EBP + 72], EBX
	mGetString [EBP + 32], [EBP + 36], MAX_INPUT_LENGTH, [EBP + 40], [EBP + 60], EAX

	; Validate user's input.
	push [EBP + 48]  ; Sign address.
	push [EBP + 44]  ; Error flag address.
	push [EBP + 40]  ; Input length address.
	push [EBP + 36]  ; Input string address.
	call validateString

	; Check if there was an input error.
	mov EAX, [EBP + 44]
	mov EAX, [EAX]
	test EAX, EAX
	jnz HandleInputError

	; --- Convert Input to SDWORD ---
	; Convert the validated string input to its SDWORD representation.
	
	; Proceed with the conversion.
	push [EBP + 52]
	push [EBP + 48]
	push [EBP + 44]
	push [EBP + 40]
	push [EBP + 36]
	call stringToSDWORD

	; Check for overflow or other conversion errors.
	mov EAX, [EBP + 44]
	mov EAX, [EAX]
	test EAX, EAX
	je HandleConversionError

HandleInputError:
	; Error handling for invalid input.

HandleConversionError:
	; Error handling for conversion issues.

	; Cleanup and exit the procedure.
	mov ESP, EBP
	pop EBP
	ret
ReadVal ENDP


; ---------------------------------------------------------------------------------
; Procedure: validateString
; Description: Validates a string to ensure each character is acceptable.
; Preconditions: Arguments are properly initialized and passed.
; Postconditions: Updated flags based on string validation.
; ---------------------------------------------------------------------------------
validateString PROC uses EAX ECX EDX ESI
	push EBP
	mov EBP, ESP

	; Initialize loop variables.
	mov ESI, [EBP + 24]  ; Input string address.
	mov ECX, [EBP + 28]  ; Input string length.

	; Raise error if input length is too short or too long.
	cmp ECX, 0
	jle InputLengthError
	cmp ECX, 12
	jge InputLengthError

	; Load first character of string.
	xor EAX, EAX  ; Clear EAX.
	cld
	lodsb

	; Validate the first character (potentially a sign).
	push [EBP + 36]  ; Address for input sign.
	push [EBP + 32]  ; Address for error flag.
	push EAX
	call validateFirstCharacter
	
	; Decrement counter and ensure there's more input to check.
	dec ECX
	cmp ECX, 0
	jle EndValidation

ValidateNextCharacter:

	; Load the next character.
	xor EAX, EAX
	cld
	lodsb

	; Check if character is valid.
	push [EBP + 32]  ; Address for error flag.
	push EAX
	call validateCharacter
	
	; If the character is invalid, exit loop.
	xor EAX, EAX
	mov EDX, [EBP + 32]
	cmp EAX, [EDX]
	jne EndValidation

	loop ValidateNextCharacter
	
	jmp EndValidation

InputLengthError:
	; Set the error flag for inappropriate length.
	mov EAX, [EBP + 32]
	mov DWORD ptr [EAX], 1

EndValidation:
	pop EBP
	ret 16
validateString ENDP

; ---------------------------------------------------------------------------------
; Procedure: validateFirstCharacter
; Description: Validates the initial character of a user string.
; Preconditions: Argument addresses are initialized and provided.
; Postconditions: Updates error and sign flags based on validation.
; ---------------------------------------------------------------------------------
validateFirstCharacter PROC uses EAX EDX
    push EBP
    mov EBP, ESP

    ; Get ASCII character.
    mov EAX, [EBP + 16]

    ; Check for '+' or '-' signs.
    cmp EAX, 2Bh  ; Check for '+'.
    je EndValidation
    cmp EAX, 2Dh  ; Check for '-'.
    je FoundMinusSign

    ; Validate if character is numeric.
    cmp EAX, 30h  ; Check for character '0'.
    jb InvalidCharacter
    cmp EAX, 39h  ; Check for character '9'.
    ja InvalidCharacter
    jmp EndValidation

FoundMinusSign:

    ; Update sign flag to -1.
    mov EAX, [EBP + 24]
    mov EDX, -1
    mov [EAX], EDX
    jmp EndValidation

InvalidCharacter:

    ; Set error flag due to invalid character.
    mov EAX, [EBP + 20]
    mov DWORD ptr [EAX], 1

EndValidation:
    pop EBP
    ret 12
validateFirstCharacter ENDP

; ---------------------------------------------------------------------------------
; Procedure: validateCharacter
; Description: Validates a character of a user string for numeric values.
; Preconditions: Argument addresses are initialized and provided.
; Postconditions: Updates the error flag if character is invalid.
; ---------------------------------------------------------------------------------
validateCharacter PROC uses EAX
    push EBP
    mov EBP, ESP

    ; Get ASCII character.
    mov EAX, [EBP + 12]

    ; Validate if character is numeric (between '0' and '9').
    cmp EAX, 30h  ; Check for character '0'.
    jb InvalidCharacter
    cmp EAX, 39h  ; Check for character '9'.
    ja InvalidCharacter
    jmp EndValidation

InvalidCharacter:

    ; Set error flag due to invalid character.
    mov EAX, [EBP + 16]
    mov DWORD ptr [EAX], 1

EndValidation:
    pop EBP
    ret 8
validateCharacter ENDP

; ---------------------------------------------------------------------------------
; Procedure: stringToSDWORD
; Description: Converts a string to a signed double word (SDWORD) value.
; Preconditions: Expected arguments are initialized and provided.
; Postconditions: Resultant SDWORD or error flag set.
; ---------------------------------------------------------------------------------
stringToSDWORD PROC uses EAX EBX ECX EDX ESI EDI
	push			EBP
	mov				EBP, ESP

    ; Initialize registers.
	mov				ESI, [EBP + 32]						
	mov				EDI, [EBP + 48]						
	mov				ECX, [EBP + 36]						
	mov				EBX, 0								
	mov				EDX, 1								

	mov				EAX, ECX
	dec				EAX
	add				ESI, EAX

_addInteger:
	mov				EAX, 0
	std
	lodsb

	cmp				EAX, 2Bh		
	je				_multiplyBySignFlag
	cmp				EAX, 2Dh		
	je				_multiplyBySignFlag
	sub				EAX, 30h

	push			EDX
	imul			EDX									
	add				EBX, EAX

	; error 
	jo				_overflowError

	pop				EDX
	mov				EAX, EDX
	mov				EDX, 10
	imul			EDX
	mov				EDX, EAX

	loop			_addInteger

_multiplyBySignFlag:

	mov				EAX, EBX
	mov				EBX, [EBP + 44]						
	mov				EBX, [EBX]
	imul			EBX								

	mov				EBX, [EBP + 44]	
	mov				sdword ptr [EBX], 1

	mov				[EDI], EAX

	jmp				_stringToSDWORDEnd

_overflowError:

	pop				EDX

	mov				EAX, [EBP + 40]
	mov				DWORD ptr [EAX], 1

_stringToSDWORDEnd:

	pop				EBP
	ret				20
stringToSDWORD ENDP

; ---------------------------------------------------------------------------------
; Procedure: WriteVal
; Description: Converts an SDWORD integer to a string and prints it to the console.
; Preconditions: Expected arguments are initialized and provided.
; Postconditions: SDWORD value is converted and printed.
; ---------------------------------------------------------------------------------
WriteVal PROC uses EAX EBX ECX EDX EDI
    ; Standard function prologue.
    push            EBP
    mov             EBP, ESP

    ; Initialization of essential registers.
    mov             EDX, [EBP + 28]           ; SDWORD value for string transformation.
    mov             EDI, [EBP + 32]           ; Destination for the result string.
    mov             ECX, 10                   ; Loop control for digits handling.
    mov             EBX, 1000000000           ; Maximum divisor to start conversion.

    ; Evaluate the sign of the input number.
    cmp             EDX, 0
    jl              _negativeNumber           ; Branch if input number is negative.
    jmp             _getChar                  ; Continue processing otherwise.

_negativeNumber:
    ; Adjust for negative values.
    neg             EDX
    mov             EAX, '-'
    STOSB                                   ; Append negative sign to the string.

    ; ==== DIGIT EXTRACTION AND STORAGE ====
    ; The process iteratively extracts digits from the input number
    ; and appends them to the resultant string.
_getChar:
    ; Extract the leading digit of the current number.
    mov             EAX, EDX
    cdq
    div             EBX                       ; Division to get quotient and remainder.

    ; Preserve current remainder for subsequent iterations.
    push            EDX

    ; Save digit or bypass if a leading zero.
    cmp             EAX, 0
    jne             _saveChar
    cmp             ECX, 1
    je              _saveChar

    ; ==== HANDLING LEADING ZEROS ====
    ; To prevent unwanted leading zeros, we check prior stored digits before appending new zeros.
    push            EAX
    push            EBX
    mov             EAX, [EBP + 32]

_checkNextChar:
    ; Evaluate prior stored digits.
    mov             BL, BYTE PTR [EAX]
    cmp             BL, 31h
    jge             _nonLeadingZero

    ; Examine next character if it's a leading zero.
    inc             EAX
    cmp             EDI, EAX
    jle             _leadingZero
    jmp             _checkNextChar

_leadingZero:
    ; Restore the state and continue to the next cycle.
    pop             EBX
    pop             EAX
    jmp             _saveCharEnd

_nonLeadingZero:
    ; Continue processing if the current digit isn't a leading zero.
    pop             EBX
    pop             EAX

_saveChar:
    ; Convert current digit to its ASCII representation and store it.
    add             EAX, 30h
    STOSB

_saveCharEnd:
    ; Update the divisor for the next cycle.
    mov             EAX, EBX
    cdq
    mov             EBX, 10
    div             EBX
    mov             EBX, EAX

    ; Restore original number.
    pop             EDX

    loop            _getChar

    ; String termination and output.
    mov             EAX, 0
    STOSB
    mDisplayString  [EBP + 32]

    ; Cleanup: Resetting the output string.
    mov             ECX, MAX_INPUT_LENGTH
    mov             EDI, [EBP + 32]
    mov             EAX, 0
    rep             STOSB

    ; Standard function epilogue.
    pop             EBP
    ret             8
WriteVal ENDP

; ============================ 
; Function: printOutput 
;  
; Summary: Displays each integer from an input array, calculates their sum and rounded average, then presents these values.
; 
; Requirements: Input addresses must be valid and the content should be initialized properly.
; 
; After-Effects: Original state of the registers is preserved post procedure call.
; 
; Input: 
;   [EBP + 28] - Title for numbers list ("You entered these numbers: ").
;   [EBP + 32] - Title for sum display ("The sum is: ").
;   [EBP + 36] - Title for average display ("The average is: ").
;   [EBP + 40] - Address of the integer array to be processed.
;   [EBP + 44] - Storage location for each output string.
; 
; Output: Modifies content at [EBP + 44] with new string data.
; ============================
printOutput PROC uses EAX EBX ECX EDX ESI
    ; Start of the procedure.
    push            EBP
    mov             EBP, ESP

    ; Initialize relevant registers.
    mov             ECX, INTEGER_COUNT
    mov             ESI, [EBP + 40]

    ; Display the numbers' title.
    call            CrLf
    mDisplayString  [EBP + 28]

_loopNumbers:
    ; Retrieve next integer from the array.
    LODSD

    ; Convert integer to string format.
    push            [EBP + 44]
    push            EAX
    call            WriteVal

    ; If not the last number, print separators (comma and space).
    cmp             ECX, 1
    je              _sumAllNumbers
    mov             AL, ','
    call            WriteChar
    mov             AL, ' '
    call            WriteChar
    loop            _loopNumbers

_sumAllNumbers:
    ; Registers reset for sum calculation.
    mov             ECX, INTEGER_COUNT
    mov             ESI, [EBP + 40]
    mov             EBX, 0                  ; Sum accumulator.

_loopSum:
    ; Add up the values from the array.
    LODSD
    add             EBX, EAX
    loop            _loopSum

    ; Display the sum title and actual sum value.
    call            CrLf
    call            CrLf
    mDisplayString  [EBP + 32]
    mov             EAX, EBX
    push            [EBP + 44]
    push            EAX
    call            WriteVal

_getAverage:
    ; Calculate the average of the integers.
    mov             EBX, INTEGER_COUNT
    cdq
    idiv            EBX

    ; Show average title and the average value.
    call            CrLf
    call            CrLf
    mDisplayString  [EBP + 36]
    push            [EBP + 44]
    push            EAX
    call            WriteVal

    ; Procedure termination.
    pop             EBP
    ret             16
printOutput ENDP

END main
