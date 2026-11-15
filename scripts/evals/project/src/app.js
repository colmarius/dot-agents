import { createStore } from "./store.js";

async function readJson(req) {
  let raw = "";
  for await (const chunk of req) raw += chunk;
  try {
    return raw ? JSON.parse(raw) : {};
  } catch {
    return undefined;
  }
}

export function createApp(store = createStore()) {
  return async function handler(req, res) {
    const url = new URL(req.url, "http://localhost");
    const send = (status, data) => {
      res.writeHead(status, { "content-type": "application/json" });
      res.end(data === undefined ? undefined : JSON.stringify(data));
    };

    if (url.pathname === "/notes" && req.method === "GET") {
      return send(200, store.list({ tag: url.searchParams.get("tag") ?? undefined }));
    }

    if (url.pathname === "/notes" && req.method === "POST") {
      const body = await readJson(req);
      if (body === undefined) return send(400, { error: "invalid JSON" });
      return send(201, store.create({ title: body.title, body: body.body, tags: body.tags ?? [] }));
    }

    const match = url.pathname.match(/^\/notes\/(\d+)$/);
    if (match && req.method === "GET") {
      const note = store.get(Number(match[1]));
      return note ? send(200, note) : send(404, { error: "not found" });
    }
    if (match && req.method === "DELETE") {
      return store.remove(Number(match[1])) ? send(204) : send(404, { error: "not found" });
    }

    return send(404, { error: "not found" });
  };
}
