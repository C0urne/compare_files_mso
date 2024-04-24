#
#
# This app compares 2 files using the daff packages and render_diff function.
# It aske for 2 files then compares then. 

library(shiny)
library(shinythemes)
library(tidyverse)
library(openxlsx)
library(daff)

# Define UI
ui <- fluidPage(
  theme = shinytheme("spacelab"),
  titlePanel("Outil comparatif 2 versions d'un même fichier"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1",
                "Fichier version antérieure",
                buttonLabel = "Choisir",
                placeholder = "Vide",
                multiple = FALSE),
      fileInput("file2",
                "Fichier version actuelle",
                buttonLabel = "Choisir",
                placeholder = "Vide",
                multiple = FALSE),
      uiOutput("sheetUI"),
      actionButton("compare", "Comparer les Fichers"),
    ),
    mainPanel(
      verbatimTextOutput("diff")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  output$sheetUI <- renderUI({
    files <- c(input$file1$datapath, input$file2$datapath)
    sheets <- unique(unlist(lapply(files, function(file) {
      if (!is.null(file)) {
        openxlsx::getSheetNames(file)
      }
    })))
    selectInput("sheet", "Feuille", choices = sheets)
  })
  
  observeEvent(input$compare, {
    req(input$file1, input$file2, input$sheet)
    
    v1 <- read.xlsx(input$file1$datapath, sheet = input$sheet)
    v2 <- read.xlsx(input$file2$datapath, sheet = input$sheet)
    
    d <- daff::diff_data(v1, v2)
    output$diff <- renderPrint(daff::render_diff(d))
  })
}

# Run the app and open in web browser
shinyApp(ui = ui, server = server)
