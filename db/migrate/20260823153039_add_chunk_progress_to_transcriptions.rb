class AddChunkProgressToTranscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :transcriptions, :completed_chunks, :integer, default: 0, null: false
    add_column :transcriptions, :total_chunks, :integer, default: 0, null: false
  end
end
