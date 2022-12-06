library(shiny)
library(datasets)

ui <- fluidPage(
  
  titlePanel("Proyección de renta para plataforma AirBnb"),
  
  sidebarLayout(
    # Barra derecha para seleccionar inputs
    sidebarPanel(
      # Select Inputs
      selectInput(inputId = "EventFinder",
                  label = "Alcaldia:",
                  choices = c("Tlalpan", "Santa Fé", "Reforma"),
                  width = "220px"
      ),
      
      radioButtons("radio", label = h5("Tipo de propiedad"), 
                   choices = list("Casa" = 1, "Departamento" = 0),
                   selected = 16),
      numericInput("titlesize", "No de Cuartos:", value = 1, min = 1, max = 50),
      numericInput("titlesize", "No de Baños:", value = 1, min = 1, max = 50),
      
      #Botones para calculo, actualización y eliminación
      
      actionButton("bus_refresh", "Calcular Tarifa"),
      actionButton("bus_refresh", "Actualizar Tarifa "),
      actionButton("bus_refresh", "Eliminar Tarifa"),
      
      hr(),
      tags$div(class="header", checked=NA,
               tags$p("Esta analisis te da una estimación del precio al que podrìas rentar tu propiedad basado en la datos provistos por la aplicación AirBnb"))
    ),
    
    
    #Panel izquierdo
    # Panel central para mostrar todos los resultados
    mainPanel(
      plotOutput("stateMap"),
      h4("Gráfica de delitos a casa habitacion en los ultimos años para esa alcaldia seleccionada", align = "left"),
      plotOutput("phonePlot"),
      tableOutput("contents"),
      h4("Observations"),
      tableOutput("view"),
      renderPlot({
        plot(x = selected_trends()$date, y = selected_trends()$close, type = "l",
             xlab = "Date", ylab = "Trend index")
      })
    )
    
    
  )
)


server <- function(input, output, session) {
  filedata <- reactive({
    infile <- input$file1
    if (is.null(infile)){
      return(NULL)      
    }
    read.csv(infile$datapath)
  })
  
  
  library(dplyr)
  library(tidyverse)
  library(ggplot2)
  library(fiftystater)
  
  
  output$column <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    #  items=names(df) # add back in if you want all columns
    nums <- sapply(df, is.numeric) # keep only number columns
    items=names(nums[nums]) # keep only number columns
    names(items)=items
    selectInput("bubble", "Choose column to map to dot size", items)
  })
  
  output$color <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    #  items=names(df) # add back in if you want all columns
    nums <- sapply(df, is.numeric) # keep only number columns
    items=names(nums[nums]) # keep only number columns
    names(items)=items
    selectInput("color", "Choose column for color",items)
  })
  
   output$contents = renderTable({
    df <- filedata()
    return(df)
  })
  
  
  output$stateMap <- renderPlot({
    
    df <- filedata()
    #df_subset <- subset(df, input$bubble > 0) # subsetting not working
    
    p3 <- ggplot() + geom_polygon(data=fifty_states, aes(x=long, y=lat, group = group),color="white", fill= "grey92") +
      geom_point(data = df, aes_string(x=df$lon, y=df$lat, size=input$bubble), color = input$color, shape = as.numeric(input$radio)) +
      scale_size(name="", range = c(input$low, input$high)) +
      ggtitle(input$title) + 
      guides(size=guide_legend(input$legend)) +
      theme_void() +
      theme(aspect.ratio=1.62/3, 
            plot.title = element_text(size = input$titlesize),
            legend.title=element_text(size= input$legendsize),
            text=element_text(family=input$family))
    p3
    
  })
  
  output$downloadPlot <- downloadHandler(
    filename = function() {paste('map-', Sys.Date(), '.png', sep='')},
    content = function(file) { 
      png(file, type='cairo')
      ggsave("storybench-mapmaker.png", width=14.4,height=7.43,units="in")
    },
    contentType = 'image/png'
  )
  
}


# Run the application 
shinyApp(ui = ui, server = server)
