TITLE Loops & Fibonacci Numbers    (Project02.asm)

; Author:Devon James                          Email:jamesde@oregonstate.edu
; Course / Project ID  [CS271_400]            Date: 10/16/17
; Description:This project will deal with the following: getting string input, designing and implementing a counted loop, designing and implementing a post-test loop, keeping track of a previous value, and implementing data validation

INCLUDE Irvine32.inc

	UPPER_LIMIT = 46
	LOWER_LIMIT = 1
	NEW_LINE = 5

.data

	header BYTE "Loops & Fibonacci Numbers", 0
	author  BYTE "Made by Devon James", 0
	prompt_1 BYTE "Hello there, what is your name?", 0
	greet BYTE "Good evening, ", 0
	prompt_2 BYTE "Plese enter the number of Fibonacci terms to be displayed (Must be a positive integer in range of 1-46):", 0
	outRange BYTE "Number you entered is out of range.", 0
	good_bye BYTE "Program is finished. Good Bye, ", 0
	space BYTE "     ", 0
	user_name DWORD ?
	number DWORD ?
	sum DWORD ?
	temp DWORD ?
	temp2 DWORD ?

.code
main PROC

	;introduction
	mov edx, OFFSET header
	call WriteString
	call CrLf
	mov edx, OFFSET author
	call WriteString
	call CrLf

	;get User Name
	mov edx, OFFSET prompt_1
	call WriteString
	mov edx, OFFSET user_name
	mov ecx, 50
	call ReadString
	
	;Display User Name
	mov edx, OFFSET greet
	call WriteString
	mov edx, OFFSET user_name
	call WriteString
	call CrLf
		
    dataValid:                       
	;Get Interger Input
	     mov edx, OFFSET prompt_2           
	     call WriteString
		 call CrLf
	     call ReadInt
		 mov number, eax

	;Data Validation
		 cmp eax, LOWER_LIMIT        
		 jl errorMessage
 		 cmp eax, UPPER_LIMIT
		 jg errorMessage

	;Display Fibonacci
	     mov eax, 1
		 mov ebx, 1
		 mov ecx, number
		 sub ecx, 2        ;Print first two terms and subtract counter by 2
		 mov sum, 0
		 mov temp, 0
		 mov temp2, 0
		 call WriteDec
		 mov edx, OFFSET space
		 call WriteString
		 call WriteDec
		 mov edx, OFFSET space
		 call WriteString

	fibLoop:
		 add eax, ebx
         call WriteDec
		 mov edx, OFFSET space
		 call WriteString
		 mov sum, eax
		 mov eax, ebx
		 mov ebx, sum
		 ;Using Division to determine a new line
		 mov temp, eax
		 mov temp2, ebx
		 mov eax, ecx
		 mov ebx, NEW_LINE
		 cdq
		 div ebx
		 cmp edx, 0
		 jne newLine
		 call CrLf

	newLine:
	    mov eax, temp
		mov ebx, temp2
		loop fibLoop

	jmp Finish

	;Prompts error if number is out of range
	errorMessage:
		 mov edx, OFFSET outRange
		 call WriteString
		 call CrLf
		 jmp dataValid

	;good-bye
	Finish:
	     call CrLf
		 mov edx, OFFSET good_bye
		 call WriteString
		 mov edx, OFFSET user_name
		 call WriteString
		 call CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
