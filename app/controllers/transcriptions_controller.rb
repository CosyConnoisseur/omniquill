class TranscriptionsController < ApplicationController
  def create
    authorize :transcription

    uploaded_file = params[:audio_file]

    return render json: { error: "No audio file received" }, status: :bad_request unless uploaded_file.present?

    chapter = Chapter.find(params[:chapter_id])
    transcription = chapter.transcription || chapter.create_transcription!

    transcription.update!(
      status: "processing",
      text: nil,
      total_chunks: 0,
      completed_chunks: 0
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
  end

  def show
    authorize :transcription

    transcription = Transcription.find(params[:id])

    if transcription.processing? && transcription.updated_at < 1.minutes.ago
      transcription.update!(status: "failed")
    end

    render json: {
      status: transcription.status,
      text: transcription.text,
      completed_chunks: transcription.completed_chunks,
      total_chunks: transcription.total_chunks
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

  def processing_status
    authorize :chapter

    chapter = Chapter.find(params[:id])

    render json: {
      completed: chapter.title.present? && chapter.summary.present? && chapter.highlights.present?,
      chapter_id: chapter.id
    }
  end

  def cancel
    authorize :transcription

    transcription = Transcription.find(params[:id])

    return render json: {
      success: true,
      status: transcription.status
    } if transcription.canceled?

    transcription.update!(status: "canceled")

    render json: {
      success: true,
      status: transcription.status
    }
  end

  def current
    transcription = current_user.transcriptions
                                .where(status: %w[processing chunking transcribing summarizing])
                                .order(created_at: :desc)
                                .first
    render json: {
      id: transcription&.id,
      status: transcription&.status
    }
  end
end
