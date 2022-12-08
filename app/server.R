
library(dplyr)
library(tidyverse)
library(ggplot2)
library(shinylogs)
library(DT)


source("ai_maps.R")
source("requests.R")


server <- function(input, output, session) {
  track_usage(storage_mode = store_null())

  output$stateMap <- renderPlot({
    p3 <- get_airbnb_default()
    p3
  })

  output$crimeMap <- renderPlot({
    p2 <- get_crime_default()
    p2
  })

  output$listingsTable <- renderDataTable({
    df <- get_request("listings", list())
    return(df)
  })

  observeEvent(ignoreInit = TRUE, input$delegacionId, {
    delegacion <- input$delegacionId
    if (delegacion != "") {
      df <- get_request("colonias", list(delegacion = delegacion))
      updateSelectInput(session, "coloniaId", label = "Colonia:", choices = as.list(df$colonias))
    }
  })

  observeEvent(ignoreInit = TRUE, input$estimateNew, {

    size_df <- get_size_df(input$delegacionId, input$coloniaId)

    if (size_df > 0 | input$coloniaId == ""){
      output$stateMap <- renderPlot({
        mun_name <- input$delegacionId
        col_name <- input$coloniaId
        p3 <- get_airbnb_map(mun_name, col_name)
        p3
      })
      output$crimeMap <- renderPlot({
        p2 <- get_carpetas_map(input$delegacionId, input$coloniaId)
        p2
      })

      output$barCharListings <- renderPlot({
        p4 <- get_listings_colonia_bars(input$delegacionId, input$coloniaId)
        p4
      })

      output$barCrime <- renderPlot({
        p4 <- get_delitos_colonia_bars(input$delegacionId, input$coloniaId)
        p4
      })

      output$estimate <- renderPrint({
        showModal(modalDialog("Calculando nueva estimación", footer = NULL))

        estimation <- get_stimation_listings(input$rooms, input$restrooms, input$room_type, input$coloniaId)
        cat("Nueva estimación:\n\n")
        cat(estimation, sep = ", ")
        removeModal()
      })
    }else{
      showModal(modalDialog("No existen datos para esta colonia", footer = NULL, easyClose=TRUE))
    }
  })

  output$listings <- renderDataTable(
    {
      df <- get_request("listings", list())
      df <- fromJSON(df)
      return(df)
    },
    options = list(searching = FALSE),
    selection = "single"
  )

  observeEvent(ignoreInit = TRUE, input$saveEstimate, {
    if (is.null(input$coloniaId)){
      showModal(modalDialog("Debes tener una colonia seleccionada", footer = NULL, easyClose=TRUE))
    }else{
    showModal(modalDialog("Guardando nueva estimación", footer = NULL))

    current_estimation <- get_stimation_listings(input$rooms, input$restrooms, input$room_type, input$coloniaId)
    status <- post_request("listings", body = toJSON(data.frame(amount = current_estimation, colonia = input$coloniaId, bedrooms = input$rooms, bathroom = input$restrooms)))
    df <- get_request("listings", list())
    df <- fromJSON(df)
    output$listings <- renderDataTable(df, server = TRUE, options = list(searching = FALSE), selection = "single")
    removeModal()
    }
  })

  table_listings <- reactive({
    df <- get_request("listings", list())
    data <- fromJSON(df)
    data
  })


  observeEvent(ignoreInit = TRUE, input$deleteEstimate, {
    showModal(modalDialog("Eliminando estimación seleccionada", footer = NULL))
    n <- input$listings_rows_selected
    if (is.null(n)){
      showModal(modalDialog("Debes seleccionar una fila de la tabla", footer = NULL, easyClose=TRUE))
    }else{
    id <- table_listings()[input$listings_rows_selected, c("id")]
    url <- sprintf("listings/%s", id)
    message <- delete_request(url)
    print(message)
    df <- get_request("listings", list())
    df <- fromJSON(df)
    output$listings <- renderDataTable(df, options = list(searching = FALSE), selection = "single")
    removeModal()}
  })

  observeEvent(ignoreInit = TRUE, input$updateEstimate, {
    n <- input$listings_rows_selected
    if (is.null(n)){
      showModal(modalDialog("Debes seleccionar una fila de la tabla", footer = NULL, easyClose=TRUE))
    }else{
      showModal(modalDialog("Actualizando estimación seleccionada", footer = NULL))
      id <- table_listings()[input$listings_rows_selected, c("id")]
      print(id)
      current_estimation <- get_stimation_listings(input$rooms, input$restrooms, input$room_type, input$coloniaId)
      url <- sprintf("listings/%s", id)
      status <- put_request(url, body = toJSON(data.frame(amount = current_estimation, colonia = input$coloniaId, bedrooms = input$rooms, bathroom = input$restrooms)))
      df <- get_request("listings", list())
      df <- fromJSON(df)
      output$listings <- renderDataTable(df, options = list(searching = FALSE), selection = "single")
      removeModal()
    }
  })
}
