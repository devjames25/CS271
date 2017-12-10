TITLE Integer Array Program     (Project03.asm)

; Author:Devon James
; Course / Project ID   [CS271_400]             Date:10/30/2017
; Description:This program displays the program's title and name, prompts for the user's 
;name and greets the user, displays instructions, repeatedly prompt the user to enter 
;a number until a non-negative number is entered, calculate the sum and average,
;and displays the results(sum and average), number of negative numbers entered, and parting message.

INCLUDE Irvine32.inc

LOWER_LIMIT = -100

.data

user_name BYTE ?
header BYTE "Welcome to Integer Array Program by Devon James", 0
prompt1 BYTE "What is your name?", 0
greeting BYTE "Hello ", 0
instruct1 BYTE "Please enter numbers between [-100, -1].", 0
instruct2 BYTE "Enter a positive number(including 0) when you want to tally the results.", 0
prompt2 BYTE "Enter number here: ", 0
array SDWORD 99 DUP(?)
count SDWORD ?
sum SDWORD ?
average SDWORD ?
errorMessage BYTE "Number is out of range.", 0
valid BYTE "You entered ", 0
numbers BYTE " valid numbers.", 0
total BYTE "The sum of your valid numbers is ", 0
avgMessage BYTE "The rounded average is ", 0
farewell BYTE "Thank you for playing Integer Array Program! It's been a pleasure to meet you, ", 0

.code
main PROC
	call greet
	call getData
	call calculate 
	call goodBye

	exit	; exit to operating system
main ENDP

;Procedure to introduced the program, greet the user, and displays the instructions.
;receives: none
;returns: user input value for global variable user_name
;preconditions:  none
;registers changed: ecx, edx
greet PROC

    ;Display Header
	mov edx, OFFSET header
	call WriteString
	call CrLf

	;Prompt and recieve user name
	mov edx, OFFSET prompt1
	call WriteString
	mov edx, OFFSET user_name
	mov ecx, 50
	call ReadString

	;Display user name
	mov edx, OFFSET greeting
	call WriteString
	mov edx, OFFSET user_name
	call WriteString
	call CrLf

	;Display program instructions
	mov edx, OFFSET instruct1
	call WriteString
	call CrLf
	mov edx, OFFSET instruct2
	call WriteString
	call CrLf
     
	ret
greet ENDP

;Procedure to get values for array using a loop, which includes data validation, 
;and displays the amount of non-positive integers in the array.
;receives: none
;returns: user input values to place in the global variable array and count is a global variable
;preconditions:  none
;registers changed: eax, edx, esi, ecx
getData PROC

	;Input integer and place them in an array
	mov esi, 0
	mov count, 0
	top:
	   mov edx, OFFSET prompt2
	   call WriteString
	   call ReadInt
	   mov array[esi], eax        ;places input integer in array
	   cmp eax, LOWER_LIMIT
	   jl dataValid
	   add esi, 4                 ;adds 4 to move up 4 bytes in memory 
	   inc count                  ;increments as integers are placed in the array
	   cmp eax, 0
	   jl top
	   jge continueProg
	   loop top

	;Prompts error if a number is out of range
	dataValid:
		mov edx, OFFSET errorMessage
		call WriteString
		call CrLf
		jmp top

	;Display amount of integers in the array
continueProg:
    mov ecx, 1
	mov edx, OFFSET valid
	call WriteString
	mov array[esi], 0    ;places 0 in the last address of the array that we entered
	sub count, 1        
	mov eax, count       ;subtracts the count value by 1 to get accurate number of integers in array
	call WriteDec
	mov edx, OFFSET numbers
	call WriteString
	call CrLf
	loop continueProg
	ret
getData ENDP

;Procedure to calculate the sum and average of the non-positive integers 
;in the array and display the results
;receives: integers in array and count as a global variable
;returns: global variables sum = array[esi] + array[esi+4]+..., average = sum/count 
;preconditions:  none
;registers changed: eax, ebx, ecx, edx, esi
calculate PROC
    ;Calculate the total of numbers in the array 
	mov esi, 0
	mov eax, array[esi]
	mov ecx, count    ;set counter to number of integers are in the array
	mov sum, 0
	collecting:
		add esi, 4    ;moves up 4 address spaces
		add eax, array[esi]
		mov sum, eax
		loop collecting
		
	;Display the sum
	mov edx, OFFSET total
	call WriteString
	mov eax, sum
	call WriteInt
	call CrLf

	;Calculate and display averages 
	mov edx, OFFSET avgMessage
	call WriteString
	mov eax, sum
	mov ebx, count
	cdq
	idiv ebx      ;signed divison 
	call WriteInt
	call CrLf

	ret
calculate ENDP  

;Procedure to bid farewell to the user .
;receives: user_name is a global variable
;returns: none
;preconditions:  none
;registers changed: edx
goodBye PROC
    ;Displays ending message
	mov edx, OFFSET farewell
	call WriteString
	mov edx, OFFSET user_name
	call WriteString
	call CrLf
	ret
goodBye ENDP

END main
