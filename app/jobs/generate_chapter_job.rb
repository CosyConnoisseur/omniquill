class GenerateChapterJob < ApplicationJob
  queue_as :default

  def perform(transcription_id)
    transcription = Transcription.find(transcription_id)
    current_chapter = transcription.chapter
    campaign = current_chapter.campaign

    result = ChapterGenerationService.call(transcription.text)

    new_chapter = campaign.chapters.create!(
      title: result["title"],
      summary: result["summary"],
      highlights: result["highlights"]
    )

    Rails.logger.info "Generated Chapter ##{new_chapter.id} for Campaign ##{campaign.id}"
  end
end
