-- Mart: daily order totals. Incremental because the source table is
-- append-only and a full refresh gets slower every day.
{{ config(materialized='incremental', unique_key='order_date') }}

select
    date_trunc('day', ordered_at) as order_date,
    count(*)                      as order_count,
    sum(amount_cents) / 100.0     as order_total
from {{ ref('stg_orders') }}
{% if is_incremental() %}
where ordered_at >= (select max(order_date) from {{ this }})
{% endif %}
group by 1
