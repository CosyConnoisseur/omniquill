class TranscriptionsController < ApplicationController
  def create
    authorize :transcription

    uploaded_file = params[:audio_file]

    return render json: { error: "No audio file received" }, status: :bad_request unless uploaded_file.present?

    chapter = Chapter.find(params[:chapter_id])
    transcription = chapter.transcription || chapter.create_transcription!(
      status: "processing"
    )

    transcription.audio.purge
    transcription.audio.attach(uploaded_file)

    TranscriptionJob.perform_later(transcription.id)

    render json: {
      status: "processing",
      id: transcription.id
    }
  # Rescue errors and clean up the temporary WAV file.
  rescue => e
    transcription&.update(status: "failed")
    Rails.logger.error e.full_message
    render json: { error: e.message }, status: :internal_server_error
  ensure
    File.delete(wav_path) if defined?(wav_path) && File.exist?(wav_path)
  end

  def show
    authorize :transcription

    transcription = Transcription.find(params[:id])

    render json: {
      status: transcription.status,
      text: transcription.text
    }
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
