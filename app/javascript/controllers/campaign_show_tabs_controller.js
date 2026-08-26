import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { campaignId: Number }

  connect() {
    console.log("connected to tabs")

    // 1. Check if a hash is present in the URL (e.g., "#link1-tab" or "#active-tab")
    const hash = window.location.hash
    let targetTabId = null

    if (hash) {
      // Clean up the hash to get the raw ID string
      const cleanHash = hash.replace("#", "")

      // Safety check: verify an element with this exact ID exists inside our tabs container
      if (this.element.querySelector(`#${cleanHash}`)) {
        targetTabId = cleanHash
      }
    }

    // 2. If no valid hash was used in the link, fall back to your working localStorage setup
    if (!targetTabId) {
      const storageKey = `campaign_tab_${this.campaignIdValue}`
      targetTabId = localStorage.getItem(storageKey)
    }

    // 3. Fire Bootstrap manually to fully display and select the tab layout
    if (targetTabId) {
      const tabTriggerEl = this.element.querySelector(`#${targetTabId}`)

      if (tabTriggerEl && !tabTriggerEl.classList.contains("active") && typeof bootstrap !== "undefined" && bootstrap.Tab) {
        // Wrap in a tiny delay to ensure the browser's native focus sequence finishes first
        setTimeout(() => {
          const tab = bootstrap.Tab.getOrCreateInstance(tabTriggerEl)
          tab.show()
        }, 1)
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


// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static values = { campaignId: Number }

//   connect() {
//     console.log("connected to tabs")
//     // 1. Build the exact key name for this specific campaign
//     const storageKey = `campaign_tab_${this.campaignIdValue}`
//     const savedTabId = localStorage.getItem(storageKey)

//     if (savedTabId) {
//       // 2. Safely capture the correct button element
//       const tabTriggerEl = this.element.querySelector(`#${savedTabId}`)

//       // 3. Fire Bootstrap manually only if the tab isn't already the visible active choice
//       if (tabTriggerEl && !tabTriggerEl.classList.contains("active") && typeof bootstrap !== "undefined" && bootstrap.Tab) {
//         const tab = bootstrap.Tab.getOrCreateInstance(tabTriggerEl)
//         tab.show()
//       }
//     }
//   }

//   saveTab(event) {
//     const activeTabId = event.target.id

//     if (activeTabId) {
//       const storageKey = `campaign_tab_${this.campaignIdValue}`
//       localStorage.setItem(storageKey, activeTabId)
//     }
//   }
// }
