
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const savedTab = localStorage.getItem("characterTab")

    if (savedTab) {
      this.showTab(savedTab)
    } else {
      this.showTab("character")
    }
  }

  show(event) {
    const tabName = event.currentTarget.dataset.tab

    localStorage.setItem("characterTab", tabName)

    this.showTab(tabName)
  }

  showTab(tabName) {
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

    // Change folder colour
    this.element.classList.remove("brown", "green", "blue")

    if (tabName === "character") {
      this.element.classList.add("brown")
    } else if (tabName === "description") {
      this.element.classList.add("green")
    } else if (tabName === "sheet") {
      this.element.classList.add("blue")
    }
  }
}
