import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { campaignId: Number }

  connect() {
    console.log("connected to tabs")
    // 1. Build the exact key name for this specific campaign
    const storageKey = `campaign_tab_${this.campaignIdValue}`
    const savedTabId = localStorage.getItem(storageKey)

    if (savedTabId) {
      // 2. Safely capture the correct button element
      const tabTriggerEl = this.element.querySelector(`#${savedTabId}`)

      // 3. Fire Bootstrap manually only if the tab isn't already the visible active choice
      if (tabTriggerEl && !tabTriggerEl.classList.contains("active") && typeof bootstrap !== "undefined" && bootstrap.Tab) {
        const tab = bootstrap.Tab.getOrCreateInstance(tabTriggerEl)
        tab.show()
      }
    }
  }

  saveTab(event) {
    const activeTabId = event.target.id

    if (activeTabId) {
      const storageKey = `campaign_tab_${this.campaignIdValue}`
      localStorage.setItem(storageKey, activeTabId)
    }
  }
}
