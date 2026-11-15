export function createStore() {
  const notes = new Map();
  let nextId = 1;

  return {
    list({ tag, limit, offset = 0 } = {}) {
      const all = [...notes.values()];
      const matching = tag ? all.filter((note) => note.tags.includes(tag)) : all;
      return limit === undefined ? matching.slice(offset) : matching.slice(offset, offset + limit);
    },
    get(id) {
      return notes.get(id) ?? null;
    },
    create({ title, body = "", tags = [] }) {
      const note = { id: nextId++, title, body, tags, createdAt: new Date().toISOString() };
      notes.set(note.id, note);
      return note;
    },
    remove(id) {
      return notes.delete(id);
    },
  };
}
