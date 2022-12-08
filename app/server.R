
library(dplyr)
library(tidyverse)
library(ggplot2)
library(shinylogs)

source("ai_maps.R")
source("requests.R")

server <- function(input, output, session) {
  track_usage(storage_mode = store_null())


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

  output$stateMap <- renderPlot({
    df <- filedata()
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

  output$crimeMap <- renderPlot({
    p2 <- get_crime_default()
    p2
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

  observeEvent(ignoreInit=TRUE, input$delegacionId, {
    delegacion <- input$delegacionId
    if(delegacion != ''){
      df <- get_request("colonias", list(delegacion= delegacion))
      updateSelectInput(session, "coloniaId", label = "Colonia:", choices = as.list(df$colonias))
    }
  })

  observeEvent(ignoreInit=TRUE, input$estimateNew, {
    output$stateMap <- renderPlot({
      mun_name <- input$delegacionId
      col_name <- input$coloniaId
      p3 <- get_airbnb_map(mun_name, col_name)
      p3
    })
    output$crimeMap <- renderPlot({
      p2 <- get_carpetas_map(input$delegacionId, input$coloniaId)
    })

    output$barCharListings <- renderPlot({
      p4 <- get_listings_colonia_bars(input$delegacionId, input$coloniaId)
      p4
    })

    output$barCrime <- renderPlot({
      p4 <- get_delitos_colonia_bars(input$delegacionId, input$coloniaId)
      p4
    })

    output$stimation <- renderTable({
      df <- get_stimation_listings(input$rooms, input$restrooms, input$room_type, input$coloniaId)
      return(df)
    })

  })
}
