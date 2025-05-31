section .data
    tit         db 10, '| ----------- |',10, '| Calculadora |',10, '| ----------- |',10,0
    ltit        equ $ - tit
    obVal1      db 10, 'Valor 1: ',0
    lobVal1     equ $ - obVal1
    obVal2      db 10, 'Valor 2: ',0
    lobVal2     equ $ - obVal2
    opc1        db 10,'1. Adição ',0
    lopc1       equ $ - opc1
    opc2        db 10,'2. Subtração ',0
    lopc2       equ $ - opc2
    opc3        db 10,'3. Multiplicação ',0
    lopc3       equ $ - opc3
    opc4        db 10,'4. Divisão ',0
    lopc4       equ $ - opc4
    msgOpc      db 10,'Qual operação você deseja realizar? ',0
    lmsgOpc     equ $ - msgOpc
    msgErro     db 10,'Opção inválida',10,0
    lmsgErro    equ $ - msgErro
    msgDivZero  db 10,'Divisão por zero não é permitida',10,0
    lmsgDivZero equ $ - msgDivZero
    nLinha      db 10,0
    lLinha      equ $ - nLinha

section .bss
    opc        resb 2
    num1       resb 12
    num2       resb 12
    result     resb 16

section .text
    global _start

_start:
    mov ecx, tit
    mov edx, ltit
    call mst_saida

    mov ecx, obVal1
    mov edx, lobVal1
    call mst_saida
    mov ecx, num1
    mov edx, 12
    call ler

    mov ecx, obVal2
    mov edx, lobVal2
    call mst_saida
    mov ecx, num2
    mov edx, 12
    call ler

    mov ecx, opc1
    mov edx, lopc1
    call mst_saida
    mov ecx, opc2
    mov edx, lopc2
    call mst_saida
    mov ecx, opc3
    mov edx, lopc3
    call mst_saida
    mov ecx, opc4
    mov edx, lopc4
    call mst_saida

    mov ecx, msgOpc
    mov edx, lmsgOpc
    call mst_saida
    mov ecx, opc
    mov edx, 2
    call ler

    mov al, [opc]
    sub al, '0'

    cmp al, 1
    je adicionar
    cmp al, 2
    je subtrair
    cmp al, 3
    je multiplicar
    cmp al, 4
    je dividir
    mov ecx, msgErro
    mov edx, lmsgErro
    call mst_saida
    jmp saida

adicionar:
    lea esi, [num1]
    call string_to_int
    push eax            
    lea esi, [num2]
    call string_to_int  
    pop ebx             
    add eax, ebx
    lea edi, [result]
    call int_to_string
    call print_result
    jmp saida

subtrair:
    lea esi, [num1]
    call string_to_int
    mov ebx, eax
    lea esi, [num2]
    call string_to_int
    sub ebx, eax
    mov eax, ebx
    lea edi, [result]
    call int_to_string
    call print_result
    jmp saida

multiplicar:
    lea esi, [num1]
    call string_to_int
    push eax
    lea esi, [num2]
    call string_to_int
    pop ebx
    imul eax, ebx
    lea edi, [result]
    call int_to_string
    call print_result
    jmp saida

dividir:
    lea esi, [num1]
    call string_to_int
    push eax
    lea esi, [num2]
    call string_to_int  
    cmp eax, 0
    je div_zero
    mov ecx, eax        
    pop eax
    cdq
    idiv ecx
    lea edi, [result]
    call int_to_string
    call print_result
    jmp saida

div_zero:
    mov ecx, msgDivZero
    mov edx, lmsgDivZero
    call mst_saida
    jmp saida

print_result:
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, result+16
    sub edx, edi
    int 0x80
    mov ecx, nLinha
    mov edx, lLinha
    call mst_saida
    ret

saida:
    mov eax, 1
    mov ebx, 0
    int 0x80

ler:
    mov eax, 3
    mov ebx, 0
    int 0x80
    ret

mst_saida:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

string_to_int:
    xor eax, eax
    xor ebx, ebx
    mov bl, 0
    mov cl, [esi]
    cmp cl, '-'
    jne .parse
    inc esi
    mov bl, 1
.parse:
    mov ecx, 0
.next:
    mov al, [esi]
    cmp al, 0
    je .done
    cmp al, 10
    je .done
    cmp al, '0'
    jb .done
    cmp al, '9'
    ja .done
    sub al, '0'
    imul ecx, ecx, 10
    add ecx, eax
    inc esi
    jmp .next
.done:
    mov eax, ecx
    cmp bl, 1
    jne .end
    neg eax
.end:
    ret

int_to_string:
    mov ecx, edi
    add ecx, 15
    mov byte [ecx], 0
    dec ecx
    mov ebx, 10
    mov edx, 0
    mov cl, 0
    cmp eax, 0
    jne .int_to_str
    mov byte [ecx], '0'
    dec ecx
    jmp .done
.int_to_str:
    cmp eax, 0
    jge .positive
    neg eax
    mov cl, 1
.positive:
.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    dec ecx
    test eax, eax
    jnz .loop
    cmp cl, 1
    jne .done
    mov byte [ecx], '-'
    dec ecx
.done:
    inc ecx
    mov edi, ecx
    ret