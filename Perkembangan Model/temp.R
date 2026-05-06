
# ada improvement ish, tapi ngefix spatial dependancy dan spatial autocorrelation
#Outputting to make it show better 
library(stargazer)
stargazer(model.lm,lagX,semModel,sdemModel,sarModel, sdmModel, type = "html",
          title="Regression Results", out = "WebApp/Scripts/Model/hasil.html")

