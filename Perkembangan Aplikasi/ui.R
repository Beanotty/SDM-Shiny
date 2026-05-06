

ui <- dashboardPage(skin = "blue",
                    dashboardHeader(title = "Equalyst"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Beranda", 
                                 icon = icon("home"),
                                 startExpanded = TRUE,
                                 menuSubItem("Latar Belakang",
                                             tabName = "background",
                                             icon = icon("book")),
                                 menuSubItem("Dataset",
                                             tabName = "dataset",
                                             icon = icon("table"))
                        ),
                        menuItem("Visualisasi & Interpretasi", 
                                 tabName = "visual", 
                                 icon = icon("chart-bar")),
                        menuItem("Prediksi",
                                 tabName = "predict",
                                 icon = icon("sliders"))
                      )
                    ),
                    
          dashboardBody(
            shinyFeedback::useShinyFeedback(),
                      roundedBox,
                      GeneralText,
                      tabItems(
                        # Visualization Page
                        tabItem(tabName = "visual", 
                                fluidRow(
                                  box(
                                    width = 12,
                                    fluidRow(
                                      column(width = 4,
                                             selectInput("pilihPlot", "Pilih Visualisasi:",
                                                         choices = c("Distribusi IKG" = "Dependant",
                                                                     "Hubungan IKG dan Variabel Independen" = "Independant",
                                                                     "Hasil perbandingan Data asli dan Data Prediksi" = "residual")),
                                             box(width = 12 ,
                                                 title = NULL,
                                                 class = "roundedBox",
                                                 solidHeader = TRUE,
                                                 uiOutput("plotInterpretation")
                                                 )
                                      ),
                                      column(width = 8,
                                             uiOutput("plotSelection"))
                                    )
                                  ),
                                  
                                  tabBox(
                                    width = 12,
                                    id = "tabsetVisual",
                                    height = "auto",
                                    tabPanel("Model",
                                             class = "model-text",
                                               uiOutput('modelused')
                                    ),
                                    
                                    tabPanel("Signifikansi dan Interpretasi",
                                             class = "model-text",
                                             uiOutput("tabelInterpretasi")
                                    )
                                  )
                                )
                        ),
                        
                        # Prediction Page
                        tabItem(tabName = "predict", 
                                fluidRow(
                                  box(
                                    h2("Input Parameters"),
                                    numericInput("Wpar", label = "Input Persentase Keterlibatan Perempuan dalam Parlemen",
                                                 max = 100, min =0 , value = 0),
                                    numericInput("Wwork", label = "Input Persentase Keterlibatan Sebagai Tenaga Professional",
                                                max = 100, min = 0, value = 0),
                                    sliderInput("Unourish", label = "Prevalensi Ketidakcukupan Konsumsi Pangan",
                                                max = max(df$Unourish), min = min(df$Unourish), value = median(df$Unourish)),
                                    sliderInput("Childbirth", label = "Melahirkan Anak Lahir Hidup Yang Pertama Kali Berumur Kurang dari 20 tahun",
                                                max = max(df$Childbirth), min = min(df$Childbirth), value = median(df$Childbirth)),
                                    sliderInput("Wsumbang", label = "Sumbangan Pendapatan Perempuan",
                                                max = max(df$Wsumbang), min = min(df$Wsumbang), value = median(df$Wsumbang)),
                                    sliderInput("TFR", label = "True Fertility Rate",
                                                max = max(df$TFR), min = min(df$TFR), value = median(df$TFR)),
                                    
                                    column(6, 
                                           align = "center", offset = 3,
                                           actionButton("submitbutton", "Submit", 
                                                        class = "btn btn-primary"),
                                           actionButton("reset", "Reset"),
                                           
                                           tags$style(type = 'text/css', 
                                                      "#button { vertical-align: middle; height: 50px; width: 100%;
                                                       font-size: 30px; }")
                                    )
                                  ),

                                  column(width = 6,
                                         box(
                                           class = "model-text",
                                           width = 12,
                                           tags$label(h3('Output')),
                                           verbatimTextOutput('contents'),
                                           tableOutput('tabledata'),
                                           uiOutput('predictionInterpretation')
                                         )
                                      )
                                )
                        ),
                        
                        # About Page
                        tabItem(tabName = "background",
                                fluidRow(
                                  box(
                                    width = 12,
                                    solidHeader = TRUE,
                                    class = "model-text",
                                    uiOutput("webExplain")

                                  ),

                                  box(
                                    width = 12,
                                    solidHeader = TRUE,
                                    leafletOutput("map")
                                  ),
                                  
                                  box(width = 9, 
                                      status = "primary",
                                      class = "model-text",
                                      uiOutput('aboutols')
                                  ),
                                  box(title = "Created By:", 
                                      width = 3, status = "primary",
                                      p("Name    : Reyza Farzan Rahmatsyah"),
                                      p("NIM     : 2540122716"),
                                      p("Email   : reyza.rahmatsyah@binus.ac.id"),
                                      p("Jurusan : Computer Science and Statistics")
                                  )
                                )
                        ),
                        
                        # Dataset Page
                        tabItem(tabName = "dataset",
                                fluidRow(
                                  box(width = 12, status = "primary",
                                      DT::dataTableOutput("dataToShow")
                                      ),
                                  
                                  box(width = 12, status = "primary",
                                      class = "model-text",
                                      uiOutput('aboutdataset')
                                  )
                                )
                        )
                      )
                    )
)
