library(shiny)
library(datasets)
library(jsonlite)

ui <- fluidPage(
  titlePanel("Proyección de renta para plataforma AirBnb"),
  sidebarLayout(
    # Barra derecha para seleccionar inputs
    sidebarPanel(
      # Select Inputs
      selectInput(
        inputId = "delegacionId",
        label = "Alcaldia:",
        choices = c(
          "",
          "Benito Juarez",
          "Miguel Hidalgo",
          "Venustiano Carranza",
          "Iztacalco",
          "Tlalpan",
          "Cuauhtemoc",
          "Iztapalapa",
          "Gustavo A. Madero",
          "Alvaro Obregon",
          "Azcapotzalco",
          "Coyoacan",
          "Milpa Alta",
          "Xochimilco",
          "La Magdalena Contreras",
          "Cuajimalpa de Morelos",
          "Tlahuac"
        ), # Lista de Alcadias
        width = "220px"
      ),
      selectInput(
        inputId = "coloniaId",
        label = "Colonia:",
        choices = c(), # Lista de Colonias
        width = "220px"
      ),
      radioButtons("radio",
        label = h5("Tipo de propiedad"),
        choices = list(
          "Cuarto Privado" = "Private room",
          "Departament o Casa completa" = "Entire home/apt",
          "Cuarto compartido" = "Shared room"
        ), # El valor 0 , 1 será diferente para la base que se esta montando.
        selected = 0
      ),
      numericInput("rooms", "No de Cuartos:", value = 1, min = 1, max = 50),
      numericInput("restrooms", "No de Baños:", value = 1, min = 1, max = 50),

      # Botones para calculo, actualización y eliminación
      actionButton("bus_refresh", "Calcular Tarifa"), # "bus_refresh" argumento para acción del boton.
      actionButton("bus_refresh", "Actualizar Tarifa "),
      actionButton("bus_refresh", "Eliminar Tarifa"),
      hr(),
      tags$div(
        class = "header", checked = NA,
        tags$p("Esta analisis te da una estimación del precio al que
              podrías rentar tu propiedad basado en la datos provistos
              por la aplicación AirBnb")
      )
    ),


    # Panel derecha
    # Panel central para mostrar todos los resultados
    mainPanel(
      plotOutput("stateMap"),
      h4("Gráfica de delitos a casa habitacion en los ultimos años para esa alcaldia seleccionada", align = "left"),
      plotOutput("phonePlot"),
      tableOutput("contents"),
      h4("Observations"),
      tableOutput("view"),
      renderPlot({
        # plot(
        #   x = selected_trends()$date, y = selected_trends()$close, type = "l",
        #   xlab = "Date", ylab = "Trend index"
        # )
      })
    )
  )
)
