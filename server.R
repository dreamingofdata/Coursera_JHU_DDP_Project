library(shiny)
library(dplyr)
sldata <- read.csv("data/SingleDaySL.csv")
levels(sldata$ConceptName)[1] <- 'NONE'

shinyServer(
  function(input, output) {
    dataInput <- reactive({
      summarizeBy <- input$summarizeBy
      grouped_data <- sldata %>% group_by_(summarizeBy)
      
      metric <- switch(input$metric, 
                     "Pieces Shipped" = grouped_data %>% summarize(value = sum(InvoicePieces, na.rm = TRUE)),
                     "Pieces Damaged" = grouped_data %>% summarize(value = sum(Credit...Damage, na.rm = TRUE)),
                     "Pieces Missing" = grouped_data %>% summarize(value = sum(Credit...Short, na.rm = TRUE)),
                     "Pieces Mispicked" = grouped_data %>% summarize(value = sum(Credit...Mispick, na.rm = TRUE)))
      names(metric) <- c('grouped_by', "value")
      metric <- metric %>% 
                top_n(10) %>%
                arrange(-value) %>%
                filter(value > 0)
    })
    
    output$table <- renderTable(dataInput())
    
    output$barchart <- renderPlot({
      data <- dataInput()
      plotcolor <- switch(input$metric, 
                          "Pieces Shipped" = "blue",
                          "Pieces Damaged" = "red",
                          "Pieces Missing" = "green",
                          "Pieces Mispicked" = "yellow")
      title <- paste(input$metric, "grouped by", input$summarizeBy)
      barplot(data$value, 
              names.arg=data$grouped_by,
              col= plotcolor,
              main = title,
              las = 2)})
  }
)
