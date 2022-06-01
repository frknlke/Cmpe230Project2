jmp start				;jumps to the start
                                                                                   
result db 5 dup 0		
	characters     dw 10,13,"$"     ;output string		
	temp   dw 0			;temporary variable
	count  dw 1			;variablle to print exactly length of 4 result	
					
start:				  	;starts the program
	mov cx,0	 			
	mov bl,0

readcharacter:                    	; reads input character by character
	mov ah,01h				
	int 21h					
	mov dx,0				
	mov dl,al				
	mov ax,cx
	cmp dl,32
	if e jmp push_stack
	cmp dl,'+'
	if e jmp ADDNUMBERS
	cmp dl,'*'
	if e jmp MULTIPLYNUMBERS
	cmp dl,'/'
	if e jmp DIVIDENUMBERS
	cmp dl,'&'
	if e jmp ANDNUMBERS
	cmp dl,'|'
	if e jmp ORNUMBERS
	cmp dl,'^'
	if e jmp BITWISEORNUMBERS
	cmp dl,0D				
	if e jmp last_push
	cmp dl,64d				
	ja parta
	jmp partb
	jmp readcharacter

last_push:				; when enter is seen if last thing is variable than we push it
	cmp ax,0
	if e jmp modify_result
	push ax
	mov ax,0h
	mov cx,0h
	jmp modify_result
	
push_stack:				; push number to the stack
	cmp ax,0
	if e jmp readcharacter
	push ax
	mov ax,0h
	mov cx,0h
	jmp readcharacter
parta:					;if the bit is letter than this method is called
	sub dx,'7'				
	mov temp,dx				
	mov ax,cx		
	mov cx,16d
	mul cx					 
	add ax,temp				
	mov cx,ax				
	jmp readcharacter
partb:					;id the bit is number than this method is called
	sub dx,'0'				
	mov temp,dx				
	mov ax,cx		
	mov cx,16d
	mul cx					
	add ax,temp				
	mov cx,ax				
	jmp readcharacter

ADDNUMBERS:				;adds two numbers
	pop ax
	pop bx
	add ax,bx
	push ax
	mov ax,0
	mov bx,0
	jmp readcharacter

MULTIPLYNUMBERS:			;multiplies two numbers
	POP AX
	POP CX
	MUL CX
	PUSH AX
	mov ax,0
	mov cx,0
	jmp readcharacter

DIVIDENUMBERS:				;divides two numbers
	MOV DX,0
	POP CX
	POP AX
	DIV CX
	PUSH AX
	mov ax,0
	mov cx,0
	jmp readcharacter

ANDNUMBERS:  				;calculates the bitwise and of two numbers                                          
	POP AX
	POP BX
	AND AX,BX
	PUSH AX
	mov ax,0
	mov bx,0
	jmp readcharacter	

ORNUMBERS:				;calculates the bitwise or of two numbers
	POP AX
	POP BX
	OR AX,BX	
	PUSH AX	
	mov ax,0
	mov bx,0
	jmp readcharacter
	
BITWISEORNUMBERS:			;calculates the bitwise xor of two numbers
	POP AX
	POP BX
	XOR AX,BX
	PUSH AX	
	mov ax,0
	mov bx,0
	jmp readcharacter

modify_result:				;moves the cursor to the end
	pop ax
	mov bx,offset result+4 	
	mov b[bx],"$"			
	dec bx

convert_hexadecimal:			;converts the number to hexadecimal
	mov dx,0
	mov cx,16d
	div cx
	cmp dx,10
	jb convert_hexadecimaldig
	jmp convert_hexadecimallet						
	


convert_hexadecimallet:			;if the bit is letter than this method is called

				
	add dx,55d  			
	mov [bx],dl				
	dec bx
	inc count
	cmp count,5				
	jb convert_hexadecimal
	jmp print_characters

convert_hexadecimaldig:			;if the bit is number than this method is called

				
	add dx,48d  			
	mov [bx],dl				
	dec bx
	inc count
	cmp count,5				
	jb convert_hexadecimal
	jmp print_characters


print_characters:			;prints carriage return and line feed
	mov ah,09
	mov dx,offset characters		
	int 21h

print_result:				;prints the result
	mov dx,bx								
	mov ah,09
	inc dx
	int 21h
	jmp exit
	

exit:					;exit the program
	mov ah,04ch				
	mov al,00
	int 21h
