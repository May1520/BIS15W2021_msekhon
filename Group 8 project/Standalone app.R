library(tidyverse)
library(janitor)
library(shiny)
library(shinydashboard)
library(lubridate)

options(scipen = 999)

covid <- read.csv("Data/WHO-COVID-19-global-data.csv") %>% clean_names()

covid$i_date_reported <- lubridate::mdy(covid$i_date_reported)

covid <- covid %>% mutate_if(is.integer,as.numeric)

covid <- covid %>% 
  select(i_date_reported, country, cumulative_cases, cumulative_deaths)

ui <- dashboardPage(skin="blue",
                    dashboardHeader(title = "COVID-19 Information"),
                    dashboardSidebar(disable = T),
                    dashboardBody(
                      fluidRow(
                        box(title = "Plot Options", width = 3,
                            selectInput("fill", "Select Country", choices =unique(covid$country)),
                            radioButtons("x", "Select X Variable", choices = c("cumulative_cases", "cumulative_deaths"), selected = "cumulative_cases"),
                            box(title = "Disease Abundance", width = 9,
                                plotOutput("plot", width = "800px", height = "500px", click="plot_click"),
                                verbatimTextOutput("info")
                            ) 
                        ) 
                      )
                    ) 
)

server <- function(input, output, session) { 
  
  output$plot <- renderPlot({
    covid %>% 
      filter(country==input$fill) %>% 
      ggplot(aes_string(x = "i_date_reported", y = input$x, fill=input$x)) + 
      geom_col()+
      labs(x="Date reported")
  })
}

shinyApp(ui, server)
