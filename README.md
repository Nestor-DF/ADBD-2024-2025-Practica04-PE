## Instrucciones para Usar el Script con Docker

0. **Asegúrate de tener Docker y el cliente postgreSQL instalado en tu máquina.**
```bash
sudo apt update
sudo apt install docker.io
sudo apt install postgresql-client
```

1. **Construir la imagen Docker**:
```bash
docker build -t my-postgres-image .
```

2. **Ejecutar el contenedor Docker**:
```bash
docker run --name my-postgres-container -v $(pwd):/docker-entrypoint-initdb.d -e POSTGRES_USER=nestor -e POSTGRES_PASSWORD=12ab12ab -e POSTGRES_DB=viveros -p 5432:5432 my-postgres-image
```

3. **Conectarse a postgresql**:
```bash
psql -h localhost -U nestor -d postgres
```

4. **Ejecutar el script**:
```sql
\i script.sql
```