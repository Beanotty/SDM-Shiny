library(readxl)

load.data.cleaned <- function(path){
  
  data_raw <- read_excel(path, sheet = "Data") 
  data.filtered <- data_raw[data_raw$Filter == FALSE,]
  data.filtered
  # Data Preprocesssing ####
  dataFirst <- data.filtered[,1:ncol(data.filtered)]
  dataFirst
  library(dplyr)
  
  dataFirst <- dataFirst %>% 
    mutate_at(c(2:ncol(dataFirst)), as.numeric)
  
  # Omitting missing values / maybe or maybe not ini dipakai, 
  # soalnya bisa memengaruhi apa yang diitung
  dataModeling <- na.omit(dataFirst)
  dataX <-  dataModeling %>% 
    select(-IKG, -Filter, -Longitude, -Latitude, -`Kabupaten/Kota`)
  
  
  data.lm <- as.data.frame(cbind(Names = dataModeling$`Kabupaten/Kota`,
                                 IKG = dataModeling$IKG,
                                 dataX, 
                                 Long = dataModeling$Longitude,
                                 Lat = dataModeling$Latitude))
  
}

exportShiny <- function(data){
  library(xlsx)
  write.xlsx(data, "Model/forShiny.xlsx", row.names = FALSE)
}
