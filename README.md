## Instrucciones para Configurar la Base de Datos PostgreSQL en Docker y probar el script

1. **Construir la imagen de Docker**

```bash
docker build -t my-postgres-image .
```

2. **Ejecutar el contenedor**

```bash
docker run -d --name my-postgres-container -p 5432:5432 my-postgres-image
```

3. **Acceder al contenedor**

```bash
docker exec -it my-postgres-container bash
```

4. **Restaurar la base de datos**

```bash
pg_restore -d AlquilerDVD -U postgres -h localhost -p 5432 ./docker-entrypoint-initdb.d/AlquilerPractica.tar
```
```bash
pg_restore --clean --if-exists -d AlquilerDVD -U postgres -h localhost -p 5432 ./docker-entrypoint-initdb.d/AlquilerPractica.tar
```

5. **Conectar a la base de datos**

```bash
psql -U postgres -d AlquilerDVD
```

6. **Ejecutar script**:

```sql
\i ./docker-entrypoint-initdb.d/script.sql
```
