TITLE Sorting Array    (Project05.asm)

; Author:Devon James
; Course / Project ID         [CS270_400]         Date:11/20/17
; Description:1. Introduce the program. 
;2. Get a user request in the range [min = 10 .. max = 200].
;3. Generate request random integers in the range [lo = 100 .. hi = 999], 
;storing them in consecutive elements of an array. 4. Display the list of integers 
;before sorting, 10 numbers per line. 5. Sort the list in descending order 
;(i.e., largest first). 6. Calculate and display the median value, rounded to 
;the nearest integer. 7. Display the sorted list, 10 numbers per line.

INCLUDE Irvine32.inc

min = 10
max = 200
lo = 100
hi = 999
NEW_LINE = 10


.data

header BYTE "Welcome to the Sorting Array Program by Devon James.", 0
explain BYTE "We will be generating random numbers and placing them in an array, then displaying the unsorted and sorting version.", 0
prompt BYTE "Please enter a number within the range of 10 and 200 here:", 0
errorLess BYTE "Number you entered is less than the given range!", 0
errorGreat BYTE "Number you entered is greater than the given range!", 0
medArray BYTE "The median of the array is ", 0
bye BYTE "The results were certified by Devon James. Farewell!", 0
sortList BYTE "Sort Array", 0
unsortList BYTE "Unsort Array", 0
space BYTE "  ", 0
median DWORD ?
range DWORD ?
counter DWORD 0
array DWORD 100 DUP(?)

.code
main PROC
	call introduction

	push OFFSET range
	call getData

	push OFFSET array
	push range
	call fillArray

	push OFFSET unsortList
	push range         
	push OFFSET array   
	call displayUnsort

	push range
	push OFFSET array
	call sortArray

	push range
	push OFFSET array
	call displayMed

	push OFFSET sortList
	push range         
	push OFFSET array   
	call displaySort

	call farewell
	exit	; exit to operating system
main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
introduction PROC
	mov edx, OFFSET header
	call WriteString 
	call CrLf

	mov edx, OFFSET explain
	call WriteString
	call CrLf
	ret
introduction ENDP

;Procedure to get the user's input data.
;receives: address of range on system stack
;returns: user's input on global range
;preconditions:  eax, edx, edi
;registers changed: edx
getData PROC
	push ebp
	mov ebp, esp
	mov edi, [ebp+8]

top:
	mov edx, OFFSET prompt
	call WriteString
	call ReadDec
	cmp eax, min        
	jl errorMin
	cmp eax, max
	jg errorMax
	jmp continue

;data validation if input is less than min constant
errorMin:
	mov edx, OFFSET errorLess
	call WriteString
	call CrLf
	jmp top

;data validation if input is greater than max constant
errorMax:
	mov edx, OFFSET errorGreat
	call WriteString
	call CrLf
	jmp top

continue:
	mov [edi], eax
	jmp endLoop

endLoop:
	pop ebp
	ret 4
getData ENDP

;Procedure to put random numbers into an array.
;receives: address of array and value of range on system stack
;returns: random numbers of  the array within the range
;preconditions:  range is between 100 and 999
;registers changed: eax, ecx, edi
fillArray PROC
	push ebp
	mov ebp, esp
	mov edi, [ebp+12]
	mov ecx, [ebp+8]
	
 randomLoop:
	mov eax, hi
	call RandomRange
	add eax, lo
	mov [edi], eax
	add edi, 4
	loop randomLoop
	
	pop ebp
	ret 8
fillArray ENDP

;Procedure to display the numbers in the array.
;receives: address of array and unsortedList and value of range from the system stack
;returns: first range elements in the array
;preconditions:  range is between 100 and 999
;registers changed: eax, ebx, ecx, edx, edi
displayUnsort PROC
	push ebp
	mov ebp, esp
	mov edi, [ebp+8]
    mov ecx, [ebp+12]
	mov edx, [ebp+16]
	call WriteString
    call CrLf
    mov ebx, 0

printUnsort:
	mov eax, [edi]
	call WriteDec
	mov edx, OFFSET space
	call WriteString
	add edi, 4
	inc counter
	mov edx, 0
	mov ebx, NEW_LINE
	div ebx
	cmp edx, 0
	jne skipLine
	call CrLf

skipLine:
	loop printUnsort
	call CrLf

	pop ebp
	ret 12
displayUnsort ENDP

;Procedure to sort the array from greatest to least.
;receives: address of array and value of range from the system stack
;returns: range numbers in descending order
;preconditions: range elements between 100 and 999
;registers changed: ecx, edx, esi
sortArray PROC
	push ebp
	mov ebp, esp
	mov ecx, [ebp+12]
	dec ecx

loop1:
	push ecx
	mov esi, [ebp+8]

loop2:
	mov eax, [esi]
	cmp [esi+4], eax
	jb loop3
	xchg eax, [esi+4]
	mov [esi], eax

loop3:
	add esi, 4
	loop loop2
	pop ecx
	loop loop1

loop4:
	pop ebp
	ret 8
sortArray ENDP

;Procedure to calculate and display the median value of the array.
;receives: address of array and value of range from the system stack
;returns: none
;preconditions:  range elements between 100 and 999
;registers changed: eax, edx, esi
displayMed PROC
	push ebp
	mov ebp, esp
	mov eax, [ebp+12]
	mov esi, [ebp+8]
	mov edx, OFFSET medArray
	call WriteString
	test eax, 1
	jz evenNum
	jmp oddNum

evenNum:
	shr eax, 1
	shl eax, 2
	add esi, eax
	mov eax, [esi]
	add eax, [esi-4]
	shr eax, 1
	jmp printMed

oddNum:
	shr eax, 1
	shl eax, 2
	add esi, eax
	mov eax, [esi]
	jmp printMed

printMed:
	call WriteDec
	call CrLf

	pop ebp
	ret 8
displayMed ENDP

;Procedure to display the sorted array.
;receives: address of array and sortList and the value of range from the system stack
;returns: none
;preconditions:  range elements between 100 and 900
;registers changed: eax, ecx, edx, edi
displaySort PROC
    push ebp
	mov ebp, esp
	mov edi, [ebp+8]
	mov ecx, [ebp+12]
	mov edx, [ebp+16]
	call WriteString
	call CrLf
	mov ebx, 0

printSort:
	mov eax, [edi]
	call WriteDec
	mov edx, OFFSET space
	call WriteString
	add edi, 4
	inc counter
	mov edx, 0
	mov ebx, NEW_LINE
	div ebx
	cmp edx, 0
	jne skipLine
	call CrLf

skipLine:
	loop printSort
	call CrLf

	pop ebp
	ret 12
displaySort ENDP

;Procedure to say good-bye.
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
