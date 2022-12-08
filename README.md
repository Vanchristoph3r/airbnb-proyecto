# Estadística Computacional 
# Proyecto Airbnb
## Integrantes
-	Christopher Chávez Jiménez
-	León
-	José Luis Pérez Castellanos (CU: 159497)

## Resumen

Proyecto final, cuya objetivo es el de la utilización de los siguientes softwares:
-	Bash
-	PostgreSQL
-	Docker
-	Docker Compose
-	Shiny
-	R
-   Python

## Base de datos

La base de datos que se analizará en este trabajo será la de AirBnB CDMX.

### Explicación de variables creadas

- Delitos, son la suma de delitos cometidos. Agrupamos por la caregoría del delito y la colonia donde se cometió.
- Nombre de la alcaldía, se obtuvo mediante la geoubicación del hospedaje. Lo anterior, cruzando la información de la latitud y longitud con el archivo de polígonos para la Ciudad de México.
- Nombre de la colonia, se obtuvo mediante la geoubicación del hospedaje. Lo anterior, cruzando la información de la latitud y longitud con el archivo de polígonos para la Ciudad de México.
- Creamos la variable de baños, a través de la conversión de la variable de tipo caracter a continua.
- La variable a predecir es precio, toma valores de (0, inf), por lo tanto resolvimos el problema a través de una regresión lineal, utilizando el número de baños, número de cuartos, tipo de hospedaje y colonia.

## Procedimiento de limpieza de datos


### El Producto de Datos y el problema de negocio

Se ofrece un producto de datos que se construya a través de los hospedajes vigentes en la plataforma de AirBnB para la Ciudad de México y su respectiva información. Además, se une a la información que genera la Procuraduría de la Ciudad de México, sobre las carpetas de investigación que se abrieron en el 2020 para todos los delitos.

### Problema de negocio 

Nuestro objetivo es el de ofrecer un producto de datos que permita a los inversionistas interesados en el sector inmobiliario en tomar una decisión de inversión. Con la aplicación podrán realizar una predicción sobre el precio promedio con el que podrían rentar a través de la plataforma de AirBnB. Lo anterior, tomando en cuenta las características propias de su propiedad y características asociadas a su geo ubicación en la Ciudad de Mexico. Además, de ofrecerle un panorama de seguridad de su colonia.


# Estructura del proyecto

## backend
Carpeta contiene el API, usando los siguiente.
- FastAPI
- PostgreSQL
### dir sql 
Contiene la consultas creadas para extraccion de los datos de la db

## db
Contiene la definicion de la base de datos y los datos en formato csv iniciales.

## app
Contiene el shiny app, dividido en multiples archivos. 
#### ui.R
Contiene el UI del shimy
#### server.R
Definicion de funciones del server, como triggers y updates de la aplicación

#### ai_maps.R 
Continene la regresiones(modelo) y el mapa a usar de las delegaciones

#### requests.R
Definición de POST, PUT, DELETE, GET.


# Ejecución del proyecto:

```bash
docker-compose up
```

# Funcionamiento de la aplicación 

La aplicación muestra dos mapas de la CDMX, el primero con los lugares listados en 
Airbnb y el segundo con el indice de crimenes en CDMX. 
Se deberá elegir  Alcaldia, Colonia, tipo de hospedaje, número de habitaciones y número de baños.
Posrteriormente se actualizaran los maps y arrojara una estimación.
Se puede editar la lista de estimaciones anteriores, se podrán eliminar, agregar o actualizar.


# Re-Entrenamiento del modelo:
1.	El modelo lo podrán reentrenar solo los administradores del proyecto, esto debido a que el proceso se llevará a cabo a través de la actualización de los hospedajes que se encuentran disponibles en la plataforma de AirBnB, es decir, el reentrenamiento no se lleva a cabo con la información que se genera  a través de las predicciones realizadas, sino por un proceso de actualización de la base de datos original.  
3.	Bastara con actualizar el archivo listings_cdmx_updated.csv y carpeta.csv y la platorma entrenara con esa nueva información. La base de datos actual está actualizada hasta 2020

# Disclaimer

Consideramos no re-entrenar el modelo porque la preddición del preció está en función de hospedajes reales y no sobre un interes de inversión. Se puede actualizar los csv para poder reentrenar. Implementamos el CRUD en las estimaciones generadas por la plataforma, que es el objectivo principal de nuestro proyecto.


