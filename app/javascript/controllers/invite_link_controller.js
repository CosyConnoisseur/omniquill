import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invite-link"
export default class extends Controller {

static values = {
    url: String
  }

  async copy() {

    await navigator.clipboard.writeText(this.urlValue)
// copies value stored in this.urlValue
// https://developer.mozilla.org/en-US/docs/Web/API/Clipboard/writeText
    this.element.textContent = "Copied!"
  }
}
