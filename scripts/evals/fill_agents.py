"""Fill a dot-agents AGENTS.md template with the notes-api project facts, as `adapt` would."""
import re
import sys

FACTS = {
    "Overview": "notes-api - a small JSON HTTP API for personal notes, built on Node's `http` module with an in-memory store.",
    "Tech Stack": "- Language: JavaScript (ES modules), Node.js 24\n- Framework: none (`node:http`)\n- Database: in-memory `Map` in `src/store.js`\n- Testing: `node:test`",
    "Commands": "```bash\nnpm start   # run the server on $PORT (default 3000)\nnpm test    # run all tests\n```",
    "Conventions": "- Keep handlers in `src/app.js` and data access in `src/store.js`.\n- Every endpoint change updates `docs/api.md` and adds a test in `test/app.test.js`.\n- Commit messages: imperative summary line.",
    "Architecture Notes": "`src/server.js` starts the server; `src/app.js` routes requests; `src/store.js` holds notes. `docs/api.md` is the public API reference.",
}


def fill(text: str) -> str:
    text = re.sub(r"\A> \*\*📝 TEMPLATE:\*\*.*?\n\n", "", text, flags=re.S)
    for heading, body in FACTS.items():
        pattern = re.compile(rf"(^## {re.escape(heading)}\n\n)(.*?)(?=^## |\Z)", re.S | re.M)
        text, count = pattern.subn(lambda m: m.group(1) + body + "\n\n", text)
        if count != 1:
            raise SystemExit(f"section not found once: {heading}")
    return text.rstrip() + "\n"


if __name__ == "__main__":
    sys.stdout.write(fill(open(sys.argv[1], encoding="utf-8").read()))
