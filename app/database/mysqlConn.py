import psycopg2
from psycopg2 import sql
import json

class mysqlConn:
    
    def __init__(self,config):
        config = json.load( open('./config.json'))
        database = config['database']
        self.connect =psycopg2.connect(
        host=database["host"],
        user=database["user"],
        password=database["password"],
        database=database["schema"],
        port=5432
        )
        self.connect.autocommit = False
    
    def start(self):
        self.cursor = self.connect.cursor()
    
    def stop(self):
        self.cursor.close()
        self.connect.close()
    
    # INSERT
    def insert(self, table: str, values: list):
        placeholders = ", ".join(["%s"] * len(values))
        query = sql.SQL("INSERT INTO {} VALUES ({})").format(
            sql.Identifier(table),
            sql.SQL(placeholders)
        )
        try:
            self.cursor.execute(query, values)
            self.connect.commit()
            self.cursor.close()
            return {"code": 200, "msg": "Successfully inserted"}
        except psycopg2.Error as e:
            self.connect.rollback()
            return {"code": 500, "msg": str(e)}
    
    # UPDATE
    def update(self, table: str, id: str, values: dict):
        set_clauses = []
        set_values = []
        
        for key, value in values.items():
            set_clauses.append(sql.Identifier(key))
            set_values.append(value)
        
        set_values.append(id)  # for WHERE clause
        
        query = sql.SQL("UPDATE {} SET {} WHERE id = %s").format(
            sql.Identifier(table),
            sql.SQL(", ").join([
                sql.SQL("{} = %s").format(sql.Identifier(k)) 
                for k in values.keys()
            ])
        )
        
        try:
            self.cursor.execute(query, list(values.values()) + [id])
            self.connect.commit()
            self.cursor.close()
            return {"code": 200, "msg": "Updated Successfully"}
        except psycopg2.Error as e:
            self.connect.rollback()
            return {"code": 309, "msg": str(e)}
    
    # DELETE
    def delete(self, tabla: str, id: str):
        query = sql.SQL("DELETE FROM {} WHERE id = %s").format(
            sql.Identifier(tabla)
        )
        try:
            self.cursor.execute(query, (id,))
            self.connect.commit()
            self.cursor.close()
            return {"code": 200, "msg": "Successfully deleted"}
        except psycopg2.Error as e:
            self.connect.rollback()
            return {"code": 309, "msg": str(e)}
    
    # GET ALL
    def getAll(self, tabla: str):
        query = sql.SQL("SELECT * FROM {}").format(
            sql.Identifier(tabla)
        )
        try:
            self.cursor.execute(query)
            myresult = self.cursor.fetchall()
            self.cursor.close()
            print(myresult)
            return {"code": 200, "msg": myresult}
        except psycopg2.Error as e:
            return {"code": 309, "msg": str(e)}
    
    # GET
    def get(self, tabla: str, id: str):
        query = sql.SQL("SELECT * FROM {} WHERE id = %s").format(
            sql.Identifier(tabla)
        )
        try:
            self.cursor.execute(query, (id,))
            myresult = self.cursor.fetchall()
            self.cursor.close()
            return {"code": 200, "msg": myresult}
        except psycopg2.Error as e:
            return {"code": 309, "msg": str(e)}

    #SEARCH
    def search(self, tabla: str, values: dict, search: str):
        # Construimos los marcadores de posición (%s) para evitar inyección SQL
        # psycopg2 se encarga de detectar si es int, str, etc.
        sql_parts = [f"{key} = %s" for key in values]
        
        # Unimos las condiciones según el operador
        connector = " AND " if search == "AND" else " OR "
        where_clause = connector.join(sql_parts)
        
        # Usamos Identifier para el nombre de la tabla (opcional pero recomendado)
        sql = f"SELECT * FROM {tabla} WHERE {where_clause}"
        
        try:
            # Pasamos los valores como un segundo argumento a execute
            self.cursor.execute(sql, list(values.values()))
            myresult = self.cursor.fetchall()
            
            # Nota: cerrar el cursor aquí invalidará futuras operaciones 
            # a menos que crees uno nuevo en cada llamada.
            self.cursor.close() 
            
            return {"code": 200, "msg": myresult}
        except (Exception, psycopg2.Error) as e:
            return {"code": 309, "msg": str(e)}
