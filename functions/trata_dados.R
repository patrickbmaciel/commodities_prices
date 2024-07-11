#' @name trata_dados
#' @description realiza transformação do formato da coluna de data e cáculo da 
#' cotação média mensal
#' @param df base de dados do CEPEA
#' @param variavel nome da variável de indicador de preço

trata_dados <- function(df, variavel) {
  
  df <- 
    df %>% 
    dplyr::select(data = Data, !!variavel := `À vista R$`) %>% 
    dplyr::mutate(data = sub("^\\d{2}", "01", data),
                  data = gsub("/", "-", data)) %>% 
    dplyr::mutate(data = format(as.Date(data, format = "%d-%m-%Y"), "%Y-%m-%d"),
                  data = as.Date(data)) %>% 
    dplyr::group_by(data) %>% 
    dplyr::summarise(!!variavel := mean(!!sym(variavel)))
  
  return(df)
  
}
