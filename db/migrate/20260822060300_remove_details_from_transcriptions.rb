class RemoveDetailsFromTranscriptions < ActiveRecord::Migration[8.1]
  def change
    remove_column :transcriptions, :title, :string
    remove_column :transcriptions, :summary, :text
    remove_column :transcriptions, :highlights, :text
  end
end
