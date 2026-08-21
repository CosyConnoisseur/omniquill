import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open() {
    this.modalTarget.classList.remove("d-none")
  }

  close() {
    this.modalTarget.classList.add("d-none")
  }

  closeOutside(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }
  zoom(event) {
    event.currentTarget.classList.toggle("zoomed")
  }

}
