class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :synopsis
      t.string :setting
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
