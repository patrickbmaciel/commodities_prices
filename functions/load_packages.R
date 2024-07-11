#' @name load_packages
#' @description carrega todos os pacotes necessários do pipeline

# 1) Definindo os pacotes
packages <- c("dplyr", "purrr", "readxl", "forecast", "zoo", "ggplot2", "plotly")

# 2) Carregando os pacotes
sapply(packages, library, character.only = TRUE)
