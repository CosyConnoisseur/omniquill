class TranscriptionsController < ApplicationController
  def create
    authorize :transcription

    uploaded_file = params[:audio_file]

    return render json: { error: "No audio file received" }, status: :bad_request unless uploaded_file.present?

    wav_path = Rails.root.join("tmp", "recording.wav")

    system(
      "ffmpeg",
      "-y",
      "-i", uploaded_file.tempfile.path,
      "-ar", "16000",
      "-ac", "1",
      "-c:a", "pcm_s16le",
      wav_path.to_s
    )

    chat = RubyLLM.chat(model: "gemini-3.1-flash-lite")

    response = chat.ask(
      "Transcribe this audio exactly.",
      with: wav_path.to_s
    )

    puts "===== TRANSCRIPTION ====="
    puts response.content
    puts "========================="

    render json: { text: response.content }
  rescue => e
    Rails.logger.error e.full_message
    render json: { error: e.message }, status: :internal_server_error
  ensure
    File.delete(wav_path) if defined?(wav_path) && File.exist?(wav_path)
  end
end
