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

  def last_played_at
    chapters.map do |chapter|
      chapter.updated_at
    end.max
  end

  # just to know there are other ways to write this
  #
  #   def last_played_at
  #     chapters.map { |chapter| chapter.updated_at }.max
  #   end
  #
  #   or
  #
  #   def last_played_at
  #     chapters.map(&:updated_at).max
  #   end
end
