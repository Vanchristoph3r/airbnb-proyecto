## llamando a las librerias que (creemos que) vamos a usar
# if (!require("pacman")) install.packages("pacman")

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

# listings <- read.csv("listings_cdmx_updated.csv", header=TRUE, stringsAsFactors=FALSE,encoding="UTF-8")
# carpeta <- read.csv("carpeta.csv", header=TRUE, stringsAsFactors=FALSE, encoding="UTF-8")

# names(mapa_cdmx)

#####
# names(listings)

get_airbnb_default <- function(mun_name, col_name) {
  airbnb_graph <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(data = listings, aes(x = longitude, y = latitude, shape = room_type, color = room_type), size = 1) +
    theme_map()
}

get_airbnb_map <- function(mun_name, col_name) {
  airbnb_graph <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(
      data = listings %>% dplyr::filter(mun_name == mun_name & col_name == col_name),
      aes(x = longitude, y = latitude, shape = room_type, color = room_type), size = 1
    ) +
    theme_map()
}

# names(carpeta)
get_carpetas_map <- function(mun_name, col_name) {
  carpetas <- ggplot() +
    geom_sf(data = mapa_cdmx, fill = NA) +
    geom_point(
      data = carpeta %>% dplyr::filter(mun_name == mun_name & col_name == col_name), aes(x = longitud, y = latitud), size = 1,
      shape = 23, fill = "darkred"
    ) +
    theme_map()
}

# unique(carpeta$categoria_delito)
# Delitos_colonia <- ggplot() +
#   geom_col(
#     data = carpeta %>%
#       dplyr::filter(mun_name == "" & col_name == "") %>%
#       dplyr::group_by(col_name, categoria_delito) %>%
#       dplyr::summarise(Freq = n()),
#     aes(x = categoria_delito, y = Freq, fill = categoria_delito), position = "dodge"
#   ) +
#   coord_flip() +
#   theme(legend.position = "top")

# Airbnb_colonia <- ggplot() +
#   geom_col(
#     data = carpeta %>%
#       dplyr::filter(mun_name == "" & col_name == "") %>%
#       dplyr::group_by(col_name, room_type) %>%
#       dplyr::summarise(Freq = n()),
#     aes(x = categoria_delito, y = Freq, fill = categoria_delito), position = "dodge"
#   ) +
#   coord_flip() +
#   theme(legend.position = "top")


# # names(listings)
# summary(reg1 <- felm(price ~ bedrooms + bathroom + as.factor(room_type) | 0 | 0 | 0,
#   data = listings
# ))

# # names(carpeta)
# unique(carpeta$categoria_delito)

# carpetas_colonia <- carpeta %>%
#   dplyr::filter(categoria_delito == c(
#     "ROBO A NEGOCIO CON VIOLENCIA",
#     "ROBO A CASA HABITACIÓN CON VIOLENCIA"
#   )) %>%
#   dplyr::group_by(col_code) %>%
#   dplyr::summarise(Delitos = n())



# # names(listings)
# base <- dplyr::left_join(listings, carpetas_colonia,
#   by = c("col_code" = "col_code")
# )

# summary(base)
# summary(reg1 <- felm(price ~ bedrooms + bathroom + as.factor(room_type) + Delitos | 0 | 0 | 0,
#   data = base
# ))

# summary(reg2 <- felm(price ~ as.factor(host_is_superhost) + as.factor(instant_bookable) | 0 | 0 | 0,
#   data = base
# ))

# --------
#### mapas

#### densidad de acuerdo a alcaldia

#### piensas invertir en una propiedad para rentarla por airbnb
# en que alcaldia tienes pensado invertir?

### casa o departamento

# numero de cuartos
# numero de banos

#### muestro grafica de delitos a casa habitacion en los ultimos anos para esa alcaldia
