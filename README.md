# Pontifícia Universidade Católica do Paraná
# Programação Lógica e Funcional - Frank Coelho de Alcantara
# Participantes:
## Gustavo Berg Ribeiro - 
## Gustavo Ferronatto Ribeiro -
## João Guilherme Machado Palma - 
## Renan Belem Biavati - 

## Link OnlineGDB: https://www.onlinegdb.com/edit/pb4qP-mb90#

# Sistema de Gerenciamento de Inventário em Haskell

## 1. Visão Geral do Projeto

Este sistema implementa um gerenciador de inventário interativo, utilizando **Haskell** para demonstrar os princípios da **Programação Funcional Pura**. O foco é na **separação rigorosa entre a lógica de negócio (pura)** e as **operações de I/O** (interação via terminal, persistência de estado e logs de auditoria).

## 2. Instruções de Compilação e Execução (OnlineGDB)

Para rodar o projeto no ambiente OnlineGDB (ou qualquer IDE com suporte a Haskell):

### Etapa 1: Compilação

1.  Copie o código completo do projeto para o arquivo principal.
2.  **Verifique a Linguagem:** Certifique-se de que a linguagem de execução esteja definida como **Haskell** no seletor do GDB.
3.  Clique no botão **"Run"** (ou "Compilar" / "Executar").

O GHC (o compilador Haskell) irá compilar o código e gerar um executável (`a.out`).

### Etapa 2: Execução

Após a compilação, o programa se inicia automaticamente, exibindo as mensagens de carregamento:
--- Sistema de Gerenciamento de Inventário (Haskell) ---
Arquivo Inventario.dat não encontrado. Iniciando inventário vazio.
Arquivo Auditoria.log não encontrado. Iniciando novo log.
Entradas de Log Antigas: 0

--- INVENTÁRIO ATUAL ---
fromList []

Comando (ADD/REMOVE/UPDATE/SAIR) >

O sistema estará rodando o **REPL** (Read-Eval-Print Loop), pronto para receber comandos.

> **Nota sobre I/O:** Devido às restrições de ambientes online (como o OnlineGDB), você pode notar que os comandos `REPORT` e a leitura de arquivos funcionam melhor quando a **execução não é reiniciada**, pois o sistema de arquivos virtual pode manter locks temporários (`resource busy`).

## 3. Exemplos de Comandos e Uso

Use o *prompt* para digitar os comandos.

| Ação | Comando | Saída de Exemplo (Sucesso) |
| :--- | :--- | :--- |
| **Adicionar** | `ADD M10 Martelo_Borracha 50 Ferramentas` | `>>> Sucesso: Adicionado Item: ...` |
| **Atualizar** | `UPDATE M10 80` | `>>> Sucesso: Atualizado M10. Nova Qtd: 80` |
| **Remover** | `REMOVE M10 10` | `>>> Sucesso: Removido 10 de M10. Nova Qtd: 70` |
| **Relatório** | `REPORT` | Exibe erros de lógica e itens mais movimentados lidos do `Auditoria.log`. |
| **Sair** | `SAIR` | `Saindo do sistema. Tchau!` |

### Exemplo de Erro de Lógica (Validação)

Este comando demonstra a **validação pura** de estoque insuficiente:

* **Comando:** `REMOVE M10 100` (Se o estoque atual for 70)
* **Saída:** `>>> Erro: Estoque insuficiente. Atual: 70`

A operação **falha**, o `Inventario.dat` **não é alterado**, e a falha é registrada no `Auditoria.log`.

## 4. Validação: Status dos Requisitos Principais

O código foi validado para cumprir todos os seguintes requisitos:

* **Separação Pura:** Lógica de negócio é isolada (Requisito 3).
* **Persistência Condicional:** Estado salvo apenas em sucesso (Requisito 4).
* **Log de Auditoria:** Todas as tentativas (sucesso/falha) são registradas (`appendFile`, Requisito 5).
* **Relatórios:** O comando `REPORT` analisa o histórico de logs (Requisito 4).
