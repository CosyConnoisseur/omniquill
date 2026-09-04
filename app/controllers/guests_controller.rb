class GuestsController < ApplicationController
    # Skip Devise
  skip_before_action :authenticate_user!, only: [:create]

  # Skip Pundit
  skip_after_action :verify_authorized, only: [:create]

  def create
    random_hex = SecureRandom.hex(6)
    guest_email = "guest_#{random_hex}@example.com"

    @guest = User.create!(
      email: guest_email,
      username: "Guest",
      password: SecureRandom.alphanumeric(16),
      guest: true # mark them as a guest
    )

    GenerateGuestCampaign.call(@guest)

    sign_in(@guest)

    flash[:notice] = "Welcome! You are browsing as a temporary guest."
    redirect_to root_path
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, alert: "Something went wrong creating your guest session."
  end
end
