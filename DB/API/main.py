import os
import psycopg2
import pandas as pd
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from .env file

class Lake:
    
    def __init__(self, queries):
        self.queries = queries

    def __connect_db(self, env_prefix):
        db = os.getenv(f'{env_prefix}_DB_NAME')
        usr = os.getenv(f'{env_prefix}_DB_USER')
        pswrd = os.getenv(f'{env_prefix}_DB_PASSWORD')
        host = os.getenv(f'{env_prefix}_DB_HOST')
        port = os.getenv(f'{env_prefix}_DB_PORT')
        schema = os.getenv(f'{env_prefix}_DB_SCHEMA')
        option = f"-c search_path=dbo,{schema}"

        conn = psycopg2.connect(
            database=db, 
            user=usr,
            password=pswrd,
            host=host,
            port=port,
            options=option
        )
        return conn

    def get_source_data(self, env_prefix, schema, table):
        conn = self.__connect_db(env_prefix)
        cursor = conn.cursor()

        try:
            cursor.execute(f'SELECT * FROM {f"{schema}.{table}"}')
            
            # fetch all data 
            result_source = cursor.fetchall()

            colnames = [desc[0] for desc in cursor.description]

            df = pd.DataFrame(result_source, columns=colnames)
            target = table.replace('"', "")
            df.to_csv(f'{target}.csv', sep=';', index=False)
            print(f'{target}.csv successfully created')
        except (Exception, psycopg2.DatabaseError) as error:
            print(f"Erreur: {error}")
            conn.rollback()
        finally:
            cursor.close()
            conn.close()
    
    def remake_db(self,env_prefix):
        conn = self.__connect_db(env_prefix)
        cursor = conn.cursor()
        file_path = self.queries
        try:
            # Lire les requêtes SQL depuis le fichier
            with open(file_path, "r") as file:
                queries = file.read()

            # Exécuter les requêtes SQL
            cursor.execute(queries)
            conn.commit()
            print("Database successfully reset.")
        except (Exception, psycopg2.DatabaseError) as error:
            print(f"Erreur: {error}")
            conn.rollback()
        finally:
            cursor.close()
    
    def copy_from_csv(self, env_prefix, table, csv_file_path):
        conn = self.__connect_db(env_prefix)
        cursor = conn.cursor()
        with conn.cursor() as cursor:
            try:
                with open(csv_file_path, 'r') as f:
                    cursor.copy_expert(f"COPY {table} FROM STDIN WITH CSV HEADER DELIMITER ';'", f)
                conn.commit()
                print(f"Data copied successfully from {csv_file_path} to {table}.")
            except (Exception, psycopg2.DatabaseError) as error:
                print(f"Error: {error}")
                conn.rollback()
            finally:
                cursor.close()
                conn.close() 
                os.remove(csv_file_path)





# Usage
lake = Lake(queries='queries.sql')

tables_source = ['"User"','"Hive"','"HiveData"','"Session"']
tables_target = ['"user"','"hive"','"hive_data"','"session"']

for table in tables_source:
    lake.get_source_data(env_prefix='SOURCE',schema='public', table=table)

lake.remake_db(env_prefix='TARGET')

for i in range(len(tables_target)):
    file_name = tables_source[i].replace('"','') 
    file_name_raw =  fr"{file_name}.csv"

    lake.copy_from_csv(env_prefix='TARGET', table=tables_target[i], csv_file_path=file_name_raw)



