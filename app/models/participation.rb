class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  has_many :characters
end
