import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invite-link"
export default class extends Controller {

  static values = {
    url: String
  }

  static targets = ["caption", "sign"]

  async copy() {
    await navigator.clipboard.writeText(this.urlValue)

    this.captionTarget.textContent = "Copied!"
  }

  sign(event) {
    event.preventDefault()

    this.signTarget.src = "/assets/signed.png"

    setTimeout(() => {
      this.element.closest("form").submit()
       //finds the button_to form and submits it
    }, 1500)
  }
}
