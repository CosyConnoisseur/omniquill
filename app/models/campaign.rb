class Campaign < ApplicationRecord
  belongs_to :user

  has_many :participations
  has_many :chapters, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :characters, through: :participations

  has_one_attached :card_image
  has_one_attached :banner
  # user_id is DM, players are participations

  validates :title, length: { minimum: 6 }
end
