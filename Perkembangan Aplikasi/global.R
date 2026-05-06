library(shinydashboard)
library(shinythemes)
library(shiny)
library(knitr)
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(kableExtra)
library(markdown)
library(tidyverse)
library(rsconnect)
library(mvnpermute)
library(ggplot2)
library(ggthemes)
library(spdep)
library(spatialreg)
library(tidyr)
library(leaflet)
library(dplyr)
library(DT)
library(shinyFeedback)

roundedBox <-tags$head(
              tags$style(HTML("
                        .roundedBox  {
                        background-color: #3c8dbc !important;  
                        border-radius: 10px !important;
                        border: 1px solid #3c8dbc;
                        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                        color: white !important;
                      }"
                    )
                  )
                )

GeneralText <- tags$head(
                tags$style(HTML("
                                .model-text {
                                  font-size: 13pt;
                                }
                                
                                .model-text .table *{
                                  font-size: 11pt !important ;
                                }
                                
                                .model-text a {
                                  text-decoration: underline !important;
                                  color: blue !important;
                                }

                                .model-text a:hover {
                                  color: darkblue !important;
                                }"
                  )
                )
)

library(readxl)
df <- data.frame(read_excel("Scripts/forShiny.xlsx"))
signifikansiModel <- data.frame(read_excel("Scripts/interpretation.xlsx", sheet = "Sheet1"))
model <- readRDS("Scripts/model_sdm.rds")
