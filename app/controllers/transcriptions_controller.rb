class TranscriptionsController < ApplicationController
  def create
    authorize :transcription

    uploaded_file = params[:audio_file]

    return render json: { error: "No audio file received" }, status: :bad_request unless uploaded_file.present?

    # Convert the uploaded audio to WAV format
    # wav_path = Rails.root.join("tmp", "recording.wav")
    wav_path = Rails.root.join("tmp", "recording-#{SecureRandom.uuid}.wav")

    # Run FFmpeg to convert into a WAV file suitable for transcription.
    success = system(
      "ffmpeg",
      "-y",
      "-i", uploaded_file.tempfile.path,
      "-ar", "16000",
      "-ac", "1",
      "-c:a", "pcm_s16le",
      wav_path.to_s
    )

    # Stop if FFmepg failed to convert the audio
    raise "Audio conversion failed" unless success

    chat = RubyLLM.chat(model: "gemini-3.1-flash-lite")

    response = chat.ask(
      "Transcribe this audio exactly.",
      with: wav_path.to_s
    )

    # Print the generated transcript on the terminal.
    puts "===== TRANSCRIPTION ====="
    puts response.content
    puts "========================="

    render json: { text: response.content }
  # Rescue errors and clean up the temporary WAV file.
  rescue => e
    Rails.logger.error e.full_message
    render json: { error: e.message }, status: :internal_server_error
  ensure
    File.delete(wav_path) if defined?(wav_path) && File.exist?(wav_path)
  end

  # Allows the user to download the full transcript.
  def download
    authorize :transcription, :download?

    send_data(
      params[:text],
      filename: "transcript.txt",
      type: "text/plain",
      disposition: "attachment"
    )
  end
end
