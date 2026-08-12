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
    console.log("Buffer changed! Current text:", rawText)
    // Execute your exact regex rules in JavaScript
    const nameMatch = rawText.match(/NAME:\s*(.*?)(?=DESCRIPTION:|$)/i)
    const descMatch = rawText.match(/DESCRIPTION:\s*([\s\S]*)/i)

    // Smoothly update the input values character-by-character
    if (nameMatch && nameMatch[1]) {
      this.nameInputTarget.value = nameMatch[1].trim()
    }

    if (descMatch && descMatch[1]) {
      this.descriptionInputTarget.value = descMatch[1].trim()
    }
  }

  disconnect() {
    if (this.mutationObserver) this.mutationObserver.disconnect()
  }
}
