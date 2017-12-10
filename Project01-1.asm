TITLE Simple Math     (Project01.asm)

; Author: Devon James         Email:jamesde@oregonstate.edu
; Course / Project ID      CS270_400/ Project 1       Date: 10/9/2017
; Description: This MASM program will introduce the programmer, displays the intructions for the user, prompts the user to input two numbers, calculate the sum, difference, product, qoutient, and remainder of the numbers, and report the results.

INCLUDE Irvine32.inc



.data
	intro  BYTE "Learning the basics of math with a simple program by Devon James! ", 0
	instruct  BYTE "Enter two numbers and the computer will calculate the sum, difference, product, quotient, and remainder for you! ", 0
	good_bye BYTE "Congrats! You made your first program. Have a nice day! ", 0
	prompt_1 BYTE "Enter the first number: ", 0
	prompt_2 BYTE "Enter the second number: ", 0
	total BYTE "The sum is ", 0
	subtract BYTE "The difference is ", 0
	multiply BYTE "The product is ", 0
	division BYTE "The quotient is ", 0
	leftover BYTE "The remainder is ", 0
	input_1 DWORD ?  
	input_2 DWORD ?
	sum   DWORD ?
	difference  DWORD ?
	product DWORD ?
	quotient DWORD ?
	remainder DWORD ?

.code
main PROC

	;Output introduction
	mov edx, OFFSET intro
	call WriteString
	call CrLf

	;Output instructions for user
	mov edx, OFFSET instruct
    call WriteString
	call CrLf

	;Prompt user to input first integer
	mov edx, OFFSET prompt_1
	call WriteString
	call ReadInt
	mov input_1, eax

	;Prompt user to input second integer
	mov edx, OFFSET prompt_2
	call WriteString
	call ReadInt
	mov input_2, eax

	;Calculate sum
	mov eax, input_1
	add eax, input_2
	mov sum, eax

	;Calculate difference
	mov eax, input_1
	sub eax, input_2
	mov difference, eax

	;Calculate product
	mov eax, input_1
	mov ebx, input_2
	mul ebx
	mov product, eax

	;Calculate quotient and remainder
	mov eax, input_1
	cdq
	mov ebx, input_2
	div ebx
	mov quotient, eax
	mov remainder, edx

	;Report sum
	mov edx, OFFSET total
	call WriteString
	mov eax, sum
	call WriteDec
	call CrLf
	
	;Report difference
	mov edx, OFFSET subtract
	call WriteString
	mov eax, difference
	call WriteDec
	call CrLf

	;Report product
	mov edx, OFFSET multiply
	call WriteString
	mov eax, product
	call WriteDec
	call CrLf

	;Report quotient
	mov edx, OFFSET division
	call WriteString
	mov eax, quotient
	call WriteDec
	call CrLf

	;Report remainder
	mov edx, OFFSET leftover
	call WriteString
	mov eax, remainder
	call WriteDec
	call CrLf

	;Output exiting message
	mov edx, OFFSET good_bye
	call WriteString
	call CrLf

	exit	; exit to operating system
main ENDP



END main
