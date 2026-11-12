-- Staging: one row per order, types cast, nothing else.
with source as (

    select * from {{ ref('raw_orders') }}

)

select
    id::varchar           as order_id,
    customer_id::varchar  as customer_id,
    ordered_at::timestamp as ordered_at,
    status::varchar       as status,
    amount_cents::int     as amount_cents
from source
