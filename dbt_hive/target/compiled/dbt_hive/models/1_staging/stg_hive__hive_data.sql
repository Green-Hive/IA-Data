WITH source_data AS (
    select 
        *
    from 
        "hive"."lake"."hive_data"
)

SELECT * FROM source_data