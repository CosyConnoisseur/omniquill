class Chapter < ApplicationRecord
  belongs_to :campaign

  has_many :stickies, dependent: :destroy
end
