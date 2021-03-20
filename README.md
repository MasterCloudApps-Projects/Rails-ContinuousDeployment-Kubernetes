# Rails-ContinuousDeployment-Kubernetes

Para tener una aplicación rails dockerizada hay varias imagenes de las cuales podemos partir para crear nuestra propia imagen con nuestra aplicación.
Las hay desde una imagen con el servidor de aplicaciones y servidor web ya integrado (passenger+nginx) o se puede partir de una imagen con la versión de Ruby deseada, como puede ser en mi aplicación con Ruby 2.7.0 y añadir en la aplicación rails un servidor de aplicaciones, en mi caso uso Puma.

## Dockerfile

La diferencia entre dockerizar una aplicación rails para entorno de desarrollo o de producción se basa en las variables de entorno que declaremos para nuestra aplicación:

- RAILS_ENV, seteamos que el entorno es producción
- RAILS_SERVE_STATIC_FILES, al estar en el entorno de producción queremos que se puedan servir static files, assets.
- RAILS_LOG_TO_STDOUT, aqui le decimos que en vez de escribir en el log queremos que escriba en el stdout, salida estandar de Unix.

En el dockerfile vamos a meter como archivo entrypoints una validación por si el pid del server ya esta levantado.

La aplicación rails vamos a dockerizarla junto una base datos Postgres, vamos a crear un contenedor a partir de una imagen ya creada (postgres:12.1)

Y vamos a crear un contenedor de RabbitMQ donde vamos a consumir una cola 'product'. Y tendremos un 

La cola 'product' la va producir una aplicación rails 2.5.1 con base de datos MongoDB:

https://github.com/fjfdepedro/rails_mongo

Cada vez que se guarde en base de datos, encolaremos en la queue 'product' de RabbitMQ un json del producto creado.

Queremos es esta manera simular el tener dos microservicios.

Utilizamos variables de entorno para los parametros de conexión sa la base de datos Postgres (archivo .env)

## Docker compose

En el docker compose vamos a crear los contenedores de mi aplicación Rails y una base de datos Postgres, ademas de crear las conexiones entre ellos, vamos a crear los volumenes necesarios, y habilitar los puertos.
Este desarrollo está en el repositorio:
https://github.com/fjfdepedro/docker-compose-images

## Docker hub

Se sube la imagen a docjer hub y a partir de esa imagen vamos crear los ficheros de Helm necesarios para deplegar el servicio de nuestra aplicación a nuestro nodo local de kubernetes

https://hub.docker.com/repository/docker/fjfdepedro/rails_postgres

https://hub.docker.com/repository/docker/fjfdepedro/rails_mongo



## Helm3
Creo las plantillas para un namespace determinado con los deployments de la aplicación rails y de la base de datos postgres.
