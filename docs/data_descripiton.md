# Descrição dos Dados
Os dados utilizados neste estudo são da Plataforma OpenAlex,
disponíveis no site desta. Para acessá-los:
1. Visite o site do OpenAlex: [https://openalex.org/].
2. Efetue a consulta conforme os parâmetros do trabalho.
    1) em fulltext usamos como termos de busca “direito à alimentação or direito and alimentação”;]
    2) em title&abstract usamos como termos de busca “direito à alimentação or direito and alimentação”;
    3) em country escolhemos a opção “Brazil”;
    4) em language escolhemos “portuguese”;
    5) em year escolhemos “2014-2023” e;
    6) e em work escolhemos “open access published”;
    7) Os dados podem ser baixados nos formatos RIS, CSV e TXT, recomenda-se os dois primeiros;
    8) caso seja baixado em formato CSV, tratar antes no EXCEL e salvá-lo em XLSX.
3. Siga as instruções em `code/` para processar os dados.
4. Uma parte dos dados foi usado para gerar análises bibliométricas no VOSviewer. Utilize os DOI's da pasta 'data' ou extraía da base. Esses DOI's alimentam o VOSviewer e geram análises de rede, citações, etc. As análises nesse software podem variar conformas as configurações usadas. As análises geradas para o artigo estão na pasta 'figures' com títulos 'vos_an_dt_alim'.
