# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Character.destroy_all
Participation.destroy_all
Campaign.destroy_all
User.destroy_all

new_user = User.new(
  username: "Player 1",
  email: "p1@example.com",
  password: "password123",
  password_confirmation: "password123" # Devise standard check
)

new_user.save!

campaign = Campaign.create!(user:new_user, title: "Epic Quest")
first_participation = Participation.create!(user:new_user, campaign:campaign)
Character.create!(
  [
    {
    name: "Squilliam Fancyson",
    stats_summary: "Squilliam Fancyson is Squidward Tentacles' high school arch-rival. Squilliam attended Squidward's band class, and always puts him down. He is a very wealthy, snooty rival of Squidward who looks down at Squidward, for being just a lowly cashier in a greasy spoon.",
    participation: first_participation
    }
  ]
)
