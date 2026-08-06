class Chapter < ApplicationRecord
  belongs_to :campaign

  has_many :stickies
end
