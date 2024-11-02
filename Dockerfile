# Usa la imagen oficial de PostgreSQL
FROM postgres:latest

# Configura las variables de entorno necesarias para PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=12ab12ab
ENV POSTGRES_DB=AlquilerDVD

# Crea una carpeta para almacenar los scripts dentro del contenedor
RUN mkdir -p /docker-entrypoint-initdb.d

# Copia el script SQL y el archivo de respaldo al contenedor
COPY ./initdb.sql /docker-entrypoint-initdb.d/
COPY ./AlquilerPractica.tar /docker-entrypoint-initdb.d/

# Exponemos el puerto de PostgreSQL
EXPOSE 5432