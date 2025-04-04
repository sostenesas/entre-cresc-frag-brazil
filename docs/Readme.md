# Entre crescimento e fragmentação

Este repositório contém os materiais do artigo "Entre Crescimento e Fragmentação: O Direito à Alimentação na Pesquisa Acadêmica Brasileira (2014-2023)".

## Estrutura do Repositório
- **manuscript/**: Manuscrito do artigo (word).
- **data/**: Dados utilizados, com as bases geradas mais um arquivo na extensão RIS para uso adicional e um arquivo de DOI's, extraídos da base bruta, para possível revisão narrativa.
- **code/**: Scripts para análise (quantitativa) sendo um mais simples usado na submissão do artigo e outro mais completo e comentado.
- **figures/**: Gráficos gerados para o artigo.
- **tables/**: Tabelas com resultados.
- **docs/**: Documentação adicional.
- **references/**: Arquivos de referências (BibTeX).

## Como Reproduzir os Resultados
1. Clone este repositório: `git clone https://github.com/sostenesas/entre-cresc-frag-brazil.git`
2. Instale as dependências (e.g., R, pacotes como `tidyverse`).
3. Execute os scripts  `analise_bibliometrica_dt_alimentacao.R` e `script_R_analise_bibliometrica_original` em `code/`.
4. Os resultados dos scripts serão gerados em `figures/` e `tables/`.

## Dados
Os dados são provenientes da base bibliográfica da plataforma OpenAlex. Consulte `data/data_description.md` para instruções de acesso via OpenAlex. Há também dados do Google Trends sobre a busca de termos-chave (`time_line_term_dt_alim.txt`) que deve ser processado em script próprio.

## Licença
Este projeto está licenciado sob [MIT License](LICENSE).

## Contato
Para dúvidas, entre em contato com [sostenes.soeiro@gmail.com].
