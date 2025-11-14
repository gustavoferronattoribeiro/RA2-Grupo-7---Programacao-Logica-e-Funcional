-- DEFINIÇÕES DE ARQUIVO E I/O

inventarioFile :: FilePath
inventarioFile = "Inventario.dat"

logFile :: FilePath
logFile = "Auditoria.log"

-- Tenta ler o arquivo de Inventário, tratando ausencia do arquivo
lerInventario :: IO Inventario
lerInventario = do
    catch (do
        conteudo <- readFile inventarioFile
        putStrLn $ "Inventário carregado de " ++ inventarioFile
        return (read conteudo)
        )
        (\e -> if isDoesNotExistError e
               then do
                   putStrLn $ "Arquivo " ++ inventarioFile ++ " não encontrado. Iniciando inventário vazio."
                   return Map.empty
               else do
                   -- CORREÇÃO: Removemos a anotação de tipo (e :: SomeException)
                   putStrLn $ "Erro ao carregar inventário: " ++ show e
                   return Map.empty
        )

-- Tenta ler o arquivo de Log (apenas para exibição inicial) tratando ausencia
lerLog :: IO [LogEntry]
lerLog = do
    catch (do
        conteudo <- readFile logFile
        putStrLn $ "Log de auditoria carregado de " ++ logFile
        let logs = map readMaybe (lines conteudo)
        return [log | Just log <- logs]
        )
        (\e -> if isDoesNotExistError e
               then do
                   putStrLn $ "Arquivo " ++ logFile ++ " não encontrado. Iniciando novo log."
                   return []
               else do
                   -- CORREÇÃO: Removemos a anotação de tipo (e :: SomeException)
                   putStrLn $ "Erro ao carregar log: " ++ show e
                   return []
        )

-- Persiste o Inventário no arquivo
persistirInventario :: Inventario -> IO ()
persistirInventario inv = do
    writeFile inventarioFile (show inv)
    putStrLn $ "-> Inventário persistido em " ++ inventarioFile

-- Adiciona uma nova entrada de Log no arquivo
anexarLog :: LogEntry -> IO ()
anexarLog logEntry = do
    appendFile logFile (show logEntry ++ "\n")
    putStrLn "-> Log de auditoria atualizado."

-- LOOP PRINCIPAL main IO

-- | A função principal do programa.
main :: IO ()
main = do
    putStrLn "--- Sistema de Gerenciamento de Inventário (Haskell) ---"

    -- 1. Inicialização: Tenta carregar o estado
    estadoInicial <- lerInventario
    logInicial <- lerLog
    putStrLn $ "Entradas de Log Antigas: " ++ show (length logInicial)

    -- 2. Inicia o loop de execucao
    repl estadoInicial

-- | O loop interativo (REPL).
repl :: Inventario -> IO ()
repl estadoAtual = do
    putStrLn "\n--- INVENTÁRIO ATUAL ---"
    putStrLn $ show estadoAtual
    putStr $ "\nComando (ADD/REMOVE/UPDATE/SAIR) > "
    hFlush stdout

    entrada <- getLine

    if map toUpper entrada == "SAIR"
        then putStrLn "Saindo do sistema. Tchau!"
        else do
            -- 3. Loop de execução: Processa o comando
            (novoEstado, mensagem) <- handleComando estadoAtual entrada

            -- 4. Processa o resultado e Persiste
            putStrLn $ ">>> " ++ mensagem
            repl novoEstado

-- Função I/O que obtém o tempo, invoca a lógica pura e persiste.
handleComando :: Inventario -> String -> IO (Inventario, String)
handleComando inv entrada = do
    currentTime <- getCurrentTime -- Obtém o UTCTime atual

    let parts = words entrada

    case parts of
        [] -> handleQueryFail inv currentTime entrada
        (comando:args) -> case map toUpper comando of
            "ADD" -> processarLopicaEDados inv currentTime parts addItemWrapper
            "REMOVE" -> processarLopicaEDados inv currentTime parts removeItemWrapper
            "UPDATE" -> processarLopicaEDados inv currentTime parts updateItemWrapper
            "REPORT" -> handleReport inv currentTime args -- NOVO Comando de Relatório
            _ -> handleQueryFail inv currentTime entrada
            
-- Lida com querys e não altera o estado do inventário, apenas registra no log.
handleQuery :: Inventario -> UTCTime -> [String] -> IO (Inventario, String)
handleQuery inv time args =
    -- Verifica se há argumentos
    case args of
        [] -> 
            let (logAction, logDetails, logStatus, resultMsg) = 
                    (QueryFail "QUERY", "Comando QUERY fornecido sem argumentos.", Falha "Argumentos Faltando", "Erro: O comando QUERY precisa de um subcomando (ID, CATEGORY, LOWSTOCK).")
            in do
                let logEntry = mkLogEntry time logAction logDetails logStatus
                anexarLog logEntry
                return (inv, resultMsg)
        
        -- Se houver argumentos, processa o subcomando (usando pattern matching seguro)
        (subcomando:queryArgs) -> 
            let (logAction, logDetails, logStatus, resultMsg) = case map toUpper subcomando of
                    
                    -- ID: Espera exatamente um argumento (o ID)
                    "ID" -> case queryArgs of
                        (idToFind:[]) -> -- pattern matching: (arg:resto) onde resto é vazio
                            case queryItem idToFind inv of
                                Just item -> (QueryFail $ "QUERY ID " ++ idToFind, "Encontrado item: " ++ show item, Sucesso, "Item encontrado:\n" ++ show item)
                                Nothing -> (QueryFail $ "QUERY ID " ++ idToFind, "Item não encontrado: " ++ idToFind, Falha "Item não encontrado", "Erro: Item '" ++ idToFind ++ "' não encontrado.")
                        _ ->
                            (QueryFail $ unwords ("QUERY":subcomando:queryArgs), "Argumentos insuficientes/excesso para QUERY ID.", Falha "Argumento Inválido", "Erro: Formato: QUERY ID <id>")

                    -- CATEGORY: Espera exatamente um argumento (a categoria)
                    "CATEGORY" -> case queryArgs of
                        (catToFind:[]) -> -- pattern matching: (arg:resto) onde resto é vazio
                            let items = queryByCategory catToFind inv
                                itemCount = length items
                            in (QueryFail $ "QUERY CATEGORY " ++ catToFind, "Encontrados " ++ show itemCount ++ " itens na categoria " ++ catToFind, Sucesso, "Itens na categoria " ++ catToFind ++ " (" ++ show itemCount ++ "):\n" ++ unlines (map show items))
                        _ ->
                            (QueryFail $ unwords ("QUERY":subcomando:queryArgs), "Argumentos insuficientes/excesso para QUERY CATEGORY.", Falha "Argumento Inválido", "Erro: Formato: QUERY CATEGORY <cat>")

                    -- LOWSTOCK: Espera exatamente um argumento (o limite)
                    "LOWSTOCK" -> case queryArgs of
                        (limitStr:[]) ->
                            case readMaybe limitStr :: Maybe Int of
                                Just limit ->
                                    let items = queryLowStock limit inv
                                        itemCount = length items
                                    in (QueryFail $ "QUERY LOWSTOCK " ++ show limit, "Encontrados " ++ show itemCount ++ " itens abaixo de " ++ show limit, Sucesso, "Itens com estoque baixo (" ++ show itemCount ++ "):\n" ++ unlines (map show items))
                                Nothing ->
                                    (QueryFail $ unwords ("QUERY":subcomando:queryArgs), "Limite de estoque inválido.", Falha "Limite inválido", "Erro: Limite de estoque deve ser um número inteiro.")
                        _ ->
                            (QueryFail $ unwords ("QUERY":subcomando:queryArgs), "Argumentos insuficientes/excesso para QUERY LOWSTOCK.", Falha "Argumento Inválido", "Erro: Formato: QUERY LOWSTOCK <limite>")

                    _ ->
                        (QueryFail $ unwords (subcomando:queryArgs), "Subcomando QUERY inválido.", Falha "Comando QUERY inválido", "Erro: Subcomando QUERY não reconhecido. Tente ID, CATEGORY ou LOWSTOCK.")
            
            in do
                -- Registra a consulta no log (mesmo que seja apenas leitura)
                let logEntry = mkLogEntry time logAction logDetails logStatus
                anexarLog logEntry
                -- Retorna o estado original (inv) e a mensagem de resultado.
                return (inv, resultMsg)

-- Wrapper genérico para chamar a lógica pura, tratar o Either e persistir
processarLopicaEDados :: Inventario -> UTCTime -> [String]
                     -> (Inventario -> UTCTime -> [String] -> Either String ResultadoOperacao)
                     -> IO (Inventario, String)
processarLopicaEDados inv time parts logicWrapper =
    case logicWrapper inv time parts of
        -- Sucesso (Right): Persiste o novo inventário e o log
        Right (newInv, logEntry) -> do
            anexarLog logEntry
            persistirInventario newInv
            return (newInv, show (status logEntry) ++ ": " ++ detalhes logEntry)

        -- Falha (Left): Cria e Persiste apenas o log de falha (o estado não muda)
        Left err -> do
            let logEntry = mkLogEntry time (QueryFail (unwords parts)) err (Falha err)
            anexarLog logEntry
            return (inv, err) -- Retorna o estado original (inv) e a mensagem de erro


-- Funções Wrapper para ajustar o parsing antes de chamar a função Pura (Simplificação)
-- Nota: Estas funções são uma ponte entre o I/O (parsing de string) e a função pura.
addItemWrapper :: Inventario -> UTCTime -> [String] -> Either String ResultadoOperacao
addItemWrapper inv time (_:id:nome:qtdStr:cat:_) =
    case readMaybe qtdStr of
        Just qtd -> addItem time id nome qtd cat inv
        Nothing -> Left "Erro de Parse: Quantidade inválida para ADD."
addItemWrapper _ _ _ = Left "Erro de Parse: Formato ADD incorreto. Ex: ADD P10 Parafuso 100 Ferragens"

removeItemWrapper :: Inventario -> UTCTime -> [String] -> Either String ResultadoOperacao
removeItemWrapper inv time (_:id:qtdStr:_) =
    case readMaybe qtdStr of
        Just qtd -> removeItem time id qtd inv
        Nothing -> Left "Erro de Parse: Quantidade inválida para REMOVE."
removeItemWrapper _ _ _ = Left "Erro de Parse: Formato REMOVE incorreto. Ex: REMOVE P10 10"

updateItemWrapper :: Inventario -> UTCTime -> [String] -> Either String ResultadoOperacao
updateItemWrapper inv time (_:id:newQtdStr:_) =
    case readMaybe newQtdStr of
        Just newQtd -> updateItem time id newQtd inv
        Nothing -> Left "Erro de Parse: Nova quantidade inválida para UPDATE."
updateItemWrapper _ _ _ = Left "Erro de Parse: Formato UPDATE incorreto. Ex: UPDATE P10 200"

handleQueryFail :: Inventario -> UTCTime -> String -> IO (Inventario, String)
handleQueryFail inv time entrada = do
    let logEntry = mkLogEntry time (QueryFail entrada) "Comando não reconhecido ou formato inválido." (Falha "Comando inválido.")
    anexarLog logEntry
    return (inv, "Comando desconhecido ou formato incorreto. O erro foi logado.")