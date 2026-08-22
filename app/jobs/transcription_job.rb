class TranscriptionJob < ApplicationJob
  queue_as :default

  def perform(transcription_id)
    transcription = Transcription.find(transcription_id)

    # Convert the uploaded audio to WAV format
    input_path = Rails.root.join("tmp", "recoding-#{SecureRandom.uuid}.mp4")
    wav_path = Rails.root.join("tmp", "recording-#{SecureRandom.uuid}.wav")

    File.binwrite(input_path, transcription.audio.download)

    # Run FFmpeg to convert into a WAV file suitable for transcription.
    success = system(
      "ffmpeg",
      "-y",
      "-i", input_path.to_s,
      "-ar", "16000",
      "-ac", "1",
      "-c:a", "pcm_s16le",
      wav_path.to_s
    )

    raise "Audio conversion failed" unless success

    chat = RubyLLM.chat(model: "gemini-3.1-flash-lite")

    response = chat.ask(
      "Transcribe this audio exactly.",
      with: wav_path.to_s
    )

    transcription.update!(
      text: response.content,
      status: "completed"
    )
  end
end
