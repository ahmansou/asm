section .text
	global start

start:
	; ;(0x2000004)(rdi, rsi, rdx);
	; mov rax, 0x2000004	; write syscall
	; mov rdi, 1		; std out as fd 
	; mov rsi, msg	; msg as buffer
	; mov rdx, msg.len	; len
	; syscall		; run all above

	; read
	mov		rax, 0x2000003
	mov		rsi, msg
	mov		rdi, 0
	mov		rdx, 1000
	syscall

	mov		rcx, msg
	; dec rcx
	
	; print
	mov		rdx, rax
	mov		rax, 0x2000004
	mov		rdi, 1
	mov		rcx, rcx
	syscall

	mov		rdx, output             ; rdx holds address of next byte to write
	mov		r8, 1                   ; initial line length
	mov		r9, 0

line:
	mov		byte [rdx], '*'         ; write single star
	inc		rdx                     ; advance pointer to next cell to write
	inc		r9                      ; "count" number so far on line
	cmp		r9, r8                  ; did we reach the number of stars for this line?
	jne		line

lineDone:
	mov       byte [rdx], 10          ; write a new line char
	inc       rdx                     ; and move pointer to where next char goes
	inc       r8                      ; next line will be one char longer
	mov       r9, 0                   ; reset count of stars written on this line
	cmp       r8, maxlines            ; wait, did we already finish the last line?
	jng       line                    ; if not, begin writing this line

done:
	mov       rax, 0x02000004         ; system call for write
	mov       rdi, 1                  ; file handle 1 is stdout
	mov       rsi, output             ; address of string to output
	mov       rdx, dataSize           ; number of bytes
	syscall

	; exit
	mov		rax, 0x2000001
	mov		rdi, 0
	syscall

section .data

msg: db "H"
.len equ $-msg

section   .bss
maxlines  equ       8
dataSize  equ       44
output:   resb      dataSize