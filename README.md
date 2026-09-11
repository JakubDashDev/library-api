# Library Management API

## Running it

```
docker compose up
```

The API is available at `http://localhost:3000`, seeded automatically.

A Postman collection is at `postman/library-api.postman_collection.json`.

Emails can be viewed in Mailpit at `http://localhost:8025`

## Key design decisions

1. Solid Queue is used for background job processing because it's built into Rails. No extra infrastructure needed, which keeps the setup simple and is enough for an early stage API.
2. Serial numbers and customer card numbers are server-generated, six-digit strings, produced by picking a random number and retrying on collision. Since they're never used as database primary/foreign keys, storing them as strings costs nothing, while preserving genuine leading zeros and matching the "six-digit number" requirement literally. Uniqueness and format are enforced at both the Rails and database level. A Postgres sequence was omitted to keep app startup simple.
3. A book's status is derived from its most recent borrowing's `returned_at` value, rather than stored as its own column. It is enough to answer "is this book available," with no risk of the two drifting out of sync.
4. Blueprinter is used for serializing data because it is lightweight, with named views to separate a lightweight list representation from a detailed one that includes full borrowing history.
5. Reminder emails are scheduled as individual jobs at the moment a book is borrowed, rather than a periodic polling job. Early returns cancel their scheduled reminder jobs directly through Solid Queue's execution records.

## Limitations

1. Solid Queue has limited throughput compared to a Redis-backed queue.
2. Job cancellation relies on undocumented Solid Queue internals rather than a public API.
3. Deleting a book also deletes its borrowing history.
4. No pagination/filtering on list endpoints.
5. The six-digit code space is finite.
6. No retry/discard policy configured on `ReminderJob`.
7. No automated test suite.

## Future development

1. Move to Sidekiq + Redis if job volume grows enough to affect app/database performance.
2. Widen the unique serial number / customer card number to more digits.
3. Add pagination for performance.

## Future features

1. Sorting and filtering for books.
2. Customer-engagement features: stats, borrowing history, leaderboards.
3. Extend the book entity: categories, age rating, description, publish date.
4. A recommendation engine based on categories and customer borrowing history.
5. Soft delete for books, so book data can persist after "deletion."
