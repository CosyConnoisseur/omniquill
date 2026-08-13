import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "buffer", "nameInput", "descriptionInput",
    "submitButton", "aiButton", "loadingButton",
    "fileField", "clearFileButton", "clearTextButton",
    "previewContainer", "imagePreview", "pdfPreview",
    "portraitPreview", "portraitField", "clearPortraitButton", "portraitPreviewContainer"
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

    // Regex to grab name and description
    const nameMatch = rawText.match(/NAME:\s*([^\n\r]*)/i)
    const descMatch = rawText.match(/DESCRIPTION:\s*([\s\S]*)/i)

    // Read from index 1, the captured group, instead of the whole thing
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

  previewSheetFile(){
    console.log("preview run")
    const fileInput = this.fileFieldTarget

    const file = fileInput.files[0]

    const fileURL = URL.createObjectURL(file)

    this.imagePreviewTarget.classList.add("d-none")
    this.pdfPreviewTarget.classList.add("d-none")
    this.previewContainerTarget.classList.remove("d-none")

    //A
    if (file.type.startsWith("image/")){
      this.imagePreviewTarget.src=fileURL
      this.imagePreviewTarget.classList.remove("d-none")
    }
    //B
    else if (file.type.startsWith("application/pdf")){
      this.pdfPreviewTarget.src=fileURL
      this.pdfPreviewTarget.classList.remove("d-none")
    }
  }

  previewPortraitFile(){
    console.log("portrait preview run")
    const fileInput = this.portraitFieldTarget

    const file = fileInput.files[0]

    const fileURL = URL.createObjectURL(file)

    this.portraitPreviewContainerTarget.classList.remove("d-none")

    this.portraitPreviewTarget.src=fileURL
    this.portraitPreviewTarget.classList.remove("d-none")
    this.clearPortraitButtonTarget.classList.remove("d-none")
    }

  clearFile(){
    console.log("clear file run")
    this.fileFieldTarget.value = ""
    this.clearFileButtonTarget.classList.add("d-none")

    this.previewContainerTarget.classList.add("d-none")

    if (this.imagePreviewTarget.src) URL.revokeObjectURL(this.imagePreviewTarget.src)
    if (this.pdfPreviewTarget.src) URL.revokeObjectURL(this.pdfPreviewTarget.src)

    this.imagePreviewTarget.src = ""
    this.pdfPreviewTarget.src = ""

    this.updateButton()
  }

    clearPortraitFile(){
    console.log("clear portrait run")
    this.portraitFieldTarget.value = ""
    this.clearPortraitButtonTarget.classList.add("d-none")

    this.portraitPreviewContainerTarget.classList.add("d-none")

    if (this.portraitPreviewTarget.src) URL.revokeObjectURL(this.portraitPreviewTarget.src)

    this.portraitPreviewTarget.src = ""
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
