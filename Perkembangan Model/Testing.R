library(lmtest)
library(nortest)


testLinearAssumption <- function(model){
  lillie <- lillie.test(resid(model))
  dw <- dwtest(model)
  bp <- bptest(model)

  results <- data.frame(
    Test = c("Lilliefors", "Durbin-Watson", "Breusch-Pagan"),
    Statistic = c(lillie$statistic, dw$statistic, bp$statistic),
    P_Value = c(lillie$p.value, dw$p.value, bp$p.value)
  )
  
  print(results)
  
}

testSpatialAutocorrelation <- function(df){
  #spatial Dependency
  library(ape)
  ozone.dists <- as.matrix(dist(cbind(df$Long, df$Lat)))
  which(ozone.dists == 0, arr.ind = TRUE)
  ozone.dists.stable <- ozone.dists
  ozone.dists.stable[ozone.dists.stable < 1e-4] <- 1e-4
  
  ozone.dists.inv <- 1 / ozone.dists.stable
  diag(ozone.dists.inv) <- 0
  print(Moran.I(df$IDG, ozone.dists.inv)$p.value)
}

model_summary <- function(model, actual) {

  resid <- residuals(model)
  
  # Metrics
  mse <- mean(resid^2)
  rmse <- sqrt(mse)
  mape <- mean(abs(resid / actual)) * 100
  mpe <- mean(resid / actual) * 100
  
  sse <- if (!is.null(model$SSE)) model$SSE else sum(resid^2)
  
  # Pseudo R-squared
  pseudo_r2 <- 1 - (sse / (var(actual) * (length(actual) - 1)))
  
  # AIC
  model_aic <- AIC(model)
  
  # Output table
  result <- data.frame(
    MSE = round(mse, 4),
    RMSE = round(rmse, 4),
    MAPE = round(mape, 2),
    MPE = round(mpe, 2),
    Pseudo_R2 = round(pseudo_r2, 4),
    AIC = round(model_aic, 2)
  )
  
  return(result)
}

