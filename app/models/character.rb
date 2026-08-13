class Character < ApplicationRecord
  belongs_to :participation, optional: true

  has_one_attached :portrait
  has_one_attached :document_upload
  # belongs_to :user
  # belongs_to :campaign

  validates :name, presence: true
  validates :stats_summary, presence: true
end
