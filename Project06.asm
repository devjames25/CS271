TITLE Low-Level I/O Procedure     (Project06.asm)

; Author: Devon James
; Course / Project ID                 Date: 12/4/17
; Description:1) Designing, implementing, and calling low-level I/O procedures
2) Implementing and using a macro

INCLUDE Irvine32.inc

getString MACRO addressSTR, length  
	push ecx
	push edx
	mov edx, addressSTR
	mov ecx, length
	call ReadString
	pop edx
	pop ecx
ENDM

displayString MACRO buffer
	push edx
	mov edx, OFFSET buffer
	call WriteString
	pop edx
ENDM

	NUM = 10

.data

header BYTE "Welcome to the low-level I/O procedure program by Devon James", 0
instruct BYTE "This program will take in 10 unsigned integers and displays the list of those intgers with its calcualted sum and average value.", 0
prompt BYTE "Please enter a number here:", 0
errorMessage BYTE "ERROR! The number you entered was either too big or not an unsigned number. Try Again.", 0
list BYTE "These are the numbers that you have entered: ", 0
sumMessage BYTE "The sum of these numbers is: ", 0
avgMessage BYTE "The average is: ", 0
bye BYTE "Ths program is finished. Farewell!", 0
userInput BYTE 32 DUP(?)
array DWORD 10 DUP(0)
buff BYTE 255 DUP(0)
sum DWORD ?
average DWORD ?

.code
main PROC
	displayString header
	call CrLf
	displayString instruct
	call CrLf
	call CrLf

	mov ecx, NUM
	mov edi, OFFSET array

;User input for 10 values
readAgain:
	displayString prompt

	push OFFSET buff
	push SIZEOF buff
	call ReadVal

	mov eax, DWORD PTR buff     ;mov pointer of buff to eax register
	mov [edi], eax              ;mov poiter of buff to indirect address of array
	add edi, 4
	loop readAgain

	mov ecx, NUM
	mov esi, OFFSET array
	mov ebx, 0

	displayString list
	call CrLf

;Calculate the sum of the values in the array
sumLoop:
	mov eax, [esi]
	add ebx, eax

	push eax
	push OFFSET userInput
	call WriteVal
	add esi, 4
	loop sumLoop

	mov eax, ebx
	mov sum, eax
	displayString sumMessage
	
	push sum
	push OFFSET userInput
	call WriteVal
	call CrLf

;Calculate the average of the values in the array
	mov ebx, NUM
	mov edx, 0
	div ebx

	mov ecx, eax
	mov eax, edx
	mov edx, 2
	mul edx
	cmp eax, ebx
	mov eax, ecx
	mov average, eax
	jb avgLoop
	inc eax
	mov average, eax

avgLoop:
	displayString avgMessage
	push average
	push OFFSET userInput
	call WriteVal
	call CrLf

	displayString bye
	call CrLf

	exit	; exit to operating system
main ENDP

; Procedure to get the user's input
; receives: address and size of buff
; returns: none
; preconditions: none
; registers changed: eax, ebx, ecx, edx, esi
readVal PROC
	  push ebp
      mov ebp, esp
	  pushad

begin:
      mov edx, [ebp+12]      ;@address of buff
      mov ecx, [ebp+8]            ;size of buff

	  getString edx, ecx

	  mov esi, edx
	  mov eax, 0
	  mov ecx, 0
	  mov ebx, 10
	  cld

   counter:
      lodsb                  ;load the first byte
      cmp ax, 0
      je finish
      cmp ax, 48            ;if input is less than 0 or not a number
      jl errorJmp
      cmp ax, 57            ;if input is greater than 9 or not a number
      jg errorJmp
      sub ax, 48
	  xchg eax, ecx
	  mul ebx
	  jc errorJmp           ;jump if carry flag is set
	  jnc noError           ;jump if carry flag is not set
      
   errorJmp:                     ;invalid input
      displayString errorMessage
      call  CrLf
      jmp begin
         
	noError:         
      add eax, ecx
	  xchg eax, ecx
	  jmp counter
	    
    finish:
      xchg ecx,eax
	  mov DWORD PTR buff, eax     ;mov input to pointer of buff
	  popad
      pop ebp
	  ret 8
readVal ENDP

; Procedure to convert a numeric value to string
; receives: address of a array and value of sum 
; returns: none
; preconditions: none
; registers changed: eax, ebx, edx, edi
writeVal PROC
	push	ebp
	mov		ebp, esp
	pushad	
	mov eax, [ebp+12]  ;sum
	mov edi, [ebp+8]   ;@address of array
	mov ebx, 10
	push 0

convert:
	mov edx, 0
	div ebx
	add edx, 48
	push edx

	cmp eax, 0
	jne convert

store:
	pop [edi]
	mov eax, [edi]
	inc edi
	cmp eax, 0
	jne store

	mov edx, [ebp+8]
	displayString OFFSET userInput
	call Crlf

	popad		;restore registers
	pop ebp
	ret 8
writeVal ENDP

END main
