# Order statuses

Agreed with the source owner, March 2024.

| Status | Meaning |
|---|---|
| `pending` | Order placed, not yet shipped |
| `shipped` | Handed to the carrier |
| `completed` | Delivered and settled |
| `cancelled` | Cancelled before shipping |

The normal path is `pending` → `shipped` → `completed`. `cancelled` is terminal
and can follow `pending` only.

This list is revised when the order process changes. If you see a value that is
not here, it has not been agreed — go to the source owner before assuming it is
valid. Today's rows show you what exists, not what is allowed.
