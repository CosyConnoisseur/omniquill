class Chapter < ApplicationRecord
  belongs_to :campaign

  has_one :transcription, dependent: :destroy

  has_many :stickies, dependent: :destroy
end
