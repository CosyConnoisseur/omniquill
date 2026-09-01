import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "recordIcon",
    "pauseIcon",
    "heading",
    "output",
    "transcript",
    "timer",
  ]

  static values = {
    chapterId: Number,
    campaignId: Number
  }

  connect() {
    this.pollingTimeout = null
    this.chapterPollingTimeout = null

    console.log("Recording controller connected")

    this.isRecording = false
    this.mediaRecorder = null
    this.mediaStream = null
    // Store the audio data produced by MediaRecorder
    this.audioChunks = []

    this.timerInterval = null
    this.elapsedSeconds = 0
  }

  disconnect() {
    clearTimeout(this.pollingTimeout)
    clearInterval(this.timerInterval)
  }

  async toggle() {
    if (!this.mediaRecorder) {
      await this.startRecording()
    } else if (this.mediaRecorder.state === "paused") {
      this.mediaRecorder.resume()

      this.isRecording = true

      this.recordIconTarget.style.display = "none"
      this.pauseIconTarget.style.display = "block"

      this.headingTarget.innerText = "Recording"

      this.startTimer()
    }
  }

  async startRecording() {
    if (!window.isSecureContext) {
      console.error("Microphone requires a secure context")
      this.headingTarget.innerText =
        "Microphone requires HTTPS"
      return
    }

    if (!window.MediaRecorder) {
      console.error("MediaRecorder is not supported")
      this.headingTarget.innerText =
        "Audio recording is not supported on this browser"
      return
    }

    try {
      this.mediaStream = await navigator.mediaDevices.getUserMedia({
        audio: true
      })

      const supportedMimeTypes = [
        "audio/mp4",
        "audio/webm;codecs=opus",
        "audio/webm",
        "audio/ogg;codecs=opus"
      ]

      const mimeType = supportedMimeTypes.find(type =>
        MediaRecorder.isTypeSupported(type)
      )

      if (!mimeType) {
        console.error("No supported audio recording format found")
        this.headingTarget.innerText = "Audio recording is not supported"
        this.mediaStream.getTracks().forEach(track => track.stop())
        return
      }

      console.log("Using recording format:", mimeType)

      this.mediaRecorder = new MediaRecorder(
        this.mediaStream,
        { mimeType }
      )

      // Store the audio data produced by MediaRecorder
      this.audioChunks = []

      this.mediaRecorder.ondataavailable = (event) => {
        this.audioChunks.push(event.data)
      }

      this.mediaRecorder.start()

      this.isRecording = true

      this.recordIconTarget.style.display = "none"
      this.pauseIconTarget.style.display = "block"

      this.headingTarget.innerText = "Recording"

      this.startTimer()
    } catch (error) {
      console.error("Microphone access failed:", error)

      if (error.name === "NotAllowedError") {
        this.headingTarget.innerText =
          "Microphone permission is required"
      } else if (error.name === "NotFoundError") {
        this.headingTarget.innerText =
          "No microphone was found"
      } else if (error.name === "NotReadableError") {
        this.headingTarget.innerText =
          "Microphone is already in use"
      } else {
        this.headingTarget.innerText =
          "Unable to access the microphone"
      }
    }
  }

  pause() {
    if (!this.mediaRecorder || !this.isRecording) return

    this.mediaRecorder.pause()

    this.isRecording = false

    this.pauseIconTarget.style.display = "none"
    this.recordIconTarget.style.display = "block"

    this.headingTarget.innerText = "Quill at the ready"

    this.stopTimer()
  }

  async uploadAudio(blob, filename = "recording.mp4") {
    const formData = new FormData()

    formData.append("audio_file", blob, filename)
    formData.append("chapter_id", this.chapterIdValue)

    console.log("Chapter ID:", this.chapterIdValue)

    const csrfToken = document.querySelector(
      'meta[name="csrf-token"]'
    ).content

    try {
      const response = await fetch("/transcriptions", {
        method: "POST",
        headers: {
          "X-CSRF-Token": csrfToken
        },
        body: formData
      })

      const data = await response.json()

      if (response.ok) {
        localStorage.setItem(
          "omniquill_processing",
          JSON.stringify({
            transcriptionId: data.id,
            chapterId: this.chapterIdValue,
            campaignId: this.campaignIdValue,
            startedAt: Date.now()
          })
        )

        window.dispatchEvent(new CustomEvent("processing-started"))

        this.resetRecording()
      } else {
        console.error(data.error)
        this.transcriptTarget.innerText = `Error: ${data.error}`
      }
    } catch (error) {
      // this.outputTarget.innerText = "Failed to upload audio"
      console.error(error)
      this.transcriptTarget.innerText = "Failed to upload audio"
    }
  }

  uploadAudioFile() {
    const fileInput = document.getElementById("audio-file")
    const file = fileInput.files[0]

    if (!file) {
      return
    }

    this.uploadAudio(file, file.name)
  }

  generateTranscript() {
    if (!this.mediaRecorder) return

    this.headingTarget.innerText = "Generating transcript..."

    this.mediaRecorder.onstop = () => {
      // Convert the recorded audio chunks into a single audio file
      // Since we have record/pause button
      const audioBlob = new Blob(this.audioChunks, {
        type: this.mediaRecorder.mimeType
      })

      // send the audio file to Rails for transcription
      this.uploadAudio(audioBlob)

      this.mediaStream.getTracks().forEach(track => track.stop())
    }

    this.mediaRecorder.stop()
    this.isRecording = false
  }

  resetRecording() {
    this.isRecording = false
    this.mediaRecorder = null
    this.mediaStream = null
    // Store the audio data produced by MediaRecorder
    this.audioChunks = []

    this.recordIconTarget.style.display = "block"
    this.pauseIconTarget.style.display = "none"

    this.headingTarget.innerText = "Quill at the ready"

    this.resetTimer()
  }

  startTimer() {
    this.stopTimer()

    this.timerInterval = setInterval(() => {
      this.elapsedSeconds++

      const hours = Math.floor(this.elapsedSeconds / 3600)
      const minutes = Math.floor((this.elapsedSeconds % 3600)/60)
      const seconds = this.elapsedSeconds % 60

      this.timerTarget.innerText =
        `${hours.toString().padStart(2, "0")}:` + `${minutes.toString().padStart(2, "0")}:` + `${seconds.toString().padStart(2, "0")}`
    }, 1000)
  }

  stopTimer() {
    clearInterval(this.timerInterval)
    this.timerInterval = null
  }

  resetTimer() {
    this.stopTimer()
    this.elapsedSeconds = 0
    this.timerTarget.innerText = "00:00:00"
  }

  async downloadTranscript() {
    const text = this.transcriptTarget.innerText

    if (!text || text === "Waiting for speech...") {
      return
    }

    const csrfToken = document.querySelector(
      'meta[name="csrf-token"]'
    ).content

    const formData = new FormData()
    formData.append("text", text)

    const response = await fetch("/transcriptions/download", {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken
      },
      body: formData
    })

    if (!response.ok) {
      console.error("Failed to download transcript")
      return
    }

    const blob = await response.blob()
    const url = URL.createObjectURL(blob)

    const link = document.createElement("a")
    link.href = url
    link.download = "transcript.txt"
    link.click()

    URL.revokeObjectURL(url)
  }

  showCancelledState() {
    this.cancelButtonTarget.remove()

    this.statusTarget.textContent = "Transcription cancelled"
  }
}
