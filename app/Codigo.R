# Titulo: PREOYECTO ESTADISTICA DESCRIPTIVA
# Author: EQUIPO
#######


rm(list=ls ()) # para vaciar el workspace donde vas a trabajar


## llamando a las librerias que (creemos que) vamos a usar
if (!require ("pacman")) install.packages ("pacman")


pacman::p_load (dplyr
                , haven
                , ggplot2
                , ggpubr
                , ggthemes  ## si quieren mas themes
                , readstata13
                , readxl
                , sf
                , tidyverse
                , tidyr
                , units
                , viridis ## paleta de colores Viridis
                , wesanderson## p/usar paleta de colores de Wes Anderson
                , stringr
                ,RColorBrewer
                ,patchwork
                ,Rmisc
                ,lfe
                ,stargazer
                ,AER
                ,haven
                ,skimr
                ,modelsummary
                ,spdep
                ,estimatr
                ,texreg)


setwd("E:/Maestria/Airbnb")



###funciones

stat_box_data <- function(y, upper_limit = max(iris$Sepal.Length) * 1.15) {
  return( 
    data.frame(
      y = 0.95 * upper_limit,
      label = paste('count =', length(y), '\n',
                    'mean =', round(mean(y), 1), '\n',
                    'SD =', round(sd(y), 1), '\n')
    )
  )
}

###
listings <- read.csv("listings_cdmx.csv", header=TRUE, stringsAsFactors=FALSE,encoding="UTF-8")
Mapa_cdmx <- st_read("georef-mexico-colonia-millesime.shp", stringsAsFactors=FALSE)
carpeta <- read.csv("carpeta.csv", header=TRUE, stringsAsFactors=FALSE, encoding="UTF-8")

#####

names(listings)

airbnb_graph <- ggplot()+
  geom_sf(data = Mapa_cdmx, fill = NA) +
  geom_point(data = listings, aes(x = longitude, y = latitude, shape = room_type, color = room_type), size = 1) +
  theme_map()


carpetas <- ggplot()+
  geom_sf(data = Mapa_cdmx, fill = NA) +
  geom_point(data = carpeta, aes(x = longitud, y = latitud), size = 1, 
             shape = 23, fill = "darkred") +
  theme_map()

listings <- as.data.frame(listings)
carpeta <- as.data.frame(carpeta)

summary(listings)
summary (reg1 <- felm (price ~ bedrooms + bathroom + as.factor(room_type)| 0| 0 | 0, 
                       data=listings))

names(carpeta)
unique(carpeta$categoria_delito)

carpetas_colonia <- carpeta %>% 
  dplyr::filter(categoria_delito == c("ROBO A NEGOCIO CON VIOLENCIA",
                                      "ROBO A CASA HABITACIÓN CON VIOLENCIA")) %>%
  dplyr::group_by(col_code) %>% 
  dplyr::summarise(Delitos = n())



names(listings)
base <- dplyr::left_join(listings, carpetas_colonia, 
                               by = c("col_code" = "col_code"))

summary(base)
summary (reg1 <- felm (price ~ bedrooms + bathroom + as.factor(room_type) + Delitos| 0| 0 |0,
                       data=base))

summary (reg2 <- felm (price ~  as.factor(host_is_superhost)+ as.factor(instant_bookable)| 0| 0 | 0, 
                       data=base))


####mapas

####densidad de acuerdo a alcaldia

####piensas invertir en una propiedad para rentarla por airbnb
#en que alcaldia tienes pensado invertir?

### casa o departamento

#numero de cuartos
#numero de banos

#### muestro grafica de delitos a casa habitacion en los ultimos anos para esa alcaldia










