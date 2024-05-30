from airflow import DAG
from airflow.operators.dummy import DummyOperator
from datetime import datetime
from airflow.operators.python import PythonOperator

# Identification du DAG
DAG_ID = 'test_1'


def function_1():
    print("Run function_1!")


def function_2():
    print("Run function_2!")


def function_3():
    print("Run function_3!")


# Définition du DAG
with DAG(DAG_ID,
         schedule_interval='@daily',catchup=False) as dag:

    start_task = DummyOperator(task_id='start')

    end_task = DummyOperator(task_id='end')

    task_1 = PythonOperator(task_id='task_1', python_callable=function_1)
    task_2 = PythonOperator(task_id='task_2', python_callable=function_2)
    task_3 = PythonOperator(task_id='task_3', python_callable=function_3)
    task_4 = PythonOperator(task_id='task_4', python_callable=function_3)

    start_task >> task_1 >> [task_2, task_3, task_4] >> end_task
