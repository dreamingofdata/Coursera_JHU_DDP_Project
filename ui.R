library(shiny)

shinyUI(fluidPage(
  titlePanel('Service Level Explorer'),
  fluidRow(
    helpText("A distributor to restuarants monitors various performance metrics.",
             "This application could be utilized to quickly navigate through ",
             "various KPIs for different organizations throughout the country.")
  ),
  sidebarLayout(
    sidebarPanel(
       h3('Choose inputs'),
       selectInput("metric", "Choose Metric", 
                   c("Pieces Shipped", "Pieces Damaged", 
                  "Pieces Missing", "Pieces Mispicked"), 
                   selected = "SalesOrg", multiple = FALSE),
       selectInput("summarizeBy", "Summarize By", 
                   c("State", "SalesOrg", "ConceptName"), 
                   selected = "SalesOrg", multiple = FALSE),
       helpText("View various metrics grouped in different",
                "ways. Just select a desired metric and the",
                "summarization type. The plot to the right",
                "will update automatically!",
                br(),br(),
                "Note: For demonstration purposes only.",
                "Data represents on a single day's worth",
                "of deliveries.")
       
    ),
    mainPanel(
      plotOutput("barchart")
    )

  )
))

