# 0) Configurações iniciais -----------------------------------------------

# 0.1) Limpando R
rm(list = ls())
cat("\014")

# 0.2) Importando funções
purrr::map(paste0("functions/", list.files("functions/", pattern = ".R$")), source)

# 0.3) Definindo o horizonte de previsão, isto é, quantidade de meses
n_previsao <- 12

# 0.4) Definindo configurações de gráficos
size_line <- 1.2
color_line <- "black"
size_title <- 16
size_axis_title <- 14
size_axis_text <- 12

# 1) Baixando dados -------------------------------------------------------

# 1.1) Açúcar
utils::download.file(url = "https://cepea.esalq.usp.br/br/indicador/series/acucar.aspx?id=53",
                     destfile = "inputs/cepea_acucar.xls",
                     mode = "wb")

# 1.2) Etanol
utils::download.file(url = "https://cepea.esalq.usp.br/br/indicador/series/etanol.aspx?id=103",
                     destfile = "inputs/cepea_etanol.xls",
                     mode = "wb")

# 1.3) Soja
utils::download.file(url = "https://cepea.esalq.usp.br/br/indicador/series/soja.aspx?id=92",
                     destfile = "inputs/cepea_soja.xls",
                     mode = "wb")

# 2) Lendo dados ----------------------------------------------------------

# Aviso: é necessário realizar um processo manual para ler as bases de dados, 
# isto é, deve-se abrir as planilhas em xls e salvá-las como xlsx.

# 2.1) Açúcar
df_acucar <- readxl::read_xlsx(path = "inputs/cepea_acucar.xlsx", 
                               sheet = "Plan 1",
                               skip = 3)

# 2.2) Etanol
df_etanol <- readxl::read_xlsx(path = "inputs/cepea_etanol.xlsx", 
                               sheet = "Plan 1",
                               skip = 3)

# 2.3) Soja
df_soja <- readxl::read_xlsx(path = "inputs/cepea_soja.xlsx", 
                               sheet = "Plan 1",
                               skip = 3)

# 3) Tratando dataframes --------------------------------------------------

# Tratamento: transformação do formato da coluna de data e cáculo da cotação
# média mensal.

# 3.1) Açúcar
df_acucar_final <- 
  trata_dados(df = df_acucar,
              variavel = "ind_acucar")

# 3.2) Etanol
df_etanol_final <- 
  trata_dados(df = df_etanol,
              variavel = "ind_etanol")

# 3.3) Soja
df_soja_final <- 
  trata_dados(df = df_soja,
              variavel = "ind_soja")

# 4) Plotando séries ------------------------------------------------------

# 4.1) Açúcar
ggplotly(
  ggplot(df_acucar_final, aes(x = data, y = ind_acucar)) +
           geom_line(color = color_line, size = size_line) +
           labs(x = "Data", 
                y = "Indicador Médio Mensal (R$)",
                title = "Indicador do Açúcar Cristal Branco Médio Mensal") +
           theme_minimal() +
           theme(
             plot.title = element_text(size = size_title, face = "bold"),
             axis.title.x = element_text(size = size_axis_title),
             axis.title.y = element_text(size = size_axis_title),
             axis.text.x = element_text(size = size_axis_text),
             axis.text.y = element_text(size = size_axis_text))
  )

# 4.2) Etanol
ggplotly(
  ggplot(df_etanol_final, aes(x = data, y = ind_etanol)) +
    geom_line(color = color_line, size = size_line) +
    labs(x = "Data", 
         y = "Indicador Médio Mensal (R$)",
         title = "Indicador do Etanol Hidratado Médio Mensal") +
    theme_minimal() +
    theme(
      plot.title = element_text(size = size_title, face = "bold"),
      axis.title.x = element_text(size = size_axis_title),
      axis.title.y = element_text(size = size_axis_title),
      axis.text.x = element_text(size = size_axis_text),
      axis.text.y = element_text(size = size_axis_text))
)

# 4.3) Soja
ggplotly(
  ggplot(df_soja_final, aes(x = data, y = ind_soja)) +
    geom_line(color = color_line, size = size_line) +
    labs(x = "Data", 
         y = "Indicador Médio Mensal (R$)",
         title = "Indicador da Soja Médio Mensal") +
    theme_minimal() +
    theme(
      plot.title = element_text(size = size_title, face = "bold"),
      axis.title.x = element_text(size = size_axis_title),
      axis.title.y = element_text(size = size_axis_title),
      axis.text.x = element_text(size = size_axis_text),
      axis.text.y = element_text(size = size_axis_text))
)

# 5) Decompondo séries ----------------------------------------------------

# 5.1) Açúcar

# 5.1.1) Convertendo data frame para série temporal
acucar_st <- ts(df_acucar_final$ind_acucar, start = c(2003, 5), frequency = 12)

# 5.1.2) Realizando decomposição
acucar_dec <- decompose(acucar_st)

# 5.1.3) Plotando decomposição
plot(acucar_dec)

# 5.2) Etanol

# 5.2.1) Convertendo data frame para série temporal
etanol_st <- ts(df_etanol_final$ind_etanol, start = c(2002, 11), frequency = 12)

# 5.1.2) Realizando decomposição
etanol_dec <- decompose(etanol_st)

# 5.1.3) Plotando decomposição
plot(etanol_dec)

# 5.1) Soja

# 5.1.1) Convertendo data frame para série temporal
soja_st <- ts(df_soja_final$ind_soja, start = c(2006, 3), frequency = 12)

# 5.1.2) Realizando decomposição
soja_dec <- decompose(soja_st)

# 5.1.3) Plotando decomposição
plot(soja_dec)

# 6) Gerando previsões ----------------------------------------------------

# 6.1) Açúcar

# 6.1.1) Gerando ARIMA
arima_acucar <- auto.arima(acucar_st)

# 6.1.2) Realizando previsão
previsao_acucar <- forecast(arima_acucar, h = n_previsao)

# 6.1.3) Apresentando modelo
summary(arima_acucar)

# 6.2) Etanol

# 6.2.1) Gerando ARIMA
arima_etanol <- auto.arima(etanol_st)

# 6.2.2) Realizando previsão
previsao_etanol <- forecast(arima_etanol, h = n_previsao)

# 6.2.3) Apresentando modelo
summary(arima_etanol)

# 6.3) Soja

# 6.3.1) Gerando ARIMA
arima_soja <- auto.arima(soja_st)

# 6.3.2) Realizando previsão
previsao_soja <- forecast(arima_soja, h = n_previsao)

# 6.3.3) Apresentando modelo
summary(arima_soja)

# 7) Analisando previsões -------------------------------------------------

# 7.1) Açúcar

# 7.1.1) Convertendo as previsões para um dataframe
df_previsao_acucar <- set_previsao(previsao = previsao_acucar)

# 7.1.2) Plotando gráfico com projeção
ggplotly(
  ggplot() +
    geom_line(data = df_acucar_final, aes(x = data, y = ind_acucar, color = "Histórico"), size = size_line) +
    geom_line(data = df_previsao_acucar, aes(x = data, y = mean, color = "Previsão"), size = size_line, linetype = "dashed") +
    geom_ribbon(data = df_previsao_acucar, aes(x = data, ymin = lower_80, ymax = upper_80, fill = "Intervalo de 80%"), alpha = 0.3) +
    geom_ribbon(data = df_previsao_acucar, aes(x = data, ymin = lower_95, ymax = upper_95, fill = "Intervalo de 95%"), alpha = 0.3) +
    labs(x = "Data", 
         y = "Indicador Médio Mensal (R$)",
         title = "Previsão do Indicador do Açúcar Cristal Branco Médio Mensal") +
    scale_color_manual(name = NULL, values = c("Histórico" = "black", "Previsão" = "blue")) +
    scale_fill_manual(name = "Legenda", values = c("Intervalo de 80%" = "darkgray", "Intervalo de 95%" = "gray")) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = size_title, face = "bold", hjust = 0.5),
      axis.title.x = element_text(size = size_axis_title),
      axis.title.y = element_text(size = size_axis_title),
      legend.title = element_text(size = size_axis_title, face = "bold"),
      legend.text = element_text(size = size_axis_text),
      axis.text.x = element_text(size = size_axis_text),
      axis.text.y = element_text(size = size_axis_text))
  )

# 7.2) Etanol

# 7.2.1) Convertendo as previsões para um dataframe
df_previsao_etanol <- set_previsao(previsao = previsao_etanol)

# 7.2.2) Plotando gráfico com projeção
ggplotly(
  ggplot() +
    geom_line(data = df_etanol_final, aes(x = data, y = ind_etanol, color = "Histórico"), size = size_line) +
    geom_line(data = df_previsao_etanol, aes(x = data, y = mean, color = "Previsão"), size = size_line, linetype = "dashed") +
    geom_ribbon(data = df_previsao_etanol, aes(x = data, ymin = lower_80, ymax = upper_80, fill = "Intervalo de 80%"), alpha = 0.3) +
    geom_ribbon(data = df_previsao_etanol, aes(x = data, ymin = lower_95, ymax = upper_95, fill = "Intervalo de 95%"), alpha = 0.3) +
    labs(x = "Data", 
         y = "Indicador Médio Mensal (R$)",
         title = "Previsão do Indicador do Etanol Hidratado Médio Mensal") +
    scale_color_manual(name = NULL, values = c("Histórico" = "black", "Previsão" = "blue")) +
    scale_fill_manual(name = "Legenda", values = c("Intervalo de 80%" = "darkgray", "Intervalo de 95%" = "gray")) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = size_title, face = "bold", hjust = 0.5),
      axis.title.x = element_text(size = size_axis_title),
      axis.title.y = element_text(size = size_axis_title),
      legend.title = element_text(size = size_axis_title, face = "bold"),
      legend.text = element_text(size = size_axis_text),
      axis.text.x = element_text(size = size_axis_text),
      axis.text.y = element_text(size = size_axis_text))
  )

# 7.3) Soja

# 7.3.1) Convertendo as previsões para um dataframe
df_previsao_soja <- set_previsao(previsao = previsao_soja)

# 7.3.2) Plotando gráfico com projeção
ggplotly(
  ggplot() +
    geom_line(data = df_soja_final, aes(x = data, y = ind_soja, color = "Histórico"), size = size_line) +
    geom_line(data = df_previsao_soja, aes(x = data, y = mean, color = "Previsão"), size = size_line, linetype = "dashed") +
    geom_ribbon(data = df_previsao_soja, aes(x = data, ymin = lower_80, ymax = upper_80, fill = "Intervalo de 80%"), alpha = 0.3) +
    geom_ribbon(data = df_previsao_soja, aes(x = data, ymin = lower_95, ymax = upper_95, fill = "Intervalo de 95%"), alpha = 0.3) +
    labs(x = "Data", 
         y = "Indicador Médio Mensal (R$)",
         title = "Previsão do Indicador do Soja Hidratado Médio Mensal") +
    scale_color_manual(name = NULL, values = c("Histórico" = "black", "Previsão" = "blue")) +
    scale_fill_manual(name = "Legenda", values = c("Intervalo de 80%" = "darkgray", "Intervalo de 95%" = "gray")) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = size_title, face = "bold", hjust = 0.5),
      axis.title.x = element_text(size = size_axis_title),
      axis.title.y = element_text(size = size_axis_title),
      legend.title = element_text(size = size_axis_title, face = "bold"),
      legend.text = element_text(size = size_axis_text),
      axis.text.x = element_text(size = size_axis_text),
      axis.text.y = element_text(size = size_axis_text))
  )
