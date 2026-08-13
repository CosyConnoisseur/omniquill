import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "buffer", "nameInput", "descriptionInput",
    "submitButton", "aiButton", "loadingButton",
    "fileField", "clearFileButton", "clearTextButton"
  ]

  connect() {
    console.log("Stimulus connected")
    this.aiObserver = new MutationObserver(() => this.parseAndFill())
    this.aiObserver.observe(this.bufferTarget, { textContent: true, childList: true, subtree: true })
    this.typingTimeout = null
  }

  updateButton(){
    const fileInput = this.element.querySelector("input[type='file']")
    const hasFile = fileInput && fileInput.files.length > 0

    const hasName = this.nameInputTarget.value.length > 0
    const hasDesc = this.descriptionInputTarget.value.length > 0
    const hasText = hasName || hasDesc

    const form = this.element.querySelector("form")
    if (!form) return

    if(hasText){
      this.clearTextButtonTarget.classList.remove("d-none")
    } else {
      this.clearTextButtonTarget.classList.add("d-none")
    }
    //A
    if (hasFile && !hasText){
      this.submitButtonTarget.classList.add("d-none")
      this.aiButtonTarget.classList.remove("d-none")
      this.clearFileButtonTarget.classList.remove("d-none")
      console.log("image added")

      if (!form.action.includes("/parse_sheet")){
        form.action = form.action.replace(/\/$/, "") + "/parse_sheet"
        //console.log("url changed to parse!")
        form.setAttribute("data-turbo", "true")
      }
    }

    //B
    else {
      this.submitButtonTarget.classList.remove("d-none")
      this.aiButtonTarget.classList.add("d-none")

      if(hasFile){
        this.clearFileButtonTarget.classList.remove("d-none")
      } else {
        this.clearFileButtonTarget.classList.add("d-none")
      }

      form.action = form.action.replace("/parse_sheet", "")
      //console.log("url changed to submit!")
      form.setAttribute("data-turbo", "false")
    }

  }

  showLoading(){
    if (!this.aiButtonTarget.classList.contains("d-none")){
      this.aiButtonTarget.classList.add("d-none")
      this.loadingButtonTarget.classList.remove("d-none")
    }
  }

  parseAndFill() {
    console.log("parse and fill ran")
    const rawText = this.bufferTarget.innerText
    //console.log("Buffer updated! Text contents:", rawText)

    // Regex matches the string sequence
    const nameMatch = rawText.match(/NAME:\s*([^\n\r]*)/i)
    const descMatch = rawText.match(/DESCRIPTION:\s*([\s\S]*)/i)

    // FIX: Read from index 1 (the captured group) and run replace/trim directly on it
    if (nameMatch && nameMatch[1]) {
      const cleanName = nameMatch[1].replace(/[\*\#_\[\]]/g, "").trim()
      this.nameInputTarget.value = cleanName
    }

    if (descMatch && descMatch[1]) {
      this.descriptionInputTarget.value = descMatch[1].trim()
    }

    clearTimeout(this.typingTimeout)
    this.typingTimeout = setTimeout(() => {
      this.cleanupForm()
    }, 1500)
  }

  clearFile(){
    console.log("clear file run")
    this.fileFieldTarget.value = ""
    this.clearFileButtonTarget.classList.add("d-none")
    this.updateButton()
  }

  clearText(){
    console.log("clear text run")
    this.nameInputTarget.value = ""
    this.descriptionInputTarget.value = ""
    this.bufferTarget.innerText = ""
    this.updateButton()
  }

  cleanupForm(){
    if (this.bufferTarget.innerText.length > 0){
      this.loadingButtonTarget.classList.add("d-none")
      this.updateButton()
    }
  }

  disconnect() {
    if (this.aiObserver) this.aiObserver.disconnect()
  }
}
