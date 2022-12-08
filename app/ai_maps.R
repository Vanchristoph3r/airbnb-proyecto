# pacman::p_load(
#   dplyr,
#   haven,
#   ggplot2,
#   ggpubr,
#   ggthemes ## si quieren mas themes
#   , readstata13,
#   readxl,
#   sf,
#   tidyverse,
#   tidyr,
#   units,
#   viridis ## paleta de colores Viridis
#   , wesanderson ## p/usar paleta de colores de Wes Anderson
#   , stringr,
#   RColorBrewer,
#   patchwork,
#   Rmisc,
#   lfe,
#   stargazer,
#   AER,
#   haven,
#   skimr,
#   modelsummary,
#   spdep,
#   estimatr,
#   texreg,
#   RPostgreSQL
# )

library(tidyverse)
library(RPostgreSQL)
library(ggplot2)
library(sf)
library(ggthemes)
library(lfe)
# READ DATA from databases

dsn_database <- "airbnb"
dsn_hostname <- "db"
dsn_port <- "5432"
dsn_uid <- "airbnb_user"
dsn_pwd <- ""

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

get_airbnb_default <- function() {
  airbnb_graph <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(data = listings, aes(x = longitude, y = latitude, shape = room_type, color = room_type), size = 1) +
    theme_map()
}

get_crime_default <- function() {
  carpetas <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(
      data = carpeta, aes(x = longitud, y = latitud), size = 1,
      shape = 23, fill = "darkred"
    ) +
    theme_map()
}

get_airbnb_map <- function(munname, colname) {
  airbnb_graph <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(
      data = listings %>% filter(col_name == colname),
      aes(x = longitude, y = latitude, shape = room_type, color = room_type), size = 1
    ) +
    theme_map()
}

get_carpetas_map <- function(munname, colname) {
  carpetas <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(
      data = carpeta %>% filter(col_name == colname), aes(x = longitud, y = latitud), size = 1,
      shape = 23, fill = "darkred"
    ) +
    theme_map()
}

# unique(carpeta$categoria_delito)
get_delitos_colonia_bars <- function(mun_name, col_name) {
  Delitos_colonia <- ggplot() +
    geom_col(
      data = carpeta %>%
        dplyr::filter(mun_name == mun_name & col_name == col_name) %>%
        dplyr::group_by(col_name, categoria_delito) %>%
        dplyr::summarise(Freq = n()),
      aes(x = categoria_delito, y = Freq, fill = categoria_delito), position = "dodge"
    ) +
    coord_flip() +
    theme(legend.position = "top")
}

get_listings_colonia_bars <- function(mun_name, col_name) {
  Airbnb_colonia <- ggplot() +
    geom_col(
      data = listings %>%
        dplyr::filter(mun_name == mun_name & col_name == col_name) %>%
        dplyr::group_by(col_name, room_type) %>%
        dplyr::summarise(Freq = n()),
      aes(x = room_type, y = Freq, fill = room_type), position = "dodge"
    ) +
    theme(legend.position = "top")
}

# # names(listings)
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
