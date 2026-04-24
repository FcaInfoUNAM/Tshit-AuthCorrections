# TShit

## clone the repository

```cmd
git clone "{url}"
```
visualiza la estructura de archivos en del repositorio

## Corregir la conexión a la base de datos

### Paso1
1. Agrega al archivo de configuración el atributo database.schema en el archivo config.json y coloca las credenciales d etu base de datos
```
...
"database":{
        "host":"localhost",
        "user":"root",
        "password":"root",
        "schema":"tshirt"
    },
...
```
Run the database creation scripts
```bash
psql -U postgres -f app/database/schema/user.sql
psql -U root -d tshit -f app/database/schema/main.sql
```
2. Importa las bibliotecas os.path, json y manda a llamar la configuración el archivo config.json en lugar de las cadenas en el código

```python
import mysql.connector
import os.path
import json

class mysqlConn:
    
    def __init__(self,config):
        config = json.load( open('./config.json'))
        database = config['database']
        self.connect =mysql.connector.connect(
        host=database["host"],
        user=database["user"],
        password=database["password"],
        database=database["schema"]
        )
#### ...
```
 3. Prueba el correcto funcionamiento de la app 

```flask --app main run --debug```

## Generar un token nuevo en lugar de usar el id de usuario

1. crea un usuario
``` bash
curl --location 'localhost:5000/v1/signUp' --header 'Content-Type: application/json' --data-raw '{
  "name": "John Doe",
  "user": "jdoe",
  "email": "jdoe@example.com",
  "status": "active",
  "type": "admin",
  "passwd": "SecurePassword123!",
  "passwd2": "SecurePassword123!"
}'
```
1. crea un usuario
``` bash
curl --location 'localhost:5000/v1/signUp' --header 'Content-Type: application/json' --data-raw '{
  "name": "John Doe",
  "user": "jdoe",
  "email": "jdoe@example.com",
  "status": "active",
  "type": "admin",
  "passwd": "SecurePassword123!",
  "passwd2": "SecurePassword123!"
}'
```
2. Logueate con ese usuario
```bash
curl --location 'http://127.0.0.1:5000/v1/auth' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "jdoe@example.com",
  "passwd": "SecurePassword123!"
}'
```

3. prueba el usuario con un endpoint diferente

```bash
curl --location --request GET 'http://127.0.0.1:5000/v1/proveedor?authKey=14c7fc7e05064000'
```
4. Revisa la carpeta auth, encontrarás que se generan archivos por casa sesión, revisa uno de ellos y valida la información del usuario


5. Analiza qué ventajas tiene que se genere más de una llave por usuario y qué desventajas podría tener (revisa la carpeta auth)

6. Revisa la base de datos

```bash
psql -U root -d tshit
```
```sql
SELECT * FROM users;
```


7. Inserta un proveedor y revisa la base de datos
```bash
curl --location 'http://127.0.0.1:5000/v1/proveedor?authKey=111b7bcd2b064000' --header 'Content-Type: application/json' --data '{
    "name":"Proveedor",
    "RFC":"PV212121123",
    "legalName":"Proveedor SA DE CV",
    "legalAddress":"CALE 1 COL 1 DEL 1 MX",
    "active":true
}'
```
```bash
psql -U root -d tshit
```
```sql
SELECT * FROM proveedores;
```
