import configparser
import psycopg2
import pandas as pd

class Lake:
    
    def __init__(self, conf,queries):
        self.config = configparser.ConfigParser()
        self.config.read(conf)
        self.queries = queries

    def __connect_db(self, env):
        db = self.config[env]['database']
        usr = self.config[env]['user']
        pswrd = self.config[env]['password']
        host = self.config[env]['host']
        port = self.config[env]['port']
        option = f"-c search_path=dbo,{self.config[env]['schema']}"

        conn = psycopg2.connect(
            database=db, 
            user=usr,
            password=pswrd,
            host=host,
            port=port,
            options=option
        )
        return conn

    def get_source_data(self, env, schema, table):
        conn = self.__connect_db(env)
        cursor = conn.cursor()

        try:
            cursor.execute(f'SELECT * FROM {f"{schema}.{table}"}')
            
            # fetch all data 
            result_source = cursor.fetchall()

            colnames = [desc[0] for desc in cursor.description]

            df = pd.DataFrame(result_source, columns=colnames)
            target = table.replace('"', "")
            df.to_csv(f'./New Data/{target}.csv', sep=';', index=False)
            print(f'{target}.csv crée avec succès')
        except (Exception, psycopg2.DatabaseError) as error:
            print(f"Erreur: {error}")
            conn.rollback()
        finally:
            cursor.close()
            conn.close()
    
    def remake_db(self,env):
        conn = self.__connect_db(env)
        cursor = conn.cursor()
        file_path = self.queries
        try:
            # Lire les requêtes SQL depuis le fichier
            with open(file_path, "r") as file:
                queries = file.read()

            # Exécuter les requêtes SQL
            cursor.execute(queries)
            conn.commit()
            print("Base de données réinitialisée avec succès.")
        except (Exception, psycopg2.DatabaseError) as error:
            print(f"Erreur: {error}")
            conn.rollback()
        finally:
            cursor.close()
    
    def copy_from_csv(self, env, table, csv_file_path):
        conn = self.__connect_db(env)
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



# Usage
lake = Lake(conf='cred.ini', queries='queries.sql')

tables_source = ['"User"','"Hive"','"HiveData"','"Session"']
tables_target = ['"user"','"hive"','"hive_data"','"session"']

schema_source = 'public.'

for table in tables_source:
    schema = 'public'
    lake.get_source_data(env='SOURCE',schema='public', table=table)

lake.remake_db(env='TARGET')

for i in range(len(tables_target)):
    file_name = tables_source[i].replace('"','') 
    file_name_raw =  fr".\New Data\{file_name}.csv"

    lake.copy_from_csv(env='TARGET', table=tables_target[i], csv_file_path=file_name_raw)



