class GenerateChapterJob < ApplicationJob
  queue_as :default

  def perform(transcription_id)
    transcription = Transcription.find(transcription_id)

    return if transcription.reload.canceled?

    transcription.update!(status: "summarizing")

    current_chapter = transcription.chapter

    result = ChapterGenerationService.call(transcription.text)

    return if transcription.reload.canceled?

    current_chapter.update!(
      title: result["title"],
      summary: result["summary"],
      highlights: result["highlights"]
    )

    transcription.update!(status: "completed")

    Rails.logger.info "Generated Chapter ##{current_chapter.id}"
  end
end
