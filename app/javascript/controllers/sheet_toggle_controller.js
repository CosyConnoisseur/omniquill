import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open(event) {
    if (window.innerWidth <= 600) {
      window.open(event.currentTarget.src, "_blank")
    } else {
      event.currentTarget.classList.toggle("zoomed")
    }
  }

  close() {
    this.modalTarget.classList.add("d-none")
  }

  closeOutside(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }


}
