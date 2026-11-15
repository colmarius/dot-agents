export function createStore() {
  const notes = new Map();
  let nextId = 1;

  return {
    list({ tag } = {}) {
      const all = [...notes.values()];
      return tag ? all.filter((note) => note.tags.includes(tag)) : all;
    },
    get(id) {
      return notes.get(id) ?? null;
    },
    create({ title, body = "", tags = [] }) {
      const note = { id: nextId++, title, body, tags, createdAt: new Date().toISOString() };
      notes.set(note.id, note);
      return note;
    },
    update(id, changes) {
      const note = notes.get(id);
      if (!note) return null;
      for (const key of ["title", "body", "tags"]) {
        if (changes[key] !== undefined) note[key] = changes[key];
      }
      return note;
    },
    remove(id) {
      return notes.delete(id);
    },
  };
}
