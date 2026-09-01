class GuestsController < ApplicationController
    # Skip Devise's authenticate_user! check if you have a global one set up
  skip_before_action :authenticate_user!, only: [:create]

  # Skip Pundit authorization checks for this specific login mechanism
  skip_after_action :verify_authorized, only: [:create]

  def create
    # 1. Generate a completely unique, temporary email address
    random_hex = SecureRandom.hex(6)
    guest_email = "guest_#{random_hex}@example.com"

    # 2. Build and save the temporary guest user in the database
    @guest = User.create!(
      email: guest_email,
      username: "Guest",
      password: SecureRandom.alphanumeric(16), # Devise requires a valid password
      guest: true # Mark them as a guest!
    )
    host_user = User.find(7)
    shared_blob = "eyJfcmFpbHMiOnsiZGF0YSI6MTUyLCJwdXIiOiJibG9iX2lkIn19--87d07c070109dc449db2d76d30321bd1ef350012"


p2_cloud_key = "vaxdr8xpd7eije2xth9rohzxfuf8" #
p2_cloud_image = ActiveStorage::Blob.find_by(key: p2_cloud_key)

if p2_cloud_image.nil?
  p2_cloud_image = ActiveStorage::Blob.create!(
    key:          p2_cloud_key,
    filename:     "sandbox_placeholder.jpg",
    content_type: "image/jpeg",
    byte_size:    0,
    checksum:     "0"
  )
end

p3_cloud_key = "yjrswrq5lei9hf0kur6lph9ujxup" #
p3_cloud_image = ActiveStorage::Blob.find_by(key: p3_cloud_key)

if p3_cloud_image.nil?
  p3_cloud_image = ActiveStorage::Blob.create!(
    key:          p3_cloud_key,
    filename:     "sandbox_placeholder.jpg",
    content_type: "image/jpeg",
    byte_size:    0,
    checksum:     "0"
  )
end

p4_cloud_key = "wye8g7l7gqpljgf4k91i6r4i4pop" #
p4_cloud_image = ActiveStorage::Blob.find_by(key: p4_cloud_key)

if p4_cloud_image.nil?
  p4_cloud_image = ActiveStorage::Blob.create!(
    key:          p4_cloud_key,
    filename:     "sandbox_placeholder.jpg",
    content_type: "image/jpeg",
    byte_size:    0,
    checksum:     "0"
  )
end


    # p3_cloud_image = ActiveStorage::Blob.find_by(key: "public ID")
    # p4_cloud_image = ActiveStorage::Blob.find_by(key: "public ID")

    @campaign = Campaign.create!(
      title: "Welcome to OmniQuill",
      synopsis: "Welcome and thank you for trying OmniQuill! This is an app that blah blah... Please have a look at the Characters tab",
      # card_image: "",
      user: host_user,
      # participation: @guest
      # guest participation?
    )
    @campaign.card_image.attach(shared_blob)
    @campaign.participations.create!(user: @guest)

    p2_seat = @campaign.participations.create!(user_id: 8) #
    p3_char = @campaign.participations.create!(user_id: 9) #
    p4_char = @campaign.participations.create!(user_id: 10) #

    p2_character = Character.create!(
      name: "Jared, the Summoner", #
      stats_summary: "hello I'm a stats summary", #
      # portrait: "",
      # campaign participation?
      participation: p2_seat
    )
    p2_character.portrait.attach(p2_cloud_image)

    p3_character = Character.create!(
      name: "Sammy, the Speaker", #
      stats_summary: "hello I'm a stats summary", #
      # portrait: "",
      # campaign participation?
      participation: p3_char
    )
    p3_character.portrait.attach(p3_cloud_image)

    p4_character = Character.create!(
      name: "Ben, the Recorder", #
      stats_summary: "hello I'm a stats summary", #
      # portrait: "",
      # campaign participation?
      participation: p4_char
    )
    p4_character.portrait.attach(p4_cloud_image)

    # @character.participations.create!(campaign: @campaign, user: host_user)

    # 3. Use Devise's native helper to log this user in immediately
    sign_in(@guest)

    # 4. Send them to your dashboard or landing page
    flash[:notice] = "Welcome! You are browsing as a temporary guest."
    redirect_to root_path
  end
end


# @guest = User.create!(
#       email: guest_email,
#       username: "Guest",
#       password: SecureRandom.alphanumeric(16), # Devise requires a valid password
#       guest: true # Mark them as a guest!
#     )
#     host_user = User.find(7)
#     shared_blob = ActiveStorage::Blob.find_by!(key: "750ruin9i2ipdk9ujjod8185j8r4")
#     @campaign = Campaign.create!(
#       title: "Welcome to OmniQuill",
#       synopsis: "",
#       # card_image: "",
#       user: host_user,
#       # participation: @guest
#       # guest participation?
#     )
#     # @campaign.card_image.attach(shared_blob)
#     @campaign.participations.create!(user: @guest)
#     p2_char = @campaign.participations.create!(user_id: 8)
#     # p3_char = @campaign.participations.create!(user_id: 9)
#     # p4_char = @campaign.participations.create!(user_id: 10)

#     @character = Character.create!(
#       name: "Homer Simpson",
#       stats_summary: "hello I'm a stats summary",
#       # portrait: "",
#       # campaign participation?
#       participation: p2_char
#     )
#     # p3_character = Character.create!(
#     #   name: "Spyro The Dragon",
#     #   stats_summary: "hello I'm a stats summary",
#     #   # portrait: "",
#     #   # campaign participation?
#     #   participation: p3_char
#     # )
#     # p4_character = Character.create!(
#     #   name: "Super Mario",
#     #   stats_summary: "hello I'm a stats summary",
#     #   # portrait: "",
#     #   # campaign participation?
#     #   participation: p4_char
#     # )
#     @character.participations.create!(campaign: @campaign, user: host_user)
