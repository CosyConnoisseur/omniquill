import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  show(event) {
    const tabName = event.currentTarget.dataset.tab

    console.log("Clicked:", tabName)

    const contents = this.element.querySelectorAll("[data-tab-content]")

    contents.forEach((content) => {
      content.style.display = "none"
    })

    const content = this.element.querySelector(
      `[data-tab-content="${tabName}"]`
    )

    if (content) {
      content.style.display = "block"
    }
  }
}
