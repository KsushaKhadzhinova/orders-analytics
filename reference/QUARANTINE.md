# Quarantined orders

Two rows were moved out of `seeds/raw_orders.csv` into
`quarantine/raw_orders_rejected.csv` so that the data tests can stay strict and
green. They were **not deleted**: the owner decides what happens to them.

| Order | Why it was rejected | Test that caught it | Open question for the owner |
|---|---|---|---|
| `O1005` | customer `C999` does not exist in `raw_customers` | `relationships` on `stg_orders.customer_id` | Is `C999` a real customer missing from the customers extract, or a bad key? |
| `O1006` | status `refunded` is not in the agreed list | `accepted_values` on `stg_orders.status` | Is `refunded` a legitimate new state? If yes, add it to `ORDER-STATUSES.md` first, then to the test |

## Consequences

- Both orders were placed on 2024-02-03, so that day has **no row** in
  `fct_daily_orders` after the fix (before: 2 orders, 249.00).
- `fct_daily_orders` is incremental. After changing the seed it must be rebuilt
  with `dbt build --full-refresh`, otherwise the old 2024-02-03 row stays in the
  table (stale).

## The other valid way to resolve `refunded`

If the owner confirms `refunded` is a real state: add it to
`ORDER-STATUSES.md` (with who confirmed and when), add it to the
`accepted_values` list, and put `O1006` back into the seed. The test is
widened **after** the confirmation, not to make the red go away.
