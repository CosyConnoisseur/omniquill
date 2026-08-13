class Character < ApplicationRecord
  belongs_to :participation
  delegate :user_id, :campaign_id, to: :participation, allow_nil: true

  has_one_attached :portrait
  has_one_attached :document_upload



  # has_one :user, through: :participation
  # has_one :campaign, through: :participation

  delegate :campaign, to: :participation, allow_nil: true

  validates :name, presence: true
  validates :stats_summary, presence: true
end
