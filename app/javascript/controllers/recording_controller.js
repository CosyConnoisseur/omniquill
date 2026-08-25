import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "recordIcon",
    "pauseIcon",
    "heading",
    "output",
    "transcript",
    "progress",
    "timer"
  ]

  static values = {
    chapterId: Number
  }

  connect() {
    this.pollingTimeout = null
    console.log("Recording controller connected")

    this.isRecording = false
    this.mediaRecorder = null
    this.mediaStream = null
    // Store the audio data produced by MediaRecorder
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
      console.error("Microphone access denied:", error)
    }
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
    if (this.pollingTimeout) {
      clearTimeout(this.pollingTimeout)
      this.pollingTimeout = null
    }

    this.outputTarget.classList.remove("d-none")
    this.progressTarget.innerText = "Preparing to upload audio..."
    this.transcriptTarget.innerText = "Transcribing audio..."

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

      // const text = await response.text()
      // console.log("Server response:", text)
      // const data = JSON.parse(text)
      const data = await response.json()

      if (response.ok) {
        // this.transcriptTarget.innerText = data.text
        // this.headingTarget.innerText = "Ready when you are!"
        this.progressTarget.innerText = "Starting transcription..."
        this.headingTarget.innerText = "Processing..."

        this.pollTranscription(data.id)

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

  async pollTranscription(id) {
    const response = await fetch(`/transcriptions/${id}`)
    const data = await response.json()

    console.log("Polling:", id, data)

    if (data.total_chunks > 0) {
      this.progressTarget.innerText =
        `Transcription progress: ${data.completed_chunks} / ${data.total_chunks} chunks completed`
    }

    if (data.status == "completed") {
      this.progressTarget.innerText = ""
      this.transcriptTarget.innerText = data.text
      this.headingTarget.innerText = "Ready when you are!"
      return
    }

    if (data.status == "failed") {
      this.transcriptTarget.innerText = "Transcription failed."
      return
    }

    this.pollingTimeout = setTimeout(
      () => this.pollTranscription(id),
      2000
    )
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
}
