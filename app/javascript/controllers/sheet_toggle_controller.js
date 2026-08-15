import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open() {
    console.log("OPEN FIRED")
    this.modalTarget.classList.remove("d-none")
  }

  close() {
    console.log("CLOSE FIRED")
    this.modalTarget.classList.add("d-none")
  }

  closeOutside(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }
}
