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
