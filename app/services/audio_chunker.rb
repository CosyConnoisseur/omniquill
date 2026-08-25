require 'tmpdir'

# This service class is responsible for chunking an audio file into smaller
# segments of a specified duration. It uses the FFMPEG library to handle audio
# processing.
class AudioChunker
  def self.call(audio_file_path, chunk_duration:)
    new(audio_file_path, chunk_duration: chunk_duration).call
  end

  def initialize(audio_file_path, chunk_duration:)
    @audio_file_path = audio_file_path
    @chunk_duration = chunk_duration

    @output_dir = Dir.mktmpdir("audio_chunks_")
  end

  def call
    output_pattern = "#{@output_dir}/chunk_%03d.wav"
    success = system(
      "ffmpeg",
      "-y",
      "-i",
      @audio_file_path,
      "-f",
      "segment",
      "-segment_time",
      @chunk_duration.to_s,
      "-reset_timestamps",
      "1",
      output_pattern)

    raise "FFMPEG failed to chunk audio" unless success

    chunks = Dir.glob("#{@output_dir}/chunk_*.wav").sort

    chunks.map.with_index do |path, index|
      duration = `ffprobe -v error -show_entries format=duration -of csv=p=0 "#{path}"`.to_f

      {
        index: index,
        path: path,
        start_time: index * @chunk_duration,
        duration: duration
      }
    end
  end
end
