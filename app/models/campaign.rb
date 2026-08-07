class Campaign < ApplicationRecord
  belongs_to :user

  has_many :participations
  has_many :chapters, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :characters, through: :participations

  # user_id is DM, players are participations
end
