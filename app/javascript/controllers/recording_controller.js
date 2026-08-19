import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "recordIcon",
    "pauseIcon",
    "heading",
    "output",
    "timer"
  ]

  connect() {
    console.log("Recording controller connected")

    this.isRecording = false
    this.mediaRecorder = null
    this.mediaStream = null
    this.audioChunks = []

    this.timerInterval = null
    this.elapsedSeconds = 0
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
    try {
      this.mediaStream = await navigator.mediaDevices.getUserMedia({
        audio: true
      })

      const mimeType = "audio/mp4"

      this.mediaRecorder = new MediaRecorder(
        this.mediaStream,
        { mimeType }
      )

      this.audioChunks = []

      this.mediaRecorder.ondataavailable = (event) => {
        this.audioChunks.push(event.data)
      }

      this.mediaRecorder.start()

      this.isRecording = true

      this.recordIconTarget.style.display = "none"
      this.pauseIconTarget.style.display = "block"

      this.headingTarget.innerText = "Recording"
    } catch (error) {
      console.error("Microphone access denied:", error)
    }

    this.startTimer()
  }

  pause() {
    if (!this.mediaRecorder || !this.isRecording) return

    this.mediaRecorder.pause()

    this.isRecording = false

    this.pauseIconTarget.style.display = "none"
    this.recordIconTarget.style.display = "block"

    this.headingTarget.innerText = "Ready when you are!"

    this.stopTimer()
  }

  async uploadAudio(blob, filename = "recording.mp4") {
    this.outputTarget.classList.remove("d-none")
    this.outputTarget.innerText = "Transcribing audio..."

    const formData = new FormData()
    console.log(MediaRecorder.isTypeSupported("audio/webm"))

    formData.append("audio_file", blob, filename)

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

      const text = await response.text()
      console.log("Server response:", text)

      const data = JSON.parse(text)

      //this.outputTarget.innerText = data.text || `Error: ${data.error}`
      if (response.ok) {
        this.outputTarget.innerText = data.text
        this.headingTarget.innerText = "Ready when you are!"

        this.resetRecording()
      } else {
        console.error(data.error)
        this.outputTarget.innerText = `Error: ${data.error}`
      }
    } catch (error) {
      // this.outputTarget.innerText = "Failed to upload audio"
      console.error(error)
      this.outputTarget.innerText = "Failed to upload audio"
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
      const audioBlob = new Blob(this.audioChunks, {
        type: this.mediaRecorder.mimeType
      })

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
    this.audioChunks = []

    this.recordIconTarget.style.display = "block"
    this.pauseIconTarget.style.display = "none"

    this.headingTarget.innerText = "Ready when you are!"

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
}
