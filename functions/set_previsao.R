#' @name set_previsao
#' @description converte as previsões para um dataframe
#' @param previsao previsão realizada via função "forecast"

set_previsao <- function(previsao) {
  
  df <- 
    data.frame(
      data = as.Date(as.yearmon(time(previsao$mean))),
      mean = as.numeric(previsao$mean),
      lower_80 = as.numeric(previsao$lower[, 1]),
      upper_80 = as.numeric(previsao$upper[, 1]),
      lower_95 = as.numeric(previsao$lower[, 2]),
      upper_95 = as.numeric(previsao$upper[, 2])
    )
  
  return(df)
  
}
