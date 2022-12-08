Estadística Computacional 

Integrantes
•	Christopher Chávez Jiménez
•	León
•	José Luis Pérez Castellanos (CU: 159497)

Resumen

Proyecto final, cuya objetivo es el de la utilización de los siguientes softwares:
•	Bash
•	PostgreSQL
•	Docker
•	Docker Compose
•	Shiny
•	R

Base de datos

La base de datos que se analizará en este trabajo será la de AirBnB CDMX.

Explicación de variables creadas

•	Delitos, son la suma de delitos que se encuentran en las carpetas de investigacion. Agrupamos por la caregoría del delito y la colonia donde se cometió.
•	Nombre de la alcaldía, se obtuvo mediante la geoubicación del hospedaje. Lo anterior, cruzando la información de la latitud y longitud con el archivo de polígonos para la Ciudad de México.
•	Nombre de la colonia, se obtuvo mediante la geoubicación del hospedaje. Lo anterior, cruzando la información de la latitud y longitud con el archivo de polígonos para la Ciudad de México.
•	Creamos la variable de baños, a través de la conversión de la variable de tipo caracter a continua.
•	La variable a predecir es precio, toma valores de (0, inf), por lo tanto resolvimos el problema a través de una regresión lineal, utilizando el número de baños, número de cuartos, tipo de hospedaje y colonia.

Procedimiento de limpieza de datos


El Producto de Datos y el problema de negocio
Se ofrece un producto de datos que se construya a través de los hospedajes vigentes en la plataforma de AirBnB para la Ciudad de México y su respectiva información. Además, se une a la información que genera la Procuraduría de la Ciudad de México, sobre las carpetas de investigación que se abrieron en el 2020 para todos los delitos.
Problema de negocio 
Nuestro objetivo es el de ofrecer un producto de datos que permita a los inversionistas interesados en el sector inmobiliario en tomar una decisión de inversión. Con la aplicación podrán realizar una predicción sobre el precio promedio con el que podrían rentar a través de la plataforma de AirBnB. Lo anterior, tomando en cuenta las características propias de su propiedad y características asociadas a su geo ubicación en la Ciudad de Mexico. Además, de ofrecerle un panorama de seguridad de su colonia.

Especificaciones 
Se solicita que la aplicación contenga los siguientes requisitos:

Base de Datos de soporte: Los datos deben de guardarse en un postgreSQL, esto para replicar la necesidad de motores externos de bases de datos en la vida real.
Ingesta inicial. La primer insersión de los datos a su base de datos debe de ser a través de Bash.
Modelo como Servicio Web. La API debe tener un modelo corriendo a manera de servicio.
Reentrenamiento del Modelo . Pasado un tiempo y con suficientes datos nuevos, usualmente se busca un reentrenamiento del modelo, por lo cual su API debe de ser capaz de hacerlo mediante una solicitud.
Ambiente totalmente reproducible. La API debe estar empaquetada por completo para que pueda correr sin ningún problema en cualquier computadora.
Captura de resultados del Modelo. Se busca entender el rendimiento y precisión del modelo, por ello es necasio desplegar sus resultados de desempeño, tal que el equipo de ciencia de datos pueda entender qué tan bien o mal está respondiendo.
Infraestructura y Ejecución
Para ejecutar este producto de datos se requiere:

Para levantar la imagen de docker y la base de datos:
1.	Descargar el archivo…
2.	Limpieza de datos:
3.	Construir la imagen de docker:
Para acceder a los servicios del producto de datos:
1.	Abrir el explorador de internet e ir a la siguiente dirección:
i.	localhost
2.	Se accede a la página principal que contiene 4 botones con las siguientes funciones:
i.	Mostrar datos: Muestra la tabla disponible en la base de datos con el dataset utilizado para entrenar el modelo. Nota: El dataset se creó a partir de todas las propiedades que se encuentran disponibles en la plataforma de AirBnB
ii.	Realizar predicción sobre el precio por noche: Permite realizar una predicción, al ingresar los campos más importantes para explicar el precio promedio
iii.	Explicación de variables:

iv.	Agregar registro a nueva base de datos: Permite agregar observaciones a la base de datos que se crea a partir de la información que proveen los usuarios, sin embargo, esta no se añade a la base de datos de AirBnB.
v.	Mostrar predicciones: Se muestran las predicciones realizadas hasta el momento.






3.	Adicionalmente, se puede visualizar y trabajar con la base de datos utilizando el servicio de pgAdmin, para ello, ejecutar lo siguiente:
i.	Abrir el explorador de internet e ir a la siguiente dirección:
a.	localhost:8000
ii.	Después de visualizar la pantalla de bienvenida de pgAdmin, ingresar los siguientes datos:
a.	username: admin@admin.com
b.	password: admin
iii.	Después de entrar al servicio de pgAdmin, dar click derecho sobre Servers en el menú de la izquierda, seleccionar Create y posteriormente Server.
iv.	En la ventana que se despliega, capturar la siguiente información:
a.	Pestaña General: Darle nombre al servidor, por ejemplo: Rodent.
b.	Pestaña Connection:
a.	Host name: db
b.	Username: root
c.	Password: root
v.	Estarán disponibles las siguientes tablas:
a.	all_info: Contiene los registros del dataset de entrenamiento del modelo.
b.	predicted_results: Contiene las predicciones realizadas.
4.	Para salir de este producto de datos, hay que cerrar las pestañas del explorador y ejecutar Ctrl+C en la terminal donde se está corriendo la imagen de Docker.
Re-Entrenamiento del modelo:
1.	El modelo lo podrán reentrenar solo los administradores del proyecto, esto debido a que el proceso se llevará a cabo a través de la actualización de los hospedajes que se encuentran disponibles en la plataforma de AirBnB, es decir, el reentrenamiento no se lleva a cabo con la información que se genera  a través de las predicciones realizadas, sino por un proceso de actualización de la base de datos original.
2.	Se crea una nueva base de datos con las proyecciones e intereses de inversión, así se podrá consultar esta información, eliminar registros que no generen información útil para el proyecto y actualizar registros.


EDA
Se puede consultar el análisis exploratorio de datos en la carpeta del respositorio.
Entrenamiento
Se puede consultar los detalles del entrenamiento del modelo de predicción en el código de R.

Aspectos a evaluar
Limpieza de código
Documentación del código
Funcionamiento del código

