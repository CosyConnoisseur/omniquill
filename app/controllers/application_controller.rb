class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit::Authorization
  # checking the authorize method has been called, and then whether the user is meant to do anything on this page
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  # scoping to ensure users are only seeing the records that they are supposed to.
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

    private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username])
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def should_verify_authorized?
    !skip_pundit? && action_name != "index"
  end

  def should_verify_policy_scoped?
    !skip_pundit? && action_name == "index"
  end
end
