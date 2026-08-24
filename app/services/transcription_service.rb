class TranscriptionService
  def self.call(chunk)
    new(chunk).call
  end

  def initialize(chunk)
    @chunk = chunk
  end

  def call
    chat = RubyLLM.chat(model: "gemini-3.1-flash-lite")

    started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    response = chat.ask(
      "Transcribe this audio exactly.",
      with: @chunk[:path]
    )

    latency = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at

    Rails.logger.info(
      "Transcription chunk#{@chunk[:index]} " \
      "duration=#{@chunk[:duration]}s " \
      "latency=#{latency.round(2)}s"
    )

    {
      index: @chunk[:index],
      text: response.content,
      duration: @chunk[:duration],
      latency: latency
    }
  end
end
