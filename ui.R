library(shiny)
library(ggplot2)
library(plyr)
library(RColorBrewer)

  
shinyUI(pageWithSidebar(
  
  headerPanel("Composers played in concerts organized by the Helsinki Philharmonic Orchestra since 1882"),
  

  sidebarPanel(
       
    h5(paste("At least ", nc, " concerts in one decade", sep = "")),
    
    checkboxGroupInput(inputId = "c", 
                label = "Choose:",
                choices = sort(unique(stats[stats$inConcert >= nc,]$composer)),
                selected = c("Sibelius Jean", "Bach Johann Sebastian"))
        
  ),
  
  
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", 
               plotOutput("chart", height = "500px", width = "auto"),
               br(),
               plotOutput("chart2", height = "500px", width = "auto"),
               br(),
               a(href = "http://www.hri.fi/fi/data/helsingin-kaupunginorkesterin-konsertit-1882/", target = "_blank",
                 "Data | "),
               a(href = "http://www.hri.fi/lisenssit/hri-nimea/#english", target = "_blank",
                 "Helsinki Region Infoshare - data pool licence")), 
      tabPanel("Plotted data", 
               tableOutput("data")),
      tabPanel("Other stats", 
               h5(paste("Works played at least ", n, " times in one concert"), sep = ""),
               br(),
               tableOutput("data2"))
    )
    
  )
  
))
