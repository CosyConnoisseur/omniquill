import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { campaignId: Number }

  connect() {
    console.log("connected to tabs")
    this.decideTab()

    // listen for turbo renders so it runs on every note updates
    document.addEventListener("turbo:render", this.handleTurboRender)
  }

  disconnect() {
    console.log("disconnecting")
    document.removeEventListener("turbo:render", this.handleTurboRender)
  }

  // arrow function locks in 'this'
  handleTurboRender = () => {
    this.decideTab()
  }

  decideTab() {
    console.log("deciding tab")
    const hash = window.location.hash
    let targetTabId = null

    //A use hash
    if (hash) {
      const cleanHash = hash.replace("#", "")

      if (this.element.querySelector(`#${cleanHash}`)) {
        targetTabId = cleanHash
      }
    }

    // B use saved tab
    if (!targetTabId) {
      const storageKey = `campaign_tab_${this.campaignIdValue}`
      targetTabId = localStorage.getItem(storageKey)
    }

    //C go to tab but only run if it's not already active / Keep scroll position
    if (targetTabId) {
      const tabTriggerEl = this.element.querySelector(`#${targetTabId}`)

      if (tabTriggerEl && !tabTriggerEl.classList.contains("active") && typeof bootstrap !== "undefined" && bootstrap.Tab) {

        const urlParams = new URLSearchParams(window.location.search)
        const shouldPreserveScroll = urlParams.get('scroll') === 'preserve'

        if (shouldPreserveScroll) {
          const scrollX = window.scrollX
          const scrollY = window.scrollY

          requestAnimationFrame(() => {
            const tab = bootstrap.Tab.getOrCreateInstance(tabTriggerEl)
            tab.show()
            window.scrollTo(scrollX, scrollY) // immediately go to scroll position

            // Scrub the URL bar
            const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname + window.location.hash
            window.history.replaceState({ path: cleanUrl }, '', cleanUrl)
          })

        } else {
          requestAnimationFrame(() => {
            const tab = bootstrap.Tab.getOrCreateInstance(tabTriggerEl)
            tab.show()
            })
          }
      }
    }
  }

  //save tab in localStorage
  saveTab(event) {
    console.log("saving tab")
    const activeTabId = event.target.id
    if (activeTabId) {
      const storageKey = `campaign_tab_${this.campaignIdValue}`
      localStorage.setItem(storageKey, activeTabId)
    }
  }
}
