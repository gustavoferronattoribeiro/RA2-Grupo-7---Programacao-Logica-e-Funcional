-- FUNÇÕES PURAS (LÓGICA DE NEGÓCIO)

-- Funcao auxiliar para criar uma LogEntry.
mkLogEntry :: UTCTime -> AcaoLog -> String -> StatusLog -> LogEntry
mkLogEntry time act details st = LogEntry
    { timestamp = time
    , acao = act
    , detalhes = details
    , status = st
    }

-- Adiciona um novo Item ao inventario
addItem :: UTCTime -> String -> String -> Int -> String -> Inventario
        -> Either String ResultadoOperacao
addItem time id nome qtd cat inv
    | Map.member id inv =
        Left $ "Erro: Item com ID '" ++ id ++ "' já existe. Use UPDATE."
    | qtd <= 0 =
        Left $ "Erro: Quantidade para adição deve ser positiva."
    | otherwise =
        let newItem = Item id nome qtd cat
            newInv = Map.insert id newItem inv
            logDetails = "Adicionado Item: " ++ show newItem
            logEntry = mkLogEntry time Add logDetails Sucesso
        in Right (newInv, logEntry)

-- Remove (diminui quantidade) de um Item existente
removeItem :: UTCTime -> String -> Int -> Inventario
           -> Either String ResultadoOperacao
removeItem time id qtdToRemove inv =
    case Map.lookup id inv of
        Nothing ->
            Left $ "Erro: Item com ID '" ++ id ++ "' não encontrado."

        Just item ->
            if qtdToRemove > quantidade item
                then Left $ "Erro: Estoque insuficiente. Atual: " ++ show (quantidade item)
                else
                    let newQtd = quantidade item - qtdToRemove
                        newInv = if newQtd <= 0
                                 then Map.delete id inv
                                 else Map.insert id item { quantidade = newQtd } inv
                        logDetails = "Removido " ++ show qtdToRemove ++ " de " ++ id ++ ". Nova Qtd: " ++ show newQtd
                        logEntry = mkLogEntry time Remove logDetails Sucesso
                    in Right (newInv, logEntry)

-- Atualiza a quantidade de um Item existente
updateItem :: UTCTime -> String -> Int -> Inventario
           -> Either String ResultadoOperacao
updateItem time id newQtd inv =
    case Map.lookup id inv of
        Nothing ->
            Left $ "Erro: Item com ID '" ++ id ++ "' não encontrado para atualização."

        Just item ->
            if newQtd < 0
                then Left $ "Erro: Nova quantidade deve ser não negativa."
                else
                    let newInv = Map.insert id item { quantidade = newQtd } inv
                        logDetails = "Atualizado " ++ id ++ ". Nova Qtd: " ++ show newQtd
                        logEntry = mkLogEntry time Update logDetails Sucesso
                    in Right (newInv, logEntry)

--Consulta um Item pelo ID. Retorna Maybe Item
queryItem :: String -> Inventario -> Maybe Item
queryItem id inv = Map.lookup id inv

-- Lista todos os Itens de uma categoria especifica
queryByCategory :: String -> Inventario -> [Item]
queryByCategory cat inv =
    Map.elems $ Map.filter (\item -> categoria item == cat) inv

-- Lista Itens com quantidade abaixo de um limite (estoque baixo)
queryLowStock :: Int -> Inventario -> [Item]
queryLowStock limite inv =
    Map.elems $ Map.filter (\item -> quantidade item < limite) inv