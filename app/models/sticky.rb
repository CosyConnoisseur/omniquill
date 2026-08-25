class Sticky < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
  validates :text, length: { minimum: 3, too_short: "You need at least %{count} characters" }
  validates :text, length: { maximum: 20, too_long: "You can only have %{count} characters" }
end
