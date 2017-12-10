TITLE Composite Numbers     (Project04.asm)

; Author:Devon James
; Course / Project ID       [CS270_400]          Date:11/6/17
; Description:Write a program to calculate composite numbers. First, the user is instructed to enter the number of
;composites to be displayed, and is prompted to enter an integer in the range [1 .. 400]. The user
;enters a number, n, and the program verifies that 1 < n < 400. If n is out of range, the user is reprompted
;until s/he enters a value in the specified range. The program then calculates and displays
;all of the composite numbers up to and including the nth composite. The results should be displayed
;10 composites per line with at least 3 spaces between the numbers.

INCLUDE Irvine32.inc

UPPER_LIMIT = 400
LOWER_LIMIT = 1
NEW_LINE = 10

.data

header BYTE "Welcome to the Composite Numbers Program by Devon James", 0
instruct1 BYTE "Enter the number of composite numbers you want to see.", 0
instruct2 BYTE "The program prints up to 400 composites.", 0
prompt BYTE "Enter the number of composites to display [1...400]: ", 0
errorPrompt BYTE "Number you entered is out of range. Please try again.", 0
bye BYTE "The results were certified by Devon James. Farewell!", 0
userInput DWORD ?
number DWORD 4
divisor DWORD ?
counter DWORD 0
space BYTE "   ", 0
boolComp DWORD ?

.code
main PROC

	call intro  
	call getData            
	call showComposite     
	call farewell            

	exit	                 ; exit to operating system
main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

intro PROC
	;Display the program header
	mov edx, OFFSET header
	call WriteString
	call CrLf

	;Display the first instructions
	mov edx, OFFSET instruct1
	call WriteString
	call CrLf

	;Display the second instructions
	mov edx, OFFSET instruct2
	call WriteString
	call CrLf

	ret
intro ENDP

;Procedure to get the number of composite numbers to print from the user
;receives: none
;returns: user input value
;preconditions:  none
;registers changed: eax, edx

getData PROC
	call dataValid
	ret                  
getData ENDP

;Sub-procedure to validate the user input value.
;receives: user input value
;returns: none
;preconditions: value must be inputted through getDate procedure
;registers changed: eax, edx

dataValid PROC
	top:
		mov edx, OFFSET prompt
		call WriteString
		call ReadInt 
		cmp eax, LOWER_LIMIT           ;If user input is less than 1, jump to error message
		jb errorLoop
		cmp eax, UPPER_LIMIT           ;If user input is greater than 400, jump to error message
		ja errorLoop
		jmp next
   
	errorLoop:
		mov edx, OFFSET errorPrompt
		call WriteString
		call CrLf
		jmp top

	next:
		mov userInput, eax             ;Stores user input value in variable

	ret
dataValid ENDP

;Procedure to output a list of composie numbers.
;receives: user input value
;returns: none
;preconditions:  value must gone through dataValid procedure 
;registers changed: eax, ebx, ecx, edx

showComposite PROC
	mov ecx, userInput          ;Sets the loop counter to the user input value

	loopStart:
		mov boolComp, 0         ;Change bool value to false(0)
		call isComposite        
		cmp boolComp, 1         
		je print                ;If bool value is true(1), then print the composite number
		inc number              ;Else increment the number to test the next value

	print:
		inc counter            ;Increment for every composite number 
		mov eax, 0
		mov eax, number
		call WriteDec
		mov edx, 0
		mov edx, OFFSET space
		call WriteString
		inc number            ;Increment the number to test next value
		mov divisor, ebx
		mov edx, 0
		mov eax, counter
		mov ebx, NEW_LINE
		div ebx
		mov ebx, divisor
		cmp edx, 0
	    jne skipLine
	    call CrLf

	skipLine:
		loop loopStart
		call CrLf

	ret 
showComposite ENDP

;Sub-procedure to check if the number is a composite.
;receives: number varible with the value of 4
;returns: set the boolComp to 1 for true or 0 for false
;preconditions:  none
;registers changed: eax, ebx, edx

isComposite PROC
	mov eax, number
	mov ebx, 2
	mov edx, 0
	div ebx
	cmp edx, 0              ;If edx is 0, then number is a composite
	je changeBool           ;Jump to set boolComp to 1(true)
	inc ebx                 ;If edx is not 0, increment ebx(divisor)

	Calc:
		mov edx, 0
		mov eax, 0
		cmp ebx, number     
		je noChangeBool     ;If ebx(divisor) and number are the same, then number is not a composite
		mov eax, number     ;Else, divide the number and see if the remainder is 0
		div ebx
		cmp edx, 0
		je changeBool       ;If edx(remainder) is 0, change boolComp to 1(true)
		add ebx, 2          ;Else, increase ebx(divisor) by 2
		jmp Calc

	changeBool:
		mov boolComp, 1     ;Bool value is true
		jmp finish

	noChangeBool:
		mov boolComp, 0     ;Bool value is false

	finish:

	ret
isComposite ENDP

;Procedure to say farewell to the user and exit the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

farewell PROC
	mov edx, OFFSET bye
	call WriteString
	call CrLf
	ret
farewell ENDP


END main
