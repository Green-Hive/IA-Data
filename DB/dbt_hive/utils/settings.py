import os
from dotenv import load_dotenv
import platform

VENV = 'local'
CURRENT_PATH = os.path.dirname(os.path.realpath(__file__))

DBT_PROJECT_NAME = 'dbt_hive'

DBT_BASE_PATH = os.path.join(CURRENT_PATH,os.pardir)
DBT_MODELS_PATH = os.path.join(DBT_BASE_PATH,'models')   
DBT_MACROS_PATH = os.path.join(DBT_BASE_PATH,'macros')   
DBT_SOURCES_PATH = os.path.join(DBT_MODELS_PATH,'0_sources')   
DBT_TARGETS_PATH = os.path.join(DBT_BASE_PATH,'target')   

PATH_VENV = DBT_BASE_PATH = os.path.join(CURRENT_PATH,os.pardir,os.pardir,os.pardir,VENV)



# Load environment variables from the .env file
load_dotenv(os.path.join(DBT_BASE_PATH,'.env'), override=True)

# # Optionally, you can print the environment variables to verify
# print("DBT_DB_HOST:", os.getenv("DBT_DB_HOST"))
# print("DBT_DB_USER:", os.getenv("DBT_DB_USER"))
# print("DBT_DB_PASSWORD:", os.getenv("DBT_DB_PASSWORD"))
# print("DBT_DB_PORT:", os.getenv("DBT_DB_PORT"))
# print("DBT_DB_NAME:", os.getenv("DBT_DB_NAME"))
# print("DBT_DB_SCHEMA:", os.getenv("DBT_DB_SCHEMA"))
