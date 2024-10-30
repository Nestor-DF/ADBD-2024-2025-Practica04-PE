# Usa la imagen oficial de PostgreSQL
FROM postgres:latest

# Configura las variables de entorno necesarias para PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=12ab12ab
ENV POSTGRES_DB=AlquilerDVD

# Crea una carpeta para almacenar los scripts dentro del contenedor
RUN mkdir -p /docker-entrypoint-initdb.d

# Copia el script SQL y el archivo de respaldo al contenedor
COPY ./script.sql /docker-entrypoint-initdb.d/
COPY ./AlquilerPractica.tar /docker-entrypoint-initdb.d/

# Exponemos el puerto de PostgreSQL
EXPOSE 5432

# docker build -t my-postgres-image .
# docker run -d --name my-postgres-container -p 5432:5432 my-postgres-image
# docker exec -it my-postgres-container bash
# pg_restore -d AlquilerDVD -U postgres -h localhost -p 5432 ./docker-entrypoint-initdb.d/AlquilerPractica.tar 
# psql -U postgres -d AlquilerDVD
