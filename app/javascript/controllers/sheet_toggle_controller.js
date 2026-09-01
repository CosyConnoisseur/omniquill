import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  open(event) {
    if (window.innerWidth <= 600) {
      window.open(event.currentTarget.src, "_blank")
      return
    }

    const image = event.currentTarget

    if (image.classList.contains("zoomed")) {
      image.classList.remove("zoomed")
      return
    }

    image.classList.add("zoomed")
  }
}
