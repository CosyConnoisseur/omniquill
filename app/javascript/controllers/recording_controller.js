import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "status", "heading"]

  toggle() {
    this.iconTarget.classList.toggle("fa-circle")
    this.iconTarget.classList.toggle("fa-pause")

    if (this.iconTarget.classList.contains("fa-pause")) {
      this.headingTarget.textContent = "Quilliam is scribing..."
    } else {
      this.headingTarget.textContent = "Quilliam is resting..."
    }
  }
}
