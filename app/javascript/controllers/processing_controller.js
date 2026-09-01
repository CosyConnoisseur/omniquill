import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "alert",
    "message",
    "progress",
    "timer",
    "chapterLink",
    "cancelButton",
    "closeButton",
  ]

  connect() {
    console.log("Processing controller connected")

    this.pollingTimeout = null
    this.timerInterval = null
    this.processingElapsedSeconds = 0

    this.handleProcessingStarted = () => this.loadProcessing()

    window.addEventListener(
      "processing-started",
      this.handleProcessingStarted
    )

    this.loadProcessing()
  }

  disconnect() {
    this.stopTimer()

    window.removeEventListener(
      "processing-started",
      this.handleProcessingStarted
    )
  }

  loadProcessing() {
    const stored = localStorage.getItem("omniquill_processing")

    if (!stored) return

    clearTimeout(this.pollingTimeout)

    const processing = JSON.parse(stored)

    this.processing = processing

    this.processingStartedAt = processing.startedAt || Date.now()

    processing.startedAt = this.processingStartedAt
    localStorage.setItem(
      "omniquill_processing",
      JSON.stringify(processing)
    )

    this.alertTarget.classList.remove("d-none")
    this.cancelButtonTarget.classList.remove("d-none")

    this.startTimer()
    this.pollTranscription(processing.transcriptionId)
  }

  async pollTranscription(id) {
    try {
      const response = await fetch(`/transcriptions/${id}`)

      if (!response.ok) {
        console.error("Transcription polling failed:", response.status)
        return
      }

      const data = await response.json()

      if (data.status === "chunking") {
        this.messageTarget.innerText = "Chunking audio file..."
        this.progressTarget.innerText = ""
      }

      if (data.status === "processing") {
        this.messageTarget.innerText = "Processing audio file..."
        this.progressTarget.innerText =
          `Processing ${data.completed_chunks} / ${data.total_chunks} chunks`
      }

      if (data.status === "completed") {
        this.messageTarget.innerText = "Generating summary..."
        this.progressTarget.innerText = ""

        this.pollChapterProcessing()
        return
      }

      if (data.status === "failed") {
        this.messageTarget.innerText = "Processing failed."
        this.progressTarget.innerText = ""

        this.finishProcessing()
        return
      }

      if (data.status === "canceled") {
        this.messageTarget.innerText = "Processing canceled."
        this.progressTarget.innerText = ""

        this.finishProcessing()
        return
      }

      this.pollingTimeout = setTimeout(
        () => this.pollTranscription(id),
        2000
      )
    } catch (error) {
      console.error("Polling failed:", error)
    }
  }

  async pollChapterProcessing() {
    try {
      const response = await fetch(
        `/campaigns/${this.processing.campaignId}/chapters/${this.processing.chapterId}/processing`
      )

      if (!response.ok) {
        console.error(
          "Chapter processing request failed:",
          response.status
        )
        return
      }

      const data = await response.json()
      console.log("Chapter processing:", data)

      if (data.completed) {
        this.messageTarget.innerText = "Chapter ready!"
        this.progressTarget.innerText = ""

        this.chapterLinkTarget.href =
          `/campaigns/${this.processing.campaignId}/chapters/${this.processing.chapterId}`

        this.chapterLinkTarget.classList.remove("d-none")

        this.finishProcessing()
        return
      }

      this.pollingTimeout = setTimeout(
        () => this.pollChapterProcessing(),
        2000
      )
    } catch (error) {
      console.error("Chapter processing polling failed:", error)
    }
  }

  async cancel() {
    if (!this.processing) return

    try {
      const csrfToken = document.querySelector(
        'meta[name="csrf-token"]'
      ).content

      const response = await fetch(
        `/transcriptions/${this.processing.transcriptionId}/cancel`,
        {
          method: "POST",
          headers: {
            "X-CSRF-Token": csrfToken,
            "Content-Type": "application/json"
          }
        }
      )

      if (!response.ok) {
        console.error("Failed to cancel processing")
        return
      }

      clearTimeout(this.pollingTimeout)

      this.messageTarget.innerText = "Processing canceled."
      this.progressTarget.innerText = ""

      this.cancelButtonTarget.classList.add("d-none")

      localStorage.removeItem("omniquill_processing")

      this.stopTimer()
    } catch (error) {
      console.error("Cancellation failed:", error)
    }
  }

  close() {
    this.alertTarget.classList.add("d-none")
  }

  finishProcessing() {
    clearTimeout(this.pollingTimeout)
    this.pollingTimeout = null
    this.stopTimer()

    localStorage.removeItem("omniquill_processing")

    this.cancelButtonTarget.classList.add("d-none")
  }

  viewChapter() {
    this.alertTarget.classList.add("d-none")
  }

  startTimer() {
    if (this.timerInterval) return

    const updateTimer = () => {
      const elapsedSeconds = Math.floor(
        (Date.now() - this.processingStartedAt) / 1000
      )

      const hours = Math.floor(elapsedSeconds / 3600)
      const minutes = Math.floor((elapsedSeconds % 3600) / 60)
      const seconds = elapsedSeconds % 60

      this.timerTarget.innerText =
        `${hours.toString().padStart(2, "0")}:` +
        `${minutes.toString().padStart(2, "0")}:` +
        `${seconds.toString().padStart(2, "0")}`
    }

    updateTimer()
    this.timerInterval = setInterval(updateTimer, 1000)
  }

  stopTimer() {
    clearInterval(this.timerInterval)
    this.timerInterval = null
  }
}
