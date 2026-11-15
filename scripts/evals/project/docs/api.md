# Notes API

All bodies are JSON.

| Method | Path | Result |
| --- | --- | --- |
| `GET` | `/notes` | `200` with all notes |
| `POST` | `/notes` | `201` with the created note; body `{ "title": string, "body"?: string }` |
| `GET` | `/notes/:id` | `200` with the note, or `404` |
| `DELETE` | `/notes/:id` | `204`, or `404` |

Invalid JSON returns `400 { "error": "invalid JSON" }`.

A note is `{ id: number, title: string, body: string, createdAt: string }`.
