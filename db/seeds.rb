# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

<<<<<<< HEAD
Character.destroy_all
Participation.destroy_all
Campaign.destroy_all
User.destroy_all

campaign = Campaign.create!(user:new_user, title: "Epic Quest")
participation = Participation.create!(user:new_user, campaign:campaign)
Character.create!(
  [
    {
    name: "Squilliam Fancyson",
    stats_summary: "Squilliam Fancyson is Squidward Tentacles' high school arch-rival. Squilliam attended Squidward's band class, and always puts him down. He is a very wealthy, snooty rival of Squidward who looks down at Squidward, for being just a lowly cashier in a greasy spoon.",
    participation: participation
    }
  ]
)

puts "Populating users..."

User.create!(
  [
    email: "aniwhistler@gmail.com",
    password: "123456",
    password_confirmation: "123456",
    username: "ani"
  ]
)

User.create!(
  [
    email: "jhony36@gmail.com",
    password: "123456",
    password_confirmation: "123456",
    username: "johno37"
  ]
)

User.create!(
  [
    email: "bill-flozner@hotmail.com",
    password: "123456",
    password_confirmation: "123456",
    username: "waifulover420"
  ]
)

User.create!(
  [
    email: "ra_stein@yahoo.jp",
    password: "123456",
    password_confirmation: "123456",
    username: "goblinpounder44"
  ]
)

User.create!(
  username: "Player 1",
  email: "p1@example.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "...finished populating users..."


puts "Populating campaigns..."

Campaign.create!(
  [
    title: "The great labyrinth",
    setting: "Medieval magic fantasy. Set underground.",
    synopsis: "Deep beneath the fractured kingdoms of Aethelgard lies the Undercrypt—a sprawling,
    ever-shifting subterranean labyrinth forged by dead gods and ancient,
    volatile magic. When a sudden eclipse unleashes a shadow plague that consumes the surface world,
    an unlikely trio—a disgraced spell-thief, a guilt-ridden paladin, and a scholar who speaks the ruin-tongue
    is forced into a desperate descent. Together, they must navigate lightless abysses, deadly arcane traps,
    and warring subterranean civilizations to reach the maze's heart, where a forgotten engine of primordial light slumbers.
    Yet in a realm that feeds on secrets and actively warps reality, the greatest threat isn't the horrors lurking in the dark,
    but the horrifying truth of why the world above was cursed in the first place.",
    user_id: 1
  ]
)

Campaign.create!(
  [
    title: "Death and Determination at Camp Diamond Lake",
    setting: "Modern day where monsters and cryptids exist. In a summer camp site surrounded by woods.",
    synopsis: "Welcome to Camp Echo Lake, a seemingly ordinary summer getaway where the 'wildlife' includes
    caffeinated Sasquatches, passive-aggressive Jackalopes, and a Mothman who refuses to leave the campfire light.
    When a horde of mischief-making gnomes swipes the camp director's prized golf cart—and the emergency smores
    stash it's up to your ragtag team of counselors to venture into the deep, weird woods and get them back.
    Armed with rusty canoe paddles, improvised spell-casting through cafeteria snacks, and a whole lot of bad decisions,
    you'll have to outsmart suburban cryptids to survive.
    Just remember to roll for initiative whenever you hear rustling in the snack shack!",
    user_id: 3
  ]
)

puts "...finished populating campaigns..."


puts "Populating chapters..."

Chapter.create!(
  [
    title: "Into the depths...",
    summary: "",
    highlights: "",
    campaign_id: 1
  ]
)

Chapter.create!(
  [
    title: "Paranoid over traps",
    summary: "",
    highlights: "",
    campaign_id: 1
  ]
)

Chapter.create!(
  [
    title: "The Depth Feelers fight",
    summary: "",
    highlights: "",
    campaign_id: 1
  ]
)

puts "...finished populating chapters..."


puts "Populating characters..."

Character.create!(
  [
    name: "Squilliam Fancyson"
  ]
)

puts "...finished populating characters..."


puts "Populating notes..."

puts "...finished populating notes..."


puts "Populating stickies..."

puts "...finished populating stickies..."
