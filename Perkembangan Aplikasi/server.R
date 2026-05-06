server <- function(input, output, session) {

  # Pilih plot ####
  output$plotSelection <- renderUI({
    if (input$pilihPlot == "Dependant") {
      plotOutput("Dependant")
    } 
    else if (input$pilihPlot == "Independant") {
      plotOutput("Independant")
    }
    
    else if (input$pilihPlot =="residual"){
      plotOutput("predictedMap")
    }
  })
  
  output$plotInterpretation <- renderUI({
    if(input$pilihPlot == "Dependant"){
      HTML("<b 'style=font-size:12pt;'>
           Distribusi IKG kelihatan berkumpul di sekitar nilai tengah, memberikan indikasi kalau polanya mirip distribusi Normal.</b>")
    }
    
    else if (input$pilihPlot == "Independant"){
      HTML("<b 'style=font-size:12pt;'>
           Beberapa hubungan menarik Antara Indeks Ketimpangan Gender dan Variabel Independen<br><br>
           1. Peningkatan dari Angka Kelahiran dan Kelahiran Dini mengakibatkan peningkatan Nilai IKG <br><br>
           2. Peningkatan dari Persentase Wanita yang bekerja dan berada dalam parlemen menurunkan Nilai IKG</b>")
    }
    
    else if (input$pilihPlot == "residual"){
      HTML("<b 'style=font-size:12pt;'>
           Ada beberapa poin data yang dekat dengan garis merah, mengindikasi ketidakbedaan dari data prediksi dan data asli.Akan tetapi, ada beberapa poin juga yang jauh, mengindikasikan kejanggalan antara kedua nilai tersebut</b>")
    }
  })
  
  # Visualization & Summary Table Process ####
  output$Dependant <- renderPlot({
    ggplot2::ggplot(data = df, aes(IKG)) +
      ggplot2::geom_histogram(binwidth = 0.1, fill = "grey50", color = "#3c8dbc") +
      theme_classic()
  })

  # 
  output$Independant <- renderPlot({
    plot_long <- pivot_longer(
      df,
      cols = -c(IKG, Long, Lat,IPG, IDG, Names),
      names_to = "Variable",
      values_to = "Value"
    )

    # Plot
    ggplot(plot_long, aes(x = Value, y = IKG)) +
      geom_point(alpha = 0.5) +
      stat_smooth(method = lm, se = FALSE, colour = "#3c8dbc") +
      facet_wrap(~ Variable, scales = "free_x") +
      theme_classic()
  })
  


  output$tabelInterpretasi <- renderUI({
    withMathJax({
      k = knitr::knit(input = "Scripts/Interpretation.Rmd", quiet = T)
      HTML(markdown::markdownToHTML(k, fragment.only = T))
    })
  })
    
  output$modelused <- renderUI({
    withMathJax({
      k = knitr::knit(input = "Scripts/modelUsed.Rmd", quiet = T)
      HTML(markdown::markdownToHTML(k, fragment.only = T))
    })
  })
  
  
  
  #Prediction process ####
  
  
  checkSumbitPressed <- reactiveVal(0)
  
  coordinates <- cbind(df$Long, df$Lat)
  list.neighbors <- nb2listw(knn2nb(knearneigh(coordinates, k = 5)), style = "W")
  impact.sdm <- summary(impacts(model, listw = list.neighbors, R = 1000), zstats = TRUE)
  
  # Input Data
  
  observeEvent(input$submitbutton, {
    checkSumbitPressed(checkSumbitPressed() + 1)
  })
  
  datasetInput <- reactive({
    req(checkSumbitPressed() > 0)
    
    Wpar = as.numeric(input$Wpar)
    Wwork = as.numeric(input$Wwork)
    valSalah = FALSE
    
    if (is.na(Wpar) || Wpar < 0 || Wpar > 100){
          shinyFeedback::feedbackWarning(
            "Wpar",
            show = TRUE,
            text = "Angka harus diantara 0-100!")
          valSalah = TRUE
    } else {
          shinyFeedback::feedbackWarning(
            "Wpar",
            show = FALSE)
    }
    
    if (is.na(Wwork) || Wwork < 0 || Wwork > 100 ){
      shinyFeedback::feedbackWarning(
        "Wwork",
        show = TRUE,
        text = "Angka harus diantara 0-100!")
      valSalah = TRUE
    } else{
      shinyFeedback::feedbackWarning(
        "Wwork",
        show = FALSE)
    }
    
    if (valSalah){
      showNotification("Kalkulasi Gagal! Periksa lagi Variabel yang digunakan!", type = "error")
      checkSumbitPressed(0)
      validate(need(F, ""))
    }
    
    
    
    
    
    #temporary dataframe untuk holding data
     test <- data.frame(
      Wpar = Wpar,
      Wwork = Wwork,
      Unourish = as.numeric(input$Unourish),
      Childbirth = as.numeric(input$Childbirth),
      Wsumbang = as.numeric(input$Wsumbang),
      TFR = as.numeric(input$TFR)
    )
    
    #narik coef total dari impacts
    coefs <- impact.sdm$res$total
    names(coefs) <- c("Wpar", "Wwork", "Unourish", "Childbirth", "Wsumbang", "TFR")
    intercept <- model$coefficients["(Intercept)"]  
    test <- test[, names(coefs), drop = FALSE]
    X <- as.matrix(test)
    # Kalkulasi
    prediction <- intercept + sum(X * coefs)
    
    Output <- data.frame(Hasil.Prediksi = prediction)
    return(Output)
  })
  # 
  
  output$tabledata <- renderTable({
    req(checkSumbitPressed() > 0)   # only proceed if button clicked
    isolate(datasetInput())
  })
  
  output$predictionInterpretation <- renderUI({
    req(checkSumbitPressed() > 0)   
    prediction <- isolate(datasetInput()$Hasil.Prediksi[1])
    interpretation <- if (prediction <= 0.399) {
      "<b style='color:green;'>IKG rendah</b><br>
     Ini menunjukkan adanya ketimpangan gender yang signifikan.  
     Disarankan untuk meningkatkan Persentase Wanita di Parlemen dan Mengurangi Kelahiran dibawah Umur untuk mengurangi IKG"
    } 
    else if (prediction >= 0.4  && prediction <=0.449) {
      "<b style='color:goldenrod;font-size = 14pt;'>IKG Menengah Bawah</b><br>
     Ketimpangan gender mulai meningkat, akan tetapi tidak terlalu jauh  dari Kategori Rendah"
    } 
    else if (prediction >= 0.450 && prediction  <= 0.499){
      "<b style='color:orange;'font-size = 14pt;>IKG Menengah Atas</b><br>
     Kondisi kesetaraan gender mulai menuju ketidakadilan."
    }
    else {
      "<b style='color:red;'>Nilai IKG yang tinggi</b><br>
     Menandakan kesetaraan gender yang tidak baik, Kelahiran dibawah Umur yang tinggi dan Representasi Parlemen rendah"
    }
    HTML(interpretation)
  })
  
  observeEvent(input$reset, {
    updateSliderInput(session,inputId = "Wpar", value = 0)
    updateSliderInput(session,inputId = "Wwork", value =0)
    updateSliderInput(session,inputId = "Unourish", value =median(df$Unourish))
    updateSliderInput(session,inputId = "Childbirth", value =median(df$Childbirth))
    updateSliderInput(session,inputId = "Wsumbang", value =median(df$Wsumbang))
    updateSliderInput(session,inputId = "TFR", value =median(df$TFR))
    
    checkSumbitPressed(0)
  })
  
  output$contents <- renderPrint({
    if (checkSumbitPressed() > 0) { 
      isolate("Kalkulasi Selesai.") 
    } else {
      return("Model siap untuk digunakan.")
    }
  })
  
  output$predictedMap <- renderPlot({
    visPredict <- df[c("Names","IKG","Long", "Lat")]
    visPredict$IKG_cat <- cut(
      visPredict$IKG,
      breaks = c(-Inf, 0.3, 0.4, 0.45, 0.5, Inf),
      labels = c("Sangat Rendah", "Rendah", "Menengah Bawah", "Menengah Atas", "Tinggi")
    )
    
    predVal  <- as.data.frame(predict(model))
    visPredict$IKGpred <- predVal$fit
    temp <- visPredict$IKG - visPredict$IKGpred
    visPredict$residuals <- temp
    
    
    ggplot(visPredict, aes(x = IKG, y = IKGpred)) +
      geom_point(alpha = 0.6, color = "steelblue") +
      geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
      theme_minimal() +
      labs(
        x = "IKG dari Dataset",
        y = "IKG Prediksi Model"
      )
    
  })
  
  
  
  #About ####
  output$map <- renderLeaflet({
    vis <- df[c("Names","IKG","Long", "Lat")]
    vis$IKG_cat <- cut(
      vis$IKG,
      breaks = c(-Inf, 0.3, 0.4, 0.45, 0.5, Inf),
      labels = c("Sangat Rendah", "Rendah", "Menengah Bawah", "Menengah Atas", "Tinggi")
    )
    
    #function untuk buat label pas hover di map
    vis$label <- lapply(seq(nrow(vis)), function(i) {
      paste0(
        "<b>", vis[i, "Names"], "</b><br>",
        "IKG: ", round(vis[i, "IKG"], 3), "<br>"
      )
    })
    
    # warnain
    pal <- colorFactor(
      palette = c(
        "Sangat Rendah" = "grey52",
        "Rendah" = "lightgreen",
        "Menengah Bawah" = "yellow",
        "Menengah Atas" = "orange",
        "Tinggi" = "darkred"
      ),
      
      domain = vis$IKG_cat
    )
    
    # max & min untuk biar gbs zoom out ke dunia
    leaflet(vis, options = leafletOptions(maxZoom = 8, minZoom = 4 )) %>%
      addTiles() %>%
      setView(lng = 118, lat = -2.5, zoom = 5) %>%
      # max untuk centernya indo
      setMaxBounds(
        lng1 = 90, lat1 = -15,  
        lng2 = 145, lat2 = 10     
      ) %>%
      addCircleMarkers(
        lng = ~Long,
        lat = ~Lat,
        radius = 6,
        fillColor = ~pal(IKG_cat),
        fillOpacity = 0.9,
        stroke = TRUE,
        color = "black",
        weight = 1,
        label = lapply(vis$label, htmltools::HTML),
        labelOptions = labelOptions(direction = "auto")
      ) %>%
      addLegend(
        "topright",
        pal = pal,
        values = vis$IKG_cat,
        title = "Klasifikasi IKG Menurut BPS"
      )
  })
  
  output$webExplain <- renderUI({
    withMathJax({
      k = knitr::knit(input = "Scripts/webIntro.Rmd", quiet = T)
      HTML(markdown::markdownToHTML(k, fragment.only = T))
    })
  })
  
  output$aboutols <- renderUI({
    withMathJax({
      k = knitr::knit(input = "Scripts/AboutOLS.Rmd", quiet = T)
      HTML(markdown::markdownToHTML(k, fragment.only = T))
    })
  })
  
  output$aboutdataset <- renderUI({
    withMathJax({
      k = knitr::knit(input = "Scripts/aboutdataset.Rmd", quiet = T)
      HTML(markdown::markdownToHTML(k, fragment.only = T))
    })
  })
  
  output$dataToShow <- DT::renderDataTable({
    DT::datatable(
      df[c("Names", "IKG", "Wpar", "Wwork", "Unourish", "Childbirth", "Wsumbang", "TFR")],
      colnames = c(
        "No",
        "Wilayah",
        "Y",
        "X<sub>1</sub>",
        "X<sub>2</sub>",
        "X<sub>3</sub>",
        "X<sub>4</sub>",
        "X<sub>5</sub>",
        "X<sub>6</sub>"
      ),
      options = list(pageLength = 5),
      escape = FALSE
    )
  })

}
