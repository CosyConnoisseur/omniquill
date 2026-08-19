console.log("recording_controller.js loaded")

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "heading", "output" ]

  connect() {
    console.log("Recording controller connected")

    this.isRecording = false
    this.mediaRecorder = null
    this.mediaStream = null
    this.audioChunks = []
  }

  async toggle() {
    if (this.isRecording) {
      this.stopRecording()
    } else {
      await this.startRecording()
    }
  }

  async startRecording() {
    console.log("startRecording called")

    try {
      this.mediaStream = await navigator.mediaDevices.getUserMedia({
        audio: true
      })

      // this.mediaRecorder = new MediaRecorder(this.mediaStream)
      //const mimeType = MediaRecorder.isTypeSupported("audio/mp4")
      //  ? "audio/mp4"
      //  : "audio/webm"
      const mimeType = "audio/mp4"

      this.mediaRecorder = new MediaRecorder(
        this.mediaStream,
        { mimeType }
      )

      console.log("Recording MIME type:", this.mediaRecorder.mimeType)

      this.audioChunks = []

      this.mediaRecorder.ondataavailable = (event) => {
        this.audioChunks.push(event.data)
      }

      this.mediaRecorder.onstop = () => {
        // const audioBlob = new Blob(this.audioChunks, {
        //  type: 'audio/webm'
        // })
        const audioBlob = new Blob(this.audioChunks, {
          type: this.mediaRecorder.mimeType
        })

        console.log("Blob:", audioBlob.type, audioBlob.size)

        this.uploadAudio(audioBlob)
        this.mediaStream.getTracks().forEach(track => track.stop())
      }

      this.mediaRecorder.start()
      this.isRecording = true

      this.iconTarget.classList.remove("text-danger")
      this.iconTarget.classList.add("text-dark")
    } catch (error) {
      console.error("Microphone access denied:", error)
    }
  }

  stopRecording() {
    if (!this.mediaRecorder || !this.isRecording) return

    this.mediaRecorder.stop()
    this.isRecording = false

    this.iconTarget.classList.remove("text-dark")
    this.iconTarget.classList.add("text-danger")
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
}

  // toggle() {
  //  this.iconTarget.classList.toggle("fa-circle")
  //  this.iconTarget.classList.toggle("fa-pause")
  //
  //  if (this.iconTarget.classList.contains("fa-pause")) {
  //    this.headingTarget.textContent = "Quilliam is scribing..."
  //  } else {
  //    this.headingTarget.textContent = "Quilliam is resting..."
  //  }
