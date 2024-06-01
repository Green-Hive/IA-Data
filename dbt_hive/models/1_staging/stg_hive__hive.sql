WITH source_data AS (
    select 
        *
    from 
        {{ source('hive','hive') }}
)

SELECT * FROM source_data