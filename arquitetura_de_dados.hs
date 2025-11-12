-- TIPOS DE DADOS (DOMÍNIO)

-- Estrutura Item no inventario
data Item = Item
    { itemID     :: String
    , nome       :: String
    , quantidade :: Int
    , categoria  :: String
    } deriving (Show, Read)

-- ADT para o tipo de acao que ocorreu
data AcaoLog
    = Add
    | Remove
    | Update
    | QueryFail String -- Armazena a query que falhou
    deriving (Show, Read)

-- ADT para o Status do resultado da operacao.
data StatusLog
    = Sucesso
    | Falha String -- Armazena a mensagem de erro
    deriving (Show, Read)

-- Registro completo de uma operacao
data LogEntry = LogEntry
    { timestamp :: UTCTime
    , acao      :: AcaoLog
    , detalhes  :: String
    , status    :: StatusLog
    } deriving (Show, Read)

-- Sinonimos de Tipo
type Inventario = Map String Item
type ResultadoOperacao = (Inventario, LogEntry) -- (Novo Estado, Log de Auditoria)