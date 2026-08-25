class CreateTranscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :transcriptions do |t|
      t.references :campaign, null: false, foreign_key: true
      t.string :status
      t.text :text
      t.text :summary

      t.timestamps
    end
  end
end
