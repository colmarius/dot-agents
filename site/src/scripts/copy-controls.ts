const copyIcon = `
  <svg class="copy-icon" aria-hidden="true" viewBox="0 0 24 24" width="18" height="18">
    <rect x="8" y="8" width="12" height="12" rx="2"></rect>
    <path d="M16 8V6a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h2"></path>
  </svg>`;

async function copyText(value: string) {
  if (navigator.clipboard && window.isSecureContext) {
    await navigator.clipboard.writeText(value);
    return;
  }

  const input = document.createElement("textarea");
  input.value = value;
  input.setAttribute("readonly", "");
  input.style.position = "fixed";
  input.style.opacity = "0";
  document.body.append(input);
  input.select();

  const copied = document.execCommand("copy");
  input.remove();

  if (!copied) throw new Error("Copy command failed");
}

export function addCopyControl(container: HTMLElement, content: HTMLElement, name: string) {
  if (container.querySelector("[data-copy-control]")) return;

  const subject = name.charAt(0).toUpperCase() + name.slice(1);
  const idleLabel = `Copy ${name}`;
  const button = document.createElement("button");
  const status = document.createElement("span");
  let resetTimer: number | undefined;

  button.className = "copy-button";
  button.type = "button";
  button.dataset.copyControl = "";
  button.setAttribute("aria-label", idleLabel);
  button.title = idleLabel;
  button.innerHTML = copyIcon;

  status.className = "sr-only";
  status.setAttribute("aria-live", "polite");
  status.setAttribute("aria-atomic", "true");

  button.addEventListener("click", async () => {
    window.clearTimeout(resetTimer);

    try {
      await copyText((content.textContent ?? "").trim());
      button.classList.add("is-copied");
      button.setAttribute("aria-label", `${subject} copied`);
      button.title = "Copied";
      status.textContent = `${subject} copied to clipboard.`;
    } catch {
      button.classList.remove("is-copied");
      button.setAttribute("aria-label", `${subject} could not be copied`);
      button.title = "Copy failed";
      status.textContent = `${subject} could not be copied.`;
    }

    resetTimer = window.setTimeout(() => {
      button.classList.remove("is-copied");
      button.setAttribute("aria-label", idleLabel);
      button.title = idleLabel;
      status.textContent = "";
    }, 2000);
  });

  container.prepend(button, status);
}
