<img width="492" height="120" alt="image" src="https://github.com/user-attachments/assets/acacec48-e6d8-4a6f-b9fc-89d5cdd57d7b" /># Pontifícia Universidade Católica do Paraná
# Programação Lógica e Funcional - Frank Coelho de Alcantara
# Participantes:
## Gustavo Berg Ribeiro - https://github.com/GustavoBergr
## Gustavo Ferronatto Ribeiro - https://github.com/gustavoferronattoribeiro
## João Guilherme Machado Palma - https://github.com/JoaoGuilhermeMP
## Renan Belem Biavati - https://github.com/RenanBelem

## Link OnlineGDB: https://onlinegdb.com/OrBc4eN3F

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

## 4.1 Cenários de Teste e Dados Mínimos:

A validação do sistema deve seguir requisitos mínimos de dados e
execução de cenários.
● Dados Mínimos: O sistema deve ser populado (na primeira execução
ou via comandos de
adição) com um mínimo de 10 Item distintos para permitir testes de
relatórios e lógica.
Primeiro RUN e início da configuração para validação do sistema e cenários de teste:
Console:
[1 of 2] Compiling Main ( main.hs, main.o )
[2 of 2] Linking a.out
--- Sistema de Gerenciamento de Inventário (Haskell) ---
Arquivo Inventario.dat não encontrado. Iniciando inventário vazio.
Arquivo Auditoria.log não encontrado. Iniciando novo log.
Entradas de Log Antigas: 0

--- INVENTÁRIO ATUAL ---
fromList []

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item1 i1 10 categoriaA
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria
= &quot;categoriaA&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item2 i2 20 categoriaB
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria
= &quot;categoriaB&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;item2&quot;,Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item3 i3 30 categoriaC
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item3&quot;, nome = &quot;i3&quot;, quantidade = 30, categoria
= &quot;categoriaC&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;item2&quot;,Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;item3&quot;,Item {itemID = &quot;item3&quot;, nome = &quot;i3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item4 i4 40 categoriaD
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item4&quot;, nome = &quot;i4&quot;, quantidade = 40, categoria
= &quot;categoriaD&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;item2&quot;,Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;item3&quot;,Item {itemID = &quot;item3&quot;, nome = &quot;i3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;}),(&quot;item4&quot;,Item {itemID = &quot;item4&quot;, nome = &quot;i4&quot;, quantidade = 40, categoria =
&quot;categoriaD&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item5 i5 50 categoriaE
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat

&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item5&quot;, nome = &quot;i5&quot;, quantidade = 50, categoria
= &quot;categoriaE&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;item2&quot;,Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;item3&quot;,Item {itemID = &quot;item3&quot;, nome = &quot;i3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;}),(&quot;item4&quot;,Item {itemID = &quot;item4&quot;, nome = &quot;i4&quot;, quantidade = 40, categoria =
&quot;categoriaD&quot;}),(&quot;item5&quot;,Item {itemID = &quot;item5&quot;, nome = &quot;i5&quot;, quantidade = 50, categoria =
&quot;categoriaE&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item6 i6 60 categoriaF
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item6&quot;, nome = &quot;i6&quot;, quantidade = 60, categoria
= &quot;categoriaF&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;item2&quot;,Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;item3&quot;,Item {itemID = &quot;item3&quot;, nome = &quot;i3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;}),(&quot;item4&quot;,Item {itemID = &quot;item4&quot;, nome = &quot;i4&quot;, quantidade = 40, categoria =
&quot;categoriaD&quot;}),(&quot;item5&quot;,Item {itemID = &quot;item5&quot;, nome = &quot;i5&quot;, quantidade = 50, categoria =
&quot;categoriaE&quot;}),(&quot;item6&quot;,Item {itemID = &quot;item6&quot;, nome = &quot;i6&quot;, quantidade = 60, categoria =
&quot;categoriaF&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item7 i7 70 categoriaG
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item7&quot;, nome = &quot;i7&quot;, quantidade = 70, categoria
= &quot;categoriaG&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;item2&quot;,Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;item3&quot;,Item {itemID = &quot;item3&quot;, nome = &quot;i3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;}),(&quot;item4&quot;,Item {itemID = &quot;item4&quot;, nome = &quot;i4&quot;, quantidade = 40, categoria =
&quot;categoriaD&quot;}),(&quot;item5&quot;,Item {itemID = &quot;item5&quot;, nome = &quot;i5&quot;, quantidade = 50, categoria =
&quot;categoriaE&quot;}),(&quot;item6&quot;,Item {itemID = &quot;item6&quot;, nome = &quot;i6&quot;, quantidade = 60, categoria =
&quot;categoriaF&quot;}),(&quot;item7&quot;,Item {itemID = &quot;item7&quot;, nome = &quot;i7&quot;, quantidade = 70, categoria =
&quot;categoriaG&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item8 i8 80 categoriaH
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item8&quot;, nome = &quot;i8&quot;, quantidade = 80, categoria
= &quot;categoriaH&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;item2&quot;,Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;item3&quot;,Item {itemID = &quot;item3&quot;, nome = &quot;i3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;}),(&quot;item4&quot;,Item {itemID = &quot;item4&quot;, nome = &quot;i4&quot;, quantidade = 40, categoria =
&quot;categoriaD&quot;}),(&quot;item5&quot;,Item {itemID = &quot;item5&quot;, nome = &quot;i5&quot;, quantidade = 50, categoria =
&quot;categoriaE&quot;}),(&quot;item6&quot;,Item {itemID = &quot;item6&quot;, nome = &quot;i6&quot;, quantidade = 60, categoria =
&quot;categoriaF&quot;}),(&quot;item7&quot;,Item {itemID = &quot;item7&quot;, nome = &quot;i7&quot;, quantidade = 70, categoria =
&quot;categoriaG&quot;}),(&quot;item8&quot;,Item {itemID = &quot;item8&quot;, nome = &quot;i8&quot;, quantidade = 80, categoria =
&quot;categoriaH&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item9 i9 90 categoriaI
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item9&quot;, nome = &quot;i9&quot;, quantidade = 90, categoria
= &quot;categoriaI&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;item2&quot;,Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;item3&quot;,Item {itemID = &quot;item3&quot;, nome = &quot;i3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;}),(&quot;item4&quot;,Item {itemID = &quot;item4&quot;, nome = &quot;i4&quot;, quantidade = 40, categoria =
&quot;categoriaD&quot;}),(&quot;item5&quot;,Item {itemID = &quot;item5&quot;, nome = &quot;i5&quot;, quantidade = 50, categoria =
&quot;categoriaE&quot;}),(&quot;item6&quot;,Item {itemID = &quot;item6&quot;, nome = &quot;i6&quot;, quantidade = 60, categoria =
&quot;categoriaF&quot;}),(&quot;item7&quot;,Item {itemID = &quot;item7&quot;, nome = &quot;i7&quot;, quantidade = 70, categoria =
&quot;categoriaG&quot;}),(&quot;item8&quot;,Item {itemID = &quot;item8&quot;, nome = &quot;i8&quot;, quantidade = 80, categoria =
&quot;categoriaH&quot;}),(&quot;item9&quot;,Item {itemID = &quot;item9&quot;, nome = &quot;i9&quot;, quantidade = 90, categoria =
&quot;categoriaI&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; add item10 i10 100 categoriaJ
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;item10&quot;, nome = &quot;i10&quot;, quantidade = 100,
categoria = &quot;categoriaJ&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;item1&quot;,Item {itemID = &quot;item1&quot;, nome = &quot;i1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;item10&quot;,Item {itemID = &quot;item10&quot;, nome = &quot;i10&quot;, quantidade = 100, categoria =
&quot;categoriaJ&quot;}),(&quot;item2&quot;,Item {itemID = &quot;item2&quot;, nome = &quot;i2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;item3&quot;,Item {itemID = &quot;item3&quot;, nome = &quot;i3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;}),(&quot;item4&quot;,Item {itemID = &quot;item4&quot;, nome = &quot;i4&quot;, quantidade = 40, categoria =
&quot;categoriaD&quot;}),(&quot;item5&quot;,Item {itemID = &quot;item5&quot;, nome = &quot;i5&quot;, quantidade = 50, categoria =
&quot;categoriaE&quot;}),(&quot;item6&quot;,Item {itemID = &quot;item6&quot;, nome = &quot;i6&quot;, quantidade = 60, categoria =
&quot;categoriaF&quot;}),(&quot;item7&quot;,Item {itemID = &quot;item7&quot;, nome = &quot;i7&quot;, quantidade = 70, categoria =
&quot;categoriaG&quot;}),(&quot;item8&quot;,Item {itemID = &quot;item8&quot;, nome = &quot;i8&quot;, quantidade = 80, categoria =
&quot;categoriaH&quot;}),(&quot;item9&quot;,Item {itemID = &quot;item9&quot;, nome = &quot;i9&quot;, quantidade = 90, categoria =
&quot;categoriaI&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; SAIR
Saindo do sistema. Tchau!

...Program finished with exit code 0
Press ENTER to exit console.

Cenário 1: Persistência de Estado (Sucesso)
■ Iniciar o programa (sem arquivos de dados).
[1 of 2] Compiling Main ( main.hs, main.o )
[2 of 2] Linking a.out
--- Sistema de Gerenciamento de Inventário (Haskell) ---
Arquivo Inventario.dat não encontrado. Iniciando inventário vazio.
Arquivo Auditoria.log não encontrado. Iniciando novo log.
Entradas de Log Antigas: 0

--- INVENTÁRIO ATUAL ---
fromList []

Comando (ADD/REMOVE/UPDATE/SAIR) &gt;

■ Adicionar 3 itens.
Comando (ADD/REMOVE/UPDATE/SAIR) &gt; ADD ITEM1 I1 10 categoriaA
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;ITEM1&quot;, nome = &quot;I1&quot;, quantidade = 10,
categoria = &quot;categoriaA&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;ITEM1&quot;,Item {itemID = &quot;ITEM1&quot;, nome = &quot;I1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; ADD ITEM2 I2 20 categoriaB
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;ITEM2&quot;, nome = &quot;I2&quot;, quantidade = 20,
categoria = &quot;categoriaB&quot;}
--- INVENTÁRIO ATUAL ---
fromList [(&quot;ITEM1&quot;,Item {itemID = &quot;ITEM1&quot;, nome = &quot;I1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;ITEM2&quot;,Item {itemID = &quot;ITEM2&quot;, nome = &quot;I2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt; ADD ITEM3 I3 30 categoriaC
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;ITEM3&quot;, nome = &quot;I3&quot;, quantidade = 30,
categoria = &quot;categoriaC&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;ITEM1&quot;,Item {itemID = &quot;ITEM1&quot;, nome = &quot;I1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;ITEM2&quot;,Item {itemID = &quot;ITEM2&quot;, nome = &quot;I2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;ITEM3&quot;,Item {itemID = &quot;ITEM3&quot;, nome = &quot;I3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt;
■ Fechar o programa.
Comando (ADD/REMOVE/UPDATE/SAIR) &gt; SAIR
Saindo do sistema. Tchau!

...Program finished with exit code 0
Press ENTER to exit console.

■ Verificar se os arquivos Inventario.dat e Auditoria.log foram criados.


<img width="492" height="120" alt="image" src="https://github.com/user-attachments/assets/c81e9c18-2ae3-465b-8c02-843b1b9d6d27" />


■ Reiniciar o programa.
[1 of 2] Compiling Main ( main.hs, main.o )
[2 of 2] Linking a.out

--- Sistema de Gerenciamento de Inventário (Haskell) ---
Inventário carregado de Inventario.dat
Log de auditoria carregado de Auditoria.log
Entradas de Log Antigas: 3

--- INVENTÁRIO ATUAL ---
fromList [(&quot;ITEM1&quot;,Item {itemID = &quot;ITEM1&quot;, nome = &quot;I1&quot;, quantidade = 10, categoria =
&quot;categoriaA&quot;}),(&quot;ITEM2&quot;,Item {itemID = &quot;ITEM2&quot;, nome = &quot;I2&quot;, quantidade = 20, categoria =
&quot;categoriaB&quot;}),(&quot;ITEM3&quot;,Item {itemID = &quot;ITEM3&quot;, nome = &quot;I3&quot;, quantidade = 30, categoria =
&quot;categoriaC&quot;})]

Comando (ADD/REMOVE/UPDATE/SAIR) &gt;

■ Executar um comando de &quot;listar&quot; (a ser criado) ou verificar se o estado carregado em
memória contém os 3 itens.
Entendemos que a listagem foi feita automaticamente via verificação do estado carregado em
memória ao iniciar o programa.


Cenário 2: Erro de Lógica (Estoque Insuficiente)
■ Adicionar um item com 10 unidades (ex: &quot;teclado&quot;).
add t1 teclado 10 acessorio
-&gt; Log de auditoria atualizado.
-&gt; Inventário persistido em Inventario.dat
&gt;&gt;&gt; Sucesso: Adicionado Item: Item {itemID = &quot;t1&quot;, nome = &quot;teclado&quot;, quantidade = 10,
categoria = &quot;acessorio&quot;}

--- INVENTÁRIO ATUAL ---
fromList [(&quot;t1&quot;,Item {itemID = &quot;t1&quot;, nome = &quot;teclado&quot;, quantidade = 10, categoria =
&quot;acessorio&quot;})]

■ Tentar remover 15 unidades desse item.
Comando (ADD/REMOVE/UPDATE/SAIR) &gt; remove t1 15
-&gt; Log de auditoria atualizado.
&gt;&gt;&gt; Erro: Estoque insuficiente. Atual: 10

--- INVENTÁRIO ATUAL ---
fromList [(&quot;t1&quot;,Item {itemID = &quot;t1&quot;, nome = &quot;teclado&quot;, quantidade = 10, categoria =
&quot;acessorio&quot;})]

■ Verificar se o programa exibiu uma mensagem de erro clara.
“&gt;&gt;&gt; Erro: Estoque insuficiente. Atual: 10”

■ Verificar se o Inventario.dat (e o estado em memória) ainda mostra 10 unidades.


<img width="886" height="70" alt="image" src="https://github.com/user-attachments/assets/dd3fc274-2602-430e-ad7b-8f5c1d2d708c" />

■ Verificar se o Auditoria.log contém uma LogEntry com StatusLog (Falha ...).

<img width="886" height="43" alt="image" src="https://github.com/user-attachments/assets/26fffd9b-8be5-4845-915f-fd711ced28df" />


Cenário 3: Geração de Relatório de Erros

■ Após executar o Cenário 2, executar o comando report.
Comando (ADD/REMOVE/UPDATE/SAIR) &gt; REPORT
Log de auditoria carregado de Auditoria.log
&gt;&gt;&gt; --- RELATÓRIO DE AUDITORIA ---
1. Erros de Lógica (1 falhas):
[2025-11-13 21:10:15.701434357 UTC] Erro: Estoque insuficiente. Atual: 10
2. Item Mais Movimentado: N/A (Log vazio)

--- INVENTÁRIO ATUAL ---
fromList [(&quot;t1&quot;,Item {itemID = &quot;t1&quot;, nome = &quot;teclado&quot;, quantidade = 10, categoria =
&quot;acessorio&quot;})]

■ Verificar se o relatório gerado (especificamente pela função logsDeErro) exibe a
entrada de log referente à falha registrada no Cenário 2 (a tentativa de remover
estoque insuficiente).
“1. Erros de Lógica (1 falhas):
[2025-11-13 21:10:15.701434357 UTC] Erro: Estoque insuficiente. Atual: 10”


