import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["description", "sheet"]

  connect() {
    console.log("🔥 SHEET TOGGLE CONNECTED")
  }

  toggle() {
    console.log("🔥 TOGGLE CLICKED")

    this.descriptionTarget.classList.toggle("d-none")
    this.sheetTarget.classList.toggle("d-none")
  }
}
