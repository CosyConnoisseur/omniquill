class TranscriptionJob < ApplicationJob
  queue_as :default

  def perform(transcription_id)
    transcription = Transcription.find(transcription_id)

    return if transcription.canceled?

    transcription.update!(status: "chunking")

    # Convert the uploaded audio to WAV format
    input_path = Rails.root.join(
      "tmp",
      "recording-#{SecureRandom.uuid}#{File.extname(transcription.audio.filename.to_s)}"
    )
    wav_path = Rails.root.join(
      "tmp",
      "recording-#{SecureRandom.uuid}.wav"
    )

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

    # Chunk the WAV file into smaller segments for processing
    chunks = AudioChunker.call(
      wav_path.to_s,
      chunk_duration: 300
    )

    transcription.update!(
      status: "processing",
      total_chunks: chunks.length,
      completed_chunks: 0
    )

    results = chunks.map do |chunk|
      transcription.reload

      break if transcription.canceled?

      result = TranscriptionService.call(chunk)

      transcription.increment!(:completed_chunks)
      transcription.touch

      result
    end

    return if transcription.reload.canceled?

    transcription.update!(
      text: TranscriptionAssembler.call(results),
      status: "completed"
    )

    return if transcription.reload.canceled?

    GenerateChapterJob.perform_later(transcription.id)
  end
end
