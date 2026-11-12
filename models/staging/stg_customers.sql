-- Staging: one row per customer.
with source as (

    select * from {{ ref('raw_customers') }}

)

select
    id::varchar           as customer_id,
    email::varchar        as email,
    created_at::timestamp as created_at
from source
