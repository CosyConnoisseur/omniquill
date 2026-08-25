class AddDetailsToTranscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :transcriptions, :highlights, :text
    add_column :transcriptions, :title, :string
  end
end
