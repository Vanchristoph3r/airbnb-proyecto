
library(dplyr)
library(tidyverse)
library(ggplot2)
source('ai_maps.R')

server <- function(input, output, session) {
  filedata <- reactive({
    infile <- input$file1
    if (is.null(infile)) {
      return(NULL)
    }
    read.csv(infile$datapath)
  })

  output$column <- renderUI({
    df <- filedata()
    if (is.null(df)) {
      return(NULL)
    }
    #  items=names(df) # add back in if you want all columns
    nums <- sapply(df, is.numeric) # keep only number columns
    items <- names(nums[nums]) # keep only number columns
    names(items) <- items
    selectInput("bubble", "Choose column to map to dot size", items)
  })

  output$color <- renderUI({
    df <- filedata()
    if (is.null(df)) {
      return(NULL)
    }
    #  items=names(df) # add back in if you want all columns
    nums <- sapply(df, is.numeric) # keep only number columns
    items <- names(nums[nums]) # keep only number columns
    names(items) <- items
    selectInput("color", "Choose column for color", items)
  })

  output$contents <- renderTable({
    df <- filedata()
    return(df)
  })


  output$stateMap <- renderPlot({
    df <- filedata()
    # df_subset <- subset(df, input$bubble > 0) # subsetting not working
    p3 <- get_airbnb_default()
    # p3 <- ggplot() +
    #   geom_polygon(data = "", aes(x = long, y = lat, group = group), color = "white", fill = "grey92") +
    #   geom_point(data = df, aes_string(x = df$lon, y = df$lat, size = input$bubble), color = input$color, shape = as.numeric(input$radio)) +
    #   scale_size(name = "", range = c(input$low, input$high)) +
    #   ggtitle(input$title) +
    #   guides(size = guide_legend(input$legend)) +
    #   theme_void() +
    #   theme(
    #     aspect.ratio = 1.62 / 3,
    #     plot.title = element_text(size = input$titlesize),
    #     legend.title = element_text(size = input$legendsize),
    #     text = element_text(family = input$family)
    #   )
    p3
  })

  output$downloadPlot <- downloadHandler(
    filename = function() {
      paste("map-", Sys.Date(), ".png", sep = "")
    },
    content = function(file) {
      png(file, type = "cairo")
      ggsave("storybench-mapmaker.png", width = 14.4, height = 7.43, units = "in")
    },
    contentType = "image/png"
  )

  observeEvent(input$save, {
    url <- sprintf("api:8080/colonias?delegacion=%s", input$delegacionId)
    resp <- GET("api:8080/colonias?delegacion=", body = toJSON(data.frame(name = input$name, lastname = input$lastname, age = input$age)))
    df <- fromJSON(content(resp, as = "text"))
    df
  })
}
