import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { campaignId: Number }

  connect() {
    console.log("connected to tabs")
    this.decideTab()

    // Listen for Turbo renders so it runs on subsequent updates/morphs
    document.addEventListener("turbo:render", this.handleTurboRender)
  }

  disconnect() {
    console.log("disconnecting")
    // Clean up event listener when navigating away completely
    document.removeEventListener("turbo:render", this.handleTurboRender)
  }

  // Arrow function binds 'this' correctly for the event listener
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

    // B: Fallback to localStorage
    if (!targetTabId) {
      const storageKey = `campaign_tab_${this.campaignIdValue}`
      targetTabId = localStorage.getItem(storageKey)
    }

    // C: Trigger Bootstrap tab show
    if (targetTabId) {
      const tabTriggerEl = this.element.querySelector(`#${targetTabId}`)

      if (tabTriggerEl && typeof bootstrap !== "undefined" && bootstrap.Tab) {

        // Check if the URL contains our custom redirect flag
        const urlParams = new URLSearchParams(window.location.search)
        const shouldPreserveScroll = urlParams.get('scroll') === 'preserve'

        if (shouldPreserveScroll) {
          // 1. Lock scroll position ONLY for your controller redirects
          const scrollX = window.scrollX
          const scrollY = window.scrollY

          setTimeout(() => {
            const tab = bootstrap.Tab.getOrCreateInstance(tabTriggerEl)
            tab.show()
            window.scrollTo(scrollX, scrollY)

            // Clean up the URL: Optional step to remove "?scroll=preserve"
            // so a manual page refresh afterwards behaves normally again.
            const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname + window.location.hash
            window.history.replaceState({ path: cleanUrl }, '', cleanUrl)
          }, 10)

        } else {
          // 2. Standard Behavior: Let Bootstrap show the tab and allow native scrolling
          setTimeout(() => {
            const tab = bootstrap.Tab.getOrCreateInstance(tabTriggerEl)
            tab.show()
          }, 10)
        }
      }
    }
  }

  // Save tab in localStorage (Keep this bound to your click events via data-action)
  saveTab(event) {
    console.log("saving tab")
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

//     const hash = window.location.hash
//     let targetTabId = null

//     //A use hash
//     if (hash) {
//       const cleanHash = hash.replace("#", "")


//       if (this.element.querySelector(`#${cleanHash}`)) {
//         targetTabId = cleanHash
//       }
//     }

//     //B use saved tab
//     if (!targetTabId) {
//       const storageKey = `campaign_tab_${this.campaignIdValue}`
//       targetTabId = localStorage.getItem(storageKey)
//     }

//     //C go to tab but only run if it's not already active
//     if (targetTabId) {
//       const tabTriggerEl = this.element.querySelector(`#${targetTabId}`)

//       if (tabTriggerEl && !tabTriggerEl.classList.contains("active") && typeof bootstrap !== "undefined" && bootstrap.Tab) {
//         setTimeout(() => {
//           const tab = bootstrap.Tab.getOrCreateInstance(tabTriggerEl)
//           tab.show()
//         }, 2)
//       }
//     }
//   }

//   //save tab in localStorage
//   saveTab(event) {
//     const activeTabId = event.target.id

//     if (activeTabId) {
//       const storageKey = `campaign_tab_${this.campaignIdValue}`
//       localStorage.setItem(storageKey, activeTabId)
//     }
//   }
// }
