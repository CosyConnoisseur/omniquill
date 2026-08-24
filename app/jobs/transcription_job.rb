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

    # Chunk the WAV file into smaller segments for processing
    chunks = AudioChunker.call(
      wav_path.to_s,
      chunk_duration: 300
    )

    transcription.update!(
      total_chunks: chunks.length,
      completed_chunks: 0
    )

    # Debugging: Log the chunks and their durations
    # chunks.each do |chunk|
    #   Rails.logger.info "Processing chunk: #{chunk}"
    # end

    # Debugging: Log the duration of each chunk
    # chunks.each_with_index do |path, index|
    #   duration = `ffprobe -v error -show_entries format=duration -of csv=p=0 "#{path}"`.strip
    #   puts "#{index}: #{duration}s"
    # end

    results = chunks.map do |chunk|
      result = TranscriptionService.call(chunk)

      transcription.increment!(:completed_chunks)

      result
    end

    transcription.update!(
      text: TranscriptionAssembler.call(results),
      status: "completed"
    )
  end
end
