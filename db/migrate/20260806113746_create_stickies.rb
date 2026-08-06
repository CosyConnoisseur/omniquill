class CreateStickies < ActiveRecord::Migration[8.1]
  def change
    create_table :stickies do |t|
      t.text :text
      t.references :user, null: false, foreign_key: true
      t.references :chapter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
