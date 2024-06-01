WITH source_data AS (
    select 
        *
    from 
        {{ source('hive','hive_data') }}
)

SELECT * FROM source_data