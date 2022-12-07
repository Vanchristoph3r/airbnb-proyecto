FROM rocker/shiny:4.0.5

# system libraries
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libpq-dev \
    libudunits2-dev \
    libproj-dev \
    libpq-dev \
    gdal-bin \
    libgdal-dev


  

# install R packages required 
RUN R -e 'install.packages(c(\
              "shiny", \
              "shinydashboard", \
              "dplyr", "tidyverse", "RPostgreSQL",\
              "texreg", "sf", "ggthemes"\
            ) \
          )'


COPY . app/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]

