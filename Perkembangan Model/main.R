setwd("C:/Users/reyza/OneDrive/Documents/BISMILLAH SKRIPSI/ThesisTemp")
library(car)
library(stats)

source("Model/Testing.R")
source("Model/Preprocessing.R")
source("Model/modeling.R")


#Cleaning The Data
df.main <- load.data.cleaned("Model/newData.xlsx")

#Summary Data
summary(df.main)
hist(df.main$TFR)

#Exporting to Shiny
# exportShiny(df.main)

# Linear Regression
model.lm <- modelTheData.base(df.main)
summary(model.lm)

# Uji asumsi regresi linear berganda
testLinearAssumption(model.lm)
vif(model.lm)

# Plottting moran dan mapping 
coordinates <- cbind(df.main$Long, df.main$Lat)
library(spdep)

neighbors <- knn2nb(knearneigh(coordinates, k = 5, longlat = TRUE))  # 6 makes more sense
list.neighbors <- nb2listw(neighbors, style = "W")

library(rnaturalearth)
library(sf)
world <- ne_countries(scale = "medium", returnclass = "sf")
indonesia <- subset(world, admin == "Indonesia")

plot(st_geometry(indonesia), col = "darkgrey", main = "Plot of Points with 5 Neighbors")
plot(neighbors, coordinates, add = TRUE, pch = 20, col = "blue")

# Moran Plot
moran.plot(df.main$IKG, listw=list.neighbors, 
           xlab="Indeks Ketimpangan Gender", 
           ylab="Lagged",
           main=c("Spatial"))

# Moran Test
moran.test(df.main$IKG, listw = list.neighbors)
lm.morantest(model.lm, list.neighbors)


# Based on these test, kayaknya yang Error lebih masuk akal, Local
lm.RStests(model.lm, list.neighbors, test = "all")

# Pemodelan Spasial  
library(spatialreg)

form <- "IKG ~ Wpar + Wwork + Unourish + Childbirth + Wsumbang + TFR"
# Spatially Lagged X

options(scipen = 10)
lagX <- lmSLX(form, data = df.main,list.neighbors)
summary(lagX)
# View direct, indirect, and total effects
summary(impacts(lagX, listw = list.neighbors, R = 1000), zstats = TRUE)

# Lag Y, Spatial Autoregressive
sarModel <- modelTheData.SAR(df.main,list.neighbors)
summary(sarModel)
# View direct, indirect, and total effects
summary(impacts(sarModel, listw = list.neighbors, R = 1000), zstats = TRUE)

#Spatial Error Model
semModel <- modelTheData.SEM(df.main, list.neighbors)
summary(semModel)

# H0 : There is no significan divergence between OLS and SEM parameters (good)
# H1 : There is  significan divergence between OLS and SEM parameters (bad)
spatialreg::Hausman.test(semModel)

#Spatial Durbin Model
sdmModel <- modelTheData.SDM(df.main,list.neighbors) 

#Spatial Durbin Error Model
sdemModel <- errorsarlm(form, df.main, list.neighbors, Durbin = TRUE)
spatialreg::Hausman.test(sdemModel)

summary(sdemModel)

options(scipen = 7)
summary(lagX)
summary(sarModel)
summary(semModel)
summary(sdmModel)
summary(sdemModel)

# LR Testing
# H0 : make it simpler
# H1 : make it complex

library(spatialreg)
LR.Sarlm(sdmModel, sarModel)
LR.Sarlm(sdmModel, lagX)
LR.Sarlm(sdmModel, model.lm)


LR.Sarlm(sdemModel, lagX)
LR.Sarlm(sdemModel, model.lm)

#Wald Test
car::linearHypothesis(sdmModel, c(
  "Wpar = 0",
  "Wwork = 0",
  "Unourish = 0",
  "Childbirth = 0",
  "Wsumbang = 0",
  "TFR = 0",
  "lag.Wpar = 0",
  "lag.Wwork = 0",
  "lag.Unourish = 0",
  "lag.Childbirth = 0",
  "lag.Wsumbang = 0",
  "lag.TFR = 0"
))


# View direct, indirect, and total effects p-values
impact.sdm <- summary(impacts(sdmModel, listw = list.neighbors, R = 1000), zstats = TRUE)
impact.sdm
summary(sdmModel)


#check for Normality
lillie.test(resid(sdmModel))

#check for autocor
s <- summary(sdmModel)

sdmFitted <-s$residuals
# Moran's I test on residuals
moran.test(sdmFitted, list.neighbors)


bptest.Sarlm(sdmModel)
# There is hetorscedasticity

summary(sdmModel)

model_summary(sdemModel, df.main$IKG)
model_summary(sdmModel, df.main$IKG)
model_summary(lagX, df.main$IKG)
model_summary(sarModel, df.main$IKG)
model_summary(semModel, df.main$IKG)
model_summary(model.lm, df.main$IKG)



# View direct, indirect, and total effects
summary(impacts(sdmModel, listw = list.neighbors, R = 1000), zstats = TRUE)


#saving Model ke RDS
saveRDS(sdmModel, file = "Model//model_sdm.rds")
