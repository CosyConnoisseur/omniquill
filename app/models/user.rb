class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :participations, :stickies, :campaigns, :notes
  has_many :chapters, through: :campaigns
  has_many :characters, through: :participations
end
