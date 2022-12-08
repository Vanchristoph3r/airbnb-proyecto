library(tidyverse)
library(RPostgreSQL)
library(ggplot2)
library(sf)
library(ggthemes)
library(lfe)

dsn_database <- "airbnb"
dsn_hostname <- "db"
dsn_port <- "5432"
dsn_uid <- "airbnb_user"
dsn_pwd <- ""

# READ DATA FROM DATABASES 
# Catch if fails
tryCatch(
  {
    drv <- dbDriver("PostgreSQL")
    print("Connecting to Database…")
    connec <- dbConnect(drv,
      dbname = dsn_database,
      host = dsn_hostname,
      port = dsn_port,
      user = dsn_uid,
      password = dsn_pwd
    )
    print("Database Connected!")
  },
  error = function(cond) {
    print("Unable to connect to Database.")
  }
)

listings <- dbGetQuery(connec, "SELECT * FROM listings")
carpeta <- dbGetQuery(connec, "SELECT * FROM crime_reports")
mapa_cdmx <- st_read("map/georef-mexico-colonia-millesime.shp", stringsAsFactors = FALSE)

listings <- as.data.frame(listings)
carpeta <- as.data.frame(carpeta)

get_size_df <- function(munname, colname){
  data_filter <- listings %>% 
                    filter(mun_name == munname) %>%
                    filter(col_name == colname)
  sizeDF <- nrow(data_filter)
  return(sizeDF)
}

get_airbnb_default <- function() {
  airbnb_graph <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(data = listings, aes(x = longitude, y = latitude, shape = room_type, color = room_type), size = 1) +
    theme_map()+labs(title = "Airbnbs en CDMX",
        color  = "Tipos de habitación", shape = "Tipos de habitación")
}

get_crime_default <- function() {
  carpetas <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(
      data = carpeta, aes(x = longitud, y = latitud), size = 1,
      shape = 23, fill = "darkred"
    ) +
    theme_map() + labs(title = "Crimenes en CDMX")
}

# Maps filtered by  mun_name and col_name
get_airbnb_map <- function(munname, colname) {
  data_filter <- listings %>% 
                    filter(mun_name == munname) %>%
                    filter(col_name == colname)
  airbnb_graph <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(
      data = data_filter,
      aes(x = longitude, y = latitude, shape = room_type, color = room_type), size = 1
    ) +
    theme_map()+labs(title = "Airbnbs en CDMX",
        color  = "Tipos de habitación", shape = "Tipos de habitación")
}

get_carpetas_map <- function(munname, colname) {
  data_filter <- carpeta %>% 
                    filter(mun_name == munname) %>%
                    filter(col_name == colname)
  carpetas <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(
      data = data_filter, aes(x = longitud, y = latitud), size = 1,
      shape = 23, fill = "darkred"
    ) +
    theme_map()+ labs(title = "Crimenes en CDMX")
}

# Barchars for airbnb and crimes
get_delitos_colonia_bars <- function(munname, colname) {
  Delitos_colonia <- ggplot() +
    geom_col(
      data = carpeta %>%
        dplyr::filter(mun_name == munname) %>%
        dplyr::filter(col_name == colname) %>%
        dplyr::group_by(col_name, categoria_delito) %>%
        dplyr::summarise(Freq = n()),
      aes(x = categoria_delito, y = Freq, fill = categoria_delito), position = "dodge"
    ) +
    coord_flip() +
    theme(legend.position = "top")
}

get_listings_colonia_bars <- function(munname, colname) {
  Airbnb_colonia <- ggplot() +
    geom_col(
      data = listings %>%
        dplyr::filter(mun_name == munname & col_name == colname) %>%
        dplyr::group_by(col_name, room_type) %>%
        dplyr::summarise(Freq = n()),
      aes(x = room_type, y = Freq, fill = room_type), position = "dodge"
    ) +
    theme(legend.position = "top") + labs(fill = "Tipo habitación")
}

# Estimación de la regresión lineal
get_stimation_listings <- function(bedroomsName, bathroomName, roomtype, colname) {
  reg1 <- lm(price ~ bedrooms + bathroom + as.factor(room_type) + as.factor(col_name), data = listings)

  predict_value_poly <- predict(reg1, data.frame(
    bedrooms = bedroomsName,
    bathroom = bathroomName,
    room_type = roomtype,
    col_name = colname
  ))
  predict_value_poly
}
