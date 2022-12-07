source('ui.R', chdir = TRUE)
source('server.R', chdir = TRUE)

# Run the application
shinyApp(ui = ui, server = server)
