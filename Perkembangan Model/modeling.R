

modelTheData.base <- function(df){
  # Linear Regression
  model <- lm(IKG~ Wpar + Wwork + Unourish+ Childbirth + Wsumbang + TFR, data = df)
  summary(model)
  return(model)
}

modelTheData.SAR <- function(df,listw){
  sarModel <- lagsarlm(IKG~ Wpar + Wwork + Unourish+ 
                         Childbirth + Wsumbang + TFR,
                       data = df, listw = listw)
  
  return(sarModel)
}

modelTheData.SEM <- function(df,listw){
  semModel <- errorsarlm(IKG~ Wpar + Wwork + Unourish+ 
                           Childbirth + Wsumbang + TFR,
                         data = df, listw = listw)
  
  return(semModel)
}

modelTheData.SDM <- function(df,listw){
  sdmModel <- lagsarlm(IKG~ Wpar + Wwork + Unourish+ 
                         Childbirth + Wsumbang + TFR,
                       data = df, listw = listw, Durbin = TRUE)
  
  return(sdmModel)
}


