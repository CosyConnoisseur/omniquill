# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # 1. Clear Devise's check ONLY if a user is an active guest.
  # If they are a full user or not logged in at all, let Devise behave normally.
  skip_before_action :require_no_authentication, only: [:new, :create], if: -> { current_user&.guest? }

  # 2. Add an extra security layer: If a fully registered user somehow forces their way here,
  # boot them out to the root page immediately.
  before_action :redirect_logged_in_members, only: [:new, :create]

  def create
    if current_user&.guest?
      build_resource(sign_up_params)
      permitted_params = params.require(:user).permit(:email, :password, :password_confirmation)

      current_user.assign_attributes(permitted_params)
      current_user.guest = false # They are officially a real user now!

      if current_user.save
        set_flash_message! :notice, :signed_up
        sign_in(resource_name, current_user, bypass: true)
        respond_with current_user, location: after_sign_up_path_for(current_user)
      else
        clean_up_passwords current_user
        set_minimum_password_length
        respond_with current_user
      end
    else
      super
    end
  end

  protected

  def update_resource(resource, params)
    if resource.guest?
      resource.update_without_password(params.except(:current_password))
    else
      super
    end
  end

  private

  # 3. Security Guard Method
  def redirect_logged_in_members
    # If a user is present, but they are NOT a guest, they are a real member!
    if current_user.present? && !current_user.guest?
      flash[:alert] = "You are already signed in."
      redirect_to root_path and return
    end
  end
end
