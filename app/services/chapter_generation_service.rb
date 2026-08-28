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
        You are an expert TTRPG Archivist and Database Engineer. Your sole task is to process raw transcripts of role-playing sessions and extract structured, high-fidelity narrative data.

        ### OBJECTIVE
        Analyze the provided session transcript, cross-reference it with the injected Campaign Context (Glossary, Known NPCs, Active PC Sheets), and generate a clean, chronologically organized summary and structured entity data block.

        ### CONTEXT INJECTION (CRITICAL LORE)
        [CAMPAIGN_CONTEXT]
        {campaign_context_json}
        [/CAMPAIGN_CONTEXT]

        ### OUTPUT RULES
        1. Output MUST be raw, valid JSON matching the exact schema specified below.
        2. Do NOT wrap the JSON in markdown code blocks (e.g., do not use ```json). Start output directly with '{' and end with '}'.
        3. Maintain a narrative accuracy threshold of over 85%. Ensure every NPC, location, item, and monster matching the context or emphasized in the transcript is accurately cataloged.
        4. Timelines and events MUST be ordered in strict chronological sequence based on the conversational flow.
        5. All descriptions must be concise, scannable, and immersive.

        ### TARGET JSON SCHEMA
        {
          "title": "Clear, evocative title of the key moment",
          "summary": "A cohesive narrative summary of the entire session, tracking major plot arcs, around 500 words.",
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
