class FixTranscriptionsChapterReference < ActiveRecord::Migration[8.1]
  def change
    remove_reference :transcriptions, :campaign, foreign_key: true
    add_reference :transcriptions, :chapter, null: false, foreign_key: true
  end
end
