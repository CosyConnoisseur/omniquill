class Character < ApplicationRecord
  belongs_to :participation

  has_one_attached :portrait
  # belongs_to :user
  # belongs_to :campaign
end
