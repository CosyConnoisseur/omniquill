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
    @campaign = Campaign.create!(
      title: "Welcome to OmniQuill",
      synopsis: "",
      # card_image: "",
      user: host_user,
      # participation: @guest
      # guest participation?
    )
    @campaign.participations.create!(user: @guest)
    p2_seat = @campaign.participations.create!(user_id: 8)

    @character = Character.create!(
      name: "generated for guest",
      stats_summary: "hello I'm a stats summary",
      # portrait: "",
      # campaign participation?
      participation: p2_seat
    )
    # @character.participations.create!(campaign: @campaign, user: host_user)

    # 3. Use Devise's native helper to log this user in immediately
    sign_in(@guest)

    # 4. Send them to your dashboard or landing page
    flash[:notice] = "Welcome! You are browsing as a temporary guest."
    redirect_to root_path
  end
end
