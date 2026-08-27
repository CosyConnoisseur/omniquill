import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { campaignId: Number }

  connect() {
    console.log("connected to tabs")

    const hash = window.location.hash
    let targetTabId = null

    //A use hash
    if (hash) {
      const cleanHash = hash.replace("#", "")


      if (this.element.querySelector(`#${cleanHash}`)) {
        targetTabId = cleanHash
      }
    }

    //B use saved tab
    if (!targetTabId) {
      const storageKey = `campaign_tab_${this.campaignIdValue}`
      targetTabId = localStorage.getItem(storageKey)
    }

    //C go to tab but only run if it's not already active
    if (targetTabId) {
      const tabTriggerEl = this.element.querySelector(`#${targetTabId}`)

      if (tabTriggerEl && !tabTriggerEl.classList.contains("active") && typeof bootstrap !== "undefined" && bootstrap.Tab) {
        setTimeout(() => {
          const tab = bootstrap.Tab.getOrCreateInstance(tabTriggerEl)
          tab.show()
        }, 2)
      }
    }
  }

  //save tab in localStorage
  saveTab(event) {
    const activeTabId = event.target.id

    if (activeTabId) {
      const storageKey = `campaign_tab_${this.campaignIdValue}`
      localStorage.setItem(storageKey, activeTabId)
    }
  }
}
