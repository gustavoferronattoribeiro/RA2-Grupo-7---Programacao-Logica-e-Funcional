-- FUNÇÕES PURAS DE ANÁLISE DE LOGS (Relatórios e Validação)

-- 7. Filtra todas as entradas de log que resultaram em falha
logsDeErro :: [LogEntry] -> [LogEntry]
logsDeErro logs = filter (\log -> case status log of
                                     Falha _ -> True
                                     Sucesso -> False) logs

-- 8. Gera o histórico de ações para um item específico (filtrando pelo itemID nos detalhes)
historicoPorItem :: String -> [LogEntry] -> [LogEntry]
historicoPorItem id logs = filter (\log -> id `elem` palavrasChave log) logs
    where
        -- Função auxiliar para extrair palavras-chave dos detalhes (simplificação)
        palavrasChave log = words (detalhes log)

-- 9. Encontra o ID do item com o maior número de entradas no log (mais movimentado)
itemMaisMovimentado :: [LogEntry] -> Maybe String
itemMaisMovimentado logs =
    case Map.toList itemCounts of
        [] -> Nothing
        counts -> Just $ fst (maximumBy (compare `on` snd) counts)
    where
        -- Funções auxiliares (requer Data.List, Data.Ord, Data.Function)

        -- Mapeia um LogEntry para o ID relevante (usando um prefixo simples)
        extractID :: LogEntry -> Maybe String
        extractID log =
            case words (detalhes log) of
                ("Adicionado":"Item:":"{":"itemID":":":id:_) -> Just (init id) -- Add
                ("Removido":_:"de":id:_) -> Just (init id) -- Remove
                ("Atualizado":id:_) -> Just (init id) -- Update
                _ -> Nothing

        -- Contagem real dos IDs extraídos
        relevantIDs = [id | Just id <- map extractID logs]
        itemCounts = Map.fromListWith (+) [(id, 1) | id <- relevantIDs]


-- INTEGRAÇÃO DO COMANDO REPORT (Função de I/O)

-- Lida com o comando REPORT. Carrega logs e chama funções puras de análise.
handleReport :: Inventario -> UTCTime -> [String] -> IO (Inventario, String)
handleReport inv time _ = do
    -- 1. Carrega todos os logs do disco (I/O)
    allLogs <- lerLog 

    -- 2. UNIFICANDO TODAS AS DEFINIÇÕES PURAS EM UM SÓ BLOCO 'let'
    let errors = logsDeErro allLogs
        mostMoved = itemMaisMovimentado allLogs
        
        -- Formata o resultado para exibição
        reportTitle = "--- RELATÓRIO DE AUDITORIA ---\n"
        
        -- Relatório de Erros
        errorReport = if null errors
                      then "1. Erros de Lógica: Nenhuma falha encontrada.\n"
                      else "1. Erros de Lógica (" ++ show (length errors) ++ " falhas):\n"
                           ++ unlines (map (\l -> "  [" ++ show (timestamp l) ++ "] " ++ detalhes l) errors)
                           
        -- Item Mais Movimentado
        movedReport = "2. Item Mais Movimentado: " ++ maybe "N/A (Log vazio)" id mostMoved ++ "\n"
        
        -- Cria a LogEntry (não será mais usada para anexar, mas é um bom ADT)
        -- logEntry = mkLogEntry time (QueryFail "REPORT") "Relatório de Auditoria Gerado" Sucesso
        
        -- Cria a mensagem final (agora no mesmo escopo)
        finalMessage = reportTitle ++ errorReport ++ movedReport

    -- REMOVEMOS A LINHA 'anexarLog logEntry' DAQUI PARA RESOLVER O BLOQUEIO DE I/O

    -- 3. Retorna o estado inalterado e a mensagem do relatório
    return (inv, finalMessage)