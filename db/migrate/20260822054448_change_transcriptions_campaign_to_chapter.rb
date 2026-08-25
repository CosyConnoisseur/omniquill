class ChangeTranscriptionsCampaignToChapter < ActiveRecord::Migration[8.1]
  def change
    rename_column :transcriptions, :campaign, foreign_key: true
    add_reference :transcriptions, :chapter, null: false, foreign_key: true
  end
end
