class ChapterGenerationService
  def self.call(text)
    new(text).call
  end

  def initialize(text)
    @text = text
  end

  def call
    chat = RubyLLM.chat

    response = chat.ask(
      <<~PROMPT
        Analyze the following transcription and generate a chapter.

        Return ONLY valid JSON with exactly these three fields:
        {
          "title": "A concise title for the chapter",
          "summary": "A brief summary of the chapter",
          "highlights": ["A list of key highlights from the chapter"]
        }

        Transcription:
        #{@text}
      PROMPT
    )

    content = response.content
    content = content.gsub(/\A```json\s*/, "").gsub(/```\s*\z/, "")

    JSON.parse(content)
  end
end
