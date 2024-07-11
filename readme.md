# Commodities Prices

## Introdução

O Commodities Prices é um projeto desenvolvido em R com o objetivo de realizar a coleta de indicadores de preço de commodities, tais como açúcar, etanol e soja, a fim de realizar análises econométricas, além de realizar previsões dessas séries temporais.

## Scripts

### analise_commodities

Primeiramente, são realizadas configurações iniciais, incluindo a limpeza do ambiente R, a importação de funções personalizadas e a definição do horizonte de previsão de 12 meses. As configurações dos gráficos também são definidas, especificando o tamanho e a cor das linhas e textos.

Em seguida, o script baixa as séries históricas de preços de açúcar, etanol e soja do site da CEPEA, salvando os arquivos no diretório `inputs/`. Os dados baixados são lidos após um processo manual de conversão de `.xls` para `.xlsx`.

Os dataframes são tratados, sendo geradas colunas de data e cotação média mensal, utilizando a função `trata_dados` para cada um dos indicadores. Após o tratamento, são criados gráficos interativos das séries históricas utilizando `ggplot2` e `plotly`.

O script então converte os dataframes processados em objetos de séries temporais e realiza a decomposição dessas séries para analisar componentes como tendência, sazonalidade e ruído. A decomposição é visualizada em gráficos específicos.

Para as previsões, são ajustados modelos ARIMA para cada série temporal, com previsões futuras baseadas nesses modelos. As previsões são apresentadas em gráficos comparando as séries históricas com as projeções futuras, incluindo intervalos de confiança de 80% e 95%.

Por fim, as previsões são convertidas em dataframes e plotadas em gráficos que mostram a evolução histórica e a projeção dos indicadores de preços.

## Funções

### trata_dados

Transforma o formato da coluna de data e calcula a cotação média mensal de uma base de dados do CEPEA. Ela recebe dois parâmetros: `df`, que é o dataframe com os dados, e `variavel`, que é o nome da variável do indicador de preço.

A função seleciona as colunas de data e do indicador, transforma o formato da data para `"YYYY-MM-DD"` e agrupa os dados por mês, calculando a média do indicador para cada mês. O resultado é um dataframe com as datas e os valores médios mensais do indicador de preço.

### set_previsao

Converte as previsões realizadas pela função `forecast` em um dataframe. Ela recebe um parâmetro, `previsao`, que é o objeto de previsão gerado pela função `forecast`. Cria um dataframe com as datas das previsões, os valores previstos (médias), e os intervalos de confiança de 80% e 95%. O dataframe resultante contém colunas para a data, a média prevista, e os limites inferior e superior dos intervalos de confiança.
