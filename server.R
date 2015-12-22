library(shiny)
library(ggplot2)
library(plyr)


shinyServer(function(input, output) {
  
  
  cdata <- reactive({
    
    if (is.null(input$c))
      return(NULL)
    stats[stats$composer %in% input$c,]
    
  })
  
  output$chart <- renderPlot({
    
    if (is.null(cdata()))
      return(NULL)
    p <- ggplot(cdata(), 
                aes(x = paste(Decade, "*"), y = inConcert, group = composer)) + 
      geom_area(aes(fill = composer), color = 1) + 
      labs(x = "Decade", y = "Number of times played") 
    
    print(p)
    
  })
  
  output$chart2 <- renderPlot({
    
    if (is.null(cdata()))
      return(NULL)
    p2 <- ggplot(data = cdata(), 
                 aes(x = paste(Decade, "*"), y = percent, fill = composer)) + 
      geom_bar(stat = "identity", position = "dodge") + 
      labs(x = "Decade", y = "Percentage of all concerts") 
    
    print(p2)
    
  })
  
  
  output$data <- renderTable({
    
    if (is.null(cdata()))
      return(NULL)
    cdata()[order(cdata()[c("composer")]),]
    
  }, include.rownames = FALSE)
  
  
  output$data2 <- renderTable({
    
    if (is.null(cdata()))
      return(NULL)
    multi
    
  }, include.rownames = FALSE)
  
})