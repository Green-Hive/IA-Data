
  
    

  create  table "hive"."atlas_STAGING"."stg_hive__hive_data__dbt_tmp"
  
  
    as
  
  (
    WITH source_data AS (
    select 
        *
    from 
        "hive"."lake"."hive_data"
)

SELECT * FROM source_data
  );
  