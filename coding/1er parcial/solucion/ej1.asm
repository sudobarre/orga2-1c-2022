
extern malloc
extern free
extern strDelete
global strArrayNew
global strArrayGetSize
global strArrayGet
global strArrayRemove
global strArrayDelete


section .rodata
;%define NULL, 0

;########### SECCION DE DATOS
section .data
;########### SECCION DE TEXTO (PROGRAMA)
section .text

; str_array_t* strArrayNew(uint8_t capacity)
;dil -> capacity
strArrayNew:
push rbp
mov rbp, rsp
push r14 
push r12 ;alineada a 16

mov r12b, dil ;muevo el valor de capacity a r12b para preservarlo

;creo el espacio para el arreglo
;porque el arreglo guarda punteros a strings
;espacio de memoria que necesito: capacity * tamaño puntero: shl r12b, 3
movzx rax, r12b
shl rax, 3
mov rdi, rax
call malloc  
mov r14, rax ;guardo el puntero al arr en r14

;creo el struct
mov rdi, 16    
call malloc ;en rax tengo el puntero a struct

mov byte [rax], 0 ;size de cero
mov byte [rax+1], r12b ;pongo el capacity
mov [rax+8], r14 ;pongo el puntero

pop r12
pop r14
pop rbp
ret
; uint8_t  strArrayGetSize(str_array_t* a)
;rdi -> str_array_t* a
strArrayGetSize:
push rbp
mov rbp, rsp

mov al, [rdi]

pop rbp
ret
; char* strArrayGet(str_array_t* a, uint8_t i)
;rdi -> a, sil -> i
strArrayGet:
push rbp
mov rbp, rsp

;chequea si i es mayor que size
cmp sil, [rdi]
jge .notfound

;esta en rango
mov rdi, [rdi + 8] ;rdi pasa a ser el array
.ciclo:
cmp sil, 0
je .iesimo
add rdi, 8 ;paso al sig elem(ptr) del arr
dec sil
jmp .ciclo

.iesimo:
mov rax, [rdi]
jmp .fin
.notfound:
mov rax, 0
.fin:
pop rbp
ret

; char* strArrayRemove(str_array_t* a, uint8_t i)
;rdi -> a, sil -> i
strArrayRemove:
push rbp
mov rbp, rsp
push rbx
push r13
push r14 ;alineada a 8
sub rsp, 8

xor rax, rax       
cmp sil, [rdi]  ;chequeo si esta fuera de rango  
jge .fin          

xor r14, r14
mov r13, rdi ;r13<- array
mov r14b, sil  ;r14b<- int8 iesimo

call strArrayGet

;tendria que pasar el iesimo a otro registro y llamar a strDelete


mov rdx, [r13+8] ;rdx<- arr

;r13<- array, r14b<- iesimo
;rbx <- ptr a devolver 
;rdx: arr
mov byte r9b, [r13] ;size del arr
dec r9b

;que pasa si estoy en el primero?

.swaps: ;shifteo todo el array un lugar a la izquierda
    cmp r14b, r9b ;estoy en el iesimo y quiero iterar hasta el final
    je .listo ;llegue al final
	lea rcx, [rdx+r14*8+8] ;cargo la direccion efectiva del sig al iesimo
    mov r8, [rcx] ; acceso al valor de la dir del iesimo, el string
	lea rcx, [rdx+r14*8] ;cargo la direccion efectiva del iesimo
    mov [rcx], r8  ;muevo el siguiente al iesimo que se borra
    inc r14b
    jmp .swaps

.listo: 
    ;estoy en el ultimo
	lea rcx, [rdx+r14*8]
    mov qword [rcx], 0 ;tal vez me tire error al leer esa pos de memoria
    dec byte [r13] ;decremento el size

.fin:
    add rsp, 8
    pop r14
    pop r13
    pop rbx
    pop rbp
    ret


; void  strArrayDelete(str_array_t* a)
strArrayDelete:
push rbp
mov rbp, rsp
push rbx
push r12
push r13
push r14 ;alineada a 16

mov bl, [rdi]	;bl(rbx)<- size
mov r12b, [rdi+1] ;r12b<-capacity
mov r13, rdi; lo preservo
	
.ciclo:
	cmp byte bl, 0
	je .fin 			
	mov rdi, r13 ;le paso el struct antes de llamar por si se cambia dsps del 1er llamado
	mov byte sil, 0	;seteo el i=0 para borrar el primero, como al borrar todo se shiftea a la izq no deberia pasar nada
	call strArrayRemove ;lo borro y tengo char*

	;tendria que llamar a strDelete del iesimo que obtuve 
	mov rdi, rax
	call strDelete

	mov bl, [r13]
	jmp .ciclo
	
.fin:
	;borro el array* y void**
	mov rdi, [r13+8] ;borro el void** vacio
	call free

	mov rdi, r13 ;el struct
	call free

	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret



