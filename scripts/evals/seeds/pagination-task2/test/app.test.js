import { after, before, test } from "node:test";
import assert from "node:assert/strict";
import { createServer } from "node:http";
import { createApp } from "../src/app.js";

let server;
let base;

before(async () => {
  server = createServer(createApp());
  await new Promise((resolve) => server.listen(0, resolve));
  base = `http://127.0.0.1:${server.address().port}`;
});

after(() => server.close());

const post = (body) =>
  fetch(`${base}/notes`, { method: "POST", body: JSON.stringify(body) });

test("creates and reads a note", async () => {
  const created = await (await post({ title: "First", body: "hello" })).json();
  assert.equal(created.title, "First");
  const fetched = await (await fetch(`${base}/notes/${created.id}`)).json();
  assert.deepEqual(fetched, created);
});

test("rejects invalid JSON", async () => {
  const res = await fetch(`${base}/notes`, { method: "POST", body: "{" });
  assert.equal(res.status, 400);
});

test("returns 404 for a missing note", async () => {
  const res = await fetch(`${base}/notes/9999`);
  assert.equal(res.status, 404);
});

test("deletes a note", async () => {
  const created = await (await post({ title: "Temp" })).json();
  const res = await fetch(`${base}/notes/${created.id}`, { method: "DELETE" });
  assert.equal(res.status, 204);
});

test("stores tags on a note", async () => {
  const created = await (await post({ title: "Tagged", tags: ["work"] })).json();
  assert.deepEqual(created.tags, ["work"]);
});

test("filters notes by tag", async () => {
  await post({ title: "Home", tags: ["home"] });
  const notes = await (await fetch(`${base}/notes?tag=home`)).json();
  assert.ok(notes.length >= 1);
  assert.ok(notes.every((note) => note.tags.includes("home")));
});

test("pages notes with limit and offset", async () => {
  const fresh = createServer(createApp());
  await new Promise((resolve) => fresh.listen(0, resolve));
  const url = `http://127.0.0.1:${fresh.address().port}`;
  for (const title of ["a", "b", "c", "d"]) {
    await fetch(`${url}/notes`, { method: "POST", body: JSON.stringify({ title }) });
  }
  const page = await (await fetch(`${url}/notes?limit=2&offset=1`)).json();
  assert.deepEqual(page.map((note) => note.title), ["b", "c"]);
  fresh.close();
});

test("rejects invalid paging parameters", async () => {
  for (const query of ["limit=0", "limit=101", "limit=abc", "offset=-1", "offset=1.5"]) {
    const res = await fetch(`${base}/notes?${query}`);
    assert.equal(res.status, 400, query);
  }
});
