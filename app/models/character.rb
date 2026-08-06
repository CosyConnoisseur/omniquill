class Character < ApplicationRecord
  belongs_to :participation

  belongs_to :user, through: :participations
  belongs_to :campaign, through: :participations
end
