# Usa la imagen oficial de PostgreSQL
FROM postgres:latest

# Configura las variables de entorno necesarias para PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=12ab12ab
ENV POSTGRES_DB=AlquilerDVD

RUN mkdir -p /docker-entrypoint-initdb.d

COPY ./initdb.sql /docker-entrypoint-initdb.d/
COPY ./script.sql /docker-entrypoint-initdb.d/
COPY ./AlquilerPractica.tar /docker-entrypoint-initdb.d/

# Exponemos el puerto de PostgreSQL
EXPOSE 5432