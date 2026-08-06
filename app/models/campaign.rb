class Campaign < ApplicationRecord
  belongs_to :user

  has_many :participations
  has_many :chapters
  has_many :notes
  has_many :characters, through: :participations

  # user_id is DM, players are participations
end
