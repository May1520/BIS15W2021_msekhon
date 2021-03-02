library(shiny)
library(tidyverse)
library(shinydashboard)

UC_admit <- readr::read_csv("data/UC_admit.csv")



ui <- dashboardPage(
  dashboardHeader(title = "Ethinicity Analysis Among UC Campuses"),
  dashboardSidebar(disable = T),
  dashboardBody(
    fluidRow(
      box(title = "Plot Options", width = 3,
          radioButtons("x", "Select Year", choices = c("2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"), 
                       selected = "2010"),
          selectInput("y", "Select Campus", choices = c("Davis", "Irvine", "Berkeley", "Irvine", "Los_Angeles", "Merced", "Riverside", "San_Diego", "Santa_Barbara", "Santa_Cruz"),
                      selected = "Davis"),
          selectInput("z", "Select Admit Category", choices = c("Applicants", "Admits", "Enrollees"),
                      selected = "Applicants")
      ), 
      box(title= "UC Admissions", width = 7,
          plotOutput("plot", width = "600px", height = "500px")
      )
    )
  )
)
server <- function(input, output, session) { 
  output$plot <- renderPlot({
    UC_admit %>% 
      filter(Academic_Yr==input$x & Campus==input$y & Category==input$z) %>% 
      ggplot(aes(x=reorder(Ethnicity, FilteredCountFR), y=FilteredCountFR))+
      geom_col(fill="steelblue", position = "dodge", alpha=1, size=4)+
      theme_grey(base_size = 18)+ 
      labs(x=NULL, y="Number of Individuals", fill="Fill Variable")+
      theme(axis.text.x = element_text(angle = 65, hjust = 1))
  })
  session$onSessionEnded(stopApp)
}
shinyApp(ui, server)
