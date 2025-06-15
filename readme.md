# Calculadora em Assembly

Este projeto é uma calculadora simples desenvolvida em Assembly para sistemas Linux (x86), capaz de realizar as quatro operações básicas: adição, subtração, multiplicação e divisão.

## Funcionalidades
- Soma
- Subtração
- Multiplicação
- Divisão (com tratamento de divisão por zero)

## Como funciona
O programa solicita ao usuário dois valores inteiros e a operação desejada. Após o cálculo, exibe o resultado na tela.

## Execução
### Pré-requisitos
- Linux x86
- NASM (montador)
- GCC ou ld (linkador)

### Montagem e execução
1. Monte o código fonte:
   ```bash
   nasm -f elf32 calculadora.asm -o calculadora.o
   ```
2. Linke o arquivo objeto:
   ```bash
   ld -m elf_i386 -o calculadora calculadora.o
   ```
3. Execute o programa:
   ```bash
   ./calculadora
   ```
4. Observação:
   Caso ao tentar executar o programa e acontecer algum erro, execute novamente com o comando sudo na frente.
   ```bash
   sudo nasm -f elf32 calculadora.asm -o calculadora.o
   ```
   ```bash
   sudo ld -m elf_i386 -o calculadora calculadora.o
   ```

## Estrutura do código
- **Entrada de dados:** Recebe dois números e a opção de operação.
- **Processamento:** Realiza a operação escolhida.
- **Saída:** Exibe o resultado ou mensagens de erro (opção inválida ou divisão por zero).

## Observações
- Apenas números inteiros são aceitos.
- O código utiliza chamadas de sistema Linux (int 0x80).

## Autores
- Desenvolvido por:
   - Cícero Ricardo Farias de Lima Júnior
   - Francielly de Oliveira Pires
   - Luana Yasmim Lourenço Nogueira
   - Luis Fernando Pedro Bom Pereira
