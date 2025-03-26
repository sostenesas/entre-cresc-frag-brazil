# Carregamento das bibliotecas necessárias
library(data.table)  # Para manipulação eficiente de dados
library(dplyr)       # Para manipulação de dados
library(ggplot2)     # Para criação de gráficos
library(tidyr)       # Para transformação de dados
library(lubridate)   # Para manipulação de datas

# Definindo o caminho base do projeto de forma mais robusta
base_path <- "C:/Users/Sóstenes/OneDrive - Insper - Instituto de Ensino e Pesquisa/Documentos/Projeto diss/entre-cresc-frag-brasil"
file_path <- file.path(base_path, "data", "time_line_dt_alim.txt")

# Leitura dos dados com verificação de existência do arquivo
if (file.exists(file_path)) {
  time_line <- fread(file_path, encoding = "UTF-8")
} else {
  stop("Arquivo não encontrado no caminho especificado")
}

# Transformação dos dados para formato longo
dados_long <- time_line %>%
  pivot_longer(
    cols = -Mês,              # Mantém a coluna Mês fixa
    names_to = "Termo",       # Nome da coluna com os nomes das variáveis
    values_to = "Contagem"    # Nome da coluna com os valores
  ) %>%
  mutate(
    Ano = ym(Mês),           # Converte Mês para formato de data
    Contagem = as.numeric(Contagem)  # Garante que Contagem seja numérico
  ) %>%
  drop_na()                 # Remove eventuais valores NA

# Criação do gráfico com personalizações
ggplot(dados_long, aes(x = Ano, y = Contagem, color = Termo)) +
  geom_line(size = 0.8) +    # Ajusta a espessura da linha
  geom_point(size = 1.5) +   # Adiciona pontos para melhor visualização
  labs(
    x = "Ano",
    y = "Contagem",
    title = "Evolução Anual dos Termos de Busca",
    subtitle = "Análise Temporal de Tendências",
    color = "Termos"
  ) +
  scale_x_date(
    date_breaks = "1 year",  # Define intervalos de 1 ano no eixo X
    date_labels = "%Y"       # Formata as datas como ano
  ) +
  theme_light() +
  theme(
    plot.title = element_text(hjust = 0.5),     # Centraliza o título
    plot.subtitle = element_text(hjust = 0.5),  # Centraliza o subtítulo
    legend.position = "bottom"                  # Posiciona a legenda embaixo
  )

# Opcional: Salvar o gráfico
ggsave(file.path(base_path, "code", "grafico_evolucao.png"), 
       width = 10, height = 6, dpi = 300)