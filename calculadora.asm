section .data
    ; --- Mensagens da Interface ---
    tit           db 10, '| ----------- |',10, '| Calculadora |',10, '| ----------- |',10,0
    ltit          equ $ - tit
    obVal1        db 10, 'Valor 1: ',0
    lobVal1       equ $ - obVal1
    obVal2        db 10, 'Valor 2: ',0
    lobVal2       equ $ - obVal2
    opc1          db 10,'1. Adição',0
    lopc1         equ $ - opc1
    opc2          db 10,'2. Subtração',0
    lopc2         equ $ - opc2
    opc3          db 10,'3. Multiplicação',0
    lopc3         equ $ - opc3
    opc4          db 10,'4. Divisão',0
    lopc4         equ $ - opc4
    msgOpc        db 10,'Qual operação você deseja realizar? ',0
    lmsgOpc       equ $ - msgOpc
    
    ; --- Mensagens de Erro e Status ---
    msgErro       db 10,'Opção inválida',10,0
    lmsgErro      equ $ - msgErro
    msgDivZero    db 10,'Divisão por zero não é permitida',10,0
    lmsgDivZero   equ $ - msgDivZero
    
    ; --- Caracteres Especiais ---
    nLinha        db 10,0
    lLinha        equ $ - nLinha

section .bss
    ; --- Buffers para Armazenar Entradas e Saídas ---
    opc           resb 2      ; Buffer para a opção do menu
    num1          resb 12     ; Buffer para o primeiro número (string)
    num2          resb 12     ; Buffer para o segundo número (string)
    result        resb 16     ; Buffer para o resultado (string)

section .text
    global _start

_start:
    ; Exibe o título da calculadora
    mov ecx, tit
    mov edx, ltit
    call mst_saida

    ; Solicita e lê o primeiro valor
    mov ecx, obVal1
    mov edx, lobVal1
    call mst_saida
    mov ecx, num1
    mov edx, 12
    call ler

    ; Solicita e lê o segundo valor
    mov ecx, obVal2
    mov edx, lobVal2
    call mst_saida
    mov ecx, num2
    mov edx, 12
    call ler

    ; Exibe o menu de operações
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

    ; Solicita e lê a opção desejada
    mov ecx, msgOpc
    mov edx, lmsgOpc
    call mst_saida
    mov ecx, opc
    mov edx, 2
    call ler

    ; Converte a opção (caractere) para número e compara
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

    ; Se a opção for inválida, exibe mensagem de erro e sai
    mov ecx, msgErro
    mov edx, lmsgErro
    call mst_saida
    jmp saida

adicionar:
    ; Converte num1 para inteiro
    lea esi, [num1]
    call string_to_int
    push eax
    ; Converte num2 para inteiro
    lea esi, [num2]
    call string_to_int
    pop ebx
    ; Realiza a soma (eax = num2, ebx = num1)
    add eax, ebx
    ; Converte o resultado para string e imprime
    lea edi, [result]
    call int_to_string
    call print_result
    jmp saida

subtrair:
    ; Converte num2 para inteiro
    lea esi, [num2]
    call string_to_int
    push eax
    ; Converte num1 para inteiro
    lea esi, [num1]
    call string_to_int
    pop ebx
    ; Realiza a subtração (eax = num1, ebx = num2)
    sub eax, ebx
    ; Converte o resultado para string e imprime
    lea edi, [result]
    call int_to_string
    call print_result
    jmp saida

multiplicar:
    ; Converte num1 para inteiro
    lea esi, [num1]
    call string_to_int
    push eax
    ; Converte num2 para inteiro
    lea esi, [num2]
    call string_to_int
    pop ebx
    ; Realiza a multiplicação com sinal (eax = num2, ebx = num1)
    imul eax, ebx
    ; Converte o resultado para string e imprime
    lea edi, [result]
    call int_to_string
    call print_result
    jmp saida

dividir:
    ; Converte o divisor (num2) para inteiro
    lea esi, [num2]
    call string_to_int
    ; Verifica se o divisor é zero
    cmp eax, 0
    je div_zero
    
    ; Salva o divisor na pilha para não ser sobrescrito
    push eax

    ; Converte o dividendo (num1) para inteiro
    lea esi, [num1]
    call string_to_int
    
    ; Restaura o divisor da pilha para ECX
    pop ecx

    ; Agora: EAX contém o dividendo (num1)
    ;        ECX contém o divisor (num2)
    
    ; Estende o sinal de EAX para EDX:EAX para a divisão com sinal
    cdq
    ; Realiza a divisão com sinal (EDX:EAX / ECX)
    idiv ecx

    ; Converte o resultado (quociente em EAX) para string e imprime
    lea edi, [result]
    call int_to_string
    call print_result
    jmp saida

div_zero:
    ; Exibe mensagem de erro de divisão por zero
    mov ecx, msgDivZero
    mov edx, lmsgDivZero
    call mst_saida
    jmp saida

print_result:
    ; A rotina int_to_string coloca o endereço inicial do resultado em EDI
    mov ecx, edi
    ; Calcula o tamanho da string a ser impressa
    mov edx, result + 16
    sub edx, edi
    ; Chama a syscall para escrever na tela
    mov eax, 4
    mov ebx, 1
    int 0x80
    ; Imprime uma nova linha
    mov ecx, nLinha
    mov edx, lLinha
    call mst_saida
    ret

saida:
    ; Finaliza o programa
    mov eax, 1
    mov ebx, 0
    int 0x80

ler:
    ; Syscall para ler do stdin
    mov eax, 3
    mov ebx, 0
    int 0x80
    ret

mst_saida:
    ; Syscall para escrever no stdout
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

; Converte uma string (incluindo negativos) para um inteiro de 32 bits com sinal
; Entrada: ESI -> ponteiro para a string
; Saída: EAX -> inteiro convertido
string_to_int:
    xor ecx, ecx      ; Zera o acumulador (resultado)
    xor ebx, ebx      ; Zera EBX, usaremos BL como flag de sinal (0=positivo, 1=negativo)

    ; Verifica se o primeiro caractere é um sinal de menos '-'
    cmp byte [esi], '-'
    jne .parse_loop   ; Se não for, pula para o loop de conversão
    mov bl, 1         ; Se for, define a flag de sinal para negativo
    inc esi           ; Avança o ponteiro para depois do sinal

.parse_loop:
    movzx eax, byte [esi] ; Pega o caractere atual

    ; Verifica se o caractere é um dígito ('0' a '9')
    cmp al, '0'
    jb .done          ; Se for menor que '0' (ex: \n ou \0), termina
    cmp al, '9'
    ja .done          ; Se for maior que '9', termina
    
    ; Converte o caractere ASCII para seu valor numérico
    sub al, '0'
    
    ; Multiplica o acumulador por 10 e soma o novo dígito
    imul ecx, ecx, 10
    add ecx, eax
    
    inc esi           ; Vai para o próximo caractere
    jmp .parse_loop

.done:
    mov eax, ecx      ; Move o resultado (sempre positivo aqui) para EAX
    cmp bl, 1         ; A flag de sinal foi ativada?
    jne .end          ; Se não, o número é positivo, finaliza
    neg eax           ; Se sim, nega o valor em EAX (complemento de dois)

.end:
    ret


; Converte um inteiro de 32 bits com sinal para uma string
; Entrada: EAX -> inteiro a ser convertido
;          EDI -> ponteiro para o início do buffer de resultado
; Saída:   EDI -> ponteiro para o início da string convertida no buffer
int_to_string:
    mov ecx, edi      ; ECX será o ponteiro de escrita no buffer
    add ecx, 15       ; Aponta para o final do buffer (de 16 bytes)
    mov byte [ecx], 0 ; Adiciona o terminador nulo da string
    dec ecx           ; Aponta para a posição do último caractere possível

    mov ebx, 10       ; Divisor para conversão para base 10
    
    ; Trata o caso especial de eax ser 0
    test eax, eax
    jnz .is_not_zero  ; Se não for zero, continua com a conversão normal
    
    ; Se EAX é zero, coloca '0' na string e finaliza
    mov byte [ecx], '0'
    mov edi, ecx      ; EDI aponta para '0'
    ret
    
.is_not_zero:
    ; Armazena o sinal original e trabalha com o número positivo
    xor esi, esi      ; Zera ESI, usaremos para a flag de sinal (0=positivo, 1=negativo)
    test eax, eax
    jns .convert_loop ; Se não for negativo (jump if not sign), pula
    mov esi, 1        ; Define a flag de sinal para negativo
    neg eax           ; Torna o número positivo para a conversão

.convert_loop:
    xor edx, edx      ; Zera EDX para a divisão (importante!)
    div ebx           ; Divide EAX por 10. Quociente em EAX, resto em EDX
    add dl, '0'       ; Converte o resto (dígito) para seu caractere ASCII
    mov [ecx], dl     ; Armazena o dígito na string
    dec ecx           ; Move o ponteiro para a esquerda no buffer
    test eax, eax     ; O quociente chegou a zero?
    jnz .convert_loop ; Se não, repete o loop
    
.add_sign:
    cmp esi, 1        ; A flag de sinal foi ativada?
    jne .done         ; Se não, finaliza
    mov byte [ecx], '-' ; Se sim, adiciona o sinal de menos
    dec ecx

.done:
    inc ecx           ; Ajusta o ponteiro para o início da string convertida
    mov edi, ecx      ; Armazena o endereço inicial em EDI para a rotina de impressão
    ret
