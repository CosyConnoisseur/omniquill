# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication, only: [:new, :create], if: -> { current_user&.guest? }

  before_action :redirect_logged_in_members, only: [:new, :create]

  def new
    if params[:user_feature] == "true"
      flash.now[:notice] = "You need to sign up to use that feature!"
    end
    super
  end

  def create
    if current_user&.guest?
      build_resource(sign_up_params)
      permitted_params = params.require(:user).permit(:email, :password, :password_confirmation, :username, :profile_picture)

      current_user.assign_attributes(permitted_params)
      current_user.guest = false

      if current_user.save
        set_flash_message! :notice, :signed_up
        bypass_sign_in(current_user)
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

  def redirect_logged_in_members
    if current_user.present? && !current_user.guest?
      flash[:alert] = "You are already signed in."
      redirect_to root_path and return
    end
  end
end
