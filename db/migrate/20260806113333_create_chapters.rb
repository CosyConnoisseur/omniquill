class CreateChapters < ActiveRecord::Migration[8.1]
  def change
    create_table :chapters do |t|
      t.string :title
      t.text :summary
      t.text :highlights
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
