import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["buffer", "nameInput", "descriptionInput"]

  // This runs automatically every time Turbo broadcasts an append to the buffer div
  connect() {
    console.log("Stimulus connected to the form successfully!")
    this.mutationObserver = new MutationObserver(() => this.parseAndFill())
    this.mutationObserver.observe(this.bufferTarget, { textContent: true, childList: true, subtree: true })
  }

  parseAndFill() {
    const rawText = this.bufferTarget.innerText
    console.log("Buffer updated! Text contents:", rawText)

    // Regex matches the string sequence
    const nameMatch = rawText.match(/NAME:\s*([^\n\r]*)/i)
    const descMatch = rawText.match(/DESCRIPTION:\s*([\s\S]*)/i)

    // FIX: Read from index 1 (the captured group) and run replace/trim directly on it
    if (nameMatch && nameMatch[1]) {
      const cleanName = nameMatch[1].replace(/[\*\#_\[\]]/g, "").trim()
      this.nameInputTarget.value = cleanName
    }

    if (descMatch && descMatch[1]) {
      this.descriptionInputTarget.value = descMatch[1].trim()
    }
  }

  disconnect() {
    if (this.mutationObserver) this.mutationObserver.disconnect()
  }
}
