# Script: code/openalex_bibliometric_analysis.R
# Descrição: Este script realiza uma análise bibliométrica de artigos do OpenAlex, focando em
# temas relacionados ao direito à alimentação e segurança alimentar. O script filtra artigos com
# base em palavras-chave no abstract, gera gráficos exploratórios (produção por ano, citações por
# ano, relação entre FWCI e citações), e cria uma nuvem de palavras a partir dos abstracts. Os
# resultados (gráficos e tabelas) são salvos nos diretórios figures/ e tables/, enquanto as bases
# intermediárias são salvas em data/.

# --- Carrega os Pacotes Necessários ---
library(tidyverse)      # Inclui dplyr, tidyr, ggplot2, e outras ferramentas para manipulação e visualização
library(data.table)     # Para leitura rápida de arquivos (embora não seja usado aqui, mantido por compatibilidade)
library(ggwordcloud)    # Para criar nuvens de palavras
library(tm)             # Para processamento de texto (criação de corpus e matriz de termos)
library(readxl)         # Para leitura de arquivos Excel
library(writexl)        # Para escrita de arquivos Excel

# --- Configurações Iniciais ---
# Define o diretório de trabalho como o diretório do script (funciona no RStudio)
# Isso garante que os caminhos relativos sejam interpretados a partir de code/
if (rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
} else {
  warning("RStudio API não disponível. Certifique-se de que o diretório de trabalho está definido como o diretório code/.")
}

# Verifica o diretório de trabalho atual
cat("Diretório de trabalho atual:", getwd(), "\n")

# Cria os diretórios figures/, tables/ e data/ na raiz do projeto, se não existirem
# O script está em code/, então usamos ../ para subir um nível até a raiz
dir.create("../figures", showWarnings = FALSE)
dir.create("../tables", showWarnings = FALSE)
dir.create("../data", showWarnings = FALSE)

# --- Carrega a Base de Dados do OpenAlex ---
# Caminho relativo para o arquivo de dados
data_file <- "../data/plan_art_dt_alim_nova.xlsx"

# Verifica se o arquivo existe
if (!file.exists(data_file)) {
  stop("Arquivo de dados plan_art_dt_alim_nova.xlsx não encontrado no diretório data/. Certifique-se de que o arquivo está presente.")
}

# Carrega os dados usando read_xlsx
df_rev_alim <- read_xlsx(data_file)

# Verifica se as colunas esperadas estão presentes
expected_cols <- c("abstract", "publication_year", "cited_by_count", "fwci", "authorships.raw_author_name")
missing_cols <- setdiff(expected_cols, colnames(df_rev_alim))
if (length(missing_cols) > 0) {
  stop(paste("As seguintes colunas estão ausentes no arquivo de dados:", paste(missing_cols, collapse = ", ")))
}

# --- Filtragem de Artigos Relevantes ---
# Define palavras-chave relacionadas ao direito à alimentação e segurança alimentar
keywords <- c(
  "direito à alimentação", "direito humano à alimentação", "direito social à alimentação",
  "segurança alimentar", "segurança nutricional", "segurança alimentar e nutricional",
  "alimentação adequada", "soberania alimentar"
)

# Cria um padrão regex para filtrar artigos pelo abstract (case-insensitive)
pattern <- paste(keywords, collapse = "|")

# Filtra artigos cujo abstract contém pelo menos uma das palavras-chave
# Calcula o número de autores por artigo com base na coluna authorships.raw_author_name
df_rev_alim1 <- df_rev_alim %>%
  filter(grepl(pattern, abstract, ignore.case = TRUE)) %>%
  mutate(n_author = str_count(authorships.raw_author_name, "\\|") + 1)

# Exibe um resumo inicial dos dados após a filtragem
cat("Resumo dos dados após filtragem por palavras-chave:\n")
print(summary(df_rev_alim1))

# Cria uma base filtrada para revisão narrativa (artigos com pelo menos 10 citações)
df_rev_alim2 <- df_rev_alim1 %>%
  filter(!is.na(publication_year)) %>%
  filter(as.numeric(cited_by_count) >= 10)

# --- Gera Gráficos Exploratórios ---

# Gráfico 1: Quantidade de artigos por ano (barras)
df_articles_per_year <- df_rev_alim1 %>%
  count(publication_year)

p1 <- ggplot(df_articles_per_year, aes(x = publication_year, y = n)) +
  geom_col(fill = "steelblue") +
  theme_minimal() +
  labs(
    x = "Ano de Publicação",
    y = "Número de Artigos",
    title = "Produção Acadêmica por Ano",
    subtitle = "Número de artigos publicados por ano após filtragem por palavras-chave"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Gráfico 2: Evolução temporal da produção (linha)
p2 <- ggplot(df_articles_per_year, aes(x = publication_year, y = n)) +
  geom_line(group = 1, color = "darkred") +
  geom_point(color = "darkred", size = 3) +
  theme_minimal() +
  labs(
    x = "Ano de Publicação",
    y = "Número de Artigos",
    title = "Evolução da Produção Acadêmica ao Longo do Tempo",
    subtitle = "Tendência temporal do número de artigos publicados"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Gráfico 3: Total de citações por ano
p3 <- ggplot(df_rev_alim1, aes(x = as.factor(publication_year), y = as.numeric(cited_by_count))) +
  geom_col(fill = "forestgreen") +
  theme_minimal() +
  labs(
    x = "Ano de Publicação",
    y = "Total de Citações",
    title = "Citações Acumuladas por Ano",
    subtitle = "Soma das citações recebidas por artigos publicados em cada ano"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Gráfico 4: Correlação entre FWCI e citações
p4 <- ggplot(df_rev_alim1, aes(x = as.numeric(fwci), y = as.numeric(cited_by_count))) +
  geom_point(color = "darkblue", alpha = 0.7) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  theme_minimal() +
  labs(
    x = "Field-Weighted Citation Impact (FWCI)",
    y = "Número de Citações",
    title = "Relação entre FWCI e Número de Citações",
    subtitle = "Dispersão com linha de regressão linear"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

# --- Processamento de Texto para Nuvem de Palavras ---
# Cria um corpus a partir dos abstracts
corpus <- Corpus(VectorSource(df_rev_alim1$abstract))

# Limpa o texto: converte para minúsculas, remove pontuação, números e stopwords
corpus <- corpus %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords("portuguese")) %>%
  tm_map(stripWhitespace)

# Remove palavras irrelevantes específicas do contexto (ajuste conforme necessário)
custom_stopwords <- c("artigo", "estudo", "pesquisa", "resultados", "métodos")
corpus <- tm_map(corpus, removeWords, custom_stopwords)

# Cria uma matriz de termos e calcula a frequência das palavras
dtm <- TermDocumentMatrix(corpus)
m <- as.matrix(dtm)
word_freqs <- sort(rowSums(m), decreasing = TRUE)
df_words <- data.frame(word = names(word_freqs), freq = word_freqs)

# Gráfico 5: Nuvem de palavras com as 50 palavras mais frequentes
p5 <- df_words %>%
  top_n(50, freq) %>%
  ggplot(aes(label = word, size = freq, color = freq)) +
  geom_text_wordcloud(area_corr_power = 1, shape = "circle") +
  scale_size_area(max_size = 10) +
  scale_color_viridis_c(option = "plasma") +
  theme_minimal() +
  labs(
    title = "Nuvem de Palavras dos Abstracts",
    subtitle = "50 palavras mais frequentes após limpeza de texto"
  ) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

# --- Salva os Gráficos como Arquivos PNG ---
# Salva os gráficos no diretório figures/ na raiz do projeto
# As dimensões (8x6 polegadas) e resolução (300 DPI) são adequadas para publicação
ggsave("../figures/articles_per_year_bar.png", plot = p1, width = 8, height = 6, dpi = 300)
ggsave("../figures/articles_per_year_line.png", plot = p2, width = 8, height = 6, dpi = 300)
ggsave("../figures/citations_per_year.png", plot = p3, width = 8, height = 6, dpi = 300)
ggsave("../figures/fwci_vs_citations.png", plot = p4, width = 8, height = 6, dpi = 300)
ggsave("../figures/wordcloud_abstracts.png", plot = p5, width = 8, height = 6, dpi = 300)

# --- Salva as Bases de Dados Intermediárias ---
# Salva as bases filtradas no diretório data/ (bases intermediárias)
write_xlsx(df_rev_alim1, "../data/base_filtrada.xlsx")
write_xlsx(df_rev_alim2, "../data/base_revisao_narrativa.xlsx")

# Salva a tabela de frequências de palavras no diretório tables/ (resultados)
write_csv(df_words, "../tables/word_frequencies.csv")

# --- Opcional: Exibe os Gráficos no R ---
# Descomente as linhas abaixo para visualizar os gráficos no RStudio ou console
# print(p1)
# print(p2)
# print(p3)
# print(p4)
# print(p5)

# Libera memória após a execução
gc()